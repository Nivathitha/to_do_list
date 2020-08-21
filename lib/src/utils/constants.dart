import 'package:flutter/material.dart';

class Constants {
  static Color teal = Color(0xff26a69a);
  static Color lightBlue = Color(0xff6A748B);
  static Color lightGrey = Color(0xffF5F5F5);
  static Color white = Color(0xfffafafa);
  static Color black = Color(0xff212121);
  static Color lightTeal = Color(0xff00bfa5);
  static Color darkTeal = Color(0xff00838f);

  static double backButtonSize = 22;
  static double logoutButtonSize = 20;
  static double actionButtonBorderRadius = 8;

  static ThemeData themePrimary = ThemeData(
      fontFamily: 'Baloo Tamma 2',
      brightness: Brightness.light,
      primaryColor: teal,
      accentColor: teal,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          //TextFeild title
          color: black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        bodyText2: TextStyle(
          //TextFeild Description
          color: lightBlue,
          fontSize: 15.0,
          fontStyle: FontStyle.italic,
        ),
        headline4: TextStyle(
          //No Tasks text
          color: black,
          fontWeight: FontWeight.bold,
        ),
        button: TextStyle(
          //No Tasks text
          color: lightGrey,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ));
}

class AssetUrls {
  static String listSvg = 'assets/svgicons/list.svg';
  static String editSvg = 'assets/svgicons/edit.svg';
  static String updateSvg = 'assets/svgicons/pencil.svg';
}
