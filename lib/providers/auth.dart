import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:mbw204_club_ina/helpers/show_snackbar.dart';
import 'package:mbw204_club_ina/views/screens/auth/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
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
enum ResendOtpStatus { idle, loading, loaded, error, empty } 
enum VerifyOtpStatus { idle, loading, loaded, error, empty }
enum ApplyChangeEmailOtpStatus { idle, loading, loaded, error, empty }

abstract class BaseAuth {
  Future register(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey, UserData userData, String userType);
  Future login(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey, UserData userData);
  Future resendOtp(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey, String email);
  Future verifyOtp(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey);
  Future applyChangeEmailOtp(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey);
  Future forgotPassword(BuildContext context, UserData userData);
  Future<InquiryRegisterModel> verify(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey, String token, UserModel user);
  InquiryRegisterModel inquiryRegisterModel;
  Future logout();
  Future authDisbursement(BuildContext context, String password);
  bool isLoggedIn();
}

class AuthProvider with ChangeNotifier implements BaseAuth {
  final AuthRepo authRepo;
  final SharedPreferences sharedPreferences;
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "${AppConstants.BASE_URL}",
      receiveDataWhenStatusError: true,
      connectTimeout: 10 * 1000, // 10 seconds
      receiveTimeout: 10 * 1000 // 10 seconds
    )
  );
  AuthProvider({
    @required this.authRepo,
    this.sharedPreferences  
  });

  bool changeEmail = true;
  String otp;
  String whenCompleteCountdown = "start";
  String changeEmailName = "";
  String emailCustom = "";

  CountDownController countDownController = CountDownController();
  TextEditingController otpTextController = TextEditingController();

  SearchBarController<dynamic> searchBarProvinsi;

  LoginStatus _loginStatus = LoginStatus.idle;
  LoginStatus get loginStatus => _loginStatus;

  RegisterStatus _registerStatus = RegisterStatus.idle;
  RegisterStatus get registerStatus => _registerStatus;

  ForgotPasswordStatus _forgotPasswordStatus = ForgotPasswordStatus.idle;
  ForgotPasswordStatus get forgotPasswordStatus => _forgotPasswordStatus;

  AuthDisbursementStatus _authDisbursementStatus = AuthDisbursementStatus.idle;
  AuthDisbursementStatus get authDisbursementStatus => _authDisbursementStatus;

  VerifyOtpStatus _verifyOtpStatus = VerifyOtpStatus.idle;
  VerifyOtpStatus get verifyOtpStatus => _verifyOtpStatus;

  ResendOtpStatus _resendOtpStatus = ResendOtpStatus.idle;
  ResendOtpStatus get resendOtpStatus => _resendOtpStatus;

  ApplyChangeEmailOtpStatus _applyChangeEmailOtpStatus = ApplyChangeEmailOtpStatus.idle;
  ApplyChangeEmailOtpStatus get applyChangeEmailOtpStatus => _applyChangeEmailOtpStatus;

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

  void setVerifyOtpStatus(VerifyOtpStatus verifyOtpStatus) {
    _verifyOtpStatus = verifyOtpStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setResendOtpStatus(ResendOtpStatus resendOtpStatus) {
    _resendOtpStatus = resendOtpStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus applyChangeEmailOtpStatus) {
    _applyChangeEmailOtpStatus = applyChangeEmailOtpStatus;
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
  Future<InquiryRegisterModel> verify(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey, String token, UserModel user) async {
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
        if(e?.response?.data['code'] == 404 && user.body.user.status == "enabled" && user.body.user.emailActivated) {
          ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 15),
              backgroundColor: ColorResources.SUCCESS,
              content: Text(getTranslated("SUCCESSFUL_LOGIN", context),
                style: poppinsRegular,
              )
            )
          );
          writeData(user);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashBoardScreen()));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OtpScreen()));
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
  Future login(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey, UserData userData) async {
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
      InquiryRegisterModel inquiryRegisterModel = await verify(context, globalKey, user.body.token, user);
      if(inquiryRegisterModel?.code == 0) {
        prefs.setString("pay_register_token", json.decode(res.data)['body']['token']);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifyScreen(
          accountName: inquiryRegisterModel.body.data.accountName,
          accountNumber: inquiryRegisterModel.body.accountNumber2,
          bankFee: inquiryRegisterModel.body.data.bankFee,
          transactionId: inquiryRegisterModel.body.transactionId,
          productId: inquiryRegisterModel.body.productId,
          productPrice: inquiryRegisterModel.body.productPrice,
        )));
      } else {
        if(user.body.user.status == "enabled" && user.body.user.emailActivated) {
          ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
            SnackBar(
              backgroundColor: ColorResources.SUCCESS,
              content: Text(getTranslated("SUCCESSFUL_LOGIN", context),
                style: poppinsRegular,
              )
            )
          );
          writeData(user);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashBoardScreen()));
        } else {
          prefs.setString("email_otp", user.body.user.emailAddress);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OtpScreen()));
        }
      }
      setStateLoginStatus(LoginStatus.loaded);
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      if(e?.type == DioErrorType.CONNECT_TIMEOUT) {
        setStateLoginStatus(LoginStatus.error);
        throw ConnectionTimeoutException("CONNECTION_TIMEOUT");
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
      print(e);
      setStateLoginStatus(LoginStatus.error);
    }
  }

  @override
  Future register(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey, UserData userData, String userType) async {
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
        "vehicle_reg_number": userData.vehilceRegNumber,
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
      InquiryRegisterModel inquiryRegisterModel = await verify(context, globalKey, json.decode(res.data)['body']['token'], user);
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
        if(user.body.user.status == "enabled" && user.body.user.emailActivated) {
          ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
            SnackBar(
              backgroundColor: ColorResources.SUCCESS,
              content: Text(getTranslated("SUCCESSFUL_REGISTER", context),
                style: poppinsRegular,
              )
            )
          );
          writeData(user);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashBoardScreen()));
        } else {
          prefs.setString("email_otp", user.body.user.emailAddress);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OtpScreen()));
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

  Future verifyOtp(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey) async {
    if(otp == null) {
      ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: ColorResources.ERROR,
          content: Text("Mohon Masukan OTP Anda",
            style: poppinsRegular,
          )
        )
      );
      return;
    }
    setVerifyOtpStatus(VerifyOtpStatus.loading);
    try {
      await dio.post("${AppConstants.BASE_URL}/user-service/verify-otp",
        data: {
          "otp": otp,
          "email": changeEmailName
        }
      );
      ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 15),
          backgroundColor: ColorResources.SUCCESS,
          content: Text("Akun Alamat E-mail $changeEmailName Anda sudah aktif, silahkan Login",
            style: poppinsRegular,
          )
        )
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => SignInScreen())
      ); 
      setVerifyOtpStatus(VerifyOtpStatus.loaded);
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      if(e?.response?.statusCode == 400) {
        ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 10),
            backgroundColor: ColorResources.ERROR,
            content: Text(json.decode(e?.response?.data)["error"],
              style: poppinsRegular,
            )
          )
        );
      }
      setVerifyOtpStatus(VerifyOtpStatus.error);
    } catch(e) {
      print(e);
      setVerifyOtpStatus(VerifyOtpStatus.error);
    }
  }

  Future resendOtp(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey, String email) async {
    setResendOtpStatus(ResendOtpStatus.loading);
    try {
      await dio.post("${AppConstants.BASE_URL}/user-service/resend-otp",
        data: {
          "email": email
        }
      );
      ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 15),
          backgroundColor: ColorResources.SUCCESS,
          content: Text("Silahkan periksa Alamat E-mail $email Anda, untuk melihat kode OTP yang tercantum",
            style: poppinsRegular,
          )
        )
      );
      setResendOtpStatus(ResendOtpStatus.loaded);
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      setResendOtpStatus(ResendOtpStatus.error);
    } catch(e) {
      print(e);
      setResendOtpStatus(ResendOtpStatus.error);
    }
  }

  Future applyChangeEmailOtp(BuildContext context,  GlobalKey<ScaffoldMessengerState> globalKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    changeEmailName = prefs.getString("email_otp");
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(changeEmailName); 
    if(!emailValid) {
      ShowSnackbar.snackbar(context, "Ex : customcare@connexist.com", "", ColorResources.ERROR);
      return;
    } else {
      if(emailCustom.trim().isNotEmpty) {
        changeEmailName = emailCustom;
      }
      notifyListeners();
    }
    try {
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.loading);
      await dio.post("${AppConstants.BASE_URL}/user-service/change-email", data: {
        "old_email": prefs.getString("email_otp"),
        "new_email": changeEmailName
      });
      prefs.setString("email_otp", changeEmailName);
      ShowSnackbar.snackbar(context, getTranslated("UPDATE_CHANGE_EMAIL_SUCCESSFUL", context), "", ColorResources.SUCCESS);
      changeEmail = true;
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.loaded);
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      ShowSnackbar.snackbar(context, json.decode(e?.response?.data)["error"], "", ColorResources.ERROR);
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.error);
    } catch(e) {
      print(e);
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.error);
    }
  }

  void cleanText() {
    otpTextController.text = "";
    notifyListeners();
  }

  Future resendOtpCall(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey) async {
    try {
      whenCompleteCountdown = "start";
      notifyListeners();
      await resendOtp(context, globalKey, changeEmailName);
    } catch(e) {
      print(e);
    }
  }

  void cancelCustomEmail() {
    changeEmail = true;
    notifyListeners();
  }

  void applyCustomEmail(BuildContext context) {
    changeEmail = true;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailCustom); 
    if(!emailValid) {
      ShowSnackbar.snackbar(context, "Ex : customcare@connexist.com", "", ColorResources.ERROR);
      return;
    } else {
      changeEmailName = emailCustom;
    }
    notifyListeners();
  }

  void changeEmailCustom() {
    changeEmail = !changeEmail;
    notifyListeners();
  }

  void emailCustomChange(String val) {
    emailCustom = val;
    notifyListeners();
  } 

  void completeCountDown() {
    whenCompleteCountdown = "completed";
    notifyListeners();
  }

  void otpCompleted(v) {
    otp = v;
    notifyListeners();
  } 
 
}