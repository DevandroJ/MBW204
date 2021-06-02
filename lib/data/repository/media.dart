import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';

class MediaRepo {
  Response response;
  
  Future<Response> postMedia(BuildContext context, File file) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: basename(file.path)),
      });
      Response res = await dio.post("${AppConstants.BASE_URL}/media-service/upload", data: formData);
      response = res;
    } on DioError catch(err) {
      throw Exception((err.response.statusCode));
    } catch(err) {
      print(err);
    }
    return response;
  }
  
}