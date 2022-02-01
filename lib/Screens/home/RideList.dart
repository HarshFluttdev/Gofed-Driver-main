import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quicksewadriver/Screens/home/NewRouteScreen.dart';
import 'package:quicksewadriver/Screens/home/RouteScreen.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:swipebuttonflutter/swipebuttonflutter.dart';

class RideListScreen extends StatefulWidget {
  @override
  _RideListScreenState createState() => _RideListScreenState();
}

class _RideListScreenState extends State<RideListScreen> {
  var loading = false;

  Stream<List> RideList() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      try {
        var id = await SharedData().getUser();
        var response = await http.post(Uri.parse(rideListUrl), body: {
          'id': id,
        });

        if (response.statusCode != 200) {
          CustomMessage.toast('Internal Server Error');
        } else if (response.body != '') {
          var data = jsonDecode(response.body);

          if (data['status'] == 200) {
            yield data['data'];
          } else {}
        }
      } catch (e) {
        print(e);
      }
    }
  }

  AcceptRide(
      var rideId,
      var pick_lat,
      var pick_lng,
      var drop_lat,
      var drop_lng,
      var drop_location,
      var pick_location,
      var contact_person,
      var contact_number,
      user_id) async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(acceptRideUrl), body: {
        'id': id,
        'ride_id': rideId.toString(),
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return RouteScreen(
                  ride_id: rideId.toString(),
                  pick_lat: pick_lat,
                  pick_lng: pick_lng,
                  drop_lat: drop_lat,
                  drop_lng: drop_lng,
                  drop_location: drop_location,
                  pick_location: pick_location,
                  contact_person: contact_person,
                  contact_number: contact_number,
                  user_id: user_id);
            }),
            (route) => false,
          );
        } else {}
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  checkIfRideTaken() async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(anyRideActiveUrl), body: {
        'id': id,
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          if (data['data'].toString() != '[]') {
            if (data['data'][0]['status_id'] == '2') {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RouteScreen(
                  ride_id: data['data'][0]['id'],
                  pick_lat: data['data'][0]['pick_lat'],
                  pick_lng: data['data'][0]['pick_lng'],
                  drop_lat: data['data'][0]['drop_lat'],
                  drop_lng: data['data'][0]['drop_lng'],
                  drop_location: data['data'][0]['drop_location'],
                  pick_location: data['data'][0]['pick_location'],
                  contact_person: data['data'][0]['contact_person'],
                  contact_number: data['data'][0]['contact_number'],
                  user_id: data['data'][0]['user_id'],
                );
              }));
            }
            if (data['data'][0]['status_id'] == '3') {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NewRouteScreen(
                  ride_id: data['data'][0]['id'],
                  pick_lat: data['data'][0]['pick_lat'],
                  pick_lng: data['data'][0]['pick_lng'],
                  drop_lat: data['data'][0]['drop_lat'],
                  drop_lng: data['data'][0]['drop_lng'],
                  drop_location: data['data'][0]['drop_location'],
                  pick_location: data['data'][0]['pick_location'],
                  contact_person: data['data'][0]['contact_person'],
                  contact_number: data['data'][0]['contact_number'],
                  user_id: data['data'][0]['user_id'],
                );
              }));
            }
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

  @override
  void initState() {
    super.initState();
    checkIfRideTaken();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: (loading)
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                      child: Container(
                        margin: EdgeInsets.only(
                            top: height * 0.06, bottom: height * 0.02),
                        child: Image.asset(
                          'assets/icons/splash.png',
                          height: height * 0.09,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                        child: Text(
                      "My Rides",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  Container(
                    height: height * 0.70,
                    width: width,
                    child: StreamBuilder(
                        stream: RideList(),
                        builder: (context, snapshot) {
                          // if (snapshot.data.length < 1) {

                          //   return Container(
                          //     width: width,
                          //     height: height,
                          //     child: Center(child: Text("No rides",style: TextStyle(fontSize: 21, fontWeight : FontWeight.bold),)),
                          //   );
                          // }
                          return (!snapshot.hasData)
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : (snapshot.data.length < 1)
                                  ? Container(
                                      width: width,
                                      height: height,
                                      child: Center(
                                          child: Text(
                                        "No rides",
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )
                                  : ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0, top: 4.0),
                                          child: Card(
                                            elevation: 3.0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              child: Container(
                                                width: width * 0.75,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Padding(
                                                          //   padding:
                                                          //       const EdgeInsets
                                                          //           .all(4.0),
                                                          //   child: Text(snapshot
                                                          //       .data[index][
                                                          //           'contact_person']
                                                          //       .toString()),
                                                          // ),
                                                          // Padding(
                                                          //   padding:
                                                          //       const EdgeInsets
                                                          //           .all(4.0),
                                                          //   child: Text(snapshot
                                                          //       .data[index][
                                                          //           'contact_number']
                                                          //       .toString()),
                                                          // ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(snapshot
                                                                .data[index][
                                                                    'pick_location']
                                                                .toString()),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(snapshot
                                                                .data[index][
                                                                    'total_amount']
                                                                .toString()),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(snapshot
                                                                .data[index][
                                                                    'drop_location']
                                                                .toString()),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: height * 0.03,
                                                            bottom:
                                                                height * 0.01),
                                                        height: height * 0.06,
                                                        child: SwipingButton(
                                                            text: "Start",
                                                            onSwipeCallback:
                                                                () {
                                                              AcceptRide(
                                                                  snapshot.data[index][
                                                                      'ride_id'],
                                                                  snapshot.data[index][
                                                                      'pick_lat'],
                                                                  snapshot.data[index][
                                                                      'pick_lng'],
                                                                  snapshot.data[index][
                                                                      'drop_lat'],
                                                                  snapshot.data[index][
                                                                      'drop_lng'],
                                                                  snapshot.data[index][
                                                                      'drop_location'],
                                                                  snapshot.data[index][
                                                                      'pick_location'],
                                                                  snapshot.data[
                                                                          index][
                                                                      'contact_person'],
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'contact_number'],
                                                                  snapshot.data[
                                                                          index]
                                                                      ['user_id']);
                                                            }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                        }),
                  )
                ],
              ),
            ),
    );
  }
}
