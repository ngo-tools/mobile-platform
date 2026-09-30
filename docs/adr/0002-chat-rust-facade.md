# ADR 0002: Chat on matrix-rust-sdk via a Rust facade

## Status

Accepted.

## Context

Organization apps need a Matrix chat with end-to-end encryption and push. The
only mature Dart SDK is licensed under AGPL-3.0, which is not acceptable for
closed organization apps. matrix-rust-sdk (Apache-2.0) is mature, but its
UniFFI bindings (`matrix-sdk-ffi`) cannot be generated for Dart reliably and
expose a large, fast-changing API.

## Decision

`ngotools_chat` wraps matrix-rust-sdk in a small Rust facade
(`ngotools_matrix_core`) bound with flutter_rust_bridge.

- The facade pins exact SDK versions and absorbs SDK changes; the Dart API
  stays small.
- OAuth sessions and tokens stay in Rust, persisted in the encrypted store.
  Dart handles only the store key, which comes from the platform keystore.
  Exception (2026-09-30): organization apps sign in without a browser with a
  session NGO.Tools issues for the device (MAS personal session). Its token
  passes through Dart once, from the NGO.Tools API into the facade, and is
  never stored outside the encrypted store.
- On iOS, app and Notification Service Extension link the same framework and
  share the store through an App Group with cross-process locks.
- Release binaries are precompiled and signed in a protected CI environment;
  apps do not need a Rust toolchain.
- `cargo deny` rejects GPL, LGPL and AGPL dependencies and known advisories.

## Consequences

The platform maintains a Rust facade and follows matrix-rust-sdk releases
(breaking changes every release). The chat adds about 24 MB installed and
10 MB download per app. Other packages may not import
`package:ngotools_chat/src/`.
