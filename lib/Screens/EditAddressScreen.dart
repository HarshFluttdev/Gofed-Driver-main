import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/Screens/profile/profile.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAddressScreen extends StatefulWidget {
  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  var loading = false;
  var userAddress = "", name = "", mobile = "", email = "";
  var vehicleNo = "";

  getAddress() async {
    setState(() {
      loading = true;
    });

    UserDetail user = UserDetail();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var id = await user.getUserDetail(prefs.get('UserMobileNo').toString());

    var response =
        await http.post(Uri.parse(profileVehicleUrl), body: {'id': id});

    var data = jsonDecode(response.body);
    setState(() {
      userAddress = data['data'][0]['address'];
      name = data['data'][0]['name'];
      mobile = data['data'][0]['mobile'];
      id = data['data'][0]['id'];
      email = data['data'][0]['email'];
      vehicleNo = data['data'][0]['vehicle_no'];
    });
    setState(() {
      loading = false;
    });
  }

  updateAddress() async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(updateProfileUrl), body: {
        'id': id,
        'address': addressController.text.toString(),
      });

      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return EditAddressScreen();
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

  @override
  void initState() {
    super.initState();
    getAddress();
  }

  TextEditingController addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: (loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 4,
                      height: height * 0.20,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width,
                              margin: EdgeInsets.only(top: height * 0.05),
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Profile();
                                        }));
                                      }),
                                  Center(
                                    child: Container(
                                      width: width * 0.75,
                                      child: Image.asset(
                                        'assets/icons/splash.png',
                                        height: height * 0.09,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(20),
                        width: width,
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Edit Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 21),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, top: height * 0.03),
                      child: Text(name, style: TextStyle(fontSize: 21)),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 20.0, top: height * 0.03),
                        child: Text(email, style: TextStyle(fontSize: 21))),
                    Container(
                        margin: EdgeInsets.only(left: 20.0, top: height * 0.03),
                        child: Text(mobile, style: TextStyle(fontSize: 21))),
                    Container(
                        margin: EdgeInsets.only(left: 20.0, top: height * 0.03),
                        child: Text(vehicleNo, style: TextStyle(fontSize: 21))),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                          controller: addressController
                            ..text = userAddress
                            ..selection = TextSelection.collapsed(
                                offset: userAddress.toString().length),
                          onChanged: (value) {
                            setState(() {
                              userAddress = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                          )),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: height * 0.15),
                        height: height * 0.06,
                        width: width * 0.50,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                              colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            updateAddress();
                          },
                          child: Center(
                            child: Text(
                              "Save",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
