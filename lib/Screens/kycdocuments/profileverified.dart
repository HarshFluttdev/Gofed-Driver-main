import 'package:flutter/material.dart';


class ProfileVerified extends StatefulWidget {
  @override
  _ProfileVerifiedState createState() => _ProfileVerifiedState();
}

class _ProfileVerifiedState extends State<ProfileVerified> {
  @override
  Widget build(BuildContext context) {
     var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Icon(
            Icons.verified_user,
            size: 150,
            color: Colors.white,
          )),
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                'Phone Verified',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )),
          Container(
            margin: EdgeInsets.only(top:10,left:50,right:30),
            child: Text(
                'Your Profile has been verified.\nPlease Continue to select your \n           delivery time slot',
                style: TextStyle(
                  height: 1.3,
                  letterSpacing: 1.0,
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),),
          ),
          SizedBox(
              height: height * 0.07,
            ),
            // customContainer(
            //     height: height * 0.06,
            //     width: width * 0.4,
            //     color: Colors.white,
            //     textcolor: Colors.black,
            //     text: 'Delivery Date & Time',
            //     ontap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));}),
        ],
      )),
    );
  }
}
