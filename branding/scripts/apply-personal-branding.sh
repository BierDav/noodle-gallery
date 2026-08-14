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
