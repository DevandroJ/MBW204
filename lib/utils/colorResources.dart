import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/theme.dart';

class ColorResources {

  static Color getBlue(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFF007ca3) : Color(0xFF00ADE3);
  }
  static Color getBlueToWhite(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFFFFFFFF) : Color(0xFF64B5F6);
  }
   static Color getBlueGreyToBlack(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFF414345) : Color(0xFFECEFF1);
  }
  static Color getColombiaBlue(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFF678cb5) : Color(0xFF92C6FF);
  }
  static Color getWhiteToBlack(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xff000000) : Color(0xffFFFFFF);
  }
  static Color getBlackToWhite(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xffFFFFFF) : Color(0xff000000) ;
  }
  static Color getPrimaryToWhite(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xffFFFFFF) : Color(0xff58595B) ;
  }
  static Color getPrimaryToBlack(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xff2E2E2E) : Color(0xff58595B) ;
  }
  static Color getDimGrayToWhite(BuildContext context) {
    return  Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xffFFFFFF) : Color(0xff6D6D6D).withOpacity(0.8);
  }
  static Color getPrimary(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xffFFFFFF) : Color(0xffAF162B);
  }
  static Color getHarlequin(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFF257800) : Color(0xFF3FCC01);
  }
  static Color getCheris(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFF941546) : Color(0xFFE2206B);
  }
  static Color getGrey(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFF808080) : Color(0xFFF1F1F1);
  }
  static Color getError(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFF4A000A) : Color(0xFFcc3300);
  }
  static Color getYellow(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFF916129) : Color(0xFFFFAA47);
  }
  static Color getHint(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFFc7c7c7) : Color(0xFF9E9E9E);
  }
  static Color getGainsBoro(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFF999999) : Color(0xFFE6E6E6);
  }
  static Color getTextBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFF414345) : Color(0xFFF3F9FF);
  }
  static Color getBlackSoft(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xFF2e2e2e) : Color(0xFFF9F9F9);
  }
  static Color getBgBlack(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xff000000) : Color(0xffAF162B);
  }
  static Color getHomeBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xff3d3d3d) : Color(0xFFF0F0F0);
  }
  static Color getImageBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xff3f4347) : Color(0xFFE2F0FF);
  }
  static Color getChatIcon(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Color(0xffbebeb) : Color(0xFFD4D4D4);
  }

  static const Color BLACK = Color(0xff000000);
  static const Color BTN_PRIMARY = Color(0xFF58595b);
  static const Color BTN_PRIMARY_SECOND = Color(0xFFDD0000);
  static const Color BLUE_GREY = Color(0xffECEFF1);
  static const Color WHITE = Color(0xffFFFFFF);
  static const Color PRIMARY = Color(0xFFaf162b);
  static const Color PINK_PRIMARY = Color(0xFFf66a6a);
  static const Color BG_GREY = Color(0xffF5F5F5);
  static const Color DIM_GRAY = Color(0xff6D6D6D);
  static const Color GRAY_PRIMARY = Color(0xffCECECE);
  static const Color GRAY_DARK_PRIMARY = Color(0xFF707070);
  static const Color GRAY_LIGHT_PRIMARY = Color(0xFFebebeb);
  static const Color BLUE = Color(0xFF64B5F6);
  static const Color COLUMBIA_BLUE = Color(0xff92C6FF);
  static const Color LIGHT_SKY_BLUE = Color(0xff8DBFF6);
  static const Color CERISE = Color(0xffE2206B);
  static const Color GREY = Color(0xffF1F1F1);
  static const Color PURPLE_DARK = Color(0xff542e71);
  static const Color PURPLE_LIGHT = Color(0xffa799b7);
  static const Color LAVENDER = Color(0xff0F5F8FD);
  static const Color SUCCESS = Color(0xff99CC33);
  static const Color ERROR = Color(0xffcc3300);
  static const Color HINT_TEXT_COLOR = Color(0xff9E9E9E);
  static const Color GAINS_BORO = Color(0xffE6E6E6);
  static const Color TEXT_BG = Color(0xffF3F9FF);
  static const Color ICON_BG = Color(0xffF9F9F9);
  static const Color HOME_BG = Color(0xffF0F0F0);
  static const Color IMAGE_BG = Color(0xffE2F0FF);
  static const Color SELLER_TXT = Color(0xff92C6FF);
  static const Color CHAT_ICON_COLOR = Color(0xffD4D4D4);
  static const Color LOW_GREEN = Color(0xffEFF6FE);
  static const Color GREEN = Color(0xff23CB60);
  static const Color YELLOW_PRIMARY = Color(0xFFffCE00);
  static const Color FLOATING_BTN = Color(0xff7DB6F5);

  static const Map<int, Color> colorMap = {
    50: Color(0x10192D6B),
    100: Color(0x20192D6B),
    200: Color(0x30192D6B),
    300: Color(0x40192D6B),
    400: Color(0x50192D6B),
    500: Color(0x60192D6B),
    600: Color(0x70192D6B),
    700: Color(0x80192D6B),
    800: Color(0x90192D6B),
    900: Color(0xff192D6B),
  };

  static const MaterialColor PRIMARY_MATERIAL = MaterialColor(0xFF192D6B, colorMap);
}
