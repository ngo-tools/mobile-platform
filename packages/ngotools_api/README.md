# ngotools_api

Secure runtime access for NGO.Tools organization apps. The public API exposes
immutable capabilities, contact projections, retry-safe confirmed mutations,
protected release approval, and sanitized RFC 9457-style problems. Dio,
polling credentials, and the OpenAPI-generated transport remain internal to
this package.

The client is generated from `openapi/mobile-runtime.yaml` with a pinned
OpenAPI Generator binary:

```bash
dart run tool/generate_api.dart
```

The platform gate rejects contract, generator, and generated-output drift.
