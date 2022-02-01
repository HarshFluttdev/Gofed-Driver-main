import 'package:flutter/material.dart';

class DayAndDateWidget extends StatelessWidget {
  final day, date;

 DayAndDateWidget({this.day, this.date});
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Text(day, style: TextStyle(fontSize: 15, color: Color(0xFF6D5DF6))),
        Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.only(top: _height * 0.01),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                                Color(0xFF6E64F6),
                                Color(0xFF82B6FE)
                              ]),
            ),
            child: Center(
                child: Text(date,
                    style: TextStyle(color: Colors.white, fontSize: 20))))
      ],
    );
  }
}
