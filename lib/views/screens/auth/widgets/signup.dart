import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/data/models/user.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/views/basewidget/textfield/custom_password_textfield.dart';
import 'package:mbw204_club_ina/views/basewidget/textfield/custom_textfield.dart';
import 'package:mbw204_club_ina/helpers/show_snackbar.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode cardNumberFocus = FocusNode();
  FocusNode noAnggotaFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  UserData userData = UserData();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController cardNumberTextController = TextEditingController();
  TextEditingController noAnggotaTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailTextController = TextEditingController();
    addressTextController = TextEditingController();
    phoneTextController = TextEditingController();
    cardNumberTextController = TextEditingController();
    noAnggotaTextController = TextEditingController();
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();
  }

  @override
  void dispose() {
    emailTextController.dispose();
    phoneTextController.dispose();
    addressTextController.dispose();
    cardNumberTextController.dispose();
    noAnggotaTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.dispose();
  }

  void register() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      try {
        if(emailTextController.text.trim().isEmpty) {
          throw CustomException("NAME_MUST_BE_REQUIRED");
        }
        if(emailTextController.text.trim().isEmpty) {
          throw CustomException("EMAIL_MUST_BE_REQUIRED");
        }
        if(phoneTextController.text.trim().isEmpty) {
          throw CustomException("PHONE_MUST_BE_REQUIRED");
        }
        if(noAnggotaTextController.text.trim().isEmpty) {
          throw CustomException("NO_MEMBER_FIELD_MUST_BE_REQUIRED");
        }
        if(passwordTextController.text.trim() != confirmPasswordTextController.text.trim()) {
          throw CustomException("PASSWORD_DID_NOT_MATCH");
        }
        userData.userName = nameTextEditingController.text;
        userData.emailAddress = emailTextController.text;
        userData.phoneNumber = phoneTextController.text;
        userData.address = addressTextController.text;
        userData.idCardNumber = cardNumberTextController.text;
        userData.noAnggota = noAnggotaTextController.text;
        userData.password = passwordTextController.text;
        await Provider.of<AuthProvider>(context, listen: false).register(context, userData);
      } on CustomException catch(e) {
        var error = e.toString();
        if(error == "EMAIL_MUST_BE_REQUIRED") {
          ShowSnackbar.snackbar(context, getTranslated(error, context), "", ColorResources.ERROR);
        } else if(error == "NAME_MUST_BE_REQUIRED") {
          ShowSnackbar.snackbar(context, getTranslated(error, context), "", ColorResources.ERROR);
        } else if (error == "PHONE_MUST_BE_REQUIRED") {
          ShowSnackbar.snackbar(context, getTranslated(error, context), "", ColorResources.ERROR);
        } else if (error == "PASSWORD_DID_NOT_MATCH") {
          ShowSnackbar.snackbar(context, getTranslated(error, context), "", ColorResources.ERROR);
        } else if(error == "EMAIL_ALREADY_TAKEN") {
          ShowSnackbar.snackbar(context, getTranslated(error, context), "", ColorResources.ERROR);
        } else if(error == "NO_MEMBER_FIELD_MUST_BE_REQUIRED") {
          ShowSnackbar.snackbar(context, getTranslated(error, context), "", ColorResources.ERROR);
        } else if(error == "PHONE_ALREADY_TAKEN") {
          ShowSnackbar.snackbar(context, getTranslated(error, context), "", ColorResources.ERROR);    
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
    return ListView(
      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomTextField(
                  hintText: getTranslated('ENTER_YOUR_NAME', context),
                  focusNode: nameFocus,
                  nextNode: emailFocus,
                  textInputType: TextInputType.text,
                  controller: nameTextEditingController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomTextField(
                  hintText: getTranslated('ENTER_YOUR_EMAIL', context),
                  focusNode: emailFocus,
                  nextNode: phoneFocus,
                  textInputType: TextInputType.emailAddress,
                  controller: emailTextController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomTextField(
                  textInputType: TextInputType.number,
                  hintText: getTranslated('ENTER_MOBILE_NUMBER', context),
                  focusNode: phoneFocus,
                  nextNode: addressFocus,
                  controller: phoneTextController,
                  isPhoneNumber: true,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomTextField(
                  textInputType: TextInputType.text,
                  hintText: getTranslated('ENTER_YOUR_ADDRESS', context),
                  focusNode: addressFocus,
                  nextNode: passwordFocus,
                  isAddress: true,
                  controller: addressTextController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomTextField(
                  textInputType: TextInputType.text,
                  hintText: getTranslated('ENTER_YOUR_ID_CARD_NUMBER', context),
                  focusNode: cardNumberFocus,
                  nextNode: noAnggotaFocus,
                  controller: cardNumberTextController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomTextField(
                  textInputType: TextInputType.text,
                  hintText: getTranslated('ENTER_YOUR_NO_MEMBER', context),
                  focusNode: noAnggotaFocus,
                  nextNode: passwordFocus,
                  controller: noAnggotaTextController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomPasswordTextField(
                  hintTxt: getTranslated('PASSWORD', context),
                  controller: passwordTextController,
                  focusNode: passwordFocus,
                  nextNode: confirmPasswordFocus,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: Dimensions.MARGIN_SIZE_DEFAULT, 
                  right: Dimensions.MARGIN_SIZE_DEFAULT, 
                  top: Dimensions.MARGIN_SIZE_SMALL
                ),
                child: CustomPasswordTextField(
                  hintTxt: getTranslated('RE_ENTER_PASSWORD', context),
                  controller: confirmPasswordTextController,
                  focusNode: confirmPasswordFocus,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 20.0, 
            right: 20.0,
            bottom: 20.0, 
            top: 30.0
          ),
        child: TextButton(
          onPressed: register,
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
              ),
            ],
            borderRadius: BorderRadius.circular(10.0)),
              child: Provider.of<AuthProvider>(context, listen: false).registerStatus == RegisterStatus.loading ? Center(
                child: Loader(
                  color: ColorResources.WHITE,
                )
              ) : Text(getTranslated('SIGN_UP', context),
                style: titilliumSemiBold.copyWith(
                  fontSize: 16.0,
                  color: ColorResources.getWhiteToBlack(context),
                )
              ),
            ),
          ),
        ),
      ],
    );
  }
}
