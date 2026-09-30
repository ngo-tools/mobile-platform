#!/usr/bin/env bash
# Runs the end-to-end test (integration_test/chat_flow_e2e.dart) on a
# simulator/emulator against the local server with fresh users per run.
#
#   ./run_durchstich.sh ios <simulator-udid>
#   ./run_durchstich.sh android <adb-serial>
set -euo pipefail

cd "$(dirname "$0")"
# Paths below are relative to this e2e directory.

PLATFORM=${1:?ios|android}
DEVICE=${2:?device id}
RUN=$(date +%H%M%S)
ALICE="alice${RUN}"
BOB="bob${RUN}"
LOG="/tmp/ngotools-chat-e2e-${PLATFORM}-${RUN}.log"
[[ $PLATFORM == ios ]] && RUST_LOG_FILE="/tmp/ngotools-chat-e2e-ios-${RUN}-rust.log"

for user in "$ALICE" "$BOB"; do
    docker compose --project-directory server --env-file server/generated/.env exec -T mas \
        mas-cli manage register-user --yes --ignore-password-complexity \
        --password "${TEST_PASSWORD:-e2e-password-1}" "$user" >/dev/null 2>&1
done

if [[ $PLATFORM == android ]]; then
    # rustls-platform-verifier neither accepts extra roots on Android nor
    # honours the network security config; it trusts AndroidCAStore (system +
    # user CAs). Install the dev CA as user CA (rootable emulator, -read-only).
    ca_hash=$(openssl x509 -inform PEM -subject_hash_old -in server/generated/caddy-root.crt -noout)
    adb -s "$DEVICE" root >/dev/null 2>&1 || true
    # adbd restarts as root; wait until the root shell answers again.
    for _ in $(seq 1 30); do
        [[ "$(adb -s "$DEVICE" shell whoami 2>/dev/null | tr -d '\r')" == root ]] && break
        sleep 1
    done
    adb -s "$DEVICE" shell mkdir -p /data/misc/user/0/cacerts-added
    adb -s "$DEVICE" push server/generated/caddy-root.crt "/data/misc/user/0/cacerts-added/${ca_hash}.0" >/dev/null
    for port in 28448 28449 28450 28451; do
        adb -s "$DEVICE" reverse "tcp:${port}" "tcp:${port}" >/dev/null
    done
fi


EXAMPLE="$(cd .. && pwd)/example"
SHOTS="/tmp/ngotools-chat-e2e-${PLATFORM}-${RUN}-screens"
mkdir -p "$SHOTS"
: > "$LOG"
# Take a device screenshot whenever the test prints `E2E_SCREENSHOT <name>`.
(tail -n +1 -F "$LOG" 2>/dev/null | while read -r line; do
    if [[ $line == *"E2E_SCREENSHOT "* ]]; then
        name=${line##*E2E_SCREENSHOT }
        if [[ $PLATFORM == ios ]]; then
            xcrun simctl io "$DEVICE" screenshot "$SHOTS/${name}.png" >/dev/null 2>&1
        else
            adb -s "$DEVICE" exec-out screencap -p > "$SHOTS/${name}.png"
        fi
        echo "SCREENSHOT $SHOTS/${name}.png"
    fi
    # Account changes on the server: `E2E_MAS kill-sessions|lock-user <user>`.
    if [[ $line == *"E2E_MAS "* ]]; then
        read -r command user <<< "${line##*E2E_MAS }"
        if [[ $command == kill-sessions || $command == lock-user ]]; then
            docker compose --project-directory server --env-file server/generated/.env exec -T mas \
                mas-cli manage "$command" "$user" >/dev/null 2>&1 && echo "MAS $command $user"
        fi
    fi
    if [[ $line == *"E2E_NSE_PUSH "* && $PLATFORM == ios ]]; then
        read -r room event <<< "${line##*E2E_NSE_PUSH }"
        payload="$SHOTS/push-${RANDOM}.json"
        # APNs payload as Sygnal sends it for event_id_only (+ mutable-content for the NSE).
        printf '{"aps":{"alert":{"title":"NGO.Tools","body":"Neue Nachricht"},"mutable-content":1},"room_id":"%s","event_id":"%s","unread_count":1}' \
            "$room" "$event" > "$payload"
        # Delivery check only: simctl push does not invoke service extensions.
        xcrun simctl push "$DEVICE" tools.ngo.mobile.chatExample "$payload" && echo "PUSHED $event"
        # Run the NSE code (same framework) as its own process in the simulator.
        fw="$EXAMPLE/build/ios/Debug-iphonesimulator/ngotools_matrix_core"
        group=$(xcrun simctl get_app_container "$DEVICE" tools.ngo.mobile.chatExample group.tools.ngo.mobile.chat-example)
        xcrun -sdk iphonesimulator swiftc -O -target arm64-apple-ios15.0-simulator -F "$fw" -framework ngotools_matrix_core \
            "$EXAMPLE/ios/NotificationService/NseResolver.swift" "$EXAMPLE/ios/nse_cli/main.swift" -o "$SHOTS/nse-cli" \
            -Xlinker -rpath -Xlinker "$fw" && codesign -s - -f "$SHOTS/nse-cli" >/dev/null 2>&1
        echo "NSE_CLI default-memory: $(SIMCTL_CHILD_NGOTOOLS_NSE_DEFAULT_MEMORY=1 xcrun simctl spawn "$DEVICE" "$SHOTS/nse-cli" "$group" "$room" "$event" 2>&1 | tail -1)"
        echo "NSE_CLI low-memory: $(xcrun simctl spawn "$DEVICE" "$SHOTS/nse-cli" "$group" "$room" "$event" 2>&1 | tail -1)"
    fi
done) &
WATCHER=$!
# The watcher runs `tail -F` and the read loop as child processes; stop them
# too, or they outlive the run and react to later logs.
stop_watcher() {
    pkill -TERM -P "$WATCHER" 2>/dev/null
    kill "$WATCHER" 2>/dev/null
}
trap stop_watcher EXIT

cd "$EXAMPLE"
echo "Users: $ALICE / $BOB — log: $LOG"
if [[ $PLATFORM == android ]]; then
    # Profile build reuses the release Rust artifacts (no debug Rust build).
    runner=(flutter drive --driver=test_driver/e2e_driver.dart --target=integration_test/chat_flow_e2e.dart --profile)
else
    runner=(flutter test integration_test/chat_flow_e2e.dart)
fi

"${runner[@]}" -d "$DEVICE" \
    --dart-define=ALICE="$ALICE" --dart-define=BOB="$BOB" \
    ${RUST_LOG_FILE:+--dart-define=RUST_LOG_FILE="$RUST_LOG_FILE"} 2>&1 | tee "$LOG" | grep -E "E2E_METRIC|E2E_SYNC|E2E_SESSION|MAS |E2E_ROOMS|E2E_RUST_LOG|E2E_NSE|NSE_CLI|PUSHED|All tests passed|Some tests failed|EXCEPTION|Expected|Actual|Error" || true
