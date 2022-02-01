import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quicksewadriver/Screens/home/DcoumentAndTrainingScreen.dart';
import 'package:quicksewadriver/Screens/home/RidePopup.dart';
import 'package:quicksewadriver/Screens/home/VehicleDetailScreen.dart';
import 'package:quicksewadriver/Screens/home/homescreen.dart';
import 'package:quicksewadriver/Screens/login/LoginScreen.dart';
import 'package:quicksewadriver/Screens/login/register.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:http/http.dart' as http;
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:android_alarm_';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var loading = false;
  var kycData = "";
  var trainingStatus = "";
  var mobile = "";

  _data() async {
    try {
      Timer(
          Duration(
            seconds: 3,
          ),
          (await SharedData().userLogged())
              ? () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DocumentAndTrainingScreen()))
              : () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen())));
    } catch (e) {
      print(e);
    }
  }

  getUserProfile() async {
    var id = await SharedData().getUser();
    try {
      var token = await FirebaseMessaging.instance.getToken();
      await http.post(Uri.parse(updateTokenUrl), body: {
        'id': id,
        'token': token.toString(),
      });
    } catch (e) {
      print(e);
    }

    var response = await http.post(Uri.parse(profileVehicleUrl), body: {
      'id': id,
    });

    if (response.statusCode != 200) {
      CustomMessage.toast('Internal Server Error');
    } else if (response.body != '') {
      var data = jsonDecode(response.body);
      trainingStatus = data['data'][0]['training'].toString();
      mobile = data['data'][0]['mobile'].toString();
      getDocumentKyc();
    }
  }

  getDocumentKyc() async {
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(registerStatusUrl), body: {
        'id': id.toString(),
        'mobile': mobile.toString(),
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);
        if (data['message'] != 'completed') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterScreen(phone: mobile),
            ),
          );
          return;
        }
      }

      response = await http.post(Uri.parse(kycStatusUrl), body: {
        'id': id,
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          kycData = data['data']['vehicle_fitness_status_word'];
          if (kycData == "Verified" && trainingStatus == "1") {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }));
          } else {
            if (await SharedData().userLogged()) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DocumentAndTrainingScreen()));
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            }
          }
        } else {}
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkRoute();
  }

  checkRoute() async {
    FirebaseOptions options = FirebaseOptions(
      apiKey: 'AIzaSyCnvYO4r8L7GoXTo8sCoC4GcFGsYyHSVVQ',
      appId: '1:899785064098:android:992a6112789ce89f6e61fb',
      messagingSenderId: '899785064098',
      projectId: 'gofed-2e794',
    );
    await Firebase.initializeApp(options: options);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        Fluttertoast.showToast(msg: payload);
        var data = jsonDecode(payload);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RidePopup(
              id: data['id'].toString(),
              pick: data['pick'].toString(),
              drop: data['drop'].toString(),
              amount: data['amount'].toString(),
            ),
          ),
        );
      },
    );
    if (!await SharedData().userLogged()) {
      _data();
    } else {
      getUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1.0, -2.0),
            end: Alignment(1.0, 2.0),
            colors: [
              Color(0xFF6D5DF6),
              Color(0xFF83B9FF),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/splash.png',
              width: 200,
            ),
            SizedBox(height: 100),
            Container(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
