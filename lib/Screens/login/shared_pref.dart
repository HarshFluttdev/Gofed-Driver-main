import 'dart:convert';

import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../widgets/CustomMessage.dart';

class Shared_pref {
  SharedPreferences preferences;

  Future<bool> get_bool(String key) async {
    preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    return await preferences.getBool(key) ?? false;
  }

  Future<void> set_bool(String key, bool value) async {
    preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }
}

class UserDetail {
  getUserDetail(var mobile) async {
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(profileVehicleUrl), body: {
        "id": id,
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          return data['data'][0]['id'];
        }
      } else {}
    } catch (e) {
      print(e);
    }
  }
}

class Uploading {
  asyncMultipleFileUpload(
      var id, var front, var back, var firstImage, var secondImage) async {
    //create multipart request for POST or PATCH method
    var id = await SharedData().getUser();
    var request = http.MultipartRequest("POST", Uri.parse(uploadUrl));
    //add text fields
    request.fields['id'] = id;

    //create multipart using filepath, string or bytes
    var frontImage = await http.MultipartFile.fromPath(front, firstImage);
    var backImage = await http.MultipartFile.fromPath(back, secondImage);
    //add multipart to request
    request.files.add(frontImage);
    request.files.add(backImage);
    var stream = await request.send();

    var response = await http.Response.fromStream(stream);
    CustomMessage.toast(response.body);
    print(response.body.toString());
    if (response.statusCode != 200) {
      CustomMessage.toast("Internal server error");
    } else if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CustomMessage.toast(data['message']);
    }
  }

  asyncSingleFileUpload(var id, var front, var firstImage) async {
    var id = await SharedData().getUser();
    var request = http.MultipartRequest("POST", Uri.parse(uploadUrl));
    //add text fields
    request.fields['id'] = id;

    //create multipart using filepath, string or bytes
    var frontImage = await http.MultipartFile.fromPath(front, firstImage);
    //add multipart to request
    request.files.add(frontImage);
    var stream = await request.send();

    var response = await http.Response.fromStream(stream);
    if (response.statusCode != 200) {
      CustomMessage.toast("Internal server error");
    } else if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CustomMessage.toast(data['message']);
    }
  }
}
