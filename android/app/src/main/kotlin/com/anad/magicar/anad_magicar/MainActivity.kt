package com.anad.magicar.anad_magicar

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.app.FlutterFragmentActivity
import android.view.WindowManager.LayoutParams

class MainActivity: FlutterFragmentActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    //getWindow().addFlags(LayoutParams.FLAG_SECURE)
  }
}
