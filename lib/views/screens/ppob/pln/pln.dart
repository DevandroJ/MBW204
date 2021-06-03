import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';

import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/views/screens/ppob/pln/tagihan_listrik.dart';
import 'package:mbw204_club_ina/views/screens/ppob/pln/token_listrik.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class PlnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: "PLN", isBackButtonExist: true),

            Column(
              children: [
                Container(
                  height: 60.0,
                  color: ColorResources.WHITE,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TokenListrikScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 5.0),
                            Container(
                              margin: EdgeInsets.only(left: 12.0),
                              child: Text("Token Listrik",
                                style: poppinsRegular.copyWith(
                                  color: ColorResources.BLACK,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 12.0),
                          child: InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TokenListrikScreen())),
                            child: Icon(Icons.keyboard_arrow_right)
                          )
                        ),
                      ],
                    ),
                  )
                ),
                Container(
                  height: 60.0,
                  color: ColorResources.WHITE,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TagihanListrikScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 5.0),
                            Container(
                              margin: EdgeInsets.only(left: 12.0),
                              child: Text("Tagihan Listrik",
                                style: poppinsRegular.copyWith(
                                  color: ColorResources.BLACK,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 12.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => TagihanListrikScreen()),
                              );
                            },
                            child: Icon(Icons.keyboard_arrow_right)
                          )
                        ),
                      ],
                    ),
                  )
                ),
              ],
            )
          ],
        ),
      ),      
    );
  }
}