import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';

class OtpScreen extends StatefulWidget {

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();

  void initState() {
    super.initState();
    (() async {
      loading = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        Provider.of<AuthProvider>(context, listen: false).changeEmailName = prefs.getString("email_otp"); 
        loading = false;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: ColorResources.BG_GREY,
      body: Consumer<AuthProvider>(
        builder: (BuildContext context, AuthProvider authProvider, Widget child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Verifikasi Alamat E-mail',
                    style: poppinsRegular.copyWith(
                      fontWeight: FontWeight.bold, 
                      fontSize: 10.sp
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                  child: RichText(
                    text: TextSpan(
                      text: "Mohon masukkan 4 digit kode telah dikirim ke Alamat E-mail ",
                      children: [
                        TextSpan(
                          text: loading ? "..." : authProvider.changeEmailName ?? "-",
                          style: poppinsRegular.copyWith(
                            color: ColorResources.BLACK,
                            fontWeight: FontWeight.bold,
                            fontSize: 9.0.sp
                          )
                        ),
                      ],
                      style: poppinsRegular.copyWith(
                        color: Colors.black54, 
                        fontSize: 9.0.sp
                      )
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20.0
                ),
                authProvider.changeEmail ? Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
                    child: PinCodeTextField(
                      appContext: context,
                      backgroundColor: Colors.transparent,
                      pastedTextStyle: poppinsRegular.copyWith(
                        color: ColorResources.SUCCESS,
                        fontSize: 9.0.sp
                      ),
                      textStyle: poppinsRegular,
                      length: 4,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        inactiveColor: ColorResources.BLUE_GREY,
                        inactiveFillColor: ColorResources.WHITE,
                        selectedFillColor: ColorResources.WHITE,
                        activeFillColor: ColorResources.WHITE,
                        selectedColor: Colors.transparent,
                        activeColor: ColorResources.BTN_PRIMARY,
                        borderWidth: 1.5,
                        fieldHeight: 50.0,
                        fieldWidth: 50.0,
                      ),
                      cursorColor: ColorResources.BTN_PRIMARY,
                      animationDuration: Duration(milliseconds: 100),
                      enableActiveFill: true,
                      keyboardType: TextInputType.text,
                      onCompleted: (v) {
                        authProvider.otpCompleted(v);
                      },
                      onChanged: (value) {

                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                    )
                  ),
                ) : Container(),
                
                authProvider.changeEmail 
                ? Container() 
                : Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextFormField(
                    onChanged: (val) {
                      authProvider.emailCustomChange(val);
                    },
                    initialValue: authProvider.changeEmailName,
                    decoration: InputDecoration(
                      fillColor: ColorResources.WHITE,
                      filled: true,
                      hintText: authProvider.changeEmailName,
                      hintStyle: poppinsRegular.copyWith(
                        fontSize: 9.0.sp
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16.0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: poppinsRegular.copyWith(
                      fontSize: 9.0.sp
                    )
                  ),
                ),
                authProvider.changeEmail ? Container() : Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 16.0, right: 16.0),
                          width: double.infinity,
                          height: 50.0,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: ColorResources.BTN_PRIMARY,
                                width: 1.0
                              )
                            ),
                              backgroundColor: ColorResources.WHITE,
                            ),
                            child: Text(getTranslated("CANCEL", context),
                              style: poppinsRegular.copyWith(
                                color: ColorResources.BTN_PRIMARY,
                                fontSize: 9.0.sp,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            onPressed: () {
                              authProvider.cancelCustomEmail();
                            }
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 16.0, right: 16.0),
                          width: double.infinity,
                          height: 50.0,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: ColorResources.BTN_PRIMARY,
                                width: 1.0
                              )
                            ),
                              backgroundColor: ColorResources.WHITE,
                            ),
                            child: Text('Apply',
                              style: poppinsRegular.copyWith(
                                color: ColorResources.BTN_PRIMARY,
                                fontSize: 9.0.sp,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            onPressed: () {
                              authProvider.applyCustomEmail();
                            }
                          ),
                        ),
                      )
                    ],
                  ),
                ), 
                authProvider.whenCompleteCountdown == "start" ? Container(
                  margin: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 35.0),
                  alignment: Alignment.centerRight,
                  child: CircularCountDownTimer(
                    duration: 120,
                    initialDuration: 0,
                    width: 40.0,
                    height: 40.0,
                    ringColor: Colors.transparent,
                    ringGradient: null,
                    fillColor: ColorResources.BTN_PRIMARY.withOpacity(0.4),
                    fillGradient: null,
                    backgroundColor: ColorResources.BTN_PRIMARY,
                    backgroundGradient: null,
                    strokeWidth: 10.0,
                    strokeCap: StrokeCap.round,
                    textStyle: poppinsRegular.copyWith(
                      fontSize: 10.0.sp,
                      color: ColorResources.WHITE,
                      fontWeight: FontWeight.bold
                    ),
                    textFormat: CountdownTextFormat.S,
                    isReverse: true,
                    isReverseAnimation: true,
                    isTimerTextShown: true,
                    autoStart: true,
                    onStart: () {
                    },
                    onComplete: () {
                      authProvider.completeCountDown();
                    },
                  ),
                ) : Container(),
                SizedBox(
                  height: 5.0,
                ),
                authProvider.whenCompleteCountdown == "completed" ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getTranslated("DID_NOT_RECEIVE_CODE", context),
                      style: poppinsRegular.copyWith(
                        color: Colors.black54,
                        fontSize: 9.0.sp
                      ),
                    ),
                    TextButton(
                      onPressed: () => authProvider.resendOtpCall(context, globalKey),
                      child: authProvider.resendOtpStatus == ResendOtpStatus.loading 
                      ? SizedBox(
                        width: 12.0,
                        height: 12.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ColorResources.BTN_PRIMARY),
                        ),
                      )
                      : Text(getTranslated("RESEND", context),
                        style: poppinsRegular.copyWith(
                          color: ColorResources.BTN_PRIMARY,
                          fontSize: 9.0.sp
                        ),
                      )
                    )
                  ],
                ) : Container(),
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  width: double.infinity,
                  height: 50.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                      backgroundColor: ColorResources.BTN_PRIMARY,
                    ),
                    child: authProvider.verifyOtpStatus == VerifyOtpStatus.loading 
                    ? Loader(
                        color: ColorResources.WHITE,
                      )
                    : Text('Verify',
                      style: poppinsRegular.copyWith(
                        color: ColorResources.WHITE,
                        fontSize: 9.0.sp,
                        fontWeight: FontWeight.bold
                      )
                    ) ,
                    onPressed: () => authProvider.verifyOtp(context, globalKey)
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextButton(
                    child: Text(getTranslated("BACK", context),
                      style: poppinsRegular.copyWith(
                        color: ColorResources.BTN_PRIMARY,
                        fontSize: 9.0.sp,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => SignInScreen())
                    )
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextButton(
                    child: Text(getTranslated("CHANGE_EMAIL", context),
                      style: poppinsRegular.copyWith(
                        color: ColorResources.BTN_PRIMARY,
                        fontSize: 9.0.sp,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    onPressed: () => authProvider.changeEmailCustom(),
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }
}
