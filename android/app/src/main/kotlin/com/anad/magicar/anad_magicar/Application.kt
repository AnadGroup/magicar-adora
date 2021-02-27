package com.anad.magicar.anad_magicar

import android.os.Bundle

import io.flutter.embedding.android.FlutterActivity
import io.flutter.app.FlutterApplication
//import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.GeneratedPluginRegistrant
//import com.google.firebase.messaging.FirebaseMessagingService
//import io.flutter.plugins.androidalarmmanager.AlarmService;
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

class Application : FlutterApplication() , PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate();
       // AlarmService.setPluginRegistrant(this);
        //FlutterFirebaseMessagingService.setPluginRegistrant(this);
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);

    }

   override fun registerWith( registry: PluginRegistry) {
       // GeneratedPluginRegistrant.registerWith(registry);
    }
}
