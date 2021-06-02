import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;
  AuthRepo({@required this.sharedPreferences});

  String getUserToken() {
    return sharedPreferences.getString("token") ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey("token");
  }
}
