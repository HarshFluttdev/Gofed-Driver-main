import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:quicksewadriver/Screens/home/VehicleDetailScreen.dart';
import 'package:quicksewadriver/Screens/login/otp.dart';
import 'package:quicksewadriver/Screens/login/registerOTPScreen.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _progressVisible = false;
  bool _value = true;
  var loading = false;
  final TextEditingController phoneController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String isValidPhone(String number) {
    String pattern = r'(^(?:[0-9]{10}$))';
    RegExp regex = new RegExp(pattern);
    if (number.length == 0) return "Can't Be Empty";
    if (!regex.hasMatch(number)) return "Invalid Phone Number";
    return null;
  }

  _verifyPhone() async {
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        _progressVisible = true;
      });

      var mobile = phoneController.text;
      var response = await http.post(Uri.parse(mobileVerifyUrl), body: {
        'mobile': mobile,
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);
        if (data['status'] == 400) {
          CustomMessage.toast("Register");
          if (data['message'] == 'register_step_2') {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await SharedData().setUser(data['data'][0]['id'].toString());
            await prefs.setString('UserMobileNo', mobile);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VehicleDetailScreen(),
                ));
          } else if (data['message'].contains('Mobile')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterOTPScreen(
                    phone: mobile,
                  ),
                ));
          } else {
            CustomMessage.toast(data['message']);
          }
        } else {
          CustomMessage.toast("Login");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  phone: mobile,
                  login: true,
                ),
              ));
        }
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(-1.0, -2.0),
              end: Alignment(1.0, 2.0),
              colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
        ),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.15,
            ),
            Image.asset(
              'assets/icons/splash.png',
              width: 200,
            ),
            SizedBox(
              height: height * 0.22,
            ),
            Container(
                child: Text(
              'Login With OTP',
              style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: height * 0.07,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              height: height * 0.07,
              width: width * 0.76,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: phoneController,
                decoration: InputDecoration(
                  fillColor: Colors.black,
                  contentPadding: EdgeInsets.only(top: 10),
                  hintText: 'Mobile Number',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                  prefixIcon: Icon(
                    FontAwesomeIcons.mobileAlt,
                    color: Colors.black,
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.06,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              height: height * 0.07,
              width: width * 0.76,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff706BF7)),
              child: TextButton(
                onPressed: () {
                  _verifyPhone();
                },
                child: loading
                    ? Center(
                        child: Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ))
                    : Center(
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _value,
                    onChanged: (bool newvalue) {
                      setState(() {
                        _value = newvalue;
                      });
                    },
                  ),
                  Text(
                    'I agree to the terms of service and privacy policy',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
