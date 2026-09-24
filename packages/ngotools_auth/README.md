# ngotools_auth

Authorization Code with PKCE, NGO.Tools token exchange, protected session
storage, renewal, logout, and token-free Bloc state for organization apps.

The package opens the system browser through AppAuth. Raw OIDC and API tokens
stay behind the package boundary. Platform attestation implementations receive
only the canonical SHA-256 challenge binding.
