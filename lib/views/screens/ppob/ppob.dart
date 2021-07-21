import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/views/screens/ppob/emoney/list_voucher_emoney.dart';
import 'package:mbw204_club_ina/views/screens/ppob/pln/pln.dart';
import 'package:mbw204_club_ina/views/screens/ppob/pulsa/list_voucher_pulsa_by_prefix.dart';
import 'package:mbw204_club_ina/views/basewidget/ppob_menus.dart';

class PPOBScreen extends StatefulWidget {
  @override
  _PPOBScreenState createState() => _PPOBScreenState();
}

class _PPOBScreenState extends State<PPOBScreen> {
  ScrollController ppobController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column( 
          children: [

            CustomAppBar(title: getTranslated("PPOB" ,context)),

            Container(
              margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1.0,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 3.0),
                  )
                ]
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3.0,
                child: GridView.builder(
                shrinkWrap: true,
                itemCount: ppobMenus[0]["menu-0"].length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 1 / 1
                ),
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [    
                            Container(
                              width: 50.0,
                              child: IconButton(
                                icon: ppobMenus[0]["menu-0"][i]["icons"],
                                onPressed: () {
                                  switch(ppobMenus[0]["menu-0"][i]["link"]) {
                                    case "pulsa":
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => ListVoucherPulsaByPrefixScreen()),
                                      );
                                    break;
                                    case "uang-elektronik" :
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => ListVoucherEmoneyScreen()),
                                      );
                                    break;
                                    case "pln":
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => PlnScreen()),
                                      );
                                    break;
                                  }
                                },
                              ),
                            ),                              
                            AutoSizeText(getTranslated(ppobMenus[0]["menu-0"][i]["text"], context),
                              style: poppinsRegular.copyWith(
                                color: ColorResources.BTN_PRIMARY,
                                fontWeight: FontWeight.bold
                              ),
                            ) , 
                          ],
                        )
                      ],
                    )
                  );
                },
              ),
              )
            )
            
          ] 
        ),
      )
    );
  }
}