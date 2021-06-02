import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/theme.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/basewidget/textfield/custom_password_textfield.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/data/models/user.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> formkey = GlobalKey();
  final UserData userData = UserData();
  
  final TextEditingController passwordOldController = TextEditingController();
  final TextEditingController passwordNewController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    Future changePassword() async {
      try { 
        if(passwordOldController.text.trim().isEmpty) {
          Fluttertoast.showToast(
            msg: getTranslated("PASSWORD_OLD_IS_REQUIRED", context),
            backgroundColor: ColorResources.ERROR
          );
          return;
        }
        if(passwordNewController.text.trim().isEmpty) {
          Fluttertoast.showToast(
            msg: getTranslated("PASSWORD_NEW_IS_REQUIRED", context),
            backgroundColor: ColorResources.ERROR
          );
          return;
        }
        if(passwordConfirmController.text.trim().isEmpty) {
          Fluttertoast.showToast(
            msg: getTranslated("PASSWORD_CONFIRM_IS_REQUIRED", context),
            backgroundColor: ColorResources.ERROR
          );
          return;
        }
        if(passwordNewController.text != passwordConfirmController.text) {
          Fluttertoast.showToast(
            msg: getTranslated("PASSWORD_CONFIRM_IS_REQUIRED", context),
            backgroundColor: ColorResources.ERROR
          );
          return;
        }
        userData.password = passwordOldController.text;
        userData.passwordNew = passwordNewController.text;
        userData.passwordConfirm = passwordConfirmController.text;
        await Provider.of<AuthProvider>(context, listen: false).forgotPassword(context, userData);
        Fluttertoast.showToast(
          msg: getTranslated("UPDATE_PASSWORD_SUCCESS", context),
          backgroundColor: ColorResources.SUCCESS
        );
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      } on ServerErrorException catch(e) {
         Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: ColorResources.ERROR
        );
      } catch(e) {
        print(e);
      }
    }

    return Scaffold(
      key: formkey,

      body: Container(
        decoration: BoxDecoration(
          image: Provider.of<ThemeProvider>(context).darkTheme ? null : DecorationImage(image: AssetImage(Images.background), fit: BoxFit.fill),
        ),
        child: Column(
          children: [

            SafeArea(
              child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: () => Navigator.pop(context),
              ),
              )
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), 
                children: [

                Padding(
                  padding: EdgeInsets.all(50),
                ),
                
                CustomPasswordTextField(
                  controller: passwordOldController,
                  hintTxt: getTranslated('OLD_PASSWORD', context),
                  textInputAction: TextInputAction.done,   
                ),

                SizedBox(height: 12.0),

                CustomPasswordTextField(
                  controller: passwordNewController,
                  hintTxt: getTranslated('ENTER_YOUR_NEW_PASSWORD', context),
                  textInputAction: TextInputAction.done,   
                ),

                SizedBox(height: 12.0),

                CustomPasswordTextField(
                  controller: passwordConfirmController,
                  hintTxt: getTranslated('RE_ENTER_PASSWORD', context),
                  textInputAction: TextInputAction.done,   
                ),


                SizedBox(height: 20.0),

                InkWell(
                  onTap: changePassword,
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                    color: ColorResources.getPrimaryToWhite(context),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), 
                        spreadRadius: 1.0, 
                        blurRadius: 7.0, 
                        offset: Offset(0, 1)
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0)),
                    child: Consumer<AuthProvider>(
                      builder: (BuildContext context, AuthProvider authProvider, Widget child) {
                        return authProvider.forgotPasswordStatus == ForgotPasswordStatus.loading 
                        ? Center(
                            child: SizedBox(
                              width: 18.0,
                              height: 18.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).accentColor
                              )
                            ))
                          ) 
                        : Text(getTranslated('CHANGE_PASSWORD', context),
                          style: titilliumSemiBold.copyWith(
                            fontSize: 16.0,
                            color: ColorResources.getWhiteToBlack(context),
                          )
                        );
                      },
                    )
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
