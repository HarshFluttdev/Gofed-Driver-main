import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quicksewadriver/Screens/home/DcoumentAndTrainingScreen.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomDropDown.dart';
import 'package:quicksewadriver/widgets/CustomTextField.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/CustomMessage.dart';

class VehicleDetailScreen extends StatefulWidget {
  @override
  _VehicleDetailScreenState createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  TextEditingController vehicleNumber = TextEditingController();
  var formKey = GlobalKey<FormState>();

  int ownVehicleValue = 0;
  var ownVehicle = 0;
  int driveVehicle = 0;
  var vehicleName;
  var loading = false;

  final List ownVehicleList = [
    {
      'name': 'Do you own a vehicle',
      'value': '0',
    },
    {
      'name': 'Yes',
      'value': '1',
    },
    {
      'name': 'No',
      'value': '2',
    }
  ];

  final List ownVehiclType = [
    {
      'name': 'Vehicle type',
      'value': '0',
    },
  ];

  final List driveVehicleList = [
    {
      'name': 'Will you drive the vehicle',
      'value': '0',
    },
    {
      'name': 'Yes',
      'value': '1',
    },
    {
      'name': 'No',
      'value': '2',
    },
  ];

  getuserData() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(profileUrl),
        body: {'mobile': prefs.getString("UserMobileNo")});

    var data = jsonDecode(response.body);

    await SharedData().setUser(data['data'][0]['id'].toString());

    setState(() {
      loading = false;
    });
  }

  SecondRegister() async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(registerStep2Url), body: {
        'id': id,
        'vehicle_name': vehicleName.toString(),
        'vehicle_type': ownVehiclType[ownVehicleValue]['value'].toString(),
        'vehicle_driver': driveVehicle.toString(),
        'vehicle_number': vehicleNumber.text.toString()
      });

      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          getuserData();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DocumentAndTrainingScreen(
                        bottomSheet: true,
                      )));
        } else {}
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  _vehicleList() async {
    try {
      setState(() {
        loading = true;
      });
      var response =
          await http.get(Uri.parse(vehicleTypeListUrl + '?distance=0'));
      setState(() {
        loading = false;
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);
        for (var item in data['data']) {
          ownVehiclType.add({'name': item['name'], 'value': item['id']});
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _vehicleList();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        CustomMessage.toast('Please Complete Registration First..!!');
        return false;
      },
      child: Scaffold(
        body: Form(
          key: formKey,
          child: SafeArea(
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: height * 0.03),
                      child: Image.asset(
                        'assets/icons/splash.png',
                        width: 150,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: height * 0.03),
                        child: Text("Welcome to GOFED",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                    Container(
                        margin: EdgeInsets.only(top: height * 0.02),
                        child: Text(
                            "Please fill below details to start earning",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16))),
                    Container(
                      margin: EdgeInsets.only(
                        top: height * 0.07,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: height * 0.02),
                      child: CustomTextField(
                          controller: vehicleNumber,
                          labelText: 'Vehicle No',
                          validate: (vehicleNo) {
                            if (vehicleNo == "") {
                              return "Can't Be Empty";
                            }
                          }),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: height * 0.02),
                      child: CustomDropDown(
                        context: context,
                        func: (value) {
                          setState(() {
                            ownVehicleValue = value;
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            vehicleName = ownVehiclType[value]['name'];
                          });
                        },
                        items: ownVehiclType,
                        value: ownVehicleValue,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: height * 0.02),
                      child: CustomDropDown(
                        context: context,
                        func: (value) {
                          setState(() {
                            driveVehicle = value;
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          });
                        },
                        items: driveVehicleList,
                        value: driveVehicle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: height * 0.02),
                      child: CustomDropDown(
                        context: context,
                        func: (value) {
                          setState(() {
                            ownVehicle = value;
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          });
                        },
                        items: ownVehicleList,
                        value: ownVehicle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.03),
                      decoration: BoxDecoration(
                          color: Color(0XFF00C800),
                          borderRadius: BorderRadius.circular(10)),
                      height: height * 0.07,
                      width: width / 1.3,
                      child: TextButton(
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              if (vehicleName == null ||
                                  ownVehicle == 0 ||
                                  driveVehicle == 0) {
                                CustomMessage.toast("Fields Can't Be Empty");
                              }
                              if (vehicleName != null &&
                                  ownVehicle != 0 &&
                                  driveVehicle != 0) {
                                SecondRegister();
                              }
                            }
                          },
                          child: (loading)
                              ? Center(
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : Text("Register",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18))),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
