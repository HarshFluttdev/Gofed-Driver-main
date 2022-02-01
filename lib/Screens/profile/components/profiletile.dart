import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quicksewadriver/widgets/size_config.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final String value;
  final Function onTap;
  final bool isToggle;
  final IconData icon;
  final Color iconColor;

  const ProfileTile({
    Key key,
    @required this.title,
    this.value,
    this.onTap,
    this.isToggle = false,
    this.icon,
    this.iconColor = Colors.black,
  }) : super(key: key);

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return isToggle
        ? ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 25.0),
            title: Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: SizedBox(
              height: 20,
              width: 20,
              child: FittedBox(
                child: CupertinoSwitch(
                  value: true,
                  onChanged: (bool value) {},
                ),
              ),
            ),
            onTap: onTap,
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: height*0.04,
                  width: height*0.04,
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          value ?? '',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (icon != null)
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Icon(
                            icon,
                            color: iconColor,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
