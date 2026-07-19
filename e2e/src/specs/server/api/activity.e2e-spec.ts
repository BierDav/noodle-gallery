import {
  ActivityCreateDto,
  AlbumResponseDto,
  AlbumUserRole,
  AssetMediaResponseDto,
  LoginResponseDto,
  ReactionType,
  SharedSpaceRole,
  createActivity as create,
  createAlbum,
  getActivityStatistics,
  removeAssetFromAlbum,
} from '@immich/sdk';
import { createUserDto, uuidDto } from 'src/fixtures';
import { errorDto } from 'src/responses';
import { app, asBearerAuth, utils } from 'src/utils';
import request from 'supertest';
import { beforeAll, beforeEach, describe, expect, it } from 'vitest';

describe('/activities', () => {
  let admin: LoginResponseDto;
  let nonOwner: LoginResponseDto;
  let asset: AssetMediaResponseDto;
  let album: AlbumResponseDto;

  const createActivity = (dto: ActivityCreateDto, accessToken?: string) =>
    create({ activityCreateDto: dto }, { headers: asBearerAuth(accessToken || admin.accessToken) });

  beforeAll(async () => {
    await utils.resetDatabase();

    admin = await utils.adminSetup();
    nonOwner = await utils.userSetup(admin.accessToken, createUserDto.user1);
    asset = await utils.createAsset(admin.accessToken);
    album = await createAlbum(
      {
        createAlbumDto: {
          albumName: 'Album 1',
          assetIds: [asset.id],
          albumUsers: [{ userId: nonOwner.userId, role: AlbumUserRole.Editor }],
        },
      },
      { headers: asBearerAuth(admin.accessToken) },
    );
  });

  beforeEach(async () => {
    await utils.resetDatabase(['activity']);
  });

  describe('GET /activities', () => {
    it('should start off empty', async () => {
      const { status, body } = await request(app)
        .get('/activities')
        .query({ albumId: album.id })
        .set('Authorization', `Bearer ${admin.accessToken}`);
      expect(body).toEqual([]);
      expect(status).toEqual(200);
    });

    it('should filter by album id', async () => {
      const album2 = await createAlbum(
        {
          createAlbumDto: {
            albumName: 'Album 2',
            assetIds: [asset.id],
          },
        },
        { headers: asBearerAuth(admin.accessToken) },
      );

      const [reaction] = await Promise.all([
        createActivity({ albumId: album.id, type: ReactionType.Like }),
        createActivity({ albumId: album2.id, type: ReactionType.Like }),
      ]);

      const { status, body } = await request(app)
        .get('/activities')
        .query({ albumId: album.id })
        .set('Authorization', `Bearer ${admin.accessToken}`);
      expect(status).toEqual(200);
      expect(body.length).toBe(1);
      expect(body[0]).toEqual(reaction);
    });

    it('should filter by type=comment', async () => {
      const [reaction] = await Promise.all([
        createActivity({
          albumId: album.id,
          type: ReactionType.Comment,
          comment: 'comment',
        }),
        createActivity({ albumId: album.id, type: ReactionType.Like }),
      ]);

      const { status, body } = await request(app)
        .get('/activities')
        .query({ albumId: album.id, type: 'comment' })
        .set('Authorization', `Bearer ${admin.accessToken}`);
      expect(status).toEqual(200);
      expect(body.length).toBe(1);
      expect(body[0]).toEqual(reaction);
    });

    it('should filter by type=like', async () => {
      const [reaction] = await Promise.all([
        createActivity({ albumId: album.id, type: ReactionType.Like }),
        createActivity({
          albumId: album.id,
          type: ReactionType.Comment,
          comment: 'comment',
        }),
      ]);

      const { status, body } = await request(app)
        .get('/activities')
        .query({ albumId: album.id, type: 'like' })
        .set('Authorization', `Bearer ${admin.accessToken}`);
      expect(status).toEqual(200);
      expect(body.length).toBe(1);
      expect(body[0]).toEqual(reaction);
    });

    it('should filter by userId', async () => {
      const reaction = await createActivity({ albumId: album.id, type: ReactionType.Like });

      const response1 = await request(app)
        .get('/activities')
        .query({ albumId: album.id, userId: uuidDto.notFound })
        .set('Authorization', `Bearer ${admin.accessToken}`);

      expect(response1.status).toEqual(200);
      expect(response1.body.length).toBe(0);

      const response2 = await request(app)
        .get('/activities')
        .query({ albumId: album.id, userId: admin.userId })
        .set('Authorization', `Bearer ${admin.accessToken}`);

      expect(response2.status).toEqual(200);
      expect(response2.body.length).toBe(1);
      expect(response2.body[0]).toEqual(reaction);
    });

    it('should filter by assetId', async () => {
      const [reaction] = await Promise.all([
        createActivity({
          albumId: album.id,
          assetId: asset.id,
          type: ReactionType.Like,
        }),
        createActivity({ albumId: album.id, type: ReactionType.Like }),
      ]);

      const { status, body } = await request(app)
        .get('/activities')
        .query({ albumId: album.id, assetId: asset.id })
        .set('Authorization', `Bearer ${admin.accessToken}`);
      expect(status).toEqual(200);
      expect(body.length).toBe(1);
      expect(body[0]).toEqual(reaction);
    });
  });

  describe('POST /activities', () => {
    it('should add a comment to an album', async () => {
      const { status, body } = await request(app)
        .post('/activities')
        .set('Authorization', `Bearer ${admin.accessToken}`)
        .send({
          albumId: album.id,
          type: 'comment',
          comment: 'This is my first comment',
        });
      expect(status).toEqual(201);
      expect(body).toEqual({
        id: expect.any(String),
        assetId: null,
        createdAt: expect.any(String),
        type: 'comment',
        comment: 'This is my first comment',
        user: expect.objectContaining({ email: admin.userEmail }),
      });
    });

    it('should add a like to an album', async () => {
      const { status, body } = await request(app)
        .post('/activities')
        .set('Authorization', `Bearer ${admin.accessToken}`)
        .send({ albumId: album.id, type: 'like' });
      expect(status).toEqual(201);
      expect(body).toEqual({
        id: expect.any(String),
        assetId: null,
        createdAt: expect.any(String),
        type: 'like',
        comment: null,
        user: expect.objectContaining({ email: admin.userEmail }),
      });
    });

    it('should return a 200 for a duplicate like on the album', async () => {
      const reaction = await createActivity({ albumId: album.id, type: ReactionType.Like });
      const { status, body } = await request(app)
        .post('/activities')
        .set('Authorization', `Bearer ${admin.accessToken}`)
        .send({ albumId: album.id, type: 'like' });
      expect(status).toEqual(200);
      expect(body).toEqual(reaction);
    });

    it('should not confuse an album like with an asset like', async () => {
      const reaction = await createActivity({
        albumId: album.id,
        assetId: asset.id,
        type: ReactionType.Like,
      });
      const { status, body } = await request(app)
        .post('/activities')
        .set('Authorization', `Bearer ${admin.accessToken}`)
        .send({ albumId: album.id, type: 'like' });
      expect(status).toEqual(201);
      expect(body.id).not.toEqual(reaction.id);
    });

    it('should add a comment to an asset', async () => {
      const { status, body } = await request(app)
        .post('/activities')
        .set('Authorization', `Bearer ${admin.accessToken}`)
        .send({
          albumId: album.id,
          assetId: asset.id,
          type: 'comment',
          comment: 'This is my first comment',
        });
      expect(status).toEqual(201);
      expect(body).toEqual({
        id: expect.any(String),
        assetId: asset.id,
        createdAt: expect.any(String),
        type: 'comment',
        comment: 'This is my first comment',
        user: expect.objectContaining({ email: admin.userEmail }),
      });
    });

    it('should add a like to an asset', async () => {
      const { status, body } = await request(app)
        .post('/activities')
        .set('Authorization', `Bearer ${admin.accessToken}`)
        .send({ albumId: album.id, assetId: asset.id, type: 'like' });
      expect(status).toEqual(201);
      expect(body).toEqual({
        id: expect.any(String),
        assetId: asset.id,
        createdAt: expect.any(String),
        type: 'like',
        comment: null,
        user: expect.objectContaining({ email: admin.userEmail }),
      });
    });

    it('should return a 200 for a duplicate like on an asset', async () => {
      const reaction = await createActivity({
        albumId: album.id,
        assetId: asset.id,
        type: ReactionType.Like,
      });

      const { status, body } = await request(app)
        .post('/activities')
        .set('Authorization', `Bearer ${admin.accessToken}`)
        .send({ albumId: album.id, assetId: asset.id, type: 'like' });
      expect(status).toEqual(200);
      expect(body).toEqual(reaction);
    });
  });

  describe('DELETE /activities/:id', () => {
    it('should remove a comment from an album', async () => {
      const reaction = await createActivity({
        albumId: album.id,
        type: ReactionType.Comment,
        comment: 'This is a test comment',
      });
      const { status } = await request(app)
        .delete(`/activities/${reaction.id}`)
        .set('Authorization', `Bearer ${admin.accessToken}`);
      expect(status).toEqual(204);
    });

    it('should remove a like from an album', async () => {
      const reaction = await createActivity({
        albumId: album.id,
        type: ReactionType.Like,
      });
      const { status } = await request(app)
        .delete(`/activities/${reaction.id}`)
        .set('Authorization', `Bearer ${admin.accessToken}`);
      expect(status).toEqual(204);
    });

    it('should let the owner remove a comment by another user', async () => {
      const reaction = await createActivity({
        albumId: album.id,
        type: ReactionType.Comment,
        comment: 'This is a test comment',
      });

      const { status } = await request(app)
        .delete(`/activities/${reaction.id}`)
        .set('Authorization', `Bearer ${admin.accessToken}`);

      expect(status).toEqual(204);
    });

    it('should not let a user remove a comment by another user', async () => {
      const reaction = await createActivity({
        albumId: album.id,
        type: ReactionType.Comment,
        comment: 'This is a test comment',
      });

      const { status, body } = await request(app)
        .delete(`/activities/${reaction.id}`)
        .set('Authorization', `Bearer ${nonOwner.accessToken}`);

      expect(status).toBe(400);
      expect(body).toEqual(errorDto.badRequest('Not found or no activity.delete access'));
    });

    it('should let a non-owner remove their own comment', async () => {
      const reaction = await createActivity(
        {
          albumId: album.id,
          type: ReactionType.Comment,
          comment: 'This is a test comment',
        },
        nonOwner.accessToken,
      );

      const { status } = await request(app)
        .delete(`/activities/${reaction.id}`)
        .set('Authorization', `Bearer ${nonOwner.accessToken}`);

      expect(status).toBe(204);
    });

    it('should return empty list when asset is removed', async () => {
      const album3 = await createAlbum(
        {
          createAlbumDto: {
            albumName: 'Album 3',
            assetIds: [asset.id],
          },
        },
        { headers: asBearerAuth(admin.accessToken) },
      );

      await createActivity({ albumId: album3.id, assetId: asset.id, type: ReactionType.Like });

      await removeAssetFromAlbum(
        {
          id: album3.id,
          bulkIdsDto: {
            ids: [asset.id],
          },
        },
        { headers: asBearerAuth(admin.accessToken) },
      );

      const { status, body } = await request(app)
        .get('/activities')
        .query({ albumId: album.id })
        .set('Authorization', `Bearer ${admin.accessToken}`);
      expect(status).toEqual(200);
      expect(body).toEqual([]);
    });
  });

  describe('GET /activities (space-linked album) — album-level activity denied to space-only readers (C1)', () => {
    it('space Viewer sees asset-level activity on a visible asset but NOT album-level comments', async () => {
      const spaceOwner = admin; // album owner
      const spaceViewer = await utils.userSetup(admin.accessToken, createUserDto.create('c1-space-viewer'));
      const c1Asset = await utils.createAsset(spaceOwner.accessToken);
      const c1Album = await utils.createAlbum(spaceOwner.accessToken, {
        albumName: 'C1 Album',
        assetIds: [c1Asset.id],
      });

      // album-level comment (no assetId) + asset-level comment (assetId set)
      await createActivity(
        { albumId: c1Album.id, type: ReactionType.Comment, comment: 'album-level secret' },
        spaceOwner.accessToken,
      );
      await createActivity(
        { albumId: c1Album.id, assetId: c1Asset.id, type: ReactionType.Comment, comment: 'on the photo' },
        spaceOwner.accessToken,
      );

      const space = await utils.createSpace(spaceOwner.accessToken, { name: 'C1 Space' });
      await utils.addSpaceMember(spaceOwner.accessToken, space.id, {
        userId: spaceViewer.userId,
        role: SharedSpaceRole.Viewer,
      });
      await utils.linkSpaceAlbum(spaceOwner.accessToken, space.id, c1Album.id);

      const asMember = await request(app)
        .get('/activities')
        .query({ albumId: c1Album.id })
        .set('Authorization', `Bearer ${spaceViewer.accessToken}`);
      expect(asMember.status).toBe(200);
      expect(asMember.body.map((a: { assetId: string | null }) => a.assetId)).toEqual([c1Asset.id]);
      expect(asMember.body.some((a: { comment?: string }) => a.comment === 'album-level secret')).toBe(false);

      const asOwner = await request(app)
        .get('/activities')
        .query({ albumId: c1Album.id })
        .set('Authorization', `Bearer ${spaceOwner.accessToken}`);
      expect(asOwner.body).toHaveLength(2); // owner sees both
    });

    it('redacts commenter/liker email on asset-level activity for a space-only reader; keeps it for an album participant (M5)', async () => {
      const spaceOwner = admin; // album owner
      const spaceViewer = await utils.userSetup(admin.accessToken, createUserDto.create('m5-space-viewer'));
      const participant = await utils.userSetup(admin.accessToken, createUserDto.create('m5-participant'));
      const m5Asset = await utils.createAsset(spaceOwner.accessToken);
      const m5Album = await utils.createAlbum(spaceOwner.accessToken, {
        albumName: 'M5 Album',
        assetIds: [m5Asset.id],
        albumUsers: [{ userId: participant.userId, role: AlbumUserRole.Viewer }],
      });

      await createActivity(
        { albumId: m5Album.id, assetId: m5Asset.id, type: ReactionType.Comment, comment: 'nice shot' },
        spaceOwner.accessToken,
      );
      await createActivity(
        { albumId: m5Album.id, assetId: m5Asset.id, type: ReactionType.Like },
        spaceOwner.accessToken,
      );

      const space = await utils.createSpace(spaceOwner.accessToken, { name: 'M5 Space' });
      await utils.addSpaceMember(spaceOwner.accessToken, space.id, {
        userId: spaceViewer.userId,
        role: SharedSpaceRole.Viewer,
      });
      await utils.linkSpaceAlbum(spaceOwner.accessToken, space.id, m5Album.id);

      // Negative: a space Viewer (no direct album access) sees both activities but with the
      // commenter/liker email redacted — name/id/avatarColor are still present.
      const asSpaceViewer = await request(app)
        .get('/activities')
        .query({ albumId: m5Album.id })
        .set('Authorization', `Bearer ${spaceViewer.accessToken}`);
      expect(asSpaceViewer.status).toBe(200);
      expect(asSpaceViewer.body).toHaveLength(2);
      for (const activity of asSpaceViewer.body) {
        expect(activity.user.email).toBe('');
        expect(activity.user.name).toBeTruthy();
        expect(activity.user.id).toBeTruthy();
        expect(activity.user.avatarColor).toBeTruthy();
      }

      // Positive control: an album participant (shared album_user) has direct access and sees the
      // real email.
      const asParticipant = await request(app)
        .get('/activities')
        .query({ albumId: m5Album.id })
        .set('Authorization', `Bearer ${participant.accessToken}`);
      expect(asParticipant.status).toBe(200);
      expect(asParticipant.body).toHaveLength(2);
      for (const activity of asParticipant.body) {
        expect(activity.user.email).toBe(spaceOwner.userEmail);
      }
    });

    // I2: GET /activities/statistics gates on the same AlbumRead as GET /activities (C1) but
    // returned the aggregate {comments, likes} count INCLUDING album-level (assetId null) rows to
    // space-only readers. Scope it the same way C1 scopes content.
    it('excludes album-level counts from GET /activities/statistics for a space-only reader; includes them for a direct reader', async () => {
      const spaceOwner = admin; // album owner
      const spaceViewer = await utils.userSetup(admin.accessToken, createUserDto.create('i2-space-viewer'));
      const participant = await utils.userSetup(admin.accessToken, createUserDto.create('i2-participant'));
      const i2Asset = await utils.createAsset(spaceOwner.accessToken);
      const i2Album = await utils.createAlbum(spaceOwner.accessToken, {
        albumName: 'I2 Album',
        assetIds: [i2Asset.id],
        albumUsers: [{ userId: participant.userId, role: AlbumUserRole.Viewer }],
      });

      // album-level like (no assetId) + asset-level comment (assetId set)
      await createActivity({ albumId: i2Album.id, type: ReactionType.Like }, spaceOwner.accessToken);
      await createActivity(
        { albumId: i2Album.id, assetId: i2Asset.id, type: ReactionType.Comment, comment: 'on the photo' },
        spaceOwner.accessToken,
      );

      const space = await utils.createSpace(spaceOwner.accessToken, { name: 'I2 Space' });
      await utils.addSpaceMember(spaceOwner.accessToken, space.id, {
        userId: spaceViewer.userId,
        role: SharedSpaceRole.Viewer,
      });
      await utils.linkSpaceAlbum(spaceOwner.accessToken, space.id, i2Album.id);

      // Negative: a space Viewer (no direct album access) sees the asset-level comment count but
      // NOT the album-level like.
      const asSpaceViewer = await getActivityStatistics(
        { albumId: i2Album.id },
        { headers: asBearerAuth(spaceViewer.accessToken) },
      );
      expect(asSpaceViewer).toEqual({ comments: 1, likes: 0 });

      // Positive control: an album participant (shared album_user) has direct access and sees the
      // full count, including the album-level like.
      const asParticipant = await getActivityStatistics(
        { albumId: i2Album.id },
        { headers: asBearerAuth(participant.accessToken) },
      );
      expect(asParticipant).toEqual({ comments: 1, likes: 1 });
    });
  });
});
