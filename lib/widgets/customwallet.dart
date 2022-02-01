import 'package:flutter/material.dart';

CustomWallet(
    var amount, var rdate, var pickLocation, var height, var commission) {
  var requiredLength = rdate.toString().length - 3;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${pickLocation.toString()}",
            style: TextStyle(fontSize: 16),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.005),
            child: Text(
              rdate.toString(),
              style: TextStyle(fontSize: 11, color: Color(0xff808080)),
            ),
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            amount,
            style: TextStyle(fontSize: 13, color: Color(0xff808080)),
          ),
          Visibility(
            visible: commission != '',
            child: Text(
              'Commission: ' + commission,
              style: TextStyle(fontSize: 11, color: Color(0xff808080)),
            ),
          ),
        ],
      ),
    ],
  );
}
