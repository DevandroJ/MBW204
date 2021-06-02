import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/theme.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/utils/images.dart';


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
      ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
        child: Image.asset(
          Images.toolbar_background, 
          fit: BoxFit.fill,
          height: 50 + MediaQuery.of(context).padding.top, 
          width: MediaQuery.of(context).size.width,
          color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : null,
        ),
      ),
      Container(
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
                style: titilliumRegular.copyWith(fontSize: 20, color: Colors.white),
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
