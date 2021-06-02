import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'Titilium',
  primaryColor: Color(0xffAF162B),
  brightness: Brightness.light,
  accentColor: Colors.white,
  hintColor: Color(0xFF9E9E9E),
  pageTransitionsTheme: PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    },
  )
);