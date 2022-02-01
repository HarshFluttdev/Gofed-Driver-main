import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quicksewadriver/Screens/home/RidePopup.dart';
import 'package:quicksewadriver/Screens/login/LoginScreen.dart';
import 'package:quicksewadriver/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool rideListOpened = false;
BuildContext appContext;

Future<void> backgroundMessageHandler(
  RemoteMessage message,
) async {
  if (globalHomeContext != null) {
    Navigator.push(
      globalHomeContext,
      MaterialPageRoute(
        builder: (context) => RidePopup(
          id: message.data['id'].toString(),
          pick: message.data['pick'].toString(),
          drop: message.data['drop'].toString(),
          amount: message.data['amount'].toString(),
        ),
      ),
    );
  }
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // NotificationDetails notificationDetails = NotificationDetails(
  //   android: AndroidNotificationDetails(
  //     'Ride',
  //     'Gofed Ride',
  //     fullScreenIntent: true,
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     visibility: NotificationVisibility.public,
  //   ),
  // );
  // flutterLocalNotificationsPlugin.show(
  //   0,
  //   'title',
  //   'body',
  //   notificationDetails,
  //   payload: jsonEncode(message.data),
  // );
}

class NotificationController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  var androidPlatformChannelSpecifics;
  var platformChannelSpecifics;
  static const MethodChannel _channel = MethodChannel('flutter_not');

  NotificationController(BuildContext context) {
    try {
      FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        var title = message.data['page'];
        if (title == 'Gofed Ride') {
          await _channel.invokeMethod("showNotification", {
            "id": "Ride",
            'title': "Gofed Ride",
            'message': 'New Ride to Accept',
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RidePopup(
                id: message.data['id'].toString(),
                pick: message.data['pick'].toString(),
                drop: message.data['drop'].toString(),
                amount: message.data['amount'].toString(),
              ),
            ),
          );
        } else if (title == 'Logout') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('user_id');
          await FirebaseAuth.instance.signOut().then((value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
                (route) => false);
          });
        }
        return;
      });
      messaging.subscribeToTopic('root');
    } catch (e) {
      print(e);
    }
  }
}
