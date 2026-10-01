#!/usr/bin/env bash
# Signs the example app with a free Apple ID ("Personal Team") for testing on
# an iPhone without the Apple Developer Program: own bundle id, no push, no
# App Group (the Notification Service Extension stays inert).
#
#   e2e/device/personal_team.sh [TEAM_ID]   # write example/ios/Flutter/Personal.xcconfig
#   e2e/device/personal_team.sh --remove    # back to the NGO.Tools team
#
# Without TEAM_ID the team of the only "Apple Development" certificate in the
# login keychain is used (Xcode creates it after adding the Apple ID under
# Settings → Accounts and building once).
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
target="$here/../../example/ios/Flutter/Personal.xcconfig"

if [[ "${1:-}" == "--remove" ]]; then
    rm -f "$target"
    echo "Removed $target – signing with the NGO.Tools team again."
    exit 0
fi

team="${1:-}"

if [[ -z "$team" ]]; then
    teams=$(security find-certificate -a -c "Apple Development" -p 2>/dev/null \
        | openssl crl2pkcs7 -nocrl -certfile /dev/stdin 2>/dev/null \
        | openssl pkcs7 -print_certs -noout 2>/dev/null \
        | grep -o 'OU *= *[A-Z0-9]\{10\}' | sed 's/.*= *//' | sort -u)
    count=$(printf '%s' "$teams" | grep -c . || true)

    if [[ "$count" != "1" ]]; then
        echo "Found $count Apple Development teams${teams:+: $(echo $teams)}." >&2
        echo "Pass the team id: $0 TEAM_ID (Xcode → Settings → Accounts → team)." >&2
        exit 1
    fi

    team="$teams"
fi

suffix=$(echo "$team" | tr '[:upper:]' '[:lower:]')

cat > "$target" <<XCCONFIG
// Written by e2e/device/personal_team.sh – not committed.
NGO_DEVELOPMENT_TEAM = $team
NGO_APP_ID = tools.ngo.mobile.chatExample.p$suffix
NGO_RUNNER_ENTITLEMENTS =
NGO_NSE_ENTITLEMENTS =
XCCONFIG

echo "Signing with team $team as tools.ngo.mobile.chatExample.p$suffix (no push, no App Group)."
