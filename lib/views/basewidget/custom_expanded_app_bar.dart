import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';

class CustomExpandedAppBar extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget bottomChild;
  final bool isGuestCheck;
  CustomExpandedAppBar({@required this.title, @required this.child, this.bottomChild, this.isGuestCheck = false});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: bottomChild,
      body: Stack(
        children: [

          // Image.asset(
          //   Images.more_page_header, height: 150, fit: BoxFit.fill, width: MediaQuery.of(context).size.width,
          //   color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : null,
          // ),

          Positioned(
            top: 40.0,
            left: Dimensions.PADDING_SIZE_SMALL,
            right: Dimensions.PADDING_SIZE_SMALL,
            child: Row(
              children: [
                CupertinoNavigationBarBackButton(
                  color: ColorResources.GRAY_DARK_PRIMARY, 
                  onPressed: () => Navigator.pop(context)
                ),
                Text(title, 
                  style: poppinsRegular.copyWith(
                  fontSize: 18.0, 
                  color: ColorResources.GRAY_DARK_PRIMARY
                ), 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis
                ),
              ]
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 120.0),
            decoration: BoxDecoration(
              color: ColorResources.BG_GREY,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: child,
          ),
          
        ]
      ),
    );
  }
}