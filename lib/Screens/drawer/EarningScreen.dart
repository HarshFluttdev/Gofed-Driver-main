import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EarningScreen extends StatefulWidget {
  @override
  _EarningScreenState createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  var loading = false;
  String formattedDate;

  getEarnings() async {
    setState(() {
      loading = true;
    });

    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(earningUrl), body: {
        'id': id,
        'from': '2021-03-01',
        'to': formattedDate.toString()
      });
      print(response.body);

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          print(data['data']);
          // CustomMessage.toast(response.body
          // .toString()
          // .substring(24, response.body.toString().length - 1));
        } else {}
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  getCurrentDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
  }

  @override
  void initState() {
    super.initState();
    getCurrentDate();
    getEarnings();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          elevation: 0,
          backgroundColor: Color(0xffF5F5F5),
          title: Padding(
            padding: EdgeInsets.only(left: _width * 0.2),
            child: Text(
              'Earnings',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ),
        body: (loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Text("No Earnings"),
              )
        // body: Container(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Container(
        //         height: _height * 0.20,
        //         child: ListView.builder(
        //             scrollDirection: Axis.horizontal,
        //             itemCount: 5,
        //             itemBuilder: (context, index) {
        //               return Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Container(
        //                     height: _height * 0.20,
        //                     width: _width * 0.80,
        //                     decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.circular(20),
        //                       gradient: LinearGradient(colors: [
        //                         Color(0xFF6E64F6),
        //                         Color(0xFF82B6FE)
        //                       ]),
        //                     ),
        //                     child: Column(
        //                       mainAxisAlignment: MainAxisAlignment.start,
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Container(
        //                             padding: EdgeInsets.all(19),
        //                             child: Text(
        //                               "31 May -05 jun",
        //                               style: TextStyle(
        //                                   fontSize: 21, color: Colors.white),
        //                             )),
        //                         Padding(
        //                           padding: const EdgeInsets.all(10.0),
        //                           child: Row(
        //                             mainAxisAlignment:
        //                                 MainAxisAlignment.spaceEvenly,
        //                             children: [
        //                               Column(
        //                                 children: [
        //                                   Text(
        //                                     "Rs. 1558.0",
        //                                     style: TextStyle(
        //                                         fontWeight: FontWeight.bold,
        //                                         fontSize: 20,
        //                                         color: Colors.white),
        //                                   ),
        //                                   Text("Earnings",
        //                                       style: TextStyle(
        //                                           fontSize: 15,
        //                                           color: Colors.white))
        //                                 ],
        //                               ),
        //                               Column(
        //                                 children: [
        //                                   Text("22H",
        //                                       style: TextStyle(
        //                                           fontWeight: FontWeight.bold,
        //                                           fontSize: 20,
        //                                           color: Colors.white)),
        //                                   Text("Time Spent",
        //                                       style: TextStyle(
        //                                           fontSize: 15,
        //                                           color: Colors.white))
        //                                 ],
        //                               ),
        //                               Column(
        //                                 children: [
        //                                   Text("1",
        //                                       style: TextStyle(
        //                                           fontWeight: FontWeight.bold,
        //                                           fontSize: 20,
        //                                           color: Colors.white)),
        //                                   Text("Trips Taken",
        //                                       style: TextStyle(
        //                                           fontSize: 15,
        //                                           color: Colors.white))
        //                                 ],
        //                               )
        //                             ],
        //                           ),
        //                         )
        //                       ],
        //                     )),
        //               );
        //             }),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15),
        //         child: Container(
        //           height: _height * 0.15,
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               DayAndDateWidget(day: "Mon", date: "31"),
        //               DayAndDateWidget(day: "Tues", date: "1"),
        //               DayAndDateWidget(day: "Wed", date: "2"),
        //               DayAndDateWidget(day: "Thurs", date: "3"),
        //               DayAndDateWidget(day: "Fri", date: "4"),
        //               DayAndDateWidget(day: "Sat", date: "5"),
        //             ],
        //           ),
        //         ),
        //       ),
        //       Container(
        //           padding: EdgeInsets.all(10),
        //           child: Text("Todays Summary",
        //               style: TextStyle(
        //                 color: Color(0xFF706CF6),
        //                 fontSize: 25,
        //               ))),
        //       SummaryTileWidget(
        //         price: "Rs.1558.0",
        //         time: "22H",
        //         trips: "1",
        //       )
        //     ],
        //   ),
        // )
        );
  }
}
