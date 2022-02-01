import 'package:flutter/material.dart';

class ReferAndEarnScreen extends StatefulWidget {
  @override
  ReferAndEarnScreenState createState() => ReferAndEarnScreenState();
}

class ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
          padding: EdgeInsets.only(left: width * 0.2),
          child: Text(
            'Refer and Earn',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: Text("No Video uploaded."),
        ),
      )
    );
  }
}