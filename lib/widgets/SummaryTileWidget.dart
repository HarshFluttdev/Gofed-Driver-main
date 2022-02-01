import 'package:flutter/material.dart';

class SummaryTileWidget extends StatelessWidget {
  final price, time, trips;

  const SummaryTileWidget({this.price, this.time, this.trips});

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          height: _height * 0.20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: _width * 0.02),
                child: Column(
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    Text("Earnings",
                        style: TextStyle(fontSize: 15, color: Colors.black))
                  ],
                ),
              ),
              Column(
                children: [
                  Text(time,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                  Text("Time Spent",
                      style: TextStyle(fontSize: 15, color: Colors.black))
                ],
              ),
              Column(
                children: [
                  Text(trips,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                  Text("Trips Taken",
                      style: TextStyle(fontSize: 15, color: Colors.black))
                ],
              )
            ],
          )),
    );
  }
}
