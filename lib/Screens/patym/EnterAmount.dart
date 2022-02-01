import 'package:flutter/material.dart';

class EnterAmountScreen extends StatefulWidget {
  @override
  _EnterAmountScreenState createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        elevation: 0,
        backgroundColor: Color(0xffF5F5F5),
        title: Padding(
          padding: EdgeInsets.only(left: _width*0.2),
          child: Text(
            'Payment',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
       body: Container(
         height: _height,
         width: _width,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: _width*0.80,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Enter Amount',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Color(0xFF6D5DF6)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
            ),
           Container(
            margin: EdgeInsets.only(top: _height * 0.10),
            height: _height * 0.05,
            width: _width * 0.50,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
            ),
            child: TextButton(
              onPressed: () async {
               
              },
              child: Center(
                child: Text(
                  'Proceed to checkout',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
          ],
      ),
       ),
      
    );
  }
}