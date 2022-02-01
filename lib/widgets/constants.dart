import 'package:flutter/material.dart';

const Color primaryColor = Color(0xff6E67F6);
const Color lightPrimaryColor = Color(0xFF9ee0c9);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color labelColor = Color(0xFF515151);
const double defaultPadding = 10.0;

var globalRideFunction;
BuildContext globalHomeContext;

///App Theme
ThemeData themeData = ThemeData.light().copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundColor,
    accentColor: primaryColor,
    tabBarTheme: ktabBarTheme,
    bottomNavigationBarTheme: kBottomNavBarTheme,
    appBarTheme: kappBarTheme);

///App AppBarTheme
AppBarTheme kappBarTheme = AppBarTheme(
    elevation: 0.0,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black));

///App TabBarTheme
TabBarTheme ktabBarTheme = TabBarTheme(
    indicator: BoxDecoration(
        color: Colors.transparent,
        border: Border(bottom: BorderSide(color: primaryColor, width: 0.8))),
    unselectedLabelColor: Colors.grey,
    labelColor: primaryColor,
    indicatorSize: TabBarIndicatorSize.label);

BottomNavigationBarThemeData kBottomNavBarTheme = BottomNavigationBarThemeData(
  showSelectedLabels: false,
  showUnselectedLabels: false,
  backgroundColor: primaryColor,
  selectedItemColor: Colors.white,
  unselectedItemColor: Colors.white70,
  elevation: 5.0,
  type: BottomNavigationBarType.fixed,
);
Text appBarTitle({BuildContext context, String text}) {
  return Text(
    "$text",
    style: Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
  );
}
