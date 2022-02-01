import 'package:flutter/material.dart';
import 'package:quicksewadriver/widgets/constants.dart';


class NotificationsCard extends StatelessWidget {
  final String profileImage;
  final String title;
  final String message;

  const NotificationsCard(
      {Key key,
      @required this.profileImage,
      @required this.title,
      this.message})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(defaultPadding),
      child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              padding: const EdgeInsets.all(defaultPadding * 0.5),
              child: ListTile(
                leading: CircleAvatar(
                  maxRadius: 30,
                  backgroundColor: primaryColor,
                  backgroundImage: NetworkImage(profileImage),
                ),
                title: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
              ))),
    );
  }
}
