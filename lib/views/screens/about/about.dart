import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CustomAppBar(title: getTranslated("ABOUT_US", context), isBackButtonExist: true),

            Container(
              width: double.infinity, 
              height: 160.0,
              margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
              child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorResources.PRIMARY,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1.0,
                        blurRadius: 3.0,
                        offset: Offset(0.0, 3.0),
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        height: 100.0,
                        child: Image.asset(Images.logo)
                      ),
                      SizedBox(height: 10.0),
                      Text("INDOMINI CLUB",
                        style: TextStyle(
                          color: ColorResources.WHITE,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ]
                  )
                ),
              )
            ),

            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("HISTORY",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sed velit condimentum mi semper imperdiet ut id leo. Proin lacinia interdum laoreet. Duis elementum, purus ac eleifend scelerisque, ex justo malesuada tellus, ac dictum purus tortor ut massa. Suspendisse viverra, risus a tincidunt fringilla, nisi mi bibendum nisi, sodales faucibus mauris mi a libero. Etiam scelerisque ligula mauris, sit amet tempor leo venenatis vel. Nunc et molestie ligula, sed rhoncus orci. Proin diam odio, maximus in rutrum in, varius eget magna. Praesent ut neque mi. Cras egestas eros id nulla accumsan placerat.",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            height: 1.8
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}