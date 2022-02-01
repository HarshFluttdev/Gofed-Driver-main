import 'package:flutter/material.dart';

Widget backArrowBtn({@required BuildContext context}) {
  return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
      ));
}

Widget button1({@required String btnTxt}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
    child: Row(
      children: [
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                btnTxt,
                textScaleFactor: 2,
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ))
      ],
    ),
  );
}
