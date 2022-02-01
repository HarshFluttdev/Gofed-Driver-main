import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:quicksewadriver/Screens/home/RideList.dart';
import 'package:quicksewadriver/Screens/home/RouteScreen.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/controller/notification_controller.dart';
import 'package:quicksewadriver/widgets/CustomElevatedButton.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:quicksewadriver/widgets/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RidePopup extends StatefulWidget {
  final String id;
  final String pick;
  final String drop;
  final String amount;
  const RidePopup({Key key, this.id, this.pick, this.drop, this.amount})
      : super(key: key);

  @override
  _RidePopupState createState() => _RidePopupState();
}

class _RidePopupState extends State<RidePopup> {
  int _timer = 30;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_timer == 0) {
        Navigator.pop(context);
        return;
      }

      setState(() {
        _timer--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/splash.png',
                        width: 100,
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Pickup Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.pick ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: Stack(
                      children: [
                        Center(
                          child: LottieBuilder.asset('assets/scanning.json'),
                        ),
                        Center(
                          child: Text(
                            'Rs. ' + (widget.amount ?? ''),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.timer,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(width: 5),
                      Text(
                        _timer.toString(),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Drop Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.drop ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    rideListOpened = true;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RideListScreen(),
                      ),
                    );
                    // SharedPreferences prefs =
                    //     await SharedPreferences.getInstance();
                    // UserDetail user = UserDetail();

                    // var userid = await user
                    //     .getUserDetail(prefs.get('UserMobileNo').toString());
                    // try {
                    //   var response = await http.post(
                    //       Uri.parse("http://gofed.in/Partner/acceptRide"),
                    //       body: {
                    //         'id': userid,
                    //         'ride_id': id.toString(),
                    //       });

                    //   if (response.statusCode != 200) {
                    //     CustomMessage.toast('Internal Server Error');
                    //   } else if (response.body != '') {
                    //     var data = jsonDecode(response.body);

                    //     if (data['status'] == 200) {
                    //       Navigator.pushAndRemoveUntil(
                    //         context,
                    //         MaterialPageRoute(builder: (context) {
                    //           return RouteScreen(
                    //             ride_id: rideId.toString(),
                    //             pick_lat: pick_lat,
                    //             pick_lng: pick_lng,
                    //             drop_lat: drop_lat,
                    //             drop_lng: drop_lng,
                    //             drop_location: drop_location,
                    //             pick_location: pick_location,
                    //             contact_person: contact_person,
                    //             contact_number: contact_number,
                    //             user_id: user_id,
                    //           );
                    //         }),
                    //         (route) => false,
                    //       );
                    //     } else {}
                    //   }
                    // } catch (e) {
                    //   print(e);
                    // }
                  },
                  child: Text('Accept'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.yellow.withOpacity(.8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
