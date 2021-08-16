import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/views/basewidget/textfield/custom_textfield.dart';

class CashoutSetAccountScreen extends StatelessWidget {
  final String title;

  CashoutSetAccountScreen({this.title});

  final TextEditingController paymentAccount = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();

  Future saveAccountPayment(BuildContext context) async {
    try {
      if(paymentAccount.text.trim().isEmpty) {
        ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
          SnackBar(
            backgroundColor: ColorResources.ERROR,
            content: Text(getTranslated("PAYMENT_ACCOUNT_IS_REQUIRED", context),
              style: poppinsRegular,
            )
          )
        );
        return;
      }
      await Provider.of<PPOBProvider>(context, listen: false).setAccountPaymentMethod(paymentAccount.text);
     int count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    } catch(e) {
      print(e);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
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
                      primary: ColorResources.BTN_PRIMARY
                    ),
                    onPressed: () { 
                      saveAccountPayment(context); 
                    }, 
                    child: Text(getTranslated("SAVE_ACCOUNT", context),
                      style: poppinsRegular.copyWith(
                        color: ColorResources.WHITE,
                        fontSize: 9.0.sp
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