import 'dart:async';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  Location._();
  static Future checkGps(BuildContext context) async {
    if(!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {       
        showDialog(
          barrierDismissible: false,
          context: context, 
          builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
          title: Text("Tidak bisa mendapatkan lokasi sekarang"),
          content: Text("Pastikan kamu telah mengaktifkan GPS"),
          actions: [
            FlatButton(
              child: Text('Aktifkan'),
                onPressed: () {
                  AndroidIntent intent = AndroidIntent(
                    action: "android.settings.LOCATION_SOURCE_SETTINGS"
                  );
                  intent.launch();
                }
              )
            ],
          ))
        );
      }
    }
  }
}