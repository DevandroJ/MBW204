import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
import 'package:mbw204_club_ina/utils/constant.dart';

class DioManager {
  static final shared = DioManager();

  Future<Dio> getClient(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    };
    dio.options.baseUrl = AppConstants.BASE_URL;
    dio.options.headers = {
      "X-Context-ID": AppConstants.X_CONTEXT_ID
    };
    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) {
        options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
        return options;
      },
      onResponse: (Response response) {
        return response;
      },
      onError: (DioError e) async {
        bool isTokenExpired = JwtDecoder.isExpired(prefs.getString('token'));
        if(isTokenExpired) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignInScreen()), (Route<dynamic> route) => false);
        }
      }
    ));
    return dio;  
  }

}