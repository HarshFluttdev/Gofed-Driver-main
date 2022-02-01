// import 'package:flutter/material.dart';
// import 'package:quicksewadriver/Screens/kycdocuments/frontpage.dart';
// import 'package:quicksewadriver/Screens/payment/paymentscreen.dart';
// import 'package:quicksewadriver/Screens/profile/profile.dart';
// import 'package:quicksewadriver/Screens/referandearn/reffer.dart';
// import 'package:quicksewadriver/Screens/trips/trips.dart';
// import 'package:quicksewadriver/widgets/buttons.dart';
// import 'package:quicksewadriver/widgets/customcard.dart';

// class Settings extends StatefulWidget {
//   @override
//   _SettingsState createState() => _SettingsState();
// }

// class _SettingsState extends State<Settings> {
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: backArrowBtn(context: context),
//         title: Text('Settings',
//             style: TextStyle(color: Colors.black, fontSize: 25)),
//       ),
//       body: SafeArea(
//           child: Column(children: [
//         CustomCard(
//             icon: Icon(Icons.verified_user_outlined),
//             height: height * 0.08,
//             text: 'Profile',
//             ontap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));}),
//         CustomCard(
//             icon: Icon(Icons.car_rental),
//             height: height * 0.08,
//             text: 'My Rides',
//             ontap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>PickUpAndDropOff()));}),
//         CustomCard(
//             icon: Icon(Icons.notifications),
//             height: height * 0.08,
//             text: 'Notifications',
//             // ontap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Notifications())
//             ),
//         CustomCard(
//             icon: Icon(Icons.share),
//             height: height * 0.08,
//             text: 'Refer and Earn',
//            // ontap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Refferfriends()));}),
//         ),CustomCard(
//             icon: Icon(Icons.bike_scooter),
//             height: height * 0.08,
//             text: 'Instant Ride'),
//         CustomCard(
//             icon: Icon(Icons.payment), height: height * 0.08, text: 'Payment',ontap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen()));}),
//             CustomCard(
//             icon: Icon(Icons.card_giftcard_rounded),
//             height: height * 0.08,
//             text: 'Gift and Vouchers'),
//             CustomCard(
//             icon: Icon(Icons.card_membership_sharp),
//             height: height * 0.08,
//             text: 'KYC Documents',
//             ontap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>FrontPage()));}),
//       ])),
//     );
//   }
// }
