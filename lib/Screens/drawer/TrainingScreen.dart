import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quicksewadriver/Screens/home/DcoumentAndTrainingScreen.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrainingVideoScreen extends StatefulWidget {
  final route;

  const TrainingVideoScreen({this.route});
  @override
  _TrainingVideoScreenState createState() => _TrainingVideoScreenState();
}

class _TrainingVideoScreenState extends State<TrainingVideoScreen> {
  var loading = false;
  var url = "";
  var videoId = "";
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '-PhqEJGaxl8',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  getTrainingVideos() async {
    setState(() {
      loading = true;
    });
    try {
      var response = await http.post(Uri.parse(trainingUrl));

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          url = data['data'][0]['video'];
          await updateTrainingStatus();
          launch(url);
          Navigator.pop(context);
        } else {}
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  updateTrainingStatus() async {
    setState(() {
      loading = true;
    });

    try {
      var id = await SharedData().getUser();
      var response = http.post(Uri.parse(updateTrainingUrl), body: {
        'id': id,
        'status': '1',
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getTrainingVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              (widget.route)
                  ? Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                      return DocumentAndTrainingScreen();
                    }))
                  : Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        elevation: 0,
        backgroundColor: Color(0xffF5F5F5),
        title: Padding(
          padding: EdgeInsets.only(left: width * 0.2),
          child: Text(
            'Training',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
      body: (loading)
          ? Center(child: CircularProgressIndicator())
          // : Column(
          //     children: [
          //       Container(
          //         width: double.infinity,
          //         height: 250,
          //         color: Colors.black,
          //         child: Center(
          //           child: Container(
          //             width: 25,
          //             height: 25,
          //             child: CircularProgressIndicator(
          //               valueColor: AlwaysStoppedAnimation(Colors.white),
          //               strokeWidth: 2,
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(height: 30),
          //       Text('Training Test Video'),
          //     ],
          //   )
          : Container(
              // child: YoutubePlayer(
              //   controller: _controller,
              //   showVideoProgressIndicator: true,
              // ),
              ),
    );
  }
}
