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
