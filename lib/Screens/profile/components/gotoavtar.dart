import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GoToAvatar extends StatelessWidget {
  final double radius;
  final Border border;
  final String url;
  final String asset;
  final String errorAsset;
  final Color backgroundColor;

  const GoToAvatar(
      {Key key,
      this.radius = 40,
      this.border,
      this.url,
      this.asset,
      this.backgroundColor = Colors.transparent,
      this.errorAsset = 'assets/images/boy.png'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: border,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: asset != null
            ? Image.asset(
                asset,
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                width: radius,
                height: radius,
                fit: BoxFit.cover,
                imageUrl: url ?? '',
                placeholder: (context, url) => Container(
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  errorAsset,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
