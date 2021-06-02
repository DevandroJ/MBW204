import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/repository/media.dart';

class MediaProvider extends ChangeNotifier {
  final MediaRepo mediaRepo;
  MediaProvider({@required this.mediaRepo});

  Future postMedia(BuildContext context, File file) async {
    try {
      Response res = await mediaRepo.postMedia(context, file);
      return res;
    } catch(e) {
      print(e);
    }
  }

}
