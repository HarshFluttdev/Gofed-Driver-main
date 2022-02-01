// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:quicksewadriver/Provider/locationprovider.dart';

// class GoogleMaps extends StatefulWidget {
//   static const String id = 'googlemap';
//   @override
//   _GoogleMapsState createState() => _GoogleMapsState();
// }

// class _GoogleMapsState extends State<GoogleMaps> {
//   LatLng currentLocation;
//   // ignore: unused_field
//   GoogleMapController _mapController;

//   @override
//   Widget build(BuildContext context) {


//     void onCreated(GoogleMapController controller) {
//       setState(() {
//         _mapController = controller;
//       });
//     }


//     return Scaffold(body: SafeArea(
//         child: Consumer<LocationProvider>(builder: (context, loc, child) {
//       var currentLocation = LatLng(loc.latitude, loc.longitude);
//       return loc.isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Stack(
//               children: [
//                 SafeArea(
//                                   child: GoogleMap(
//                     initialCameraPosition:
//                         CameraPosition(target: currentLocation, zoom: 11),
//                     zoomControlsEnabled: false,
//                     minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
//                     myLocationEnabled: true,
//                     myLocationButtonEnabled: true,
//                     mapType: MapType.normal,
//                     mapToolbarEnabled: true,
//                     onCameraMove: (CameraPosition position) {
//                       loc.onCameraMove(position);
//                     },
//                     onMapCreated: onCreated,
//                     onCameraIdle: () {
//                       loc.getMoveCamera();
//                     },
//                   ),
//                 ),
//                 // Container(
//                 //   margin: EdgeInsets.only(left: 120, top: 270),
//                 //   height: 40.0,
//                 //   width: 150.0,
//                 //   child: Container(
//                 //     decoration: BoxDecoration(
//                 //         color: Colors.white,
//                 //         borderRadius: BorderRadius.all(Radius.circular(30.0))),
//                 //     child: Padding(
//                 //       padding: const EdgeInsets.all(3.0),
//                 //       child: new Text(
//                 //         loc.getAddress.toString(),
//                 //         style: TextStyle(fontSize: 15, color: Colors.black),
//                 //         textAlign: TextAlign.center,
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 Center(
//                     child: Container(
//                         height: 30,
//                         margin: EdgeInsets.only(bottom: 40),
//                         child: Image.asset('asset/icons/pinicon.png'))),
//               ]);
//     })));
//   }
// }


