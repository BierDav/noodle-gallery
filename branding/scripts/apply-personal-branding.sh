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

# Accent color: same coral used for the web patch's --immich-ui-primary-500
# (light) / dark equivalent. immichBrandColorLight/Dark back the app's
# default ("indigo") theme's seed + primary color and aren't used anywhere
# else, so this is a safe, isolated swap of the Google-blue defaults.
sed -i.bak \
  -e 's/const Color immichBrandColorLight = Color(0x[0-9A-Fa-f]\{8\});/const Color immichBrandColorLight = Color(0xFFE85D38);/' \
  -e 's/const Color immichBrandColorDark = Color(0x[0-9A-Fa-f]\{8\});/const Color immichBrandColorDark = Color(0xFFF2A48B);/' \
  mobile/lib/constants/colors.dart
rm -f mobile/lib/constants/colors.dart.bak

# Album cover title: the web patch's "expressive Google Sans Flex" treatment
# (see brand kit's css/50-album-title.css) ported to the mobile equivalent,
# _DynamicText in remote_album_sliver_app_bar.dart. Google Sans Flex is a
# variable font (wdth/wght/ROND axes) fetched from Google Fonts on web; here
# it's bundled as an asset (OFL-licensed, same as the already-bundled
# GoogleSans/GoogleSansCode) since a mobile app can't rely on a runtime CDN
# import. Multi-line source edits use python3 (preinstalled on the GH Actions
# runner) rather than fighting sed/awk over multi-line matches.
font_dest="mobile/assets/fonts/GoogleSansFlex"
mkdir -p "$font_dest"
cp "branding/assets-personal/mobile/fonts/GoogleSansFlex-Variable.ttf" "$font_dest/GoogleSansFlex-Variable.ttf"

python3 <<'PYEOF'
import re

pubspec = "mobile/pubspec.yaml"
with open(pubspec) as f:
    content = f.read()
if "family: GoogleSansFlex" not in content:
    block = (
        "  fonts:\n"
        "    - family: GoogleSansFlex\n"
        "      fonts:\n"
        "        - asset: assets/fonts/GoogleSansFlex/GoogleSansFlex-Variable.ttf\n"
    )
    content = content.replace("  fonts:\n", block, 1)
    with open(pubspec, "w") as f:
        f.write(content)

widget = "mobile/lib/widgets/common/remote_album_sliver_app_bar.dart"
with open(widget) as f:
    content = f.read()

content = content.replace(
    "  static const _baseTextStyle = TextStyle(\n"
    "    color: Colors.white,\n"
    "    fontWeight: FontWeight.bold,\n",
    "  static const _baseTextStyle = TextStyle(\n"
    "    color: Colors.white,\n"
    "    fontFamily: 'GoogleSansFlex',\n"
    "    fontWeight: FontWeight.w800,\n"
    "    fontVariations: [FontVariation('ROND', 100), FontVariation('wdth', 25)],\n",
    1,
)
content = content.replace(
    "return Text(text, style: _baseTextStyle.copyWith(fontSize: _fontSize()), maxLines: 3);",
    "return Text(text.toUpperCase(), style: _baseTextStyle.copyWith(fontSize: _fontSize()), maxLines: 3);",
    1,
)
# Uppercase glyphs are typically wider than mixed-case for the same string --
# _lineCount must measure the same text that actually gets rendered above,
# or the auto-sizing picks a font size based on a narrower measurement than
# what's displayed and the uppercase title can overflow to more lines than
# _fontSize() intended.
content = content.replace(
    "      text: TextSpan(\n        text: text,\n        style: _baseTextStyle.copyWith(fontSize: fontSize),\n      ),",
    "      text: TextSpan(\n        text: text.toUpperCase(),\n        style: _baseTextStyle.copyWith(fontSize: fontSize),\n      ),",
    1,
)
with open(widget, "w") as f:
    f.write(content)
PYEOF

# In-app logo/wordmark: same personal mark + "Noodle Gallery" lockup as the
# web patch's top-bar wordmark (gallery-logo-inline-{light,dark}.svg in the
# brand kit — the two SVGs below are byte-identical copies of those), reused
# for the three places the mobile app actually renders a logo asset rather
# than the launcher icon:
#   - immich-logo.png: splash screen, login form, profile avatar, loading
#     indicator (immich_logo.dart and its direct AssetImage call sites).
#   - immich-logo-inline-{dark,light}.svg: the top app bar wordmark
#     (immich_sliver_app_bar.dart), picked by theme at runtime.
#   - immich-text-{dark,light}.png: the profile/about dialog wordmark
#     (app_bar_dialog.dart). Rendered from the same inline SVGs -- the org's
#     own immich-text-*.png and immich-logo-inline-*.png are already
#     byte-identical for the same reason.
# immich-logo-inline-{dark,light}.png, immich-logo-w-bg*.png,
# immich-splash*.png, immich-logo-android-adaptive-icon.png, immich-logo.svg
# and immich-logo.json aren't referenced anywhere in mobile/lib and are left
# alone -- flutter_launcher_icons/flutter_native_splash (their only
# consumers, via pubspec.yaml) never run in this pipeline.
logo_assets="branding/assets-personal/mobile/logo"

cp "$logo_assets/immich-logo.png" mobile/assets/immich-logo.png
cp "$logo_assets/immich-logo-inline-dark.svg" mobile/assets/immich-logo-inline-dark.svg
cp "$logo_assets/immich-logo-inline-light.svg" mobile/assets/immich-logo-inline-light.svg
cp "$logo_assets/immich-text-dark.png" mobile/assets/immich-text-dark.png
cp "$logo_assets/immich-text-light.png" mobile/assets/immich-text-light.png

# Native launch splash: resized at build time from the immich-logo.png just
# copied above, so the pre-Flutter splash screen shows the same coral
# aperture mark as the in-app Flutter splash/login/avatar instead of
# upstream's stock camera icon. The org's own apply-branding.sh has the same
# resize-with-ImageMagick machinery for this (see its splash.png /
# splash-android12.png handling), gated behind assets/splash.png -- which the
# org has never supplied (branding/assets/README.md still lists it
# unchecked) -- so this personal overlay is what actually brands these three
# surfaces today:
#   - drawable(-night)?-<density>/splash.png: the classic pre-Android-12
#     launch_background.xml layer-list, centered over @drawable/background.
#   - drawable(-night)?-<density>/android12splash.png: the Android 12+
#     SplashScreen API's windowSplashScreenAnimatedIcon (values(-night)-v31/
#     styles.xml), centered over a solid windowSplashScreenBackground colour
#     baked into that same styles.xml, not into the PNG.
#   - ios/Runner/Assets.xcassets/LaunchImage.imageset: the launch storyboard's
#     centered LaunchImage, over LaunchBackground.
# No separate night-mode mark is needed for any of these: the icon itself
# stays transparent (immich-logo.png has an alpha channel), so one PNG per
# size covers both themes -- only the background layers/colours differ, and
# those are untouched here.
resize_png() {
  local src="$1" dest="$2" size="$3"
  if command -v convert &>/dev/null; then
    convert "$src" -resize "${size}x${size}" "$dest"
  elif command -v magick &>/dev/null; then
    magick "$src" -resize "${size}x${size}" "$dest"
  else
    echo "ERROR: ImageMagick convert or magick is required to resize splash assets" >&2
    return 1
  fi
}

# Android 12+'s SplashScreen API centres this icon inside a system-drawn
# shape (a circle on stock Android) and, unlike an adaptive icon, doesn't pad
# it for you -- content drawn edge-to-edge gets clipped by that mask. Render
# the mark at half the canvas size, transparent-padded back out to the full
# size, so it sits inside the safe zone. The classic pre-31 splash.png and
# iOS's LaunchImage are plain centered bitmaps with no OS-applied masking, so
# they keep using the full-bleed resize_png above.
resize_png_padded() {
  local src="$1" dest="$2" size="$3"
  local content_size=$((size / 2))
  if command -v convert &>/dev/null; then
    convert "$src" -resize "${content_size}x${content_size}" -background none -gravity center -extent "${size}x${size}" "$dest"
  elif command -v magick &>/dev/null; then
    magick "$src" -resize "${content_size}x${content_size}" -background none -gravity center -extent "${size}x${size}" "$dest"
  else
    echo "ERROR: ImageMagick convert or magick is required to resize splash assets" >&2
    return 1
  fi
}

splash_src="mobile/assets/immich-logo.png"

for density in mdpi hdpi xhdpi xxhdpi xxxhdpi; do
  case "$density" in
    mdpi) splash_size=80; android12_size=288 ;;
    hdpi) splash_size=120; android12_size=432 ;;
    xhdpi) splash_size=160; android12_size=576 ;;
    xxhdpi) splash_size=240; android12_size=864 ;;
    xxxhdpi) splash_size=320; android12_size=1152 ;;
  esac

  res_dir="$android_res/drawable-${density}"
  resize_png "$splash_src" "$res_dir/splash.png" "$splash_size"
  resize_png_padded "$splash_src" "$res_dir/android12splash.png" "$android12_size"

  night_dir="$android_res/drawable-night-${density}"
  if [[ -d "$night_dir" ]]; then
    resize_png_padded "$splash_src" "$night_dir/android12splash.png" "$android12_size"
  fi
done

ios_launchimg_dest="mobile/ios/Runner/Assets.xcassets/LaunchImage.imageset"
if [[ -d "$ios_launchimg_dest" ]]; then
  resize_png "$splash_src" "$ios_launchimg_dest/LaunchImage.png" 80
  resize_png "$splash_src" "$ios_launchimg_dest/LaunchImage@2x.png" 160
  resize_png "$splash_src" "$ios_launchimg_dest/LaunchImage@3x.png" 240
fi
