import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';

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
                    Container(
                      child: Card(
                        child: Container(
                          child: ListTile(
                            onTap: () {
                              print("PRINT!");
                            },
                            leading: Image.asset(Images.facebook,
                              width: 28.0,
                              height: 28.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Card(
                        child: Container(
                          child: ListTile(
                            onTap: () {
                              print("PRINT!");
                            },
                            leading: Image.asset(Images.twitter,
                              width: 32.0,
                              height: 32.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Card(
                        child: Container(
                          child: ListTile(
                            onTap: () {
                              print("PRINT!");
                            },
                            leading: Image.asset(Images.instagram,
                              width: 28.0,
                              height: 28.0,
                            ),
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