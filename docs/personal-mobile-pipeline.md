# Personal Mobile Pipeline

Personal automation on `BierDav/noodle-gallery` (this fork only — not part of
`open-noodle/gallery` and not synced upstream). Keeps a small personal
branding patch rebased on top of the org's `release` tag and republishes a
sideloadable Android APK that Obtainium auto-installs.

## How it works

The pipeline is split across two files because of a GitHub constraint: a
`schedule` trigger is only ever honored from the workflow file on the repo's
**default branch** (`main`), even though `workflow_dispatch` and `push`
happily fire from any branch that has the file. Since none of this pipeline
belongs on `main` (it's fork-personal-only, `main` tracks upstream), the
real pipeline lives entirely on `quickme-branding`, and a separate,
minimal stub on `main` exists only to wake it up on a schedule:

- `.github/workflows/personal-mobile-pipeline-trigger.yml` (on `main`): cron,
  once daily. Its only job is `gh workflow run personal-mobile-pipeline.yml
  --ref quickme-branding`. Nothing else — no jj, no secrets, no build logic.
- `.github/workflows/personal-mobile-pipeline.yml` (on `quickme-branding`):
  the actual pipeline. Runs on that daily dispatch, on a manual
  `workflow_dispatch`, and on every `push` to `quickme-branding` (i.e. every
  time you force-push a rebase yourself).
  - `rebase` job: installs `jj`, colocates it on the checkout, fetches
    `upstream` (`open-noodle/gallery`) and `origin`, then runs
    `jj rebase --ignore-immutable -b quickme-branding -d release` --
    **locally only, this job never pushes**. `--ignore-immutable` is
    required: the `build` job's `gh release create` tags the exact commit it
    builds, and jj's default `immutable_heads()` includes `tags()`, so every
    build after the first would otherwise make its own commit immutable and
    break the next rebase.
    - **Conflict** (checked unconditionally, not just when the rebase above
      moved anything — a run can also inherit an already-conflicted state
      nobody force-pushed a fix for yet): the job just **fails**. Resolve
      with `jj` locally and force-push `quickme-branding` yourself; a later
      run picks up from there. Nothing gets pushed or opened automatically.
    - **Clean, but not pushed yet** (the local rebase result differs from
      `quickme-branding@origin`): logs that there's a new rebase to review
      and skips the build. This is how "always builds against the latest
      release" is enforced even on the `push` trigger — if what you pushed
      isn't actually based on the current `release` tag, this job's own
      local rebase would move it further, so it won't build the stale thing
      you pushed.
    - **Nothing new** (`quickme-branding@origin`'s commit already matches
      the `targetCommitish` of the latest GitHub Release): skips the build.
    - **Otherwise**: hands off to `build`.
- `build` job: applies the org's fork branding, then the personal branding
  overlay (see below), builds a release APK signed with the `PERSONAL_*`
  keystore secrets (falls back to Flutter's non-portable debug key if
  they're unset — see below), and publishes it as a GitHub Release tagged
  `personal-mobile-<version>-<code>`, marked `--latest`.
- `on-failure` job: runs whenever `rebase` or `build` genuinely fails (not
  on the ordinary no-op/conflict paths, which report themselves above).
  Opens a plain issue linking the failed run so a broken pipeline gets
  looked at even between checks (see "Copilot handoff caveat" below for why
  it doesn't try to assign anyone).

## The `quickme-branding` bookmark

A single jj commit, based directly on the `release` tag, carrying personal
patches. Every run of `personal-mobile-pipeline.yml` rebases this bookmark
onto wherever `release` has moved to, **locally, in the runner** — it never
pushes that rebase for you. To pick up a new `release`, or to add more
personal changes, do it locally with `jj`/`git` and force-push
`quickme-branding` yourself; the workflow only ever builds what's already on
`origin`, it never rewrites your pushed commit.

**Rule: this commit only ever adds new files under `branding/scripts/` or
`branding/assets-personal/`. It never modifies a tracked app source file
directly** (`AndroidManifest.xml`, `colors.dart`,
`remote_album_sliver_app_bar.dart`, `pubspec.yaml`, the launcher icon PNGs,
…). All of those get mutated only at build time, by the overlay script
running inside the ephemeral `build` job — never committed. This was gotten
wrong once while building this out (the mutated destination files got
committed straight into `quickme-branding`) and had to be fixed by
rebuilding the bookmark from scratch on top of `release` with only the
script + assets. The reasoning is the same reasoning CLAUDE.md already gives
for the org's own `apply-branding.sh`: committing branded output makes the
fork's source diverge from upstream Immich at every touched line, so the
*next* time upstream (or an org branding change) touches
`remote_album_sliver_app_bar.dart` or `colors.dart`, `jj rebase` hits a real
conflict there and needs Copilot/manual intervention — exactly what the
separate-script design exists to avoid. Keeping the tracked files pristine
means a rebase can only ever conflict on the (new, personal-only) script and
asset files themselves, which nothing upstream will ever touch.

## Personal branding overlay

`branding/scripts/apply-personal-branding.sh` is a deliberately separate
script from the org's `branding/scripts/apply-branding.sh` — the org script
is shared/upstream-owned and this fork rebases onto `open-noodle/gallery`
regularly, so any personal preference living inside it would be a permanent
source of merge conflicts. A new file with nothing for a rebase to collide
with sidesteps that entirely. The `build` job runs it right after the org's
`apply-branding` action.

It currently does five things:

1. Renames the Android home-screen label from "Noodle Gallery" to "Noodle"
   (only the `<application>` tag's label — the share-intent and view-intent
   filter labels elsewhere in the manifest are untouched).
2. Overwrites the Android launcher icon (adaptive foreground + monochrome +
   all five legacy `mipmap-*/ic_launcher.png` densities) with the personal
   brand kit's coral aperture mark, source-of-truth for which lives outside
   this repo (`~/Downloads/photos/brand` at time of writing — the same kit
   already patched onto the self-hosted server's web UI via a Dockerfile
   overlay). Pre-rendered PNGs are checked in at
   `branding/assets-personal/mobile/android/` (a personal sibling to the
   org's `branding/assets/`, same reasoning as the script itself: nothing
   there for an upstream rebase to conflict with) and just get copied into
   place — no ImageMagick/rsvg-convert needed in CI. The launcher
   background stays the existing white (`ic_launcher_background` in
   `colors.xml`) since the mark was rendered assuming a white backdrop,
   matching how the brand kit renders `apple-icon-180.png`.

   Regenerate the PNGs from the source SVG (`noodle-gallery-mark.svg`) with:

   ```bash
   rsvg-convert -w 2048 -h 2048 noodle-gallery-mark.svg -o mark.png
   magick mark.png -resize 192x192 -background none -gravity center -extent 432x432 ic_launcher_foreground.png
   magick mark.png -resize 192x192 -alpha extract mono_alpha.png
   magick -size 192x192 xc:white mono_white.png
   magick mono_white.png mono_alpha.png -compose CopyOpacity -composite mono_rgba.png
   magick mono_rgba.png -background none -gravity center -extent 432x432 ic_launcher_monochrome.png
   magick mark.png -resize 192x192 -background none -gravity center -extent 432x432 -resize 1024x1024 -background white -alpha remove -alpha off ic_launcher.png
   ```

   The 192/432 content ratio matches the existing (pre-personal-branding)
   icon's safe-zone padding — check `identify -format "%@" <old foreground>`
   if that ever needs to change.
3. Recolors the app's default ("indigo") theme from Google-blue to the same
   coral as the web patch's `--immich-ui-primary-500` (light `#e85d38` /
   dark `#f2a48b`). `immichBrandColorLight`/`Dark` in
   `mobile/lib/constants/colors.dart` back that theme's seed + primary color
   and aren't used anywhere else, so it's a safe, isolated two-line swap.
4. Gives album cover titles (`_DynamicText` in
   `remote_album_sliver_app_bar.dart`) the same "expressive Google Sans
   Flex" treatment as the web patch's `css/50-album-title.css`: uppercase,
   weight 800, and the variable font's `ROND=100`/`wdth=25` axes (fully
   rounded, narrow) via Dart's `FontVariation`. Google Sans Flex is fetched
   from a Google Fonts CDN on web; mobile can't rely on that, so the
   variable TTF is bundled as an asset instead
   (`branding/assets-personal/mobile/fonts/GoogleSansFlex-Variable.ttf`,
   OFL-licensed like the already-bundled GoogleSans/GoogleSansCode) and
   wired into `pubspec.yaml`'s `flutter.fonts` list. The auto-sizing
   `_lineCount()` measurement was updated to uppercase its text too — it
   has to measure what actually gets rendered, or picks a font size based
   on a narrower (mixed-case) estimate than the (wider, uppercase) result.

   Regenerate the font (Latin subset only) if it ever needs updating:

   ```bash
   curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/125.0.0.0" \
     "https://fonts.googleapis.com/css2?family=Google+Sans+Flex:wdth,wght,ROND@25..151,1..1000,0..100" \
     | grep -A2 '/\* latin \*/' # grab the woff2 URL from the last block
   # download it, then decompress with fontTools (needs the `brotli` extra):
   python3 -c "from fontTools.ttLib.woff2 import decompress; decompress('in.woff2', 'GoogleSansFlex-Variable.ttf')"
   ```
5. Swaps the three in-app logo assets the mobile app actually renders (as
   opposed to the launcher icon, which is `flutter build`-time only and
   already covered by step 2): `immich-logo.png` (splash screen, login form,
   profile avatar, loading indicator), `immich-logo-inline-{dark,light}.svg`
   (the top app bar wordmark, picked by theme), and `immich-text-{dark,light}.png`
   (the profile/about dialog wordmark). All five source files at
   `branding/assets-personal/mobile/logo/` are pre-rendered, same reasoning
   as the launcher icon and font. The two SVGs are byte-identical copies of
   the web patch's own `gallery-logo-inline-{light,dark}.svg`; the three
   PNGs are rendered from the same wordmark. This was the one piece of the
   overlay that got left out when the script was first written — a local
   smoke-test build proved the swap looked right, but the swap itself never
   made it out of that one-off build into the checked-in script, so every
   real release was missing it until this was noticed and fixed.
   `immich-logo-inline-{dark,light}.png`, `immich-logo-w-bg*.png`,
   `immich-splash*.png`, `immich-logo-android-adaptive-icon.png`,
   `immich-logo.svg` and `immich-logo.json` are intentionally untouched —
   nothing in `mobile/lib` reads them; their only consumers are
   `flutter_launcher_icons`/`flutter_native_splash` via `pubspec.yaml`,
   neither of which this pipeline ever runs.

Add more personal overrides (splash screen, other screens' typography) to
this same script as they come up; it only ever needs to exist on
`quickme-branding`, never on `main`.

## Signing

A dedicated keystore was generated for this pipeline (**not** the org's
production Play Store key — kept deliberately separate so this personal
automation never touches or risks that key) and stored as repo secrets:

- `PERSONAL_KEY_JKS` (base64)
- `PERSONAL_ALIAS`
- `PERSONAL_ANDROID_KEY_PASSWORD`
- `PERSONAL_ANDROID_STORE_PASSWORD`

`mobile/android/app/build.gradle`'s `hasKeystore` check falls back to
Flutter's debug signing config if `key.jks` is absent/empty — fine for a
one-off smoke test, **not** fine for real use: that debug key is regenerated
per-runner, so consecutive builds sign with different keys and Android (and
therefore Obtainium) refuses to install over the previous copy. The
`PERSONAL_*` secrets above exist precisely so every build reuses the same
key and Obtainium can update in place.

If those secrets are ever lost, generate a new keystore and update all four
secrets together — there's no way to recover Android's ability to
update-in-place for anyone who already has the old key's APK installed; they
would need to uninstall and reinstall once.

## Obtainium setup

Add the app in Obtainium with:

- **Source**: GitHub
- **URL**: `https://github.com/BierDav/noodle-gallery`
- Obtainium's default "track the latest release" behavior works as-is since
  the workflow publishes each build with `--latest`.
- If prompted for an APK filter/pattern (multiple assets aren't published
  here, so this is mostly informational): the asset is named
  `gallery-personal-<version>-<code>.apk`.

**One-tap add**: scan or open

```
https://apps.obtainium.imranr.dev/redirect?r=obtainium://add/https%3A%2F%2Fgithub.com%2FBierDav%2Fnoodle-gallery
```

on the phone (works with or without Obtainium already installed — the
`https://` redirect opens in a browser first if needed). This is
Obtainium's own `action=add` deep link
(`lib/pages/home.dart` → `interpretLink`), which just pre-fills the "Add
App" screen's URL field and lets Obtainium's normal GitHub-source detection
fill in everything else — not a hand-built `additionalSettings` payload
(the `action=app` deep link Obtainium uses for its own "share config" export
takes a full JSON app object; deriving one by hand risks missing a default
the app would otherwise infer, so `add` was the safer choice here).

## Copilot handoff caveat

Earlier versions of this pipeline pushed conflicted rebases as a PR and
assigned pipeline failures to Copilot's coding agent automatically, via
`.github/actions/assign-copilot` (looks Copilot up as a `suggestedActors`
GraphQL "actor" and assigns it via `replaceActorsForAssignable` — the
documented mechanism for assigning a bot that isn't a repo collaborator,
since the REST assignees endpoint can't target it). Both handoffs are
disabled for now: a conflicted rebase just fails the job (see above) instead
of pushing anything, and the `on-failure` issue is opened but left
unassigned. The action itself is still checked in, unused, in case it's
worth re-enabling later.

## Re-enabling other workflows

Every other workflow on this fork was disabled via `gh workflow disable`
(a repo-level GitHub setting, not a file edit — so it survives future
`jj rebase`/sync onto upstream without creating merge conflicts). To bring
one back:

```bash
gh workflow enable "<workflow name>" --repo BierDav/noodle-gallery
```
