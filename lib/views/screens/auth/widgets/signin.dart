import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/theme.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/data/models/user.dart';
import 'package:mbw204_club_ina/helpers/show_snackbar.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/views/basewidget/textfield/custom_password_textfield.dart';
import 'package:mbw204_club_ina/views/basewidget/textfield/custom_textfield.dart';

class SignInWidget extends StatefulWidget {
  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  FocusNode phoneNode = FocusNode();
  FocusNode passNode = FocusNode();
  UserData userData = UserData();
  TextEditingController phoneTextController;
  TextEditingController passwordTextController;
  GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    phoneTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    phoneTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void login() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      try {
        if (phoneTextController.text.trim().isEmpty) {
          throw CustomException("PHONE_MUST_BE_REQUIRED");
        } 
        if (passwordTextController.text.trim().isEmpty) {
          throw CustomException("PASSWORD_MUST_BE_REQUIRED");
        }
        userData.phoneNumber = phoneTextController.text;
        userData.password = passwordTextController.text;
        await Provider.of<AuthProvider>(context, listen: false).login(context, userData);
        Provider.of<ThemeProvider>(context, listen: false).pageIndex = 0;
      } on CustomException catch(e) {
        var error = e.toString();
        if(error == "PHONE_MUST_BE_REQUIRED") {
          ShowSnackbar.snackbar(context, getTranslated(error, context), "", ColorResources.ERROR);
        } 
        if(error == "PHONE_MUST_BE_REQUIRED") {
          ShowSnackbar.snackbar(context, getTranslated(error, context), "", ColorResources.ERROR);
        } else if (error == "PASSWORD_MUST_BE_REQUIRED") {
          ShowSnackbar.snackbar(context, getTranslated(error, context), "", ColorResources.ERROR);
        } else if (error == "Password incorrect") {
          ShowSnackbar.snackbar(context, getTranslated("PASSWORD_INCORRECT", context), "", ColorResources.ERROR);
        } else if (error == "Phone number incorrect") {
          ShowSnackbar.snackbar(context, getTranslated("PHONE_NUMBER_INCORRECT", context), "", ColorResources.ERROR);
        } else if(error == "CONNECTION_TIMEOUT") {
          ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.ERROR);
        } else {
          ShowSnackbar.snackbar(context, error, "", ColorResources.ERROR);    
        }
      } catch(e) {
        ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.ERROR);
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
        children: [
          Container(
            margin: EdgeInsets.only(
              left: Dimensions.MARGIN_SIZE_LARGE, 
              right: Dimensions.MARGIN_SIZE_LARGE, 
              bottom: Dimensions.MARGIN_SIZE_SMALL
            ),
            child: CustomTextField(
              hintText: getTranslated('ENTER_MOBILE_NUMBER', context),
              focusNode: phoneNode,
              nextNode: passNode,
              textInputType: TextInputType.number,
              controller: phoneTextController,
            )
          ),
          Container(
            margin: EdgeInsets.only(
              left: Dimensions.MARGIN_SIZE_LARGE, 
              right: Dimensions.MARGIN_SIZE_LARGE, 
              bottom: Dimensions.MARGIN_SIZE_DEFAULT
            ),
            child: CustomPasswordTextField(
              hintTxt: getTranslated('ENTER_YOUR_PASSWORD', context),
              textInputAction: TextInputAction.done,
              focusNode: passNode,
              controller: passwordTextController,
            )
          ),
          Container(
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0, 
              bottom: 20.0, 
              top: 20.0
            ),
            child: TextButton(
            onPressed: login,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: ColorResources.getPrimaryToWhite(context)
            ),
            child: Container(
              height: 45.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), 
                    spreadRadius: 1.0, 
                    blurRadius: 7.0, 
                    offset: Offset(0, 1)
                  ), // changes position of shadow
                ],
                borderRadius: BorderRadius.circular(10.0)),
                child: Consumer<AuthProvider>(
                  builder: (BuildContext context, AuthProvider authProvider, Widget child) {
                    return authProvider.loginStatus == LoginStatus.loading 
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
                    : Text(getTranslated('SIGN_IN', context),
                      style: titilliumSemiBold.copyWith(
                        fontSize: 16.0,
                        color: ColorResources.getWhiteToBlack(context),
                      )
                    );
                  },
                )
              ),
            )  
          ),
        ],
      ),
    );
  }
}
