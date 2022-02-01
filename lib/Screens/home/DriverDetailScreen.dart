import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quicksewadriver/Screens/home/VehicleDetailScreen.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomDropDown.dart';
import 'package:quicksewadriver/widgets/CustomTextField.dart';

class DriverDetailScreen extends StatefulWidget {
  @override
  _DriverDetailScreenState createState() => _DriverDetailScreenState();
}

class _DriverDetailScreenState extends State<DriverDetailScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  int cityValue = 0;
  int stateValue = 0;
  int ownVehicleValue = 0;

  final List cityList = [
    {
      'name': 'Select Cities',
      'value': 'NULL',
    }
  ];

  final List stateList = [
    {
      'name': 'Select States',
      'value': 'NULL',
    }
  ];

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

  var stateid;

  bool _progressVisible = false;

  _statedata() async {
    try {
      setState(() {
        _progressVisible = true;
      });

      var response = await http.get(Uri.parse(stateListUrl));

      if (response.statusCode != 200) {
        //  CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        for (var item in data['data']) {
          stateList.add({
            'value': item['id'].toString(),
            'name': item['name'].toString(),
          });
        }
        setState(() {
          stateid = data['data'][0]['id'].toString();
        });
      }

      setState(() {
        _progressVisible = false;
      });
    } catch (e) {
      print(e);
    }
  }

  _citydata() async {
    try {
      setState(() {
        _progressVisible = true;
      });

      var response = await http.get(Uri.parse(cityListUrl + stateid));
      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        for (var item in data['data']) {
          cityList.add({
            'value': item['id'].toString(),
            'name': item['name'].toString(),
          });
          print(item);
        }
      }

      setState(() {
        _progressVisible = false;
      });
    } catch (e) {
      print(e);
    }
  }

  String isname(String name) {
    if (name.length == 0) return "Can't Be Empty";
    return null;
  }

  String isValidEmail(String email) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);
    if (email.length == 0) return "Can't Be Empty";
    if (!regex.hasMatch(email)) return "Invalid Email Adress";
    return null;
  }

  @override
  void initState() {
    _statedata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: height * 0.03),
                  child: Image.asset(
                    'assets/icons/splash.png',
                    height: height * 0.09,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: height * 0.04),
                    child: Text("Welcome to GOFED",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold))),
                Container(
                    margin: EdgeInsets.only(top: height * 0.03),
                    child: Text("Please fill below details to start earning",
                        style: TextStyle(color: Colors.white, fontSize: 18))),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: height * 0.02),
                  child: CustomTextField(
                    controller: nameController,
                    validate: isname,
                    labelText: 'Full Name',
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: height * 0.02),
                  child: CustomTextField(
                    controller: emailController,
                    validate: isValidEmail,
                    labelText: 'Email',
                    icon: Icons.email,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: height * 0.02),
                  child: CustomDropDown(
                    context: context,
                    func: (value) {
                      setState(() {
                        stateValue = value;
                      });
                      _citydata();
                    },
                    items: stateList,
                    value: stateValue,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: height * 0.02),
                  child: CustomDropDown(
                    context: context,
                    func: (value) {
                      setState(() {
                        cityValue = value;
                      });
                    },
                    items: cityList,
                    value: cityValue,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: height * 0.02),
                  child: CustomDropDown(
                    context: context,
                    func: (value) {
                      setState(() {
                        ownVehicleValue = value;
                      });
                    },
                    items: ownVehicleList,
                    value: ownVehicleValue,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: height * 0.02),
                  decoration: BoxDecoration(
                      color: Color(0XFF00C800),
                      borderRadius: BorderRadius.circular(10)),
                  height: height * 0.07,
                  width: width / 1.3,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return VehicleDetailScreen();
                        }));
                      },
                      child: Text("Proceed",
                          style: TextStyle(color: Colors.white, fontSize: 25))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
