import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/screens/auth/widgets/verify.dart';
import 'package:mbw204_club_ina/data/models/ppob/register/inquiry.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/views/screens/dashboard/dashboard.dart';
import 'package:mbw204_club_ina/data/models/user.dart';
import 'package:mbw204_club_ina/data/repository/auth.dart';
import 'package:mbw204_club_ina/utils/constant.dart';

enum AuthDisbursementStatus { loading, loaded, error, idle } 
enum RegisterStatus { loading, loaded, error, idle }
enum ForgotPasswordStatus { loading, loaded, error, idle }
enum LoginStatus { loading, loaded, error, idle }

abstract class BaseAuth {
  Future register(BuildContext context, UserData userData, String userType);
  Future login(BuildContext context, UserData userData);
  Future forgotPassword(BuildContext context, UserData userData);
  Future<InquiryRegisterModel> verify(BuildContext context, String token, UserModel user);
  InquiryRegisterModel inquiryRegisterModel;
  Future logout();
  Future authDisbursement(BuildContext context, String password);
  bool isLoggedIn();
}

class AuthProvider with ChangeNotifier implements BaseAuth {
  final AuthRepo authRepo;
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "${AppConstants.BASE_URL}",
      receiveDataWhenStatusError: true,
      connectTimeout: 10 * 1000, // 10 seconds
      receiveTimeout: 10 * 1000 // 10 seconds
    )
  );
  AuthProvider({@required this.authRepo});

  SearchBarController<dynamic> searchBarProvinsi;

  LoginStatus _loginStatus = LoginStatus.idle;
  LoginStatus get loginStatus => _loginStatus;

  RegisterStatus _registerStatus = RegisterStatus.idle;
  RegisterStatus get registerStatus => _registerStatus;

  ForgotPasswordStatus _forgotPasswordStatus = ForgotPasswordStatus.idle;
  ForgotPasswordStatus get forgotPasswordStatus => _forgotPasswordStatus;

  AuthDisbursementStatus _authDisbursementStatus = AuthDisbursementStatus.idle;
  AuthDisbursementStatus get authDisbursementStatus => _authDisbursementStatus;

  void setStateLoginStatus(LoginStatus loginStatus) {
    _loginStatus = loginStatus;
    Future.delayed(Duration.zero, () =>  notifyListeners());
  }

  void setStateRegisterStatus(RegisterStatus registerStatus) {
    _registerStatus = registerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateForgotPasswordStatus(ForgotPasswordStatus forgotPasswordStatus) {
    _forgotPasswordStatus = forgotPasswordStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateAuthDisbursement(AuthDisbursementStatus authDisbursementStatus) {
    _authDisbursementStatus = authDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  InquiryRegisterModel inquiryRegisterModel;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  updateSelectedIndex(int index){
    _selectedIndex = index;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  void writeData(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", user.body.token);
    prefs.setString("refreshToken", user.body.refreshToken);
    prefs.setString("created", user.body.user.created.toString());
    prefs.setBool("emailActivated", user.body.user.emailActivated);
    prefs.setString("emailAddress", user.body.user.emailAddress);
    prefs.setBool("phoneActivated", user.body.user.phoneActivated);
    prefs.setString("phoneNumber", user.body.user.phoneNumber);
    prefs.setString("role", user.body.user.role);
    prefs.setString("status", user.body.user.status);
    prefs.setString("userId", user.body.user.userId);
    prefs.setString("userName", user.body.user.username);
    prefs.setString("userType", user.body.user.userType);
  }

  void deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("refreshToken");
    prefs.remove("created");
    prefs.remove("emailActivated");
    prefs.remove("emailAddress");
    prefs.remove("phoneActivated");
    prefs.remove("phoneNumber");
    prefs.remove("role");
    prefs.remove("status");
    prefs.remove("userId");
    prefs.remove("userName");
    prefs.remove("userType");
  }

  @override
  Future logout() {
    deleteData();
    return Future.value(true);
  }

  @override 
  Future<InquiryRegisterModel> verify(BuildContext context, String token, UserModel user) async {
    var productId;
    if(user.body.user.role == "lead") {
      productId = "48dc000f-07fb-4b7a-940d-1029ec604bf8"; // 200 K
    } else {
      productId = "8b02a294-5245-4abd-973e-990a6c2095c0"; // 100 K
    }
    try {
      Response res = await dio.post("${AppConstants.BASE_URL_PPOB}/registration/inquiry", data: {
        "productId" : productId
      }, options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "X-Context-ID": AppConstants.X_CONTEXT_ID
        }
      ));
      InquiryRegisterModel inquiryRegisterModel = InquiryRegisterModel.fromJson(res.data); 
      return inquiryRegisterModel;  
    } on DioError catch(e) {
      if(e?.response?.data != null) {
        if(e?.response?.data['code'] == 404 && user.body.user.status == "pending") {
          showAnimatedDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                    textAlign: TextAlign.center,
                    style: poppinsRegular
                  ),
                ),
              );
            },
            animationType: DialogTransitionType.scale,
            curve: Curves.fastOutSlowIn,
            duration: Duration(seconds: 2),
          );
        }
        if(e?.response?.data['code'] == 404 && user.body.user.status == "enabled") {
          showAnimatedDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Center(
                child: Container(
                  color: ColorResources.WHITE,
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.check,
                    size: 18.0,
                    color: ColorResources.GREEN,
                  ),
                ),
              );
            },
            animationType: DialogTransitionType.scale,
            curve: Curves.fastOutSlowIn,
            duration: Duration(seconds: 2),
          );
          writeData(user);
          Future.delayed(Duration(seconds: 1), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashBoardScreen())));
        } 
      }
    } catch(e) {
      showAnimatedDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              alignment: Alignment.center,
              height: 60.0,
              child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                textAlign: TextAlign.center,
                style: poppinsRegular
              ),
            ),
          );
        },
        animationType: DialogTransitionType.scale,
        curve: Curves.fastOutSlowIn,
        duration: Duration(seconds: 2),
      );
    }
    return inquiryRegisterModel;
  }

  @override
  Future login(BuildContext context, UserData userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setStateLoginStatus(LoginStatus.loading);
      Response res = await dio.post("${AppConstants.BASE_URL}/user-service/login",
        data: {
          "phone_number": userData.phoneNumber, 
          "password": userData.password
        }
      );   
      UserModel user = UserModel.fromJson(json.decode(res.data));
      InquiryRegisterModel inquiryRegisterModel = await verify(context, user.body.token, user);
      if(inquiryRegisterModel?.code == 0) {
        prefs.setString("pay_register_token", json.decode(res.data)['body']['token']);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifyScreen(
            accountName: inquiryRegisterModel.body.data.accountName,
            accountNumber: inquiryRegisterModel.body.accountNumber2,
            bankFee: inquiryRegisterModel.body.data.bankFee,
            transactionId: inquiryRegisterModel.body.transactionId,
            productId: inquiryRegisterModel.body.productId,
            productPrice: inquiryRegisterModel.body.productPrice,
          )));
        });
      } else {
        if(user.body.user.status == "enabled") {
          showAnimatedDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Center(
                child: Container(
                  color: ColorResources.WHITE,
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.check,
                    size: 18.0,
                    color: ColorResources.GREEN,
                  ),
                ),
              );
            },
            animationType: DialogTransitionType.scale,
            curve: Curves.fastOutSlowIn,
            duration: Duration(seconds: 2),
          );
        }
      writeData(user);
      Future.delayed(Duration(seconds: 1), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashBoardScreen())));
    }
      setStateLoginStatus(LoginStatus.loaded);
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      if(e?.type == DioErrorType.CONNECT_TIMEOUT) {
        setStateLoginStatus(LoginStatus.error);
        throw CustomException("CONNECTION_TIMEOUT");
      }
      if(e?.response?.statusCode == 500) {
        setStateLoginStatus(LoginStatus.error);
        throw json.decode(e.response.data);
      }
      if(e?.response?.statusCode == 400) {
        setStateLoginStatus(LoginStatus.error);
        throw CustomException(json.decode(e?.response?.data)['error']);
      }
      setStateLoginStatus(LoginStatus.error);
    } catch (e) {
      setStateLoginStatus(LoginStatus.error);
      print(e);
    }
  }

  @override
  Future register(BuildContext context, UserData userData, String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Object data = {};
    if(userType == "user") {
      data = {
        "user_fullname": userData.fullname,
        "phone_number": userData.phoneNumber,
        "email_address": userData.emailAddress,
        "password": userData.password,
        "id_member": userData.noMember,
        "chapter": userData.chapter == "01" 
        ? "Jakarta" 
        : userData.chapter == "02" 
        ? "Bandung" 
        : userData.chapter == "03" 
        ? "Tangerang" 
        : userData.chapter == "04" 
        ? "Surabaya" 
        : "-",
        "code_chapter": userData.chapter,
        "sub_modal": userData.subModel,
        "body_style": userData.bodyStyle,
        "role": "user",
        "user_type": "generic"
      };
    } else if(userType == "relatives") {
      data = {
        "user_fullname": userData.fullname,
        "phone_number": userData.phoneNumber,
        "email_address": userData.emailAddress,
        "password": userData.password,
        "referral_code": userData.codeReferfall,
        "role": "user",
        "user_type": "generic"
      };
    } else if(userType == "partnership") {
      data = {   
        "user_fullname" : userData.fullname,
        "phone_number" : userData.phoneNumber,
        "email_address" : userData.emailAddress,
        "password" : userData.password,
        "no_ktp" : userData.noKtp,
        "company_name": userData.companyName,
        "role": "user",
        "user_type": "generic"
      };
    } 
    
    try {
      setStateRegisterStatus(RegisterStatus.loading);
      Response res = await dio.post("${AppConstants.BASE_URL}/user-service/$userType/register",
        data: data
      );
      UserModel user = UserModel.fromJson(json.decode(res.data));
      InquiryRegisterModel inquiryRegisterModel = await verify(context, json.decode(res.data)['body']['token'], user);
      if(inquiryRegisterModel?.code == 0) {
        prefs.setString("pay_register_token", json.decode(res.data)['body']['token']);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifyScreen(
            accountName: inquiryRegisterModel.body.data.accountName,
            accountNumber: inquiryRegisterModel.body.accountNumber2,
            transactionId: inquiryRegisterModel.body.transactionId,
            productId: inquiryRegisterModel.body.productId,
            productPrice: inquiryRegisterModel.body.productPrice,
          )));
        });
      } else {
        if(user.body.user.status == "enabled") {
          showAnimatedDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Center(
                child: Container(
                  color: ColorResources.WHITE,
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.check,
                    size: 18.0,
                    color: ColorResources.GREEN,
                  ),
                ),
              );
            },
            animationType: DialogTransitionType.scale,
            curve: Curves.fastOutSlowIn,
            duration: Duration(seconds: 2),
          );
          writeData(user);
          Future.delayed(Duration(seconds: 1), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashBoardScreen())));
        }
      }
      setStateRegisterStatus(RegisterStatus.loaded);
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      if(e?.type == DioErrorType.CONNECT_TIMEOUT) {
        setStateRegisterStatus(RegisterStatus.error);
        throw CustomException("CONNECTION_TIMEOUT");
      }
      if(e?.response?.statusCode == 500) {
        setStateRegisterStatus(RegisterStatus.error);
        throw json.decode(e.response.data);
      }
      if(e?.response?.statusCode == 400) {
        setStateRegisterStatus(RegisterStatus.error);
        throw CustomException(json.decode(e?.response?.data)['error']);
      }
      setStateRegisterStatus(RegisterStatus.error);
    } catch(e) {
      setStateRegisterStatus(RegisterStatus.error);
      print(e);
    }
  }

  @override 
  Future authDisbursement(BuildContext context, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setStateAuthDisbursement(AuthDisbursementStatus.loading);
    try {
      Response res = await dio.post("${AppConstants.BASE_URL}/user-service/authentication-disburse", data: {
        "password": password
      }, options: Options(
        headers: {
          "Authorization": "Bearer ${prefs.getString("token")}"
        }
      ));
      setStateAuthDisbursement(AuthDisbursementStatus.loaded);
      return res.statusCode;
    } on DioError catch(e) {
      setStateAuthDisbursement(AuthDisbursementStatus.error);
      print(e?.response?.data);
      print(e?.response?.statusCode);
      if(e?.response?.statusCode == 400) {
        throw CustomException(json.decode(e.response.data)["error"]);
      }
    } catch(e) {
      setStateAuthDisbursement(AuthDisbursementStatus.error);
      print(e);
    }
  }

  @override 
  Future forgotPassword(BuildContext context, UserData userData) async {
    setStateForgotPasswordStatus(ForgotPasswordStatus.loading);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await dio.post("${AppConstants.BASE_URL}/user-service/change-password", data: {
        "old_password": userData.password,
        "new_password": userData.passwordNew,
        "confirm_new_password": userData.passwordConfirm
      }, options: Options(
        headers: {
          "Authorization": "Bearer ${prefs.getString("token")}" 
        }
      ));
      setStateForgotPasswordStatus(ForgotPasswordStatus.loaded);
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      if(e?.response?.statusCode == 400) {
        setStateForgotPasswordStatus(ForgotPasswordStatus.error);
        throw new ServerErrorException(json.decode(e?.response?.data)["error"]);
      }
    } catch(e) {
      print(e);
    }
  }
 
}