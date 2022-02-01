// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:quicksewadriver/Screens/kycdocuments/Aadhar.dart';


// class Pancard extends StatefulWidget {
//   @override
//   _PancardState createState() => _PancardState();
// }

// class _PancardState extends State<Pancard> {
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

//   uploadImageWithhttp(File imageFile, int serialno) async {
//     var postBody = {
//       'username': 'test@gmail.com',
//       "productid": "1000123", 
//       "imageno": serialno.toString(),
//       'image':
//           imageFile != null ? base64Encode(imageFile.readAsBytesSync()) : '',
//     };

//     final response = await http.post(
//       Uri.parse('http://gofedtransport.nexinfosoft.com/api/Partner/kycUpload'),
//       headers: {
//         //AuthUtils.AUTH_HEADER: _authToken
//         'Content-Type': 'application/json',
//       },
//       body: json.encode(postBody),
//     );

//     final responseJson = json.decode(response.body);

//     print(responseJson);
//   }

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
//             margin: EdgeInsets.only(top: height * 0.02, right: width * 0.33),
//             child: Text(
//               'Upload Your Pan Card',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//               padding: EdgeInsets.only(left: width * 0.04, right: width*0.04, top: height*0.04),
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
//                           margin: EdgeInsets.only(top: height*0.02),
//                           padding: const EdgeInsets.all(5.0),
//                           alignment: Alignment.centerLeft,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                           ),
//                           child: GestureDetector(
//                             onTap: () {
//                               _showPicker(context);
//                             },
//                             child: Stack(
//                               children: <Widget>[
//                                 Padding(
//                                   padding:
//                                      EdgeInsets.only(top: height*0.09, left: width*0.3),
//                                   child: CircleAvatar(
//                                     radius: 55,
//                                     backgroundColor: Color(0xffFDCF09),
//                                     child: _image != null
//                                         ? ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             child: Image.file(
//                                               _image,
//                                               width: 100,
//                                               height: 100,
//                                               fit: BoxFit.fill,
//                                             ),
//                                           )
//                                         : Container(
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
//                         Text(
//                           'Upload Icon',
//                           style: TextStyle(fontSize: 17),
//                         )
//                       ],
//                     ),
//                   ))),
//           Container(
//             margin: EdgeInsets.only(top: height*0.05, left: width*0.03, right: width*0.02),
//             child: Text(
//               'By Uploading the PAN Card you authorize us to check your CIBIL Score',
//               style: TextStyle(fontSize: 15),
//             ),
//           ),
//           Row(
//             children: [
//               Container(
//                   margin: EdgeInsets.only(left: width*0.06, top: height*0.09),
//                   child: RaisedButton(
//                     color: Colors.blue,
//                     child: Text(
//                       'Previous',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
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
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => Aadhaar()));
//                     },
//                   )),
//             ],
//           )
//         ],
//       )),
//     );
//   }
// }
