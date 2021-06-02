import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/localization/app_localization.dart';

String getTranslated(String key, BuildContext context) {
  return AppLocalization.of(context).translate(key);
}