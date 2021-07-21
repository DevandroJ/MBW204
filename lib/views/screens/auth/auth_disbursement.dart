import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/basewidget/textfield/custom_password_textfield.dart';

class AuthDisbursementScreen extends StatefulWidget {
  @override
  _AuthDisbursementScreenState createState() => _AuthDisbursementScreenState();
}

class _AuthDisbursementScreenState extends State<AuthDisbursementScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FocusNode passNode = FocusNode();

  TextEditingController passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    passwordTextController = TextEditingController();
  }

  @override 
  void dispose() {
    super.dispose();
    passwordTextController.dispose();
  }

  Future signIn(BuildContext context) async {
    try {
      if(passwordTextController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Password Must Be Required",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: ColorResources.ERROR,
        );
        return;
      }
      await Provider.of<AuthProvider>(context, listen: false).authDisbursement(context, passwordTextController.text);
    } on CustomException catch(e) {
      String error = e.toString();
      Fluttertoast.showToast(
        msg: error,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: ColorResources.ERROR
      );
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
   
  
    return Scaffold(
      body: Center(

        child: Container(
          margin: EdgeInsets.only(top: 250.0, bottom: 0.0, left: 0.0, right: 0.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [

                Container(
                  margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT, 
                    right: Dimensions.MARGIN_SIZE_DEFAULT, 
                    bottom: Dimensions.MARGIN_SIZE_DEFAULT
                  ),
                  child: CustomPasswordTextField(
                    hintTxt: "Password",
                    textInputAction: TextInputAction.done,
                    focusNode: passNode,
                    controller: passwordTextController,
                  )
                ),

                Container(
                  margin: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0, 
                    bottom: 10.0, 
                    top: 15.0
                  ),
                  child: TextButton(
                  onPressed: () => signIn(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: ColorResources.PRIMARY
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
                          return authProvider.authDisbursementStatus == AuthDisbursementStatus.loading 
                          ? Loader(
                              color: ColorResources.BTN_PRIMARY_SECOND,
                            )
                          : Text(getTranslated('SIGN_IN', context),
                            style: poppinsRegular.copyWith(
                              fontSize: 16.0,
                              color: ColorResources.WHITE,
                            )
                          );
                        } 
                      )
                    ),
                  )  
                ),

                Container(
                  margin: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0, 
                    bottom: 15.0, 
                    top: 5.0
                  ),
                  child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: ColorResources.BTN_PRIMARY
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
                      child: Text(getTranslated('BACK', context),
                        style: poppinsRegular.copyWith(
                          fontSize: 16.0,
                          color: ColorResources.WHITE,
                        )
                      )
                    ),
                  )  
                ),

              ],
            ),
          ),
        )

      ),
    );
  }
}