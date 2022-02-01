import 'package:flutter/material.dart';

class Refferfriends extends StatefulWidget {
  @override
  _RefferfriendsState createState() => _RefferfriendsState();
}

class _RefferfriendsState extends State<Refferfriends> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 30),
        child: Column(children: [
          Container(
            height: 190,
            width: 270,
            child: Image.network(
                'https://image.freepik.com/free-vector/refer-friend-earn-reward_140185-35.jpg',
                fit: BoxFit.fill),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Invite Friends',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('If you like our work,\nPlease spread the word!',
                    style: TextStyle(fontSize: 12))
              ]),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Invite',
                  style: TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                    elevation: 0),
              )
            ],
          ),
          SizedBox(height: 12)
        ]),
      ),
    );
  }
}
