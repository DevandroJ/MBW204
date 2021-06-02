import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/providers/theme.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/basewidget/not_loggedin_widget.dart';

class CustomExpandedAppBar extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget bottomChild;
  final bool isGuestCheck;
  CustomExpandedAppBar({@required this.title, @required this.child, this.bottomChild, this.isGuestCheck = false});

  @override
  Widget build(BuildContext context) {
    bool isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Scaffold(
      floatingActionButton: isGuestCheck ? isGuestMode ? null : bottomChild : bottomChild,
      body: Stack(
        children: [

          Image.asset(
            Images.more_page_header, height: 150, fit: BoxFit.fill, width: MediaQuery.of(context).size.width,
            color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : null,
          ),

          Positioned(
            top: 40,
            left: Dimensions.PADDING_SIZE_SMALL,
            right: Dimensions.PADDING_SIZE_SMALL,
            child: Row(children: [
              CupertinoNavigationBarBackButton(color: Colors.white, onPressed: () => Navigator.pop(context)),
              Text(title, style: titilliumRegular.copyWith(
                fontSize: 20.0, 
                color: Colors.white
              ), 
                maxLines: 1, 
                overflow: TextOverflow.ellipsis
              ),
            ]),
          ),

          Container(
            margin: EdgeInsets.only(top: 120.0),
            decoration: BoxDecoration(
              color: ColorResources.getHomeBg(context),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: isGuestCheck ? isGuestMode ? NotLoggedInWidget() : child : child,
          ),
          
        ]
      ),
    );
  }
}
