import 'dart:io';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';

class NotificatioDemoScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificatioDemoScreen> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title: Text(getTranslated("NOTIFICATION", context), 
              style: poppinsRegular.copyWith(color: Colors.black)),
              elevation: 0.0,
              pinned: false,
              centerTitle: false,
              floating: true,
            ),
          ];
        },
        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 4,
          itemBuilder: (BuildContext context, int i) {
            return InkWell(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage("https://cdn0-production-images-kly.akamaized.net/0r0vo4waPk9g2ZOtSePxceTuoyE=/640x480/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/706185/original/Daniel-Radcliffe-140710.gif"),
                  radius: 20.0,
                ),
                title: Text("Ut enim ad minim veniam, quis nostrud exercitation ullamco… ",
                  style: poppinsRegular.copyWith(fontSize: 14.0),
                ),
                subtitle: Text("12-12-2019",
                  style: poppinsRegular.copyWith(fontSize: 12.0)
                ),
              ),
            );
          },
        ),    
      ),
    );
  }
}
