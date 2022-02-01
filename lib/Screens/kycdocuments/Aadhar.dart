// import 'package:flutter/material.dart';
// import 'package:quicksewadriver/Screens/kycdocuments/dl.dart';
// import 'package:quicksewadriver/Screens/kycdocuments/pancard.dart';
// import 'package:quicksewadriver/Screens/kycdocuments/workDetails.dart';

// import 'profileverified.dart';


// class Aadhaar extends StatefulWidget {
//   @override
//   _AadhaarState createState() => _AadhaarState();
// }

// class _AadhaarState extends State<Aadhaar> {
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.white,
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
//       body: Container(
//           child: Column(
//         children: [
//           Container(
//             margin: EdgeInsets.only(top: height * 0.01, right: width * 0.3,left:width*0.02),
//             child: Text(
//               'Upload Your Aadhar Card',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//               padding: EdgeInsets.only(
//                   left: width * 0.03, right: width * 0.03, top: height * 0.04),
//               child: GestureDetector(
//                   onTap: () {},
//                   child: Container(
//                     height: height * 0.50,
//                     width: width * 1,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(top: height * 0.05),
//                           padding: EdgeInsets.all(5.0),
//                           alignment: Alignment.centerLeft,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                           ),
//                           child: GestureDetector(
//                             onTap: () {
//                             //  _showPicker(context);
//                             },
//                             child: Stack(
//                               children: <Widget>[
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                       top: height * 0.08, left: width * 0.3),
//                                   child: CircleAvatar(
//                                     radius: 55,
//                                     backgroundColor: Color(0xffFDCF09),
//                                     child:
//                                     // _image != null
//                                         // ? ClipRRect(
//                                         //     borderRadius:
//                                         //         BorderRadius.circular(50),
//                                         //     child: Image.file(
//                                         //     //  _image,
//                                         //       width: 100,
//                                         //       height: 100,
//                                         //       fit: BoxFit.fill,
//                                         //     ),
//                                         //   )
//                                          Container(
//                                             decoration: BoxDecoration(
//                                                 color: Colors.grey[200],
//                                                 borderRadius:
//                                                     BorderRadius.circular(50)),
//                                             width: 100,
//                                             height: 100,
//                                             child: Icon(
//                                               Icons.camera_alt,
//                                               color: Colors.grey[800],
//                                             ),
//                                           ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: height * 0.01,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                           //  upload(_image);
//                           },
//                           child: Text(
//                             'Camera Icon',
//                             style: TextStyle(fontSize: 17),
//                           ),
//                         )
//                       ],
//                     ),
//                   ))),
//           Container(
//             margin: EdgeInsets.only(top: height*0.05, left: width*0.04, right: width*0.04),
//             child: Text(
//               'Your Aadhar Card will help us to make sure we deliver to the right person',
//               style: TextStyle(fontSize: 15),
//             ),
//           ),
//           Row(
//             children: [
//               Container(
//                   margin: EdgeInsets.only(left: width*0.05, top: height*0.09),
//                   child: RaisedButton(
//                     color: Colors.blue,
//                     child: Text(
//                       'Previous',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context)=>Pancard()));
//                     },
//                   )),
//               SizedBox(
//                 width: width * 0.40,
//               ),
//               Container(
//                   margin: EdgeInsets.only(top: height*0.09),
//                   child: RaisedButton(
//                     color: Colors.blue,
//                     child: Text(
//                       'Next',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => DL
//                           ()));
//                     },
//                   )),
//             ],
//           )
//         ],
//       )),
//     );
//   }
// }