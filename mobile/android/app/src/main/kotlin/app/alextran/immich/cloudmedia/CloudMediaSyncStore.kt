package app.alextran.immich.cloudmedia

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import java.util.UUID

data class CloudAssetRow(
  val id: String,
  val mediaType: String, // "IMAGE" or "VIDEO", matches AssetType
  val mimeType: String,
  val dateTakenMillis: Long,
  val durationMillis: Long,
  val isFavorite: Boolean,
  val sizeBytes: Long,
  val width: Int,
  val height: Int,
  val orientation: Int,
)

private const val DB_NAME = "cloud_media_provider.db"
private const val DB_VERSION = 1

private const val TABLE_ASSETS = "assets"
private const val COLUMN_ID = "id"
private const val COLUMN_MEDIA_TYPE = "media_type"
private const val COLUMN_MIME_TYPE = "mime_type"
private const val COLUMN_DATE_TAKEN_MILLIS = "date_taken_millis"
private const val COLUMN_DURATION_MILLIS = "duration_millis"
private const val COLUMN_IS_FAVORITE = "is_favorite"
private const val COLUMN_SIZE_BYTES = "size_bytes"
private const val COLUMN_WIDTH = "width"
private const val COLUMN_HEIGHT = "height"
private const val COLUMN_ORIENTATION = "orientation"
private const val COLUMN_IS_DELETED = "is_deleted"
private const val COLUMN_GENERATION = "generation"

private const val TABLE_META = "meta"
private const val COLUMN_KEY = "key"
private const val COLUMN_VALUE = "value"

private const val META_GENERATION = "generation"
private const val META_COLLECTION_ID = "collection_id"

private data class ExistingAssetState(
  val sizeBytes: Long,
  val width: Int,
  val height: Int,
  val orientation: Int,
  val isFavorite: Boolean,
  val isDeleted: Boolean,
)

/**
 * Local mirror of the library exposed through `CloudMediaProviderImpl`. Populated by
 * `CloudMediaSyncEngine` from a single, stateless, repeatable listing call
 * (`POST /search/metadata`) rather than the stateful `/sync/stream` delta endpoint: that
 * endpoint's resume checkpoint is keyed per login-session and shared with the main app's own
 * Drift sync, so a second independent consumer acking against it would silently move the
 * checkpoint out from under the app's UI sync, causing it to miss records it never actually
 * processed itself. Trading true delta-sync efficiency for that isolation is deliberate.
 *
 * [COLUMN_GENERATION] is a local, monotonically increasing counter bumped whenever a row is
 * inserted, changed, or (soft-)deleted. It backs `CloudMediaProviderContract.MediaColumns
 * .SYNC_GENERATION` / `EXTRA_SYNC_GENERATION`, which the Android Photo Picker uses to ask "what
 * changed since I last looked."
 */
class CloudMediaSyncStore(context: Context) :
  SQLiteOpenHelper(context.applicationContext, DB_NAME, null, DB_VERSION) {

  override fun onCreate(db: SQLiteDatabase) {
    db.execSQL(
      """
      CREATE TABLE $TABLE_ASSETS (
        $COLUMN_ID TEXT PRIMARY KEY,
        $COLUMN_MEDIA_TYPE TEXT NOT NULL,
        $COLUMN_MIME_TYPE TEXT NOT NULL,
        $COLUMN_DATE_TAKEN_MILLIS INTEGER NOT NULL,
        $COLUMN_DURATION_MILLIS INTEGER NOT NULL DEFAULT 0,
        $COLUMN_IS_FAVORITE INTEGER NOT NULL DEFAULT 0,
        $COLUMN_SIZE_BYTES INTEGER NOT NULL DEFAULT 0,
        $COLUMN_WIDTH INTEGER NOT NULL DEFAULT 0,
        $COLUMN_HEIGHT INTEGER NOT NULL DEFAULT 0,
        $COLUMN_ORIENTATION INTEGER NOT NULL DEFAULT 0,
        $COLUMN_IS_DELETED INTEGER NOT NULL DEFAULT 0,
        $COLUMN_GENERATION INTEGER NOT NULL
      )
      """.trimIndent()
    )
    db.execSQL("CREATE INDEX idx_assets_generation ON $TABLE_ASSETS ($COLUMN_GENERATION)")
    db.execSQL("CREATE INDEX idx_assets_is_deleted ON $TABLE_ASSETS ($COLUMN_IS_DELETED)")
    db.execSQL(
      "CREATE TABLE $TABLE_META ($COLUMN_KEY TEXT PRIMARY KEY, $COLUMN_VALUE TEXT NOT NULL)"
    )
  }

  override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
    db.execSQL("DROP TABLE IF EXISTS $TABLE_ASSETS")
    db.execSQL("DROP TABLE IF EXISTS $TABLE_META")
    onCreate(db)
  }

  /** Stable per-install id Android uses to detect this is still "the same" remote collection. */
  fun getCollectionId(): String {
    getMeta(META_COLLECTION_ID)?.let { return it }
    val id = UUID.randomUUID().toString()
    setMeta(META_COLLECTION_ID, id)
    return id
  }

  fun getGeneration(): Long = getMeta(META_GENERATION)?.toLongOrNull() ?: 0L

  /**
   * Upserts one polled page of results (bumping generation only for rows that actually
   * changed). Callers must call [sweepDeleted] with the full id set once every page of a
   * complete listing pass has been applied, to soft-delete rows that disappeared; a
   * partial/failed pass must not call it, or everything not-yet-seen this pass would be
   * incorrectly marked deleted.
   */
  fun applyUpserts(rows: List<CloudAssetRow>) {
    if (rows.isEmpty()) return
    val db = writableDatabase
    db.beginTransaction()
    try {
      var generation = getGenerationLocked(db)
      for (row in rows) {
        generation = upsertLocked(db, row, generation)
      }
      setMetaLocked(db, META_GENERATION, generation.toString())
      db.setTransactionSuccessful()
    } finally {
      db.endTransaction()
    }
  }

  private fun upsertLocked(db: SQLiteDatabase, row: CloudAssetRow, generation: Long): Long {
    val existing = db.query(
      TABLE_ASSETS,
      arrayOf(COLUMN_SIZE_BYTES, COLUMN_WIDTH, COLUMN_HEIGHT, COLUMN_ORIENTATION, COLUMN_IS_FAVORITE, COLUMN_IS_DELETED),
      "$COLUMN_ID = ?", arrayOf(row.id), null, null, null
    ).use { c ->
      if (!c.moveToFirst()) null else ExistingAssetState(
        sizeBytes = c.getLong(0),
        width = c.getInt(1),
        height = c.getInt(2),
        orientation = c.getInt(3),
        isFavorite = c.getInt(4) == 1,
        isDeleted = c.getInt(5) == 1,
      )
    }

    val unchanged = existing != null &&
      existing.sizeBytes == row.sizeBytes &&
      existing.width == row.width &&
      existing.height == row.height &&
      existing.orientation == row.orientation &&
      existing.isFavorite == row.isFavorite &&
      !existing.isDeleted

    val nextGeneration = if (unchanged) generation else generation + 1
    val values = ContentValues().apply {
      put(COLUMN_ID, row.id)
      put(COLUMN_MEDIA_TYPE, row.mediaType)
      put(COLUMN_MIME_TYPE, row.mimeType)
      put(COLUMN_DATE_TAKEN_MILLIS, row.dateTakenMillis)
      put(COLUMN_DURATION_MILLIS, row.durationMillis)
      put(COLUMN_IS_FAVORITE, row.isFavorite)
      put(COLUMN_SIZE_BYTES, row.sizeBytes)
      put(COLUMN_WIDTH, row.width)
      put(COLUMN_HEIGHT, row.height)
      put(COLUMN_ORIENTATION, row.orientation)
      put(COLUMN_IS_DELETED, 0)
      put(COLUMN_GENERATION, nextGeneration)
    }
    db.insertWithOnConflict(TABLE_ASSETS, null, values, SQLiteDatabase.CONFLICT_REPLACE)
    return nextGeneration
  }

  /** Soft-deletes every non-deleted row whose id is missing from `seenIds`. */
  fun sweepDeleted(seenIds: Set<String>) {
    val db = writableDatabase
    db.beginTransaction()
    try {
      var generation = getGenerationLocked(db)
      val staleIds = mutableListOf<String>()
      db.query(
        TABLE_ASSETS, arrayOf(COLUMN_ID), "$COLUMN_IS_DELETED = 0", null, null, null, null
      ).use { c ->
        while (c.moveToNext()) {
          val id = c.getString(0)
          if (id !in seenIds) staleIds.add(id)
        }
      }

      for (id in staleIds) {
        generation += 1
        val values = ContentValues().apply {
          put(COLUMN_IS_DELETED, 1)
          put(COLUMN_GENERATION, generation)
        }
        db.update(TABLE_ASSETS, values, "$COLUMN_ID = ?", arrayOf(id))
      }
      setMetaLocked(db, META_GENERATION, generation.toString())
      db.setTransactionSuccessful()
    } finally {
      db.endTransaction()
    }
  }

  /** Raw cursor with column names already aliased to `CloudMediaProviderContract.MediaColumns`. */
  fun queryMedia(sinceGeneration: Long, limit: Int): Cursor {
    return readableDatabase.rawQuery(
      """
      SELECT
        $COLUMN_ID AS id,
        $COLUMN_DATE_TAKEN_MILLIS AS date_taken_millis,
        $COLUMN_DURATION_MILLIS AS duration_millis,
        $COLUMN_IS_FAVORITE AS is_favorite,
        $COLUMN_MIME_TYPE AS mime_type,
        $COLUMN_SIZE_BYTES AS size_bytes,
        $COLUMN_WIDTH AS width,
        $COLUMN_HEIGHT AS height,
        $COLUMN_ORIENTATION AS orientation,
        $COLUMN_GENERATION AS sync_generation
      FROM $TABLE_ASSETS
      WHERE $COLUMN_IS_DELETED = 0 AND $COLUMN_GENERATION > ?
      ORDER BY $COLUMN_GENERATION ASC
      LIMIT ?
      """.trimIndent(),
      arrayOf(sinceGeneration.toString(), limit.toString())
    )
  }

  /** Raw cursor with a single `id` column, for `onQueryDeletedMedia`. */
  fun queryDeletedMedia(sinceGeneration: Long, limit: Int): Cursor {
    return readableDatabase.rawQuery(
      """
      SELECT $COLUMN_ID AS id, $COLUMN_GENERATION AS sync_generation
      FROM $TABLE_ASSETS
      WHERE $COLUMN_IS_DELETED = 1 AND $COLUMN_GENERATION > ?
      ORDER BY $COLUMN_GENERATION ASC
      LIMIT ?
      """.trimIndent(),
      arrayOf(sinceGeneration.toString(), limit.toString())
    )
  }

  fun getMediaType(id: String): String? {
    return readableDatabase.query(
      TABLE_ASSETS, arrayOf(COLUMN_MEDIA_TYPE), "$COLUMN_ID = ? AND $COLUMN_IS_DELETED = 0",
      arrayOf(id), null, null, null
    ).use { c -> if (c.moveToFirst()) c.getString(0) else null }
  }

  private fun getGenerationLocked(db: SQLiteDatabase): Long =
    getMetaLocked(db, META_GENERATION)?.toLongOrNull() ?: 0L

  private fun getMeta(key: String): String? {
    return readableDatabase.query(
      TABLE_META, arrayOf(COLUMN_VALUE), "$COLUMN_KEY = ?", arrayOf(key), null, null, null
    ).use { c -> if (c.moveToFirst()) c.getString(0) else null }
  }

  private fun getMetaLocked(db: SQLiteDatabase, key: String): String? {
    return db.query(
      TABLE_META, arrayOf(COLUMN_VALUE), "$COLUMN_KEY = ?", arrayOf(key), null, null, null
    ).use { c -> if (c.moveToFirst()) c.getString(0) else null }
  }

  private fun setMeta(key: String, value: String) {
    val db = writableDatabase
    db.beginTransaction()
    try {
      setMetaLocked(db, key, value)
      db.setTransactionSuccessful()
    } finally {
      db.endTransaction()
    }
  }

  private fun setMetaLocked(db: SQLiteDatabase, key: String, value: String) {
    val values = ContentValues().apply {
      put(COLUMN_KEY, key)
      put(COLUMN_VALUE, value)
    }
    db.insertWithOnConflict(TABLE_META, null, values, SQLiteDatabase.CONFLICT_REPLACE)
  }
}
