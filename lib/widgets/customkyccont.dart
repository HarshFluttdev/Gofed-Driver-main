import 'package:flutter/material.dart';

Widget CustomKyc({height, width, text, ontap}) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 10, top: 40),
    child: GestureDetector(
      onTap: ontap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: () {},
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(300.0),
                          child: Image.network(
                              "http://images.unsplash.com/photo-1523285367489-d38aec03b6bd"),
                        )),
                  ],
                ),
              ),
            ),
            Text(text)
          ],
        ),
      ),
    ),
  );
}

Widget textfieldContainer({height, width,text,suffixtext}) {
  return Container(
    height: height,
    width: width,
    color: Color(0xFFE5E5E5),
    child: Padding(
      padding: const EdgeInsets.only(left:10),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: text,
            suffixText: suffixtext,
            hintStyle: TextStyle(fontWeight: FontWeight.w400)),
      ),
    ),
  );
}

Widget customContainer({color, height, width, textcolor, text, border,ontap}) {
  return GestureDetector(
    onTap: ontap,
      child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color, border: border, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: textcolor),
        ),
      ),
    ),
  );
}