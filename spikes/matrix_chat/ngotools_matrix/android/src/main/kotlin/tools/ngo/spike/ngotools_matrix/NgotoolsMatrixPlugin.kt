package tools.ngo.spike.ngotools_matrix

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** Initializes the Rust TLS verifier with the application context. */
class NgotoolsMatrixPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        ensureInitialized(binding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}

    companion object {
        @Volatile private var initialized = false

        @JvmStatic
        @Synchronized
        fun ensureInitialized(context: Context) {
            if (initialized) return
            System.loadLibrary("ngotools_matrix_core")
            nativeInit(context.applicationContext)
            initialized = true
        }

        @JvmStatic private external fun nativeInit(context: Context)
    }
}
