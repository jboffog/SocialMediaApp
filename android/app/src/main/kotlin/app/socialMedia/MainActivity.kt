package app.socialMedia

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterFragmentActivity() {
    // override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    //     GeneratedPluginRegistrant.registerWith(flutterEngine);
    //     new MethodChannel (flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
    //     .setMethodCallHandler((call, result) -> {});
    // }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}
