//! Android bootstrap: rustls-platform-verifier needs the JVM and the
//! application context before the first TLS handshake.

use jni::{errors::ThrowRuntimeExAndDefault, objects::JObject, EnvUnowned};

#[unsafe(no_mangle)]
pub extern "system" fn Java_tools_ngo_spike_ngotools_1matrix_NgotoolsMatrixPlugin_nativeInit<'caller>(
    mut unowned_env: EnvUnowned<'caller>,
    _class: JObject<'caller>,
    context: JObject<'caller>,
) {
    unowned_env
        .with_env(|env| -> jni::errors::Result<()> {
            rustls_platform_verifier::android::init_with_env(env, context)
        })
        .resolve::<ThrowRuntimeExAndDefault>()
}
