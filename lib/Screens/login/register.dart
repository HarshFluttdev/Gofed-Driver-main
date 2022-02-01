import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quicksewadriver/Screens/home/VehicleDetailScreen.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomDropDown.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:quicksewadriver/widgets/CustomTextField.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  final String phone;
  RegisterScreen({this.phone});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const String id = 'register';
  bool _value = false;
  bool _progressVisible = false;
  int purposeValue = 0;
  int stateValue = 0;
  int cityValue = 0;
  int ownVehicleValue = 0;
  var loading = false;
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();

  final TextEditingController ownerController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();
  var formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List purposeList = [
    {
      'name': 'I will be using Gofed Driver For',
      'value': 'NULL',
    }
  ];

  final List stateList = [
    {'name': 'Select States', 'value': 'NULL', 's_code': 'NULL'}
  ];

  final List cityList = [
    {
      'name': 'Select Cities',
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

  String dropBoxValidator(String val) {
    if (val == null) return "Please Select The Purpose";
    return null;
  }

  _register() async {
    setState(() {
      loading = true;
    });
    try {
      var name = nameController.text;
      var email = emailController.text;

      var address = addressController.text;

      setState(() {
        _progressVisible = true;
      });

      var response = await http.post(Uri.parse(registerUrl), body: {
        'name': name.toString(),
        'email': email.toString(),
        'mobile': widget.phone.toString(),
        'state': stateList[stateValue]['name'],
        'city': cityList[cityValue]['name'].toString(),
        'address': address.toString(),
        'alternate_number': phoneController.text,
      });

      var data = jsonDecode(response.body);

      if (data['status'] != 200) {
        CustomMessage.toast(response.body
            .toString()
            .substring(24, response.body.toString().length - 1));
      } else if (response.body != '') {
        if (data['status'] == 200) {
          await SharedData().setUser(data['data'][0]['id'].toString());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => VehicleDetailScreen()));
        } else {}
      }

      setState(() {
        _progressVisible = false;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  _data() async {
    try {
      setState(() {
        _progressVisible = true;
      });

      var response = await http.get(Uri.parse(purposeListUrl));

      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        for (var item in data['data']) {
          purposeList.add({
            'value': item['id'].toString(),
            'name': item['name'].toString(),
          });
        }
      }

      setState(() {
        _progressVisible = false;
      });
    } catch (e) {
      print(e);
    }
  }

  //state list data//
  var stateid = "";
  _statedata() async {
    try {
      setState(() {
        _progressVisible = true;
      });

      var response = await http.get(Uri.parse(stateListUrl));
      if (response.statusCode != 200) {
        CustomMessage.toast('Intenal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        for (var item in data['data']) {
          stateList.add({
            'value': item['id'].toString(),
            'name': item['state'].toString(),
            's_code': item['s_code'].toString()
          });
        }
      }

      setState(() {
        _progressVisible = false;
      });
    } catch (e) {
      print(e);
    }
    _citydata();
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
            'name': item['city'].toString(),
          });
        }
      }

      setState(() {
        _progressVisible = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _data();
    _statedata();
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
                      margin: EdgeInsets.only(top: height * 0.02),
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
                      padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: height * 0.05,
                          bottom: height * 0.01),
                      child: CustomTextField(
                        controller: nameController,
                        validate: isname,
                        labelText: 'Full Name',
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: height * 0.01),
                      child: CustomTextField(
                        controller: emailController,
                        validate: isValidEmail,
                        labelText: 'Email',
                        icon: Icons.email,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: height * 0.01),
                      child: CustomTextField(
                        controller: phoneController,
                        //  validate: isValidEmail,
                        labelText: 'Alternative Number',
                        icon: Icons.phone,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: height * 0.01),
                      child: CustomTextField(
                          controller: addressController,
                          labelText: 'Address',
                          validate: (address) {
                            if (address.length == 0) return "Can't Be Empty";
                          }),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: height * 0.01),
                      child: CustomDropDown(
                        context: context,
                        func: (value) {
                          setState(() {
                            stateValue = value;
                            stateid = stateList[value]['s_code'];
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          });
                          _citydata();
                        },
                        items: stateList,
                        value: stateValue,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: height * 0.01),
                      child: CustomDropDown(
                        context: context,
                        func: (value) {
                          setState(() {
                            cityValue = value;
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          });
                        },
                        items: cityList,
                        value: cityValue,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.05, bottom: 0.02),
                      decoration: BoxDecoration(
                          color: Color(0XFF00C800),
                          borderRadius: BorderRadius.circular(10)),
                      height: height * 0.07,
                      width: width / 1.3,
                      child: TextButton(
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              if (stateList[stateValue]['name'].toString() ==
                                  "Select States") {
                                CustomMessage.toast("Select state");
                              }
                              if (cityList[cityValue]['name'].toString() ==
                                  "Select Cities") {
                                CustomMessage.toast("Select City");
                              }
                              if (stateList[stateValue]['name'].toString() !=
                                      "Select States" &&
                                  cityList[cityValue]['name'].toString() !=
                                      "Select Cities") {
                                _register();
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
                              : Container(
                                  child: Text("Proceed",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                )),
                    ),
                    SizedBox(height: 50),
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
