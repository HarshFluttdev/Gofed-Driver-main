import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quicksewadriver/Screens/EditAddressScreen.dart';
import 'package:quicksewadriver/Screens/drawer/EarningScreen.dart';
import 'package:quicksewadriver/Screens/drawer/ReferAndEarnScreen.dart';
import 'package:quicksewadriver/Screens/drawer/TrainingScreen.dart';
import 'package:quicksewadriver/Screens/drawer/notification.dart';
import 'package:quicksewadriver/Screens/drawer/wallet.dart';
import 'package:quicksewadriver/Screens/login/LoginScreen.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:http/http.dart' as http;
import 'package:quicksewadriver/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/CustomMessage.dart';
import '../home/homescreen.dart';
import '../login/shared_pref.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var languageList = [];
  var preferredAppLanguage = "1";
  var enableDrag = true;
  var userAddress = "";
  var loading = false;
  var preferredTrainingLanguage = "1";
  var vehicle = "", vehicleno = "";
  var firstname = "", lastname = "", mobile = "", id = "", email = "";

  getuserData() async {
    setState(() {
      loading = true;
    });
    var id = await SharedData().getUser();
    final response = await http.post(Uri.parse(profileVehicleUrl), body: {
      'id': id,
    });

    if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: 'Internal Server Error');
    } else if (response.body != '') {
      var data = jsonDecode(response.body);

      firstname = data['data'][0]['name'];
      mobile = data['data'][0]['mobile'];
      id = data['data'][0]['id'];
      email = data['data'][0]['email'];
    }

    setState(() {
      loading = false;
    });
  }

  getVehicleData() async {
    setState(() {
      loading = true;
    });

    var id = await SharedData().getUser();
    var response = await http.post(Uri.parse(profileVehicleUrl), body: {
      'id': id,
    });

    if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: 'Internal Server Error');
    } else if (response.body != '') {
      var data = jsonDecode(response.body);

      vehicle = data['data'][0]['vehicle_name'].toString();
      vehicleno = data['data'][0]['vehicle_no'].toString();
      userAddress = data['data'][0]['address'];
      preferredAppLanguage = data['data'][0]['pref_app_lang'];
      preferredTrainingLanguage = data['data'][0]['pref_training_lang'];
    }

    setState(() {
      loading = false;
    });
  }

  getLanguages() async {
    setState(() {
      loading = true;
    });
    try {
      var response = await http.get(Uri.parse(languagesUrl));

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          for (var i = 0; i < data['data'].length; i++) {
            languageList.add(data['data'][i]['name']);
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

  changeAppPreferedLanguage(var language) async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(setPrefAppLangUrl), body: {
        'id': id,
        'lang': language.toString(),
      });

      if (response.statusCode != 200) {
        Fluttertoast.showToast(msg: 'Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Profile();
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

      if (response.statusCode != 200) {
        Fluttertoast.showToast(msg: 'Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Profile();
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

  getUserDetail(var mobile) async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(profileVehicleUrl), body: {
        "id": id,
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          return data['data'][0]['id'];
        }
      } else {}
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  Widget childWidget() {
    double mHeight = MediaQuery.of(context).size.height;
    return Container(
        height: mHeight * 0.30,
        child: ListView.builder(
            itemCount: languageList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  changeAppPreferedLanguage(index + 1);
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Text(languageList[index]),
                ),
              );
            }));
  }

  Widget newChildWidget() {
    double mHeight = MediaQuery.of(context).size.height;
    return Container(
        height: mHeight * 0.30,
        child: ListView.builder(
            itemCount: languageList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  changeTrainingPreferedLanguage(index + 1);
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Text(languageList[index]),
                ),
              );
            }));
  }

  @override
  void initState() {
    getLanguages();
    getuserData();
    getVehicleData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      key: scaffoldKey,
      drawer: CustomDrawer(context, width, height),
      body: (loading)
          ? Center(
              child: Container(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ))
          : Column(
              children: [
                Container(
                  width: width * 4,
                  height: height * 0.25,
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
                    margin:
                        EdgeInsets.only(left: width * 0.04, top: height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  scaffoldKey.currentState.openDrawer(),
                              child: Image.asset(
                                'assets/icons/menu.png',
                                height: height * 0.02,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.24,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.03),
                              child: Image.asset(
                                'assets/icons/splash.png',
                                height: 60,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: height * 0.03,
                        // ),

                        Container(
                          margin: EdgeInsets.only(top: height * 0.03),
                          child: Row(
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
                                Container(
                                  margin: EdgeInsets.only(left: width * 0.04),
                                  child: Icon(
                                    FontAwesomeIcons.star,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: width * 0.01),
                                  child: Text(
                                    '4.7',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  height: height * 0.2,
                  width: width * 0.9,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 8.0, bottom: 8.0, right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Text(
                                'Home Address',
                                style: TextStyle(fontSize: 18),
                              )),
                              Container(
                                height: height * 0.04,
                                width: width * 0.2,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment(-1.0, -2.0),
                                    end: Alignment(1.0, 2.0),
                                    colors: [
                                      Color(0xFF6D5DF6),
                                      Color(0xFF83B9FF)
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return EditAddressScreen();
                                    }));
                                  },
                                  child: Center(
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.01),
                            child: Text(
                              userAddress,
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xff989898)),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text(
                                'Mobile Number',
                                style: TextStyle(fontSize: 18),
                              )),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.01),
                            child: Text(
                              mobile,
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xff989898)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  height: height * 0.2,
                  width: width * 0.9,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Text(
                                      'Preferred app Language',
                                      style: TextStyle(fontSize: 16),
                                    )),
                                    Container(
                                      child: Text(
                                        languageList.length > 0
                                            ? languageList[
                                                (preferredAppLanguage == "0")
                                                    ? int.parse(
                                                        preferredAppLanguage)
                                                    : int.parse(
                                                            preferredAppLanguage) -
                                                        1]
                                            : '',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: height * 0.03,
                                  width: width * 0.2,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment(-1.0, -2.0),
                                      end: Alignment(1.0, 2.0),
                                      colors: [
                                        Color(0xFF6D5DF6),
                                        Color(0xFF83B9FF)
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                      return showModalBottomSheet(
                                          enableDrag: enableDrag,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          context: context,
                                          builder: (builder) {
                                            return childWidget();
                                          });
                                    },
                                    child: Center(
                                      child: Text(
                                        'Change',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Text(
                                      'Preferred Training Language',
                                      style: TextStyle(fontSize: 16),
                                    )),
                                    Container(
                                      child: Text(
                                        languageList.isEmpty
                                            ? ''
                                            : languageList[int.parse(
                                                    preferredTrainingLanguage) -
                                                1],
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: height * 0.03,
                                  width: width * 0.2,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment(-1.0, -2.0),
                                      end: Alignment(1.0, 2.0),
                                      colors: [
                                        Color(0xFF6D5DF6),
                                        Color(0xFF83B9FF)
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                      return showModalBottomSheet(
                                          enableDrag: enableDrag,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          context: context,
                                          builder: (builder) {
                                            return newChildWidget();
                                          });
                                    },
                                    child: Center(
                                      child: Text(
                                        'Change',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: height * 0.10),
                  height: height * 0.05,
                  width: width * 0.50,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      Color(0xFF6D5DF6),
                      Color(0xFF83B9FF),
                    ]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove('user_id');
                      await FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }), (route) => false);
                      });
                    },
                    child: Center(
                      child: Text(
                        'Log out',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
