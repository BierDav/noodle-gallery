#!/usr/bin/env bash
# Personal overrides layered on top of the org's own apply-branding.sh.
#
# Deliberately a separate script rather than an edit to apply-branding.sh:
# that file is shared/org-owned, and this fork gets rebased onto
# open-noodle/gallery regularly. Keeping personal preferences in their own
# new file means an org branding change can never conflict with a personal
# one — there's nothing here for a rebase to collide with.
#
# Only used by .github/workflows/personal-mobile-pipeline.yml, run after the
# shared apply-branding action.
set -euo pipefail
cd "$(dirname "$0")/../.."

# Home-screen app label: "Noodle" instead of the org's "Noodle Gallery".
# Scoped to the <application> tag's label specifically (not the
# intent-filter / widget labels elsewhere in the manifest, which stay as-is).
sed -i.bak -E 's/(<application android:label=")[^"]*(")/\1Noodle\2/' \
  mobile/android/app/src/main/AndroidManifest.xml
rm -f mobile/android/app/src/main/AndroidManifest.xml.bak

# Launcher icon: the personal brand kit's coral aperture mark, pre-rendered
# to the same file layout/proportions the org's own apply-branding.sh uses
# (see its "Android mipmap launcher icons" / "adaptive icon" steps) so this
# is a drop-in override, not a different convention. Source SVG + full brand
# kit (accent colors, web CSS, favicons) lives outside this repo; regenerate
# with rsvg-convert + ImageMagick if the mark ever changes.
assets="branding/assets-personal/mobile/android"
android_res="mobile/android/app/src/main/res"

cp "$assets/ic_launcher_foreground.png" "$android_res/drawable/ic_launcher_foreground.png"
cp "$assets/ic_launcher_monochrome.png" "$android_res/drawable/ic_launcher_monochrome.png"
for density in mdpi hdpi xhdpi xxhdpi xxxhdpi; do
  cp "$assets/ic_launcher.png" "$android_res/mipmap-${density}/ic_launcher.png"
done
