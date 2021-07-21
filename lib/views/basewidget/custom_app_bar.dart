import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final isBackButtonExist;
  final IconData icon;
  final Function onActionPressed;

  CustomAppBar({
    @required this.title, 
    this.isBackButtonExist = true, 
    this.icon, 
    this.onActionPressed
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      Container(
        color: ColorResources.BTN_PRIMARY,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        height: 50.0,
        alignment: Alignment.center,
        child: Row(
          children: [
            isBackButtonExist ? Container(
              margin: EdgeInsets.only(left: 15.0),
              child: CupertinoNavigationBarBackButton(
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.white,
            ))
            : SizedBox.shrink(),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(
              child: Text(
                title,
                style: poppinsRegular.copyWith(fontSize: 20, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          icon != null
          ? IconButton(
              icon: Icon(icon, size: Dimensions.ICON_SIZE_LARGE, color: Colors.white),
              onPressed: onActionPressed,
            )
          : SizedBox.shrink(),
        ]),
      ),
    ]);
  }
}
