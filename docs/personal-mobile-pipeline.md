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
  `jj rebase -b quickme-branding -d release`.
  - **No-op** (release tag unchanged since the last run): skips the build.
  - **Conflict**: pushes the conflicted branch as-is, opens a PR against
    `main`, and tries to assign it to Copilot's coding agent (via the
    `suggestedActors` GraphQL lookup, since Copilot isn't a normal
    collaborator and can't be assigned through the REST assignees endpoint).
    If that assignment call ever breaks (GitHub API surface for this is
    still new), the PR is still there for manual resolution — the next
    scheduled run picks back up once it's fixed.
  - **Clean rebase**: pushes `quickme-branding` and hands off to `build`.
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

A jj commit (or short stack of commits), based directly on the `release`
tag, carrying personal patches. Every scheduled run rebases this bookmark
onto wherever `release` has moved to. To add more personal changes, commit
them on top of `quickme-branding` locally and push; the workflow only ever
moves the bookmark forward relative to `release`, it doesn't touch your
commits. It currently carries one thing:
`branding/scripts/apply-personal-branding.sh`.

## Personal branding overlay

`branding/scripts/apply-personal-branding.sh` is a deliberately separate
script from the org's `branding/scripts/apply-branding.sh` — the org script
is shared/upstream-owned and this fork rebases onto `open-noodle/gallery`
regularly, so any personal preference living inside it would be a permanent
source of merge conflicts. A new file with nothing for a rebase to collide
with sidesteps that entirely. The `build` job runs it right after the org's
`apply-branding` action.

It currently does two things:

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

Add more personal overrides (accent colors, splash) to this same script as
they come up; it only ever needs to exist on `quickme-branding`, never on
`main`.

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
