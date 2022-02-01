
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:progress_timeline/progress_timeline.dart';
// import 'dart:convert';
// import 'package:path/path.dart';
// import 'package:async/async.dart';
// import 'package:http/http.dart' as http;
// import 'package:quicksewadriver/services/url.dart';

// class DocumentUploadScreen extends StatefulWidget {
//   @override
//   _DocumentUploadScreenState createState() => _DocumentUploadScreenState();
// }

// class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
//   File _image;
//   final picker = ImagePicker();

//   Future _imgFromCamera() async {
//     final pickedFile =
//         await picker.getImage(source: ImageSource.camera, imageQuality: 50);

//     setState(() {
//       _image = File(pickedFile.path);
//     });
//   }

//   Future _imgFromGallery() async {
//     final pickedFile =
//         await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

//     setState(() {
//       _image = File(pickedFile.path);
//     });
//   }

//   void _showPicker(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return SafeArea(
//             child: Container(
//               child: new Wrap(
//                 children: <Widget>[
//                   new ListTile(
//                       leading: new Icon(Icons.photo_library),
//                       title: new Text('Photo Library'),
//                       onTap: () {
//                         _imgFromGallery();
//                         Navigator.of(context).pop();
//                       }),
//                   new ListTile(
//                     leading: new Icon(Icons.photo_camera),
//                     title: new Text('Camera'),
//                     onTap: () {
//                       _imgFromCamera();
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   upload(File _image) async {
//     var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
//     var length = await _image.length();

//     var uri = Uri.parse(uploadUrl);

//     var request = new http.MultipartRequest("POST", uri);
//     var multipartFile = new http.MultipartFile('file', stream, length,
//         filename: basename(_image.path));
//     //contentType: new MediaType('image', 'png'));

//     request.files.add(multipartFile);
//     var response = await request.send();
//     print(response.statusCode);
//     response.stream.transform(utf8.decoder).listen((value) {
//       print(value);
//     });
//   }

//   ProgressTimeline screenProgress;
//   @override
//   void initState() {
//     List<SingleState> allStages = [
//       SingleState(stateTitle: "ID"),
//       SingleState(stateTitle: "RC"),
//       SingleState(stateTitle: "DL"),
//     ];
//     screenProgress = new ProgressTimeline(
//       states: allStages,
//       connectorLength: 120.0,
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Color(0xffF5F5F5),
//       body: Column(
//         children: [
//           Container(
//             width: width * 5,
//             height: height * 0.17,
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                     begin: Alignment(-1.0, -2.0),
//                     end: Alignment(1.0, 2.0),
//                     colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(50),
//                   bottomRight: Radius.circular(50),
//                 )),
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                   horizontal: width * 0.02, vertical: height * 0.015),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Icon(
//                           Icons.arrow_back,
//                           color: Colors.white,
//                           size: 40,
//                         ),
//                       ),
//                       SizedBox(
//                         width: width * 0.24,
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(top: height * 0.03),
//                         child: Image.asset(
//                           'assets/icons/splash.png',
//                           height: height * 0.09,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(top: height * 0.03),
//             width: width,
//             child: Center(
//                 child: Text(
//               "Upload Documents",
//               style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
//             )),
//           ),
//           SizedBox(
//             height: height * 0.02,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 2.0),
//             child: screenProgress,
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 width: width * 0.05,
//               ),
//               Text(
//                 'Owner Aadhar or Voter ID',
//                 style:
//                     TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: height * 0.04,
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 width: width * 0.07,
//               ),
//               Container(
//                 height: height * 0.15,
//                 width: width * 0.3,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey[350],
//                       offset: const Offset(
//                         0.0,
//                         3.0,
//                       ),
//                       blurRadius: 10.0,
//                       spreadRadius: 2.0,
//                     ), //BoxShadow
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: height * 0.03,
//                     ),
//                     Icon(
//                       Icons.camera_alt_rounded,
//                       color: Color(0xff6F6AF6),
//                       size: 36,
//                     ),
//                     SizedBox(
//                       height: height * 0.02,
//                     ),
//                     Text(
//                       'Front Side',
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: width * 0.2,
//               ),
//               Container(
//                 height: height * 0.15,
//                 width: width * 0.3,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey[350],
//                       offset: const Offset(
//                         0.0,
//                         3.0,
//                       ),
//                       blurRadius: 10.0,
//                       spreadRadius: 2.0,
//                     ), //BoxShadow
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: height * 0.03,
//                     ),
//                     Icon(
//                       Icons.camera_alt_rounded,
//                       color: Color(0xff6F6AF6),
//                       size: 36,
//                     ),
//                     SizedBox(
//                       height: height * 0.02,
//                     ),
//                     Text(
//                       'Back Side',
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
