# Organization app agent rules

- Run `flutter analyze` and `flutter test` before proposing a pull request.
- Read `APP_BRIEF.md` before changing application behavior.
- Before implementing a domain feature, run
  `dart run tool/modules.dart search <term>` and inspect matching modules with
  `dart run tool/modules.dart explain <module>`.
- Add only modules marked `available` with
  `dart run tool/modules.dart add <module>`; never reimplement a planned or
  supported platform module as organization-specific code.
- Treat the local module catalog as client metadata only. Backend capabilities,
  policies, and token abilities remain authoritative.
- Keep this repository free of production data, raw tokens, signing material,
  and store credentials. Use synthetic fixtures and `.invalid` hosts.
- Do not add native permissions, external hosts, dependencies, API scopes,
  signing, or release configuration without explicit manifest changes, tests,
  and human review.
- Never expose raw OAuth or API tokens to application or feature code.
- Use repositories from the NGO.Tools packages; screens must not issue direct
  HTTP requests.
- Write English Conventional Commit messages.
