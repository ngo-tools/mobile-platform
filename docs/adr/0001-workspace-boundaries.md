# ADR 0001: Workspace boundaries

## Status

Accepted.

## Decision

The platform uses a Dart pub workspace with small packages for core
configuration, auth, API, design, navigation, and testing. Organization apps
depend on these packages but do not copy their implementations.

Dependencies point toward stable platform contracts:

- `ngotools_mobile_core` has no internal dependency.
- `ngotools_auth`, `ngotools_api`, and `ngotools_design_system` may depend on
  core.
- `ngotools_navigation` may depend on core and auth.
- `ngotools_testing` may depend on all public packages.
- apps may depend on all public packages.

The repository gate rejects internal dependencies outside this graph.

## Consequences

Auth and API internals can evolve without leaking tokens or generated transport
types into feature screens. The shared workspace resolution catches package
version conflicts before publication.
