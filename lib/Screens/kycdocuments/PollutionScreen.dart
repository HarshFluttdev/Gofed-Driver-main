import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_timeline/progress_timeline.dart';
import 'package:quicksewadriver/Screens/home/DcoumentAndTrainingScreen.dart';
import 'package:quicksewadriver/Screens/kycdocuments/PanScreen.dart';
import 'package:quicksewadriver/Screens/kycdocuments/photo.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PLScreen extends StatefulWidget {
  @override
  PlScreenState createState() => PlScreenState();
}

class PlScreenState extends State<PLScreen> {
  File _image;
  File _backImage;
  var loading = false;
  final picker = ImagePicker();

  Future _imgFromCamera() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future _imgFromGallery() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future _imgBackFromCamera() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _backImage = File(pickedFile.path);
    });
  }

  Future _imgBackFromGallery() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _backImage = File(pickedFile.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showBackSideImagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgBackFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgBackFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  upload(var context) async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserDetail user = UserDetail();

    var id = await user.getUserDetail(prefs.get('UserMobileNo').toString());

    Uploading upl = Uploading();

    await upl.asyncSingleFileUpload(id, 'pollution', _image.path);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PanScreen();
    }));

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: (loading)
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02, vertical: height * 0.015),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 40,
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
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: height * 0.03),
                  width: width,
                  child: Center(
                      child: Text(
                    "Upload Documents",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  )),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  width: width,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text("ID"),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: width * 0.07,
                              height: 7,
                              decoration: BoxDecoration(color: Colors.green),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text(""),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text("DL"),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: width * 0.07,
                              height: 7,
                              decoration: BoxDecoration(color: Colors.green),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text(""),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text("RC"),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: width * 0.07,
                              height: 7,
                              decoration: BoxDecoration(color: Colors.grey),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text(""),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text("PL"),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: width * 0.07,
                              height: 7,
                              decoration: BoxDecoration(color: Colors.grey),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text(""),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text("PAN"),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: width * 0.07,
                              height: 7,
                              decoration: BoxDecoration(color: Colors.grey),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text(""),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text("IN"),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: width * 0.07,
                              height: 7,
                              decoration: BoxDecoration(color: Colors.grey),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text(""),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: Text("VF"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: height * 0.03, left: 25),
                      child: Text(
                        'Owner Pollution',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.07,
                    ),
                    InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        height: height * 0.15,
                        width: width * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[350],
                              offset: const Offset(
                                0.0,
                                3.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                          ],
                        ),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  _image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.03,
                                  ),
                                  Icon(
                                    Icons.camera_alt_rounded,
                                    color: Color(0xff6F6AF6),
                                    size: 36,
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Text(
                                    'Front Side',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.2,
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.15,
                ),
                Container(
                  height: height * 0.06,
                  width: width * 0.76,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff706BF7)),
                  child: TextButton(
                    onPressed: () {
                      if (_image == null) {
                        CustomMessage.toast("Please add image");
                      }
                      if (_image != null) {
                        upload(context);
                      }
                    },
                    child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
