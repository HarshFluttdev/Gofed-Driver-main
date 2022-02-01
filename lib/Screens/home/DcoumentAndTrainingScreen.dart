import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quicksewadriver/Screens/drawer/TrainingScreen.dart';
import 'package:quicksewadriver/Screens/home/homescreen.dart';
import 'package:quicksewadriver/Screens/home/no_services.dart';
import 'package:quicksewadriver/Screens/kycdocuments/photo.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/DetailTile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/CustomMessage.dart';
import '../drawer/TrainingScreen.dart';
import 'package:location/location.dart' as loc;

class DocumentAndTrainingScreen extends StatefulWidget {
  final bottomSheet;

  const DocumentAndTrainingScreen({this.bottomSheet});
  @override
  _DocumentAndTrainingScreenState createState() =>
      _DocumentAndTrainingScreenState();
}

class _DocumentAndTrainingScreenState extends State<DocumentAndTrainingScreen> {
  var loading = true;
  var kycData;
  var languageList = [];
  var trainingStatus = "";
  Timer timer;
  loc.Location location = new loc.Location();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  setTrainingLanguage(var language) async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(setTrainingLanguageUrl), body: {
        'id': id,
        'lang': language,
      });

      if (response.statusCode != 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("language", language);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TrainingVideoScreen(route: true)));
        } else {}
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  getDocumentKyc() async {
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(kycStatusUrl), body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          setState(() {
            kycData = data['data']['vehicle_fitness_status_word'];
          });
        } else {}
      }
    } catch (e) {
      print(e);
    }
  }

  getLanguages() async {
    try {
      var response = await http.get(Uri.parse(languagesUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          for (var i = 0; i < data['data'].length; i++) {
            setState(() {
              languageList.add(data['data'][i]['name']);
            });
          }
          await showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            context: context,
            builder: (builder) {
              return childWidget();
            },
          );
        } else {}
      }
    } catch (e) {
      print(e);
    }
  }

  Widget childWidget() {
    double mHeight = MediaQuery.of(context).size.height;
    return Container(
        height: mHeight * 0.30,
        child: ListView.builder(
            itemCount: languageList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  await changeTrainingPreferedLanguage(index + 1);
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Text(languageList[index]),
                ),
              );
            }));
  }

  changeTrainingPreferedLanguage(var language) async {
    setState(() {
      loading = true;
    });

    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(setTrainingLanguageUrl), body: {
        'id': id,
        'lang': language.toString(),
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  getUserProfile() async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(profileVehicleUrl), body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        trainingStatus = data['data'][0]['training'].toString();
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  updateFcmToken(var token) async {
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(updateTokenUrl), body: {
        'id': id,
        'token': token.toString(),
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
    if (serviceEnabled != loc.PermissionStatus.granted ||
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

          if (!addresses.first.addressLine.contains('Please') && !exist) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => NoServicesScreen(),
                ),
                (route) => false);
            return;
          } else {
            if (widget.bottomSheet != false) {
              await getLanguages();
            }
            await getToken();
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  getToken() async {
    String token = await _firebaseMessaging.getToken();
    await updateFcmToken(token);
    await getDocumentKyc();
    await getUserProfile();
    Timer.periodic(Duration(seconds: 30), (Timer t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      getDocumentKyc();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        body: (loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                height: height,
                width: width,
                child: Column(
                  children: [
                    Container(
                      width: width * 5,
                      height: height * 0.17,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment(-1.0, -2.0),
                              end: Alignment(1.0, 2.0),
                              colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: Container(
                        margin: EdgeInsets.only(top: height * 0.03),
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02, vertical: height * 0.020),
                        child: Container(
                          child: Image.asset(
                            'assets/icons/splash.png',
                            height: height * 0.09,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.17,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.0,
                                right: 8.0,
                                bottom: 10,
                                top: height * 0.04),
                            child: Text("Hi,",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.0,
                                right: 8.0,
                                bottom: 10,
                                top: height * 0.02),
                            child: Text("Let's Start Earning with gofed",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 21)),
                          ),
                        ],
                      ),
                    ),
                    (kycData == "Not Verified" ||
                            kycData == "Verified" ||
                            kycData == "Uploaded")
                        ? Opacity(
                            opacity: 0.5,
                            child: DetailTile(
                                value1: "1",
                                value2: "Upload Document",
                                value3: "Driving License,Adhar Card, Etc"),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DocumentUploadScreen()));
                            },
                            child: DetailTile(
                                value1: "1",
                                value2: "Upload Document",
                                value3: "Driving License,Adhar Card, Etc"),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: (kycData == "Not Verified")
                            ? Row(
                                children: [
                                  Icon(Icons.sd_card_alert_outlined,
                                      color: Colors.red),
                                  Text(
                                    "Waiting for verification.",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              )
                            : Container(),
                      ),
                    ),
                    (kycData == "Not Verified" || kycData == "Verified")
                        ? InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return TrainingVideoScreen();
                              }));
                            },
                            child: DetailTile(
                                value1: "2",
                                value2: "Training",
                                value3: "Get self training for using the app"),
                          )
                        : Opacity(
                            opacity: 0.5,
                            child: DetailTile(
                                value1: "2",
                                value2: "Training",
                                value3: "Get self training for using the app"),
                          ),
                    (kycData != "Verified" || trainingStatus != "1")
                        ? Opacity(
                            opacity: 0.5,
                            child: DetailTile(
                                value1: "3",
                                value2: "Get your first trip",
                                value3: "Voa! Lets take the first trip"),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return HomeScreen();
                              }));
                            },
                            child: DetailTile(
                                value1: "3",
                                value2: "Get your first trip",
                                value3: "Voa! Lets take the first trip"),
                          ),
                    (kycData != "Verified")
                        ? Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                Icon(Icons.sd_card_alert_outlined,
                                    color: Colors.red),
                                Text("Waiting for approval.",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic)),
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
      ),
    );
  }
}
