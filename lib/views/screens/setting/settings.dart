import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/views/basewidget/custom_expanded_app_bar.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/views/screens/auth/change_password.dart';
import 'package:mbw204_club_ina/views/basewidget/list_component.dart';
import 'package:mbw204_club_ina/views/basewidget/animated_custom_dialog.dart';
import 'package:mbw204_club_ina/views/screens/setting/widgets/language_dialog.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';

class SettingsScreen extends StatefulWidget {

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<PPOBProvider>(context, listen: false).getBankDisbursement(context);
      Provider.of<PPOBProvider>(context, listen: false).getEmoneyDisbursement(context);
    });
  }

  Future<bool> willPopScope() {
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: willPopScope,
      child: CustomExpandedAppBar(
        title: getTranslated("SETTINGS", context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [

            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                children: [

                  Consumer<PPOBProvider>(
                    builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          ppobProvider.getGlobalPaymentMethodName != "" 
                          && ppobProvider.getGlobalPaymentAccount != ""
                          ? Container(
                              margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(getTranslated("DESTINATION_CASHOUT", context),
                                      style: poppinsRegular,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text("${ppobProvider.getGlobalPaymentMethodName} - ${ppobProvider.getGlobalPaymentAccount}",
                                    style: poppinsRegular,
                                  ),
                                  SizedBox(width: 10.0),
                                  InkWell(
                                    onTap: () {
                                      ppobProvider.removePaymentMethod();
                                    },
                                    child: Icon(
                                      Icons.remove_circle,
                                      color: ColorResources.BTN_PRIMARY,
                                    ),
                                  )
                                ],
                              )
                            )
                          : Container(
                            margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Text(getTranslated("DESTINATION_CASHOUT", context),
                                        style: poppinsRegular,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: ColorResources.BLUE
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ListTileComponent(
                                          title: "Bank Transfer",
                                          items: ppobProvider.bankDisbursement
                                        )));
                                      }, 
                                      child: Text("Bank Transfer",
                                        style: poppinsRegular.copyWith(
                                          fontSize: 11,
                                          color: ColorResources.WHITE
                                        ),
                                      )
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: ColorResources.BLUE
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ListTileComponent(
                                          title: "E Money",
                                          items: ppobProvider.emoneyDisbursement
                                        )));
                                      }, 
                                      child: Text(getTranslated("E_MONEY", context),
                                        style: poppinsRegular.copyWith(
                                          fontSize: 11.0,
                                          color: ColorResources.WHITE
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ),

                        ],
                      );
                    },
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                    child: InkWell(
                      onTap: () {
                        showAnimatedDialog(context, LanguageDialog());
                      },
                      child: Text("${getTranslated('CHOOSE_LANGUAGE', context)}",
                        style: poppinsRegular
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 25.0, left: 16.0, right: 16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                        );
                      },
                      child: Text(getTranslated("CHANGE_PASSWORD", context),
                        style: poppinsRegular,
                      ),
                    ),
                  )

                ],
              )
            ),

          ]
        ),
      )
      
    );
  }
}

class TitleButton extends StatelessWidget {
  final String image;
  final String title;
  final Function onTap;
  TitleButton({@required this.image, @required this.title, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        image, 
        width: 25.0, 
        height: 25.0, 
        fit: BoxFit.fill, 
        color: ColorResources.BTN_PRIMARY
      ),
      title: Text(title, 
        style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)
      ),
      onTap: onTap,
    );
  }
}

