# Spike: Matrix chat on matrix-rust-sdk

Throwaway spike, not part of the workspace or the repository gate. It checks
whether a small Dart client on top of matrix-rust-sdk (Apache-2.0) is viable
for the organization apps. The result report lives outside this repository.

## Layout

- `server/`: local Synapse 1.161 + MAS 1.25 + Element Web behind Caddy
  (local CA) and a mock push gateway (`push_gateway.py`, Sygnal
  `event_id_only` format).
- `ngotools_matrix/`: Flutter FFI plugin (flutter_rust_bridge 2.13, cargokit).
  - `rust/`: facade crate `ngotools_matrix_core` (OAuth via MAS, room list,
    timeline, E2EE, recovery, media, pusher, notifications) plus a C ABI for
    the iOS Notification Service Extension (`src/nse.rs`).
  - `ios/`: `ngotools_matrix_core` pod (Rust framework shared by app and NSE)
    and the Flutter plugin pod.
  - `example/`: demo app, NSE target and the end-to-end test
    `integration_test/chat_flow_test.dart`.
- `run_durchstich.sh`: runs the end-to-end test on a simulator/emulator.

## Run

```bash
cd server
./setup.sh up        # render configs, start containers
./setup.sh ca        # trust the local CA in booted iOS simulators
python3 push_gateway.py 28451 &

cd ..
./run_durchstich.sh ios <simulator-udid>
./run_durchstich.sh android <emulator-serial>   # rootable emulator, started with -read-only
```

Requirements: Rust 1.98.1 (pinned), Android NDK 28.2, Xcode, Docker. The
vendored cargokit is patched to accept pinned toolchain versions.

## License gate

```bash
cd ngotools_matrix/rust
cargo deny check licenses sources
```
