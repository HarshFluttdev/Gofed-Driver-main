import 'package:flutter/material.dart';
import 'package:quicksewadriver/Screens/drawer/TrainingScreen.dart';
import 'package:quicksewadriver/Screens/drawer/notification.dart';
import 'package:quicksewadriver/Screens/drawer/orderscreen.dart';
import 'package:quicksewadriver/Screens/drawer/wallet.dart';
import 'package:quicksewadriver/Screens/home/RideList.dart';
import 'package:quicksewadriver/Screens/profile/profile.dart';

CustomDrawer(BuildContext context, double width, double height) {
  return Drawer(
    child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      Container(
        width: width * 4,
        height: height * 0.12,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(-1.0, -2.0),
              end: Alignment(1.0, 2.0),
              colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
        ),
        child: Container(
            margin: EdgeInsets.only(top: height * 0.02, right: width * 0.6),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.white,
                ))),
      ),
      SizedBox(
        height: height * 0.03,
      ),
      Padding(
        padding: EdgeInsets.only(left: width * 0.01),
        child: ListTile(
          leading: Image.asset(
            'assets/icons/wallets.png',
            height: height * 0.06,
          ),
          title: Text('Earning / Wallet'),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Wallet()));
          },
        ),
      ),
      SizedBox(
        height: height * 0.01,
      ),
      Padding(
        padding: EdgeInsets.only(left: width * 0.01),
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TrainingVideoScreen(route: false)));
          },
          leading: Image.asset(
            'assets/icons/training.png',
            height: height * 0.06,
          ),
          title: Text('Training'),
        ),
      ),
      SizedBox(
        height: height * 0.01,
      ),
      Padding(
        padding: EdgeInsets.only(left: width * 0.01),
        child: ListTile(
          leading: Image.asset(
            'assets/icons/notification.png',
            height: height * 0.06,
          ),
          title: Text('Notification'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationScreen()));
          },
        ),
      ),
      SizedBox(
        height: height * 0.01,
      ),
      Padding(
        padding: EdgeInsets.only(left: width * 0.01),
        child: ListTile(
          leading: Image.asset(
            'assets/icons/refer.png',
            height: height * 0.06,
          ),
          title: Text('My Orders'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OrdersScreen()));
          },
        ),
      ),
      SizedBox(
        height: height * 0.01,
      ),
      // Padding(
      //   padding: EdgeInsets.only(left: width * 0.01),
      //   child: ListTile(
      //     onTap: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => ReferAndEarnScreen()));
      //     },
      //     leading: Image.asset(
      //       'assets/icons/refer.png',
      //       height: height * 0.06,
      //     ),
      //     title: Text('Refer and Earn'),
      //   ),
      // ),
      Padding(
        padding: EdgeInsets.only(left: width * 0.01),
        child: ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RideListScreen()));
          },
          leading: Image.asset(
            'assets/icons/refer.png',
            height: height * 0.06,
          ),
          title: Text('Ride List'),
        ),
      ),
      SizedBox(
        height: height * 0.01,
      ),
      Padding(
        padding: EdgeInsets.only(left: width * 0.01),
        child: ListTile(
          leading: Image.asset(
            'assets/icons/user.png',
            height: height * 0.06,
          ),
          title: Text('Profile'),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Profile()));
          },
        ),
      ),
    ]),
  );
}
