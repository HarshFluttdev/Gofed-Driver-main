// import 'package:flutter/material.dart';
// import 'package:quicksewadriver/Screens/kycdocuments/Aadhar.dart';
// import 'package:quicksewadriver/Screens/kycdocuments/RC.dart';
// import 'package:quicksewadriver/Screens/kycdocuments/dl.dart';
// import 'package:quicksewadriver/Screens/kycdocuments/pancard.dart';
// import 'package:quicksewadriver/Screens/kycdocuments/photo.dart';
// import 'package:quicksewadriver/widgets/customkyccont.dart';

// class FrontPage extends StatefulWidget {
//   @override
//   _FrontPageState createState() => _FrontPageState();
// }

// class _FrontPageState extends State<FrontPage> {
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           color: Colors.black,
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//               child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: 20,
//                 ),
//                 child: Text(
//                   'Working Profession',
//                   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, top: 20),
//                 child: Text(
//                     'Please Complete each step given below to \n complete your profile'),
//               ),
//               CustomKyc(
//                   text: 'Capturing Your Selfie',
//                   width: width * 0.9,
//                   height: height * 0.15,
//                   ontap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => PhotoProfile()));
//                   }),
//               CustomKyc(
//                   text: 'Capturing Your Pan Card',
//                   width: width * 0.9,
//                   height: height * 0.15,
//                   ontap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => Pancard()));
//                   }),
//               CustomKyc(
//                   text: 'Capturing Your Aadhar Card',
//                   width: width * 0.9,
//                   height: height * 0.15,
//                   ontap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => Aadhaar()));
//                   }),
//               CustomKyc(
//                   text: 'Capturing Your DL',
//                   width: width * 0.9,
//                   height: height * 0.15,
//                   ontap: () {
//                     Navigator.push(
//                         context, MaterialPageRoute(builder: (context) => DL()));
//                   }),
//               CustomKyc(
//                   text: 'Capturing Your RC',
//                   width: width * 0.9,
//                   height: height * 0.15,
//                   ontap: () {
//                     Navigator.push(
//                         context, MaterialPageRoute(builder: (context) => RC()));
//                   }),
//             ],
//           )),
//         ),
//       ),
//     );
//   }
// }
