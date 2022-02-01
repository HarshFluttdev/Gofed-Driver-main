import 'dart:convert';
import 'package:background_fetch/background_fetch.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:quicksewadriver/Screens/drawer/EarningScreen.dart';
import 'package:quicksewadriver/Screens/drawer/ReferAndEarnScreen.dart';
import 'package:quicksewadriver/Screens/drawer/notification.dart';
import 'package:quicksewadriver/Screens/drawer/orderscreen.dart';
import 'package:quicksewadriver/Screens/drawer/wallet.dart';
import 'package:quicksewadriver/Screens/drawer/TrainingScreen.dart';
import 'package:quicksewadriver/Screens/home/NewRouteScreen.dart';
import 'package:quicksewadriver/Screens/home/RideList.dart';
import 'package:quicksewadriver/Screens/home/RouteScreen.dart';
import 'package:quicksewadriver/Screens/home/no_services.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/Screens/profile/profile.dart';
import 'package:quicksewadriver/controller/notification_controller.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:quicksewadriver/widgets/constants.dart';
import 'package:http/http.dart' as http;
import 'package:quicksewadriver/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:swipebuttonflutter/swipebuttonflutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  static const MethodChannel _channel = MethodChannel('flutter_not');
  Map<String, String> channelMap = {
    "id": "Ride",
    "name": "Ride name",
    "description": "Ride notifications",
  };
  var property = true;
  var changebutton = true;
  var _brightness;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var statusLoading = false;
  var rideList;
  var loading = false;
  String balance = '';
  loc.Location location = loc.Location();
  String token = "";
  bool _isKeptOn = false;
  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];
  Timer timer;
  var globalWidth;
  var globalHeight;

  var firstname = "", lastname = "", mobile = "", id = "", email = "";

  getProfileData() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(profileUrl),
        body: {'mobile': prefs.get('UserMobileNo').toString()});

    var data = jsonDecode(response.body);
    setState(() {
      firstname = data['data'][0]['name'];
      mobile = data['data'][0]['mobile'];
      id = data['data'][0]['id'];
      email = data['data'][0]['email'];
      balance = data['data'][0]['wallet_balance'].toString();
      onlineGlobalValue = int.parse(data['data'][0]['online']);
    });
    if (onlineGlobalValue.toString() == '0') {
      FlutterScreen.setBrightness(0.1);
      setState(() {
        property = true;
      });
    } else {
      FlutterScreen.resetBrightness();
      setState(() {
        property = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  Stream<List> RideList() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      try {
        var id = await SharedData().getUser();
        var response = await http.post(Uri.parse(rideListUrl), body: {
          'id': id,
        });

        if (response.statusCode != 200) {
        } else if (response.body != '') {
          var data = jsonDecode(response.body);

          if (data['status'] == 200) {
            yield data['data'];
          } else {}
        }
      } catch (e) {
        print(e);
      }
    }
  }

  AcceptRide(
      var rideId,
      var pick_lat,
      var pick_lng,
      var drop_lat,
      var drop_lng,
      var drop_location,
      var pick_location,
      var contact_person,
      var contact_number,
      var user_id,
      var loginedFirstName,
      var loginedLastName,
      var loginedMobileNo) async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(acceptRideUrl), body: {
        'id': id,
        'ride_id': rideId.toString(),
      });

      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return RouteScreen(
                ride_id: rideId.toString(),
                pick_lat: pick_lat,
                pick_lng: pick_lng,
                drop_lat: drop_lat,
                drop_lng: drop_lng,
                drop_location: drop_location,
                pick_location: pick_location,
                contact_person: contact_person,
                contact_number: contact_number,
                user_id: user_id,
                loginedFirstName: loginedFirstName,
                loginedLastName: loginedLastName,
                loginedMobileNo: loginedMobileNo);
          }));
        } else {}
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  checkIfRideTaken() async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(anyRideActiveUrl), body: {
        'id': id,
      });

      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);
        if (data['status'] == 200) {
          if (data['data'].toString() != '[]') {
            if (data['data'][0]['status_id'] == '2') {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RouteScreen(
                  loginedFirstName: data['data'][0]['first_name'],
                  loginedLastName: data['data'][0]['last_name'],
                  loginedMobileNo: data['data'][0]['contact_number'],
                  ride_id: data['data'][0]['id'],
                  pick_lat: data['data'][0]['pick_lat'],
                  pick_lng: data['data'][0]['pick_lng'],
                  drop_lat: data['data'][0]['drop_lat'],
                  drop_lng: data['data'][0]['drop_lng'],
                  drop_location: data['data'][0]['drop_location'],
                  pick_location: data['data'][0]['pick_location'],
                  contact_person: data['data'][0]['contact_person'],
                  contact_number: data['data'][0]['contact_number'],
                  user_id: data['data'][0]['user_id'],
                );
              }));
            }
            if (data['data'][0]['status_id'] == '3') {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NewRouteScreen(
                  ride_id: data['data'][0]['id'],
                  pick_lat: data['data'][0]['pick_lat'],
                  pick_lng: data['data'][0]['pick_lng'],
                  drop_lat: data['data'][0]['drop_lat'],
                  drop_lng: data['data'][0]['drop_lng'],
                  drop_location: data['data'][0]['drop_location'],
                  pick_location: data['data'][0]['pick_location'],
                  contact_person: data['data'][0]['contact_person'],
                  contact_number: data['data'][0]['contact_number'],
                  user_id: data['data'][0]['user_id'],
                );
              }));
            }
          } else {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                context: context,
                builder: (context) {
                  return (loading)
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                    child: Text(
                                  "My Rides",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                              Container(
                                height: globalHeight * 0.47,
                                width: globalWidth,
                                child: StreamBuilder(
                                    stream: RideList(),
                                    builder: (context, snapshot) {
                                      return (!snapshot.hasData)
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : (snapshot.data.length < 1)
                                              ? Container(
                                                  width: globalWidth,
                                                  height: globalHeight,
                                                  child: Center(
                                                      child: Text(
                                                    "No rides",
                                                    style: TextStyle(
                                                        fontSize: 21,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                )
                                              : ListView.builder(
                                                  itemCount:
                                                      snapshot.data.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0,
                                                              top: 4.0),
                                                      child: Card(
                                                        elevation: 3.0,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black)),
                                                          child: Container(
                                                            width: globalWidth *
                                                                0.75,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(4.0),
                                                                        child: Text(snapshot
                                                                            .data[index]['contact_person']
                                                                            .toString()),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(4.0),
                                                                        child: Text(snapshot
                                                                            .data[index]['contact_number']
                                                                            .toString()),
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            const EdgeInsets.all(4.0),
                                                                        child: Text(snapshot
                                                                            .data[index]['pick_location']
                                                                            .toString()),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: globalHeight *
                                                                            0.03,
                                                                        bottom: globalHeight *
                                                                            0.01),
                                                                    height:
                                                                        globalHeight *
                                                                            0.06,
                                                                    child: SwipingButton(
                                                                        text: "Start",
                                                                        onSwipeCallback: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          AcceptRide(
                                                                            snapshot.data[index]['ride_id'],
                                                                            snapshot.data[index]['pick_lat'],
                                                                            snapshot.data[index]['pick_lng'],
                                                                            snapshot.data[index]['drop_lat'],
                                                                            snapshot.data[index]['drop_lng'],
                                                                            snapshot.data[index]['drop_location'],
                                                                            snapshot.data[index]['pick_location'],
                                                                            snapshot.data[index]['contact_person'],
                                                                            snapshot.data[index]['contact_number'],
                                                                            snapshot.data[index]['user_id'],
                                                                            snapshot.data[index]['first_name'],
                                                                            snapshot.data[index]['last_name'],
                                                                            snapshot.data[index]['mobile'],
                                                                          );
                                                                        }),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                    }),
                              )
                            ],
                          ),
                          //),
                        );
                });
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

  var vehicle = "", vehicleno = "";
  getVehiclesData() async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      final response = await http.post(Uri.parse(profileVehicleUrl), body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        vehicle = data['data'][0]['vehicle_name'];
        vehicleno = data['data'][0]['vehicle_no'];
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  updateOnlineStatus(var onlineStatus) async {
    setState(() {
      statusLoading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(updateOnlineStatusUrl), body: {
        'id': id,
        'status': onlineStatus.toString(),
      });
      print(response.body);

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
        } else {}
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      statusLoading = false;
    });
  }

  insertTracking(var lat, var lng, var address) async {
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(insertTrackingUrl), body: {
        'id': id,
        'lat': lat.toString(),
        'lng': lng.toString(),
        'loc': address.toString()
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Position> _determinePosition() async {
    loc.PermissionStatus serviceEnabled;
    LocationPermission permission;
    loc.Location location = loc.Location();
    bool _allowed = true;

    serviceEnabled = await location.hasPermission();
    if (serviceEnabled != loc.PermissionStatus.granted &&
        serviceEnabled != loc.PermissionStatus.grantedLimited) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            'Background location Access',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          content: Text(
            'Gofed Driver collects location data to enable driver location, ride location and ride status feature even when the app is closed or not in use.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                _allowed = false;
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _allowed = true;
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      await location.requestService();
    }
    if (!_allowed) return await Future.error('User declined.');

    loc.PermissionStatus status = await location.hasPermission();
    if (status == loc.PermissionStatus.deniedForever) {
      CustomMessage.toast('Please Enable Location for the app working..!!');
      await Geolocator.openAppSettings();
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    } else if (status == loc.PermissionStatus.denied) {
      status = await location.requestPermission();
      if (status == loc.PermissionStatus.denied) {
        return Future.error('Location Permission are denied');
      }
    }
    Geolocator.getCurrentPosition().then((value) async {
      final coordinates = new Coordinates(value.latitude, value.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      try {
        var response = await http.get(Uri.parse(workingCitiesUrl));
        if (response.statusCode != 200) {
          CustomMessage.toast('Internal Server Error');
        } else if (response.body != '') {
          var data = jsonDecode(response.body);
          bool exist = false;

          if (data['status'] == 200) {
            for (var item in data['data']) {
              if (addresses.first.addressLine.contains(item['city'])) {
                exist = true;
                break;
              }
            }
          }

          // if (!addresses.first.addressLine.contains('Please') && !exist) {
          //   Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => NoServicesScreen(),
          //       ),
          //       (route) => false);
          //   return;
          // }
        }
      } catch (e) {
        print(e);
      }
      insertTracking(value.latitude, value.longitude, first.addressLine);
    });
  }

  createChannel() async {
    try {
      await _channel.invokeMethod('createNotificationChannel', channelMap);
      NotificationController(context);
      globalRideFunction = checkIfRideTaken;
      globalHomeContext = context;
    } catch (e) {
      CustomMessage.toast("Error");
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 5,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,
      ),
      (String taskId) async {
        print("[BackgroundFetch] Event received $taskId");
        setState(() {
          updateOnlineStatus(dynamic);
        });
        BackgroundFetch.finish(taskId);
      },
      (String taskId) async {
        print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
        BackgroundFetch.finish(taskId);
      },
    );
    print('[BackgroundFetch] configure success: $status');
    setState(() {
      _status = status;
    });
    if (!mounted) return;
    await createChannel();
    await getProfileData();
    await getVehiclesData();
    timer = Timer.periodic(
      Duration(seconds: 60),
      (Timer t) => updateOnlineStatus,
    );
    _determinePosition();
    Timer.periodic(Duration(seconds: 30), (Timer t) => _determinePosition());
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    globalHeight = height;
    globalWidth = width;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          //  title: Text("My ti"),
          content: Text("Are you sure , you want to go offline"),
          actions: [
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
                await updateOnlineStatus(0);
                SystemNavigator.pop();
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      },
      child: Scaffold(
        // bottomSheet: InkWell(
        //   onTap: () {
        //     checkIfRideTaken();
        //   },
        //   child: Container(
        //     height: height * 0.08,
        //     width: width,
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //           begin: Alignment(-1.0, -2.0),
        //           end: Alignment(1.0, 2.0),
        //           colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
        //     ),
        //     child: Center(
        //         child: Text(
        //       "Ride List",
        //       style: TextStyle(fontSize: 21, color: Colors.white),
        //     )),
        //   ),
        // ),
        backgroundColor: Color(0xffF5F5F5),
        key: scaffoldKey,
        drawer: CustomDrawer(context, width, height),
        body: (loading)
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width * 4,
                    height: height * 0.37,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment(-1.0, -2.0),
                            end: Alignment(1.0, 2.0),
                            colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        )),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02, vertical: height * 0.015),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    scaffoldKey.currentState.openDrawer(),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    child: Image.asset(
                                      'assets/icons/menu.png',
                                      height: height * 0.02,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.24,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.03),
                                child: Image.asset(
                                  'assets/icons/splash.png',
                                  height: height * 0.09,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.userCircle,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      firstname,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: height * 0.001,
                                    ),
                                    Text(
                                      '$vehicle-$vehicleno',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                // Container(
                                //   margin: EdgeInsets.only(left: width * 0.04),
                                //   child: Icon(
                                //     FontAwesomeIcons.star,
                                //     color: Color(0xffA4CF8C),
                                //     size: 13,
                                //   ),
                                // ),
                                // SizedBox(
                                //   width: width * 0.01,
                                // ),
                                // Text(
                                //   '4.7',
                                //   style: TextStyle(
                                //       fontSize: 13, color: Color(0xffA4CF8C)),
                                // )
                              ]),
                          Container(
                            margin: EdgeInsets.only(
                                top: height * 0.045, left: width * 0.03),
                            height: height * 0.1,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(100),
                                  bottomRight: Radius.circular(100),
                                )),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Wallet();
                                    }));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: width * 0.1),
                                    child: Image.asset(
                                      'assets/icons/wallet.png',
                                      height: height * 0.045,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.1,
                                ),
                                Text('Balance',
                                    style: TextStyle(color: primaryColor)),
                                SizedBox(
                                  width: width * 0.16,
                                ),
                                Text('₹ ' + balance,
                                    style: TextStyle(
                                        color: primaryColor, fontSize: 16)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: width * 4,
                    height: height * 0.15,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment(-1.0, -2.0),
                          end: Alignment(1.0, 2.0),
                          colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.035,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.04,
                            ),
                            SlidingSwitch(
                              value: (onlineGlobalValue == 1) ? true : false,
                              width: width * 0.4,
                              onChanged: (bool value) {
                                if (value == true) {
                                  FlutterScreen.resetBrightness();
                                  updateOnlineStatus(1);
                                }
                                if (value != true) {
                                  updateOnlineStatus(0);
                                  FlutterScreen.setBrightness(0.1);
                                }
                              },
                              height: height * 0.06,
                              animationDuration:
                                  const Duration(milliseconds: 400),
                              onTap: () {
                                setState(() {
                                  property = !property;
                                  onlineGlobalValue =
                                      onlineGlobalValue == 1 ? 0 : 1;
                                });
                              },
                              onDoubleTap: () {
                                setState(() {
                                  property = !property;
                                  onlineGlobalValue =
                                      onlineGlobalValue == 1 ? 0 : 1;
                                });
                              },
                              onSwipe: () {
                                setState(() {
                                  property = !property;
                                  onlineGlobalValue =
                                      onlineGlobalValue == 1 ? 0 : 1;
                                });
                              },
                              textOff: "OFF",
                              textOn: "ON",
                              colorOn: Colors.green,
                              colorOff: Colors.red,
                              background: const Color(0xffe4e5eb),
                              buttonColor: const Color(0xfff7f5f7),
                              inactiveColor: const Color(0xff636f7b),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: width * 0.03),
                                height: height * 0.07,
                                width: width * 0.5,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xff706BF7)),
                                child: (property)
                                    // ? FlatButton(
                                    //     onPressed: () {
                                    //       setState(() {
                                    //         changebutton = !changebutton;
                                    //       });
                                    //     },
                                    //     child: Center(
                                    //       child: Text(
                                    //         'Online',
                                    //         style: TextStyle(
                                    //             color: Colors.white, fontSize: 25),
                                    //       ),
                                    //     ),
                                    //   )
                                    ? FlatButton(
                                        onPressed: () {
                                          setState(() {
                                            changebutton = !changebutton;
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            'Offline',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                          ),
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          setState(() {
                                            changebutton = !changebutton;
                                          });
                                        },
                                        child: Center(
                                          child: (statusLoading)
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ))
                                              : Text(
                                                  'Online',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                        ),
                                      )),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
