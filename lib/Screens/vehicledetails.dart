// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:quicksewadriver/Provider/locationprovider.dart';
// import 'package:quicksewadriver/Screens/bottomnavbar/googlemaps.dart';
// import 'package:quicksewadriver/Screens/bottomnavbar/home.dart';

// class VehicleDetails extends StatefulWidget {
//   @override
//   _VehicleDetailsState createState() => _VehicleDetailsState();
// }

// class _VehicleDetailsState extends State<VehicleDetails> {
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     String gender = "";
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         maintainBottomViewPadding: true,
//         child: Stack(
//           children: [
//             Form(
//               child: ListView(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 children: <Widget>[
//                   Padding(
//                       padding:
//                           EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
//                       child: new Row(
//                         mainAxisSize: MainAxisSize.max,
//                         children: <Widget>[
//                           new Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               new Text(
//                                 'Vehicle Type',
//                                 style: TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ],
//                       )),
//                   SizedBox(
//                     height: height * 0.04,
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(left: 9),
//                     margin: EdgeInsets.only(left: 20, right: 20, bottom: 11),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blue[500]),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: purposePicker(),
//                   ),
//                   Padding(
//                       padding:
//                           EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
//                       child: new Row(
//                         mainAxisSize: MainAxisSize.max,
//                         children: <Widget>[
//                           new Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               new Text(
//                                 'Vehicle Number',
//                                 style: TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ],
//                       )),
//                   Padding(
//                       padding:
//                           EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         children: <Widget>[
//                           Flexible(
//                             child: TextFormField(
//                               decoration: InputDecoration(),
//                             ),
//                           ),
//                         ],
//                       )),
//                   Padding(
//                       padding:
//                           EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
//                       child: new Row(
//                         mainAxisSize: MainAxisSize.max,
//                         children: <Widget>[
//                           new Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               new Text(
//                                 'Will you drive the vehicle',
//                                 style: TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ],
//                       )),
//                   SizedBox(
//                     height: height * 0.04,
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(left: 9),
//                     margin: EdgeInsets.only(left: 20, right: 20, bottom: 11),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blue[500]),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: DropdownButtonFormField(
//                       items: ["Yes", "No"]
//                           .map((label) => DropdownMenuItem(
//                                 child: Text(label.toString()),
//                                 value: label,
//                               ))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           gender = value;
//                         });
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: height * 0.30,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
//                     },
//                     child: Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Container(
//                           height: height * 0.08,
//                           width: width * 0.85,
//                           decoration: BoxDecoration(
//                               color: Colors.blueAccent,
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Center(
//                             child: Padding(
//                               padding: EdgeInsets.all(10),
//                               child: Text("REGISTER",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontFamily: "Raleway",
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w600,
//                                   )),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String locVal = ' ';
//   List<String> locations = [
//     ' ',
//     'Tata Ace'.toString(),
//     'Pickup/ 8ft'.toString(),
//     '3 Wheeler'.toString(),
//     'E vehicle'.toString(),
//     '2 Vehicle'.toString(),
//     'Tata 407 14ft'.toString(),
//     'Eeco'.toString(),
//     'Champion'.toString(),
//     'Others'.toString(),
//   ];
//   Widget purposePicker() {
//     return DropdownButton(
//         value: locVal,
//         icon: Padding(
//           padding: const EdgeInsets.only(left: 230),
//           child: Icon(
//             Icons.arrow_drop_down_outlined,
//           ),
//         ),
//         iconSize: 25,
//         style: TextStyle(fontSize: 13, color: Colors.black),
//         underline: Container(
//           height: 2,
//         ),
//         onChanged: (String newVal) {
//           setState(() {
//             locVal = newVal;
//           });
//         },
//         items: locations.map<DropdownMenuItem<String>>((value) {
//           return DropdownMenuItem<String>(value: value, child: Text(value));
//         }).toList());
//   }
// }
