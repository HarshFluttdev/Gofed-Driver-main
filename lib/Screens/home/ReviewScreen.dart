import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:quicksewadriver/Screens/home/homescreen.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReviewScreen extends StatefulWidget {
  final user_id, ride_id;

  const ReviewScreen({this.user_id, this.ride_id});
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  var loading = false;
  var firstname = "";
  var amount = "";
  var userRating = 0.0;
  TextEditingController reviewController = TextEditingController();

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
    });

    setState(() {
      loading = false;
    });
  }

  addReview() async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      final response = await http.post(Uri.parse(reviewUrl), body: {
        'from_id': id.toString(),
        'to_id': widget.user_id.toString(),
        'rating': userRating.toString(),
        'review': reviewController.text.toString(),
        'type': 'user'
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));
      print(reviewController.text.toString());
      print("FEEDBACK FROM STATUS CODE" + response.statusCode.toString());
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  getRideDetail() async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(rideDetailsUrl), body: {
        'id': id,
        'ride_id': widget.ride_id,
      });

      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          amount = data['data'][0]['total_amount'];
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
    getProfileData();
    getRideDetail();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: (loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    height: height,
                    width: width,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: height * 0.20),
                          child: Text("Ride Completed!",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.02),
                          child: Text("Please rate your last ride",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 21)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.02),
                          child: Text("Rs. $amount",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.15),
                          child: Text(firstname,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 21)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.02),
                          child: RatingBar.builder(
                            initialRating: 0,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                userRating = rating;
                              });
                            },
                          ),
                        ),
                        Container(
                            width: width * 0.80,
                            margin: EdgeInsets.only(top: height * 0.10),
                            child: TextFormField(
                                controller: reviewController,
                                decoration: InputDecoration(
                                    hintText: "Leave your feedback"))),
                        Container(
                            margin: EdgeInsets.only(top: height * 0.03),
                            width: width * 0.80,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (reviewController.text == "") {
                                    CustomMessage.toast("Enter review");
                                  }
                                  if (reviewController.text != "") {
                                    addReview();
                                  }
                                },
                                child: Text("Submit feedback"))),
                        Container(
                            width: width * 0.80,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return HomeScreen();
                                  }));
                                },
                                child: Text("Skip feedback"))),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
