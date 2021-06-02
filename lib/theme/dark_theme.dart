import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Titilium',
  primaryColor: Colors.white,
  brightness: Brightness.dark,
  accentColor: Color(0xFF252525),
  hintColor: Color(0xFFc7c7c7),
  pageTransitionsTheme: PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    },
  )
);
