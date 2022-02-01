package com.gofed.driver

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.app.Notification;
import android.app.NotificationManager;
import android.app.NotificationChannel;
import android.net.Uri;
import android.media.AudioAttributes;
import android.content.ContentResolver;
import android.widget.Toast;
import android.os.Bundle

class MainActivity: FlutterActivity() {
  private val CHANNEL = "flutter_not" //The channel name you set in your main.dart file
  lateinit var builder: Notification.Builder

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      // Note: this method is invoked on the main thread.
      call, result ->

      if (call.method == "createNotificationChannel"){
        val argData = call.arguments as java.util.HashMap<String, String>
        val completed = createNotificationChannel(argData)
        if (completed == true){
            result.success(completed)
        }
        else{
            result.error("Error Code", "Error Message", null)
        }
      } else if (call.method == "showNotification") {
        val argData = call.arguments as java.util.HashMap<String, String>
        showNotification(getApplicationContext(), argData)
        result.success("")
      } else if (call.method == "showNotification") {
        val argData = call.arguments as java.util.HashMap<String, String>
        showNotification(getApplicationContext(), argData)

        val intent: Intent = Intent(this, MainActivity::class.java)
        intent.setAction(Intent.ACTION_RUN)
        intent.putExtra("route", "default")
        startActivity(intent)

        result.success("")
      } else {
        result.notImplemented()
      }
    }
  }

  private fun createNotificationChannel(mapData: HashMap<String,String>): Boolean {
    if (VERSION.SDK_INT >= VERSION_CODES.O) {
      val soundUri = Uri.parse("android.resource://" + getApplicationContext().getPackageName() + "/" + com.gofed.driver.R.raw.alert)
      val channel = NotificationChannel(mapData["id"], mapData["name"], NotificationManager.IMPORTANCE_HIGH).apply { 
          description = mapData["description"]
      }
      var audioAttributes: AudioAttributes = AudioAttributes.Builder()
              .setUsage(AudioAttributes.USAGE_NOTIFICATION)
              .build()
      channel.setSound(soundUri, audioAttributes)
      channel.enableLights(true)
      channel.enableVibration(true)
      val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
      notificationManager.createNotificationChannel(channel)
    }
    return true
  }

  private fun showNotification(context: Context, mapData: HashMap<String,String>): Boolean {
    System.out.println("new notification")
    val soundUri = Uri.parse("android.resource://" + getApplicationContext().getPackageName() + "/" + com.gofed.driver.R.raw.alert)
    val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    var audioAttributes: AudioAttributes = AudioAttributes.Builder()
              .setUsage(AudioAttributes.USAGE_NOTIFICATION)
              .build()
    if (VERSION.SDK_INT >= VERSION_CODES.O) {
        builder = Notification.Builder(context, mapData["id"])
                        .setSmallIcon(R.mipmap.ic_launcher)
                        .setContentTitle(mapData["title"])
                        .setContentText(mapData["message"])
                        .setSound(soundUri, audioAttributes)
    } else {
        builder = Notification.Builder(context)
                        .setSmallIcon(R.mipmap.ic_launcher)
                        .setContentTitle(mapData["title"])
                        .setContentText(mapData["message"])
                        .setSound(soundUri, audioAttributes)
    }
    notificationManager.notify(1234, builder.build())
    return true
  }
}
