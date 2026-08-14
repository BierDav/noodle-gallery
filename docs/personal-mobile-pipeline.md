# Personal Mobile Pipeline

Personal automation on `BierDav/noodle-gallery` (this fork only — not part of
`open-noodle/gallery` and not synced upstream). Keeps a small personal
branding patch rebased on top of the org's `release` tag and republishes a
sideloadable Android APK that Obtainium auto-installs.

## How it works

- `.github/workflows/personal-mobile-pipeline.yml` runs on a 30-minute
  `schedule` (plus manual `workflow_dispatch`).
- `rebase` job: installs `jj`, colocates it on the checkout, fetches
  `upstream` (`open-noodle/gallery`) and `origin`, then runs
  `jj rebase -b quickme-branding -d release` (always attempted — a no-op
  rebase when already based there is cheap).
  - **Conflict** (checked unconditionally, not just when the rebase above
    moved anything — a run can also inherit an already-conflicted commit a
    previous run pushed that nobody resolved yet): pushes the conflicted
    branch as-is, opens a PR against `main`, and tries to assign it to
    Copilot's coding agent (via the `suggestedActors` GraphQL lookup, since
    Copilot isn't a normal collaborator and can't be assigned through the
    REST assignees endpoint). If that assignment call ever breaks (GitHub
    API surface for this is still new), the PR is still there for manual
    resolution — the next scheduled run picks back up once it's fixed.
  - **Nothing new** (`quickme-branding`'s current commit already matches
    the `targetCommitish` of the latest GitHub Release — see below): skips
    the build. This is *not* the same as "release tag didn't move": pushing
    a new personal commit onto `quickme-branding` without `release` moving
    also produces a new tip, which correctly triggers a rebuild.
  - **Otherwise**: pushes `quickme-branding` and hands off to `build`.
- `build` job: applies the org's fork branding, then the personal branding
  overlay (see below), builds a release APK signed with the `PERSONAL_*`
  keystore secrets (falls back to Flutter's non-portable debug key if
  they're unset — see below), and publishes it as a GitHub Release tagged
  `personal-mobile-<version>-<code>`, marked `--latest`.
- `on-failure` job: runs whenever `rebase` or `build` genuinely fails (not
  on the ordinary no-op/conflict paths, which have their own handling
  above). Opens an issue linking the failed run and assigns it to Copilot's
  coding agent via the same `.github/actions/assign-copilot` mechanism, so a
  broken pipeline gets looked at even between checks.

## The `quickme-branding` bookmark

A single jj commit, based directly on the `release` tag, carrying personal
patches. Every scheduled run rebases this bookmark onto wherever `release`
has moved to. To add more personal changes, commit them on top of
`quickme-branding` locally and push; the workflow only ever moves the
bookmark forward relative to `release`, it doesn't touch your commits.

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

It currently does four things:

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

`.github/actions/assign-copilot` (used for both the conflict PR and the
`on-failure` issue) looks Copilot up as a `suggestedActors` GraphQL "actor"
and assigns it via `replaceActorsForAssignable` — the documented mechanism
for assigning a bot that isn't a repo collaborator, since the REST assignees
endpoint can't target it. This corner of GitHub's API is young — if GitHub
changes it, the step fails open (logs a warning, leaves the issue/PR
unassigned) rather than failing the run. Check the Actions log for
`::warning::` lines after any conflicted rebase or pipeline failure.

## Re-enabling other workflows

Every other workflow on this fork was disabled via `gh workflow disable`
(a repo-level GitHub setting, not a file edit — so it survives future
`jj rebase`/sync onto upstream without creating merge conflicts). To bring
one back:

```bash
gh workflow enable "<workflow name>" --repo BierDav/noodle-gallery
```
