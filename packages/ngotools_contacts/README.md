# ngotools_contacts

Read-only contact discovery for NGO.Tools mobile apps. The package provides a
stable repository boundary, stale-request-safe state management, and adaptive
list and detail views.

Optional offline reads use `EncryptedContactCache`: the complete bounded cache
document is authenticated with AES-256-GCM, its random key remains in platform
protected storage, and its scope is bound to one app, environment, tenant, and
authenticated user. Only retriable transport failures may fall back to a fresh
cache entry; authorization and invalid-response failures stay fail-closed.

Create a new scope and cache for each authenticated session, register it with
`MobileAuthCubit.registerPrivateDataPurger`, and wrap the remote repository in
`CachingContactsRepository`. This guarantees explicit logout and API-triggered
session expiry attempt to remove both ciphertext and key. A purged cache seals
itself so a late network response cannot recreate data after logout.
