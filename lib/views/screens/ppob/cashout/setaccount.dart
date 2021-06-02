import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/views/basewidget/textfield/custom_textfield.dart';
import 'package:provider/provider.dart';

class CashoutSetAccountScreen extends StatelessWidget {
  final String title;

  CashoutSetAccountScreen({this.title});

  final TextEditingController paymentAccount = TextEditingController();

  Future saveAccountPayment(BuildContext context) async {
    try {
      if(paymentAccount.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: getTranslated("PAYMENT_ACCOUNT_IS_REQUIRED", context),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: ColorResources.ERROR
        );
        return;
      }
      Navigator.of(context).pop();
      await Provider.of<PPOBProvider>(context, listen: false).setAccountPaymentMethod(paymentAccount.text);
    } catch(e) {
      print(e);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          CustomAppBar(title: title, isBackButtonExist: true),

          Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
            child: Column(
              children: [

                CustomTextField(
                  controller: paymentAccount,
                  hintText: title == "Bank Transfer" ? getTranslated("YOUR_ACCOUNT_BANK", context) : getTranslated("PHONE_NUMBER", context),
                ),

                SizedBox(height: 10.0),

                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: ColorResources.getPrimaryToWhite(context)
                    ),
                    onPressed: () { 
                      saveAccountPayment(context); 
                    }, 
                    child: Text(getTranslated("SAVE_ACCOUNT", context),
                      style: titilliumRegular.copyWith(
                        color: ColorResources.getWhiteToBlack(context)
                      ),
                    )
                  ),
                )

              ],
            )
          )      

        ],
      ),
    );
  }
}