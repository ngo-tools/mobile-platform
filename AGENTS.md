# Agent rules

- Run `dart run tool/check.dart` before proposing a pull request.
- Keep the repository free of production data, tokens, signing material, and
  store credentials.
- Use only synthetic fixtures and `.invalid` hosts.
- Do not add a native permission, external host, API scope, dependency, or
  release configuration without an explicit manifest change and tests.
- Do not weaken formatting, analysis, architecture, secret-scan, or test gates.
- Keep raw OAuth and API tokens inside `ngotools_auth`; application and feature
  code may consume authentication state, not token strings.
- Access NGO.Tools only through repositories exposed by `ngotools_api`; screens
  and feature code must not issue direct HTTP requests.
- Before implementing domain behavior, search the validated module catalog with
  `dart run tool/modules.dart search <term>` and inspect matching descriptors.
- Do not duplicate a supported module in organization-specific code or treat a
  module marked `planned` as production-ready.
- Use the external system browser with Authorization Code and PKCE. Never add a
  WebView login.
- Organization apps are bound to one tenant. Do not add runtime tenant
  selection to the shared Golden Path.
- Signing and store secrets may exist only in protected CI environments and
  require human release approval.
- Write English Conventional Commit messages.
