package com.app.mapkit.pet_map

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setLocale("ru_RU") 
        MapKitFactory.setApiKey("997c6512-8b85-46dd-9d27-118c86801117") 
        super.configureFlutterEngine(flutterEngine)
    }
}
