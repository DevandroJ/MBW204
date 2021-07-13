import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: "Media"),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                child: Column(
                  children: [

                    Card(
                      child: Container(
                        child: ListTile(
                          onTap: () async {
                            try {
                              await launch('https://www.facebook.com/mbw204clubina/');
                            } catch(e) {
                              print(e);
                            }
                          },
                          leading: Image.asset(Images.facebook,
                            width: 28.0,
                            height: 28.0,
                          ),
                          title: Text("MB W204 Club Indonesia",
                            style: poppinsRegular,
                          ),
                        ),
                      ),
                    ),
                    
                    Card(
                      child: Container(
                        child: ListTile(
                          onTap: () async {
                            try {
                              await launch('https://twitter.com/mbw202ci');
                            } catch(e) {
                              print(e);
                            }
                          },
                          leading: Image.asset(Images.twitter,
                            width: 32.0,
                            height: 32.0,
                          ),
                          title: Text("W204 Community",
                            style: poppinsRegular,
                          ),
                        ),
                      ),
                    ),

                    Card(
                      child: Container(
                        child: ListTile(
                          onTap: () async {
                            try {
                              await launch('https://www.instagram.com/mbw204clubina/');
                            } catch(e) {
                              print(e);
                            }
                          },
                          leading: Image.asset(Images.instagram,
                            width: 28.0,
                            height: 28.0,
                          ),
                          title: Text("mbw204clubina",
                            style: poppinsRegular,
                          ),
                        ),
                      ),
                    ),

                    Card(
                      child: Container(
                        child: ListTile(
                          onTap: () {
                            print("PRINT!");
                          },
                          leading: Image.asset(Images.youtube,
                            width: 36.0,
                            height: 36.0,
                          ),
                          title: Text("W204 Youtube",
                            style: poppinsRegular,
                          ),
                        ),
                      ),
                    )
                    
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}