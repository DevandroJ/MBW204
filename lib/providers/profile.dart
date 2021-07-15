import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/data/models/single_user.dart';
import 'package:mbw204_club_ina/providers/media.dart';
import 'package:mbw204_club_ina/data/models/profile.dart';
import 'package:mbw204_club_ina/data/repository/profile.dart';

enum ProfileStatus { idle, loading, loaded, error }
enum UpdateProfileStatus { idle, loading, loaded, error }
enum SingleUserDataStatus { idle, loading, loaded, error } 

class ProfileProvider extends ChangeNotifier {
  final ProfileRepo profileRepo;
  ProfileProvider({@required this.profileRepo});

  ProfileStatus _profileStatus = ProfileStatus.loading;
  ProfileStatus get profileStatus => _profileStatus;

  UpdateProfileStatus _updateProfileStatus = UpdateProfileStatus.idle;
  UpdateProfileStatus get updateProfileStatus => _updateProfileStatus;

  SingleUserDataStatus _singleUserDataStatus = SingleUserDataStatus.idle;
  SingleUserDataStatus get singleUserDataStatus => _singleUserDataStatus;
  
  ProfileData _userProfile;
  ProfileData get userProfile => _userProfile;

  SingleUserData _singleUserData;
  SingleUserData get singleUserData => _singleUserData;

  void setStateProfileStatus(ProfileStatus profileStatus) {
    _profileStatus = profileStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateUpdateProfileStatus(UpdateProfileStatus updateProfileStatus) {
    _updateProfileStatus = updateProfileStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSingleUserDataStatus(SingleUserDataStatus singleUserDataStatus) {
    _singleUserDataStatus = singleUserDataStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void getSingleUser(BuildContext context, String userId) async {
    try {
      setStateSingleUserDataStatus(SingleUserDataStatus.loading);
      SingleUserData singleUserData = await profileRepo.getUserSingleData(context, userId);
      _singleUserData = singleUserData;
      setStateSingleUserDataStatus(SingleUserDataStatus.loaded);
    } on ServerErrorException catch(_) {
      setStateSingleUserDataStatus(SingleUserDataStatus.error);
    } catch(e) {
      setStateSingleUserDataStatus(SingleUserDataStatus.error);
      print(e);
    }
  }
  
  void getUserProfile(BuildContext context) async {
    try {
      ProfileData profileData = await profileRepo.getUserProfile(context);
      _userProfile = profileData;
      setStateProfileStatus(ProfileStatus.loaded);
    } on ServerErrorException catch (_) {
      setStateProfileStatus(ProfileStatus.error);
    } catch(e) {
      print(e);
    }
  }

  Future updateProfile(BuildContext context, ProfileData profileData, File file) async {
    try {
      setStateUpdateProfileStatus(UpdateProfileStatus.loading);
      if(file != null) {
        Response res = await Provider.of<MediaProvider>(context, listen: false).postMedia(context, file);
        Map map = json.decode(res.data);
        profileData.profilePic = map['body']['path'];
      }
      await profileRepo.updateProfile(context, profileData);
      getUserProfile(context);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
      setStateUpdateProfileStatus(UpdateProfileStatus.loaded);
      Fluttertoast.showToast(
        msg: "Ubah Profil berhasil",
        backgroundColor: ColorResources.SUCCESS
      );
    } catch(e) {
      setStateUpdateProfileStatus(UpdateProfileStatus.error);
      notifyListeners();
      print(e);
    }
  }

  String get getUserProfilePic => profileRepo?.getUserProfilePic ?? "-";

  String get getSingleUserProfilePic => profileRepo?.getSingleUserProfilePic ?? "-";
  
  String get getUserId => profileRepo?.getUserId ?? "-";

  String get getUserRole => profileRepo?.getUserRole ?? "-";
  
  String get getUserName => profileRepo?.getUserName ?? "-";

  String get getUserChapter => profileRepo?.getUserChapter ?? "-";

  String get getUserFullname => profileRepo?.getUserFullname ?? "-";

  String get getUserSubModel => profileRepo?.getUserSubModel ?? "-";

  String get getUserBodyStyle => profileRepo?.getUserBodyStyle ?? "-";

  String get getSingleUserFullname => profileRepo?.getSingleUserFullname ?? "-";
  
  String get getUserIdNumber => profileRepo?.getUserIdMember ?? "-";

  String get getUserCodeReferral => profileRepo?.getUserCodeReferral ?? "-";

  String get getUserReferralBy => profileRepo?.getUserReferralBy ?? "-";

  String get getUserNoKtp => profileRepo?.getUserNoKtp ?? "-";

  String get getUserCompany => profileRepo?.getUserCompany ?? "-";
  
  String get getUserEmail => profileRepo?.getUserEmail ?? "-";
 
  String get getUserAddress => profileRepo?.getUserAddress ?? "-";
  
  String get getUserPhoneNumber => profileRepo?.getUserPhoneNumber ?? "-";
  
  String get getSingleUserPhoneNumber => profileRepo?.getSingleUserPhoneNumber ?? "-"; 
  
}
