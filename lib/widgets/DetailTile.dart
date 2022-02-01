import 'package:flutter/material.dart';

class DetailTile extends StatelessWidget {
  final value1, value2, value3;

  const DetailTile({this.value1, this.value2, this.value3});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: height * 0.15,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(-1.0, -2.0),
                end: Alignment(1.0, 2.0),
                colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(value1,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      value2,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                       value3,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
            Container(
                child: Center(
                    child: Icon(Icons.arrow_forward_ios_outlined,
                        color: Colors.white, size: 40)))
          ],
        ),
      ),
    );
  }
}
