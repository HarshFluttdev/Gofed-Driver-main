import 'package:flutter/material.dart';

class KycPersonalDetail extends StatefulWidget {
  @override
  _KycPersonalDetailState createState() => _KycPersonalDetailState();
}

class _KycPersonalDetailState extends State<KycPersonalDetail> {
  TextEditingController nameController = TextEditingController();
  var cityName;
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 100),
        height: _height,
        width: _width,
        child: Column(
          children: [
            TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name")),
            Container(
              width : _width/1.1,
              margin: EdgeInsets.only(top:_height*0.04),
              child: DropdownButton<String>(
                isExpanded: true,
                focusColor: Colors.white,
                value: cityName,
                //elevation: 5,
                style: TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: <String>[
                  'Android',
                  'IOS',
                  'Flutter',
                  'Node',
                  'Java',
                  'Python',
                  'PHP',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                hint: Text(
                  "Select City",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                onChanged: (String value) {
                  setState(() {
                    cityName = value;
                  });
                },
              ),
            ),

            Container(
              width : _width/1.1,
              margin: EdgeInsets.only(top:_height*0.04),
              child: DropdownButton<String>(
                isExpanded: true,
                focusColor: Colors.white,
                value: cityName,
                //elevation: 5,
                style: TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: <String>[
                  'Yes',
                  'No',
                 
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                hint: Text(
                  "Do you own a vehicle ? ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                onChanged: (String value) {
                  setState(() {
                    cityName = value;
                  });
                },
              ),
            ),

          ],
        ),
      ),
    ));
  }
}
