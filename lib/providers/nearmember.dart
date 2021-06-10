import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NearMemberProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  NearMemberProvider({
    this.sharedPreferences
  });

  Future getNearMember(BuildContext context) async {
    try {
      
    } catch(e) {
      print(e);
    }
  }

}