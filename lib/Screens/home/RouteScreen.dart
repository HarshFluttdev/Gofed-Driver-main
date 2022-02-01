import 'dart:async';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:quicksewadriver/Screens/home/NewRouteScreen.dart';
import 'package:quicksewadriver/Screens/home/ReviewScreen.dart';
import 'package:quicksewadriver/Screens/home/homescreen.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteScreen extends StatefulWidget {
  final ride_id,
      pick_lat,
      pick_lng,
      drop_lat,
      drop_lng,
      drop_location,
      pick_location,
      contact_person,
      user_id,
      contact_number,
      loginedFirstName,
      loginedLastName,
      loginedMobileNo;

  const RouteScreen(
      {Key key,
      this.pick_lat,
      this.pick_lng,
      this.drop_lat,
      this.drop_lng,
      this.drop_location,
      this.pick_location,
      this.ride_id,
      this.contact_person,
      this.contact_number,
      this.user_id,
      this.loginedFirstName,
      this.loginedLastName,
      this.loginedMobileNo})
      : super(key: key);
  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  Set<Marker> markers = {};
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor droppinLocationIcon;
  Map<PolylineId, Polyline> polylines = {};
  GoogleMapController _mapController;
  var pickLocationCordinates;
  var currentLocation;

  var loading = false;

  void pickupMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5, size: Size(5, 5)),
        'assets/icons/source_pin.png');
  }

  void dropMapPin() async {
    droppinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5, size: Size(48, 48)),
        'assets/icons/dest_pin.png');
    getmarkers();
  }

  getmarkers() async {
    var locations = await locationFromAddress(widget.pick_location);
    setState(() {
      pickLocationCordinates = locations;
    });

    setState(() {
      Marker origin = (Marker(
        markerId: MarkerId('origin'),
        position: LatLng(locations.first.latitude,
            locations.first.longitude), //position of marker
        infoWindow: InfoWindow(
            //popup info
            // title: 'Your Pickup Location',
            // snippet: 'My Custom Subtitle',
            ),
        icon: pinLocationIcon, //Icon for Marker
      ));

      Marker destination = (Marker(
        //add second marker
        markerId: MarkerId('destination'),
        position: LatLng(double.parse(widget.drop_lat),
            double.parse(widget.drop_lng)), //position of marker
        infoWindow: InfoWindow(
            //popup info
            //  title: 'Marker Title Second ',
            //snippet: 'My Custom Subtitle',
            ),
        icon: pinLocationIcon, //Icon for Marker
      ));
      markers.add(origin);
      //add more markers here
    });

    return markers;
  }

  updatePickUp() async {
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(ridePickedUrl), body: {
        'id': id,
        'ride_id': widget.ride_id,
      });

      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          CustomMessage.toast("Ride picked");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewRouteScreen(
                pick_lat: widget.pick_lat,
                pick_lng: widget.pick_lng,
                drop_lat: widget.drop_lat,
                drop_lng: widget.drop_lng,
                drop_location: widget.drop_location,
                pick_location: widget.pick_location,
                ride_id: widget.ride_id,
                contact_person: widget.contact_person,
                contact_number: widget.contact_number,
                user_id: widget.user_id);
          }));
        } else {}
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  //Ride Completed

  rideCompleted() async {
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(rideCompletedUrl), body: {
        'id': id,
        'ride_id': widget.ride_id,
      });

      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
        } else {}
      }
    } catch (e) {
      print(e);
    }
  }

  updatePickupStatus() async {
    setState(() {
      loading = true;
    });
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.low);
    // double distanceInMeters = Geolocator.distanceBetween(
    //     double.parse(widget.pick_lat),
    //     double.parse(widget.pick_lng),
    //     position.latitude,
    //     position.longitude);
    // if (distanceInMeters <= 1000) {
    updatePickUp();
    // } else {
    //   CustomMessage.toast("Ride not picked");
    //   setState(() {
    //     loading = false;
    //   });
    // }
  }

  CancelRide() async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(rideCancelUrl), body: {
        'id': id,
        'ride_id': widget.ride_id.toString(),
      });

      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        } else {}
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  checkIfRideTaken() async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(anyRideActiveUrl), body: {
        'id': id,
      });

      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          if (data['data'].toString() != '[]') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }));
          } else if (data['data'].toString() == '[]') {
            Navigator.pop(context);
          }
        } else {}
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  getTargetLocation() {
    currentLocation =
        LatLng(double.parse(widget.pick_lat), double.parse(widget.pick_lng));
  }

  checkRideStatus() async {
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(anyRideActiveUrl), body: {
        'id': id,
      });

      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          if (data['data'].toString() != '[]') {
            if (data['data'][0]['status_id'] == '1') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
                (route) => false,
              );
            }
            if (data['data'][0]['status_id'] == '3') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return NewRouteScreen(
                    ride_id: data['data'][0]['id'],
                    pick_lat: data['data'][0]['pick_lat'],
                    pick_lng: data['data'][0]['pick_lng'],
                    drop_lat: data['data'][0]['drop_lat'],
                    drop_lng: data['data'][0]['drop_lng'],
                    drop_location: data['data'][0]['drop_location'],
                    pick_location: data['data'][0]['pick_location'],
                    contact_person: data['data'][0]['contact_person'],
                    contact_number: data['data'][0]['contact_number'],
                    user_id: data['data'][0]['user_id'],
                  );
                }),
                (route) => false,
              );
            }
            if (data['data'][0]['status_id'] == '4') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return ReviewScreen(
                      user_id: widget.user_id, ride_id: widget.ride_id);
                }),
                (route) => false,
              );
            }
          }
        } else {}
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getTargetLocation();
    pickupMapPin();
    dropMapPin();
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (!mounted) timer.cancel();
      checkRideStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    void onCreated(GoogleMapController controller) {
      _mapController = controller;
    }

    return WillPopScope(
      onWillPop: () {
        checkIfRideTaken();
      },
      child: Scaffold(
        body: (loading)
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Container(
                      height: height,
                      width: width,
                      child: GoogleMap(
                        markers: markers,
                        initialCameraPosition:
                            CameraPosition(target: currentLocation, zoom: 11),
                        zoomControlsEnabled: false,
                        minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        mapType: MapType.normal,
                        mapToolbarEnabled: true,
                        onCameraMove: (CameraPosition position) {
                          currentLocation.onCameraMove(position);
                        },
                        onMapCreated: onCreated,
                        onCameraIdle: () {
                          // loc.getMoveCamera();
                        },
                      )),
                  Positioned(
                    top: height * 0.76,
                    left: width * 0.04,
                    child: Container(
                      width: width * 0.90,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        width: width * 0.75,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                              (widget.contact_person ?? ''))),
                                      IconButton(
                                          icon: Icon(Icons.phone,
                                              size: 30, color: Colors.blue),
                                          onPressed: () {
                                            launch(
                                                "tel://${widget.contact_number}");
                                          })
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(widget.pick_location),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.91,
                    left: width * 0.05,
                    bottom: height * 0.03,
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          //   width: width * 0.10,
                          child: ElevatedButton(
                            onPressed: () {
                              MapsLauncher.launchQuery(widget.pick_location);
                            },
                            child: Text(
                              'Get Directions',
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(fontSize: 21, color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22))),
                          ),
                        ),
                        Container(
                          height: height * 0.07,
                          width: width * 0.50,
                          child: SwipingButton(
                            text: "Pick",
                            onSwipeCallback: () {
                              updatePickupStatus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
