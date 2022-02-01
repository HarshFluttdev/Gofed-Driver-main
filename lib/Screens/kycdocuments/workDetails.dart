import 'package:flutter/material.dart';
import 'package:quicksewadriver/Screens/kycdocuments/profileverified.dart';
import 'package:quicksewadriver/widgets/customkyccont.dart';

class WorkDetails extends StatefulWidget {
  @override
  _WorkDetailsState createState() => _WorkDetailsState();
}

class _WorkDetailsState extends State<WorkDetails> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
              child: Container(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, right: 150),
              child: Text(
                'Your Working Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: height*0.1,),
            textfieldContainer(
              height: height * 0.05,
              width: width * 0.7,
              text: 'Customer Name',
            ),
            SizedBox(height: height*0.02,),
            textfieldContainer(
              height: height * 0.05,
              width: width * 0.7,
              text: 'Official Email ID',
            ),
            SizedBox(
              height: height * 0.07,
            ),
            customContainer(
                height: height * 0.06,
                width: width * 0.4,
                color: Colors.blue,
                textcolor: Colors.white,
                text: 'Submit Details'),
            SizedBox(height: height*0.2,),
            Container(
              margin: EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Text(
                'We will send a confirmation email once you submit your Official Email ID',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 30, top: 70),
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text('Previous',style: TextStyle(color:Colors.white),),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                SizedBox(
                  width: width * 0.40,
                ),
                Container(
                    margin: EdgeInsets.only(top: 70),
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text('Next',style: TextStyle(color:Colors.white),),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileVerified()));
                      },
                    )),
              ],
            )
          ],
        )),
      ),
    );
  }
}
