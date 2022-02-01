import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quicksewadriver/Screens/home/DcoumentAndTrainingScreen.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomElevatedButton.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final bool login;
  const OTPScreen({
    Key key,
    this.phone,
    this.login,
  }) : super(key: key);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool _progressVisible = false;
  bool verifyOtp = false;
  bool resendOtp = false;
  Duration resendDuration = Duration(seconds: 0);
  TextEditingController otpController = new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _verificationId = '';
  FirebaseAuth auth;

  String _otpValidate(String value) {
    if (value == '') return 'Can\'t be Empty';
    if (value.length != 6) return 'OTP length should be 6';
    return null;
  }

  _sendOtp() async {
    try {
      setState(() {
        _progressVisible = true;
      });

      auth = FirebaseAuth.instance;
      await auth.verifyPhoneNumber(
        phoneNumber: '+91' + widget.phone,
        verificationCompleted: (phoneAuthCredential) {
          CustomMessage.toast('Verification Completed');
          setState(() {
            _progressVisible = false;
          });
        },
        verificationFailed: (error) {
          CustomMessage.toast(error.message);
          setState(() {
            _progressVisible = false;
          });
        },
        codeSent: (verificationId, forceResendingToken) {
          resendDuration = Duration(seconds: 30);
          Timer.periodic(Duration(seconds: 1), (timer) {
            if (resendDuration.inSeconds == 0) {
              timer.cancel();
              setState(() {
                resendOtp = true;
              });
            }
          });
          setState(() {
            resendOtp = false;
            _progressVisible = false;
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {
          //  CustomMessage.toast('Auto Retrieval Timeout');
          setState(() {
            _progressVisible = false;
          });
        },
      );
    } catch (e) {
      print(e);
      setState(() {
        resendOtp = false;
        _progressVisible = false;
      });
    }
  }

  getuserData() async {
    setState(() {
      _progressVisible = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(profileUrl),
      body: {'mobile': widget.phone.toString()},
    );
    var data = jsonDecode(response.body);
    await SharedData().setUser(data['data'][0]['id'].toString());

    setState(() {
      _progressVisible = false;
    });
  }

  _verifyOtp() async {
    try {
      if (!_formKey.currentState.validate()) return;

      var otp = otpController.text;

      setState(() {
        _progressVisible = true;
      });
      AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await auth.signInWithCredential(authCredential);
      CustomMessage.toast('OTP Verified Successfully..!!');
      setState(() {
        _progressVisible = false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("UserMobileNo", widget.phone.toString());
      await getuserData();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentAndTrainingScreen(),
          ),
          (route) => false);
    } catch (e) {
      print(e);
      CustomMessage.toast('Error while Verifying OTP');
      setState(() {
        _progressVisible = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _sendOtp();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Form(
          key: _formKey,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
            ),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: height * 0.03),
                  child: Image.asset(
                    'assets/icons/splash.png',
                    height: height * 0.09,
                  ),
                ),
                SizedBox(height: height * 0.05),
                Visibility(
                  maintainState: true,
                  visible: widget.login != null && widget.login,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.phone,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'change',
                            style: TextStyle(color: Colors.green, fontSize: 21),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: width,
                  child: Center(
                    child: Text(
                      'One Time Password(OTP) has been sent to this number',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                Container(
                  width: width,
                  child: Center(
                    child: Text(
                      'Waiting to auto read OTP',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.20),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Colors.white),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.white,
                          controller: otpController,
                          decoration: InputDecoration(
                              labelText: "Enter OTP",
                              labelStyle: TextStyle(color: Colors.white))),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: CustomElevatedButton(
                    context: context,
                    // onPressed: getuserData,
                    onPressed: _verifyOtp,
                    child: Text(
                      'Verify',
                      style: TextStyle(fontSize: 25),
                    ),
                    buttonClicked: _progressVisible,
                  ),
                ),

                Visibility(
                  visible: true,
                  maintainState: true,
                  child: TextButton(
                    onPressed: () {
                      _sendOtp();
                      setState(() {
                        resendOtp = false;
                      });
                    },
                    child: Text('Resend OTP',
                        style: TextStyle(color: Colors.white, fontSize: 21)),
                  ),
                ),
                //),

                //   ),
                //  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
