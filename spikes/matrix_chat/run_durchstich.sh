#!/usr/bin/env bash
# Runs the end-to-end spike test (integration_test/chat_flow_test.dart) on a
# simulator/emulator against the local server with fresh users per run.
#
#   ./run_durchstich.sh ios <simulator-udid>
#   ./run_durchstich.sh android <adb-serial>
set -euo pipefail

cd "$(dirname "$0")"

PLATFORM=${1:?ios|android}
DEVICE=${2:?device id}
RUN=$(date +%H%M%S)
ALICE="alice${RUN}"
BOB="bob${RUN}"
LOG="/tmp/ngo-matrix-spike-${PLATFORM}-${RUN}.log"
[[ $PLATFORM == ios ]] && RUST_LOG_FILE="/tmp/ngo-matrix-spike-ios-${RUN}-rust.log"

for user in "$ALICE" "$BOB"; do
    docker compose --project-directory server --env-file server/generated/.env exec -T mas \
        mas-cli manage register-user --yes --ignore-password-complexity \
        --password "${TEST_PASSWORD:-spike-password-1}" "$user" >/dev/null 2>&1
done

if [[ $PLATFORM == android ]]; then
    # rustls-platform-verifier neither accepts extra roots on Android nor
    # honours the network security config; it trusts AndroidCAStore (system +
    # user CAs). Install the dev CA as user CA (rootable emulator, -read-only).
    ca_hash=$(openssl x509 -inform PEM -subject_hash_old -in server/generated/caddy-root.crt -noout)
    adb -s "$DEVICE" root >/dev/null 2>&1 && adb -s "$DEVICE" wait-for-device
    adb -s "$DEVICE" shell mkdir -p /data/misc/user/0/cacerts-added
    adb -s "$DEVICE" push server/generated/caddy-root.crt "/data/misc/user/0/cacerts-added/${ca_hash}.0" >/dev/null
    for port in 28448 28449 28450 28451; do
        adb -s "$DEVICE" reverse "tcp:${port}" "tcp:${port}" >/dev/null
    done
fi


EXAMPLE="$PWD/ngotools_matrix/example"
SHOTS="/tmp/ngo-matrix-spike-${PLATFORM}-${RUN}-screens"
mkdir -p "$SHOTS"
: > "$LOG"
# Take a device screenshot whenever the test prints `SPIKE_SCREENSHOT <name>`.
(tail -n +1 -F "$LOG" 2>/dev/null | while read -r line; do
    if [[ $line == *"SPIKE_SCREENSHOT "* ]]; then
        name=${line##*SPIKE_SCREENSHOT }
        if [[ $PLATFORM == ios ]]; then
            xcrun simctl io "$DEVICE" screenshot "$SHOTS/${name}.png" >/dev/null 2>&1
        else
            adb -s "$DEVICE" exec-out screencap -p > "$SHOTS/${name}.png"
        fi
        echo "SCREENSHOT $SHOTS/${name}.png"
    fi
    if [[ $line == *"SPIKE_NSE_PUSH "* && $PLATFORM == ios ]]; then
        read -r room event <<< "${line##*SPIKE_NSE_PUSH }"
        payload="$SHOTS/push-${RANDOM}.json"
        # APNs payload as Sygnal sends it for event_id_only (+ mutable-content for the NSE).
        printf '{"aps":{"alert":{"title":"NGO.Tools","body":"Neue Nachricht"},"mutable-content":1},"room_id":"%s","event_id":"%s","unread_count":1}' \
            "$room" "$event" > "$payload"
        # Delivery check only: simctl push does not invoke service extensions.
        xcrun simctl push "$DEVICE" tools.ngo.spike.ngotoolsMatrixExample "$payload" && echo "PUSHED $event"
        # Run the NSE code (same framework) as its own process in the simulator.
        fw="$EXAMPLE/build/ios/Debug-iphonesimulator/ngotools_matrix_core"
        group=$(xcrun simctl get_app_container "$DEVICE" tools.ngo.spike.ngotoolsMatrixExample group.tools.ngo.spike.matrix)
        xcrun -sdk iphonesimulator swiftc -O -target arm64-apple-ios15.0-simulator -F "$fw" -framework ngotools_matrix_core \
            "$EXAMPLE/ios/NotificationService/NseResolver.swift" "$EXAMPLE/ios/nse_cli/main.swift" -o "$SHOTS/nse-cli" \
            -Xlinker -rpath -Xlinker "$fw" && codesign -s - -f "$SHOTS/nse-cli" >/dev/null 2>&1
        echo "NSE_CLI default-memory: $(SIMCTL_CHILD_NGOTOOLS_NSE_DEFAULT_MEMORY=1 xcrun simctl spawn "$DEVICE" "$SHOTS/nse-cli" "$group" "$room" "$event" 2>&1 | tail -1)"
        echo "NSE_CLI low-memory: $(xcrun simctl spawn "$DEVICE" "$SHOTS/nse-cli" "$group" "$room" "$event" 2>&1 | tail -1)"
    fi
done) &
WATCHER=$!
trap 'kill $WATCHER 2>/dev/null' EXIT

cd ngotools_matrix/example
echo "Users: $ALICE / $BOB — log: $LOG"
if [[ $PLATFORM == android ]]; then
    # Profile build reuses the release Rust artifacts (no debug Rust build).
    runner=(flutter drive --driver=test_driver/integration_test.dart --target=integration_test/chat_flow_test.dart --profile)
else
    runner=(flutter test integration_test/chat_flow_test.dart)
fi

"${runner[@]}" -d "$DEVICE" \
    --dart-define=ALICE="$ALICE" --dart-define=BOB="$BOB" \
    ${RUST_LOG_FILE:+--dart-define=RUST_LOG_FILE="$RUST_LOG_FILE"} 2>&1 | tee "$LOG" | grep -E "SPIKE_METRIC|SPIKE_SYNC|SPIKE_ROOMS|SPIKE_RUST_LOG|SPIKE_NSE|NSE_CLI|PUSHED|All tests passed|Some tests failed|EXCEPTION|Expected|Actual|Error" || true
