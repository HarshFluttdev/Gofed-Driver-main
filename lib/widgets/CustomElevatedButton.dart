import 'package:flutter/material.dart';

CustomElevatedButton({
  BuildContext context,
  Widget child,
  Function onPressed,
  bool buttonClicked = false,
}) {
  return Container(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      child: buttonClicked
          ? Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
                strokeWidth: 2,
              ),
            )
          : child,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(150),
        ),
      ),
    ),
  );
}
