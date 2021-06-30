import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/single_user.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/data/models/profile.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';

class ProfileRepo {
  final SharedPreferences sharedPreferences;
  ProfileRepo({@required this.sharedPreferences});

  ProfileData profileData;
  SingleUserData singleUserData;

  Future<SingleUserData> getUserSingleData(BuildContext context, String userId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/user-service/users/$userId");
      SingleUserModel singleUserModel = SingleUserModel.fromJson(json.decode(res.data));
      singleUserData = singleUserModel.body;
    } on DioError catch(_) {
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
    return singleUserData;
  }

  Future<ProfileData> getUserProfile(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/user-service/profile/${sharedPreferences.get("userId")}");
      ProfileModel profileModel = ProfileModel.fromJson(json.decode(res.data));
      List<ProfileData> _profileData = profileModel.profileData;
      profileData = _profileData[0];
    } catch(e) {
      print(e);
    } 
    return profileData;
  }

  Future updateProfile(BuildContext context, ProfileData profileData) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.put("${AppConstants.BASE_URL}/user-service/profile/${sharedPreferences.get("userId")}",
        data: {
          "address" : profileData.address ?? "",
          "fullname" : profileData.fullname ?? "",
          "gender" : profileData.gender ?? "",
          "profile_pic": profileData.profilePic ?? "",
          // "id_card_number": profileData.idCardNumber ?? "",
          "short_bio": profileData.shortBio ?? "",
        } 
      );
      return res;
    } catch(e) {
      print(e);
    }
  }

  String get getUserName => sharedPreferences.getString("userName") ?? "-";
  
  String get getUserEmail => sharedPreferences.getString("emailAddress") ?? "-";

  String get getUserPhoneNumber => sharedPreferences.getString("phoneNumber") ?? "-";

  String get getSingleUserPhoneNumber => singleUserData?.phoneNumber ?? "-";

  String get getUserId => sharedPreferences.getString("userId") ?? null;

  String get getUserRole => sharedPreferences.getString("role") ?? null;

  String get getUserFullname => profileData?.fullname ?? "-";

  String get getUserChapter => profileData?.chapter ?? "-";

  String get getUserSubModel => profileData?.subModel ?? "-";

  String get getUserNoKtp => profileData?.noKtp ?? "-";

  String get getUserCompany => profileData?.companyName ?? "-";

  String get getUserBodyStyle => profileData?.bodyStyle ?? "-";

  String get getUserCodeReferral => profileData?.referralCode ?? "-";
  
  String get getSingleUserFullname => singleUserData?.fullname ?? "-";

  String get getUserAddress => profileData?.address ?? "-";

  String get getUserGender => profileData?.gender ?? "-";

  String get getUserIdMember => profileData?.idMember ?? "-";

  String get getUserShortBio => profileData?.shortBio ?? "-";

  String get getUserProfilePic => profileData?.profilePic ?? null;
  
  String get getSingleUserProfilePic => singleUserData?.profilePic ?? null;

}
