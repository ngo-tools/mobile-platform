// C ABI of the Rust facade for native callers (iOS Notification Service
// Extension). Dart uses the flutter_rust_bridge bindings instead.
#pragma once

#ifdef __cplusplus
extern "C" {
#endif

/// Resolves and decrypts the event of an `event_id_only` push. Returns a JSON
/// string ({ok, room_name, sender_name, body, is_encrypted, duration_ms,
/// error}) that must be released with `ngotools_nse_string_free`.
char *ngotools_nse_get_notification(const char *config_json, const char *room_id, const char *event_id);

void ngotools_nse_string_free(char *value);

#ifdef __cplusplus
}
#endif
