import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:quicksewadriver/Screens/home/ReviewScreen.dart';
import 'package:quicksewadriver/Screens/home/RouteScreen.dart';
import 'package:quicksewadriver/Screens/home/homescreen.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomElevatedButton.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:quicksewadriver/widgets/CustomTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NewRouteScreen extends StatefulWidget {
  final ride_id,
      pick_lat,
      pick_lng,
      drop_lat,
      drop_lng,
      drop_location,
      pick_location,
      contact_person,
      user_id,
      contact_number;

  const NewRouteScreen(
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
      this.user_id})
      : super(key: key);
  @override
  _NewRouteScreenState createState() => _NewRouteScreenState();
}

class _NewRouteScreenState extends State<NewRouteScreen> {
  Set<Marker> markers = {};
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor droppinLocationIcon;
  Map<PolylineId, Polyline> polylines = {};
  GoogleMapController _mapController;
  var loading = false;
  var currentLocation;
  var dropLocationCordinates;

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
    var locations = await locationFromAddress(widget.drop_location);
    setState(() {
      dropLocationCordinates = locations;
    });

    setState(() {
      Marker origin = (Marker(
        markerId: MarkerId('origin'),
        position: LatLng(double.parse(widget.pick_lat),
            double.parse(widget.pick_lng)), //position of marker
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
        position: LatLng(locations.first.latitude,
            locations.first.longitude), //position of marker
        infoWindow: InfoWindow(
            //popup info
            //  title: 'Marker Title Second ',
            //snippet: 'My Custom Subtitle',
            ),
        icon: pinLocationIcon, //Icon for Marker
      ));
      markers.add(destination);
      //add more markers here
    });

    return markers;
  }

  //Ride Completed

  rideCompleted() async {
    var id = await SharedData().getUser();
    var rideDetails = {};
    TextEditingController _rideAmount = TextEditingController();
    TextEditingController _labourCharges = TextEditingController();

    AlertDialog dialog = AlertDialog(
      title: Text(
        'Update Ride Data',
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            context: context,
            controller: _rideAmount,
            labelText: 'Extra Amount',
            keyboard: TextInputType.number,
          ),
          SizedBox(height: 20),
          CustomTextField(
            context: context,
            controller: _labourCharges,
            labelText: 'MCD Charges',
            keyboard: TextInputType.number,
          ),
          SizedBox(height: 30),
          CustomElevatedButton(
            buttonClicked: false,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            context: context,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
    await showDialog(context: context, builder: (context) => dialog);

    try {
      var response = await http.post(Uri.parse(rideCompletedUrl), body: {
        'id': id,
        'ride_id': widget.ride_id,
        'amount': _rideAmount.text,
        'labour': _labourCharges.text,
      });

      if (response.statusCode != 200) {
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return ReviewScreen(
                user_id: widget.user_id, ride_id: widget.ride_id);
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

  updateCompletedStatus() async {
    setState(() {
      loading = true;
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    double distanceInMeters = Geolocator.distanceBetween(
        dropLocationCordinates.first.latitude,
        dropLocationCordinates.first.longitude,
        position.latitude,
        position.longitude);
    if (distanceInMeters <= 1000000) {
      rideCompleted();
    } else {
      CustomMessage.toast("Ride not completed");
      setState(() {
        loading = false;
      });
    }
  }

  getTargetLocation() async {
    var locations = await locationFromAddress(widget.drop_location);
    setState(() {
      currentLocation =
          LatLng(locations.first.latitude, locations.first.longitude);
    });
  }

  reloadGoogleMap() {
    setState(() {});
  }

  checkRideStatus() async {
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(anyRideActiveUrl), body: {
        'id': id,
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
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
            if (data['data'][0]['status_id'] == '2') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return RouteScreen(
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
                  },
                ),
                (route) => false,
              );
            }
            if (data['data'][0]['status_id'] == '4') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return ReviewScreen(
                    user_id: widget.user_id,
                    ride_id: widget.ride_id,
                  );
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
      setState(() {
        _mapController = controller;
      });
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
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
                    top: height * 0.75,
                    bottom: height * 0.10,
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
                                          child: Text(widget.contact_person)),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20.0),
                                        child: IconButton(
                                            icon: Icon(Icons.phone,
                                                size: 30, color: Colors.blue),
                                            onPressed: () {
                                              launch(
                                                  "tel://${widget.contact_number}");
                                            }),
                                      )
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(widget.drop_location),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.92,
                    left: width * 0.05,
                    bottom: height * 0.02,
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: width * 0.40,
                          child: ElevatedButton(
                            onPressed: () {
                              MapsLauncher.launchQuery(widget.drop_location);
                            },
                            child: Text(
                              'Directions',
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
                          margin: EdgeInsets.only(left: 0.01),
                          width: width * 0.50,
                          child: SwipingButton(
                            text: "Complete",
                            onSwipeCallback: () {
                              updateCompletedStatus();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
