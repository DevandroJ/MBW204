import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/localization.dart';
import 'package:mbw204_club_ina/providers/splash.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';

class LanguageDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    int index = Provider.of<LocalizationProvider>(context, listen: false).languageIndex;
    
    return Dialog(
      backgroundColor: ColorResources.WHITE,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: Text(getTranslated('CHOOSE_LANGUAGE', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),

        SizedBox(
          height: 150.0, 
          child: Consumer<SplashProvider>(
            builder: (BuildContext context, SplashProvider splashProvider, Widget child) {

            List<String> valueList = [];
            AppConstants.languages.forEach((language) => valueList.add(language.languageName));

              return CupertinoPicker(
                itemExtent: 40.0,
                useMagnifier: true,
                magnification: 1.2,
                scrollController: FixedExtentScrollController(initialItem: index),
                onSelectedItemChanged: (int i) {
                  index = i;
                },
                children: valueList.map((value) {
                  return Center(child: Text(value, 
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color
                    )
                  )
                );
                }).toList(),
              );
            },
          )
        ),

        Divider(height: Dimensions.PADDING_SIZE_EXTRA_SMALL, color: ColorResources.HINT_TEXT_COLOR),
        Row(children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(getTranslated('CANCEL', context), 
                style: poppinsRegular.copyWith(
                color: ColorResources.BLACK
                )
              ),
            )
          ),
          Container(
            height: 50.0,
            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: VerticalDivider(
              width: Dimensions.PADDING_SIZE_EXTRA_SMALL, 
              color: Theme.of(context).hintColor
            ),
          ),
          Expanded(
            child: TextButton(
            onPressed: () {
              Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                AppConstants.languages[index].languageCode,
                AppConstants.languages[index].countryCode,
              ));
              Navigator.pop(context);
            },
            child: Text(getTranslated('OK', context), 
              style: poppinsRegular.copyWith(
                color: ColorResources.BLACK
              )
            ),
          )),
        ]),

      ]),
    );
  }
}