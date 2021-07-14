import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 50),
            child: Text(getTranslated('WANT_TO_SIGN_OUT', context), style: poppinsRegular, textAlign: TextAlign.center),
          ),
          Divider(
            height: 0.0, 
            color: ColorResources.HINT_TEXT_COLOR
          ),
          Row(
            children: [
            Expanded(
              child: InkWell(
              onTap: () {
                Provider.of<ProfileProvider>(context, listen: false).userProfile?.profilePic = null;
                Provider.of<AuthProvider>(context, listen: false).logout().then((condition) {
                  Navigator.pop(context);
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignInScreen()), (route) => false);
                });
              },
              child: Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorResources.BTN_PRIMARY_SECOND,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0)
                  )
                ),
                child: Text(getTranslated('YES', context), style: poppinsRegular.copyWith(color: ColorResources.WHITE)),
              ),
            )
          ),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorResources.BTN_PRIMARY, 
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10.0)
                  )
                ),
                child: Text(getTranslated('NO', context), style: poppinsRegular.copyWith(color: ColorResources.WHITE)),
              ),
            )
          ),
        ]),
      ]),
    );
  }
}
