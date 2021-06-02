import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/localization.dart';
import 'package:mbw204_club_ina/providers/theme.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/screens/inbox/inbox.dart';
import 'package:mbw204_club_ina/views/screens/sos/sos.dart';
import 'package:mbw204_club_ina/views/screens/dashboard/widgets/fancy_bottom_nav_bar.dart';
import 'package:mbw204_club_ina/views/screens/home/home.dart';
import 'package:mbw204_club_ina/views/screens/more/more.dart';

class DashBoardScreen extends StatelessWidget {
  final PageController pageController = PageController();

  final List<Widget> screens = [
    HomePage(),
    SosScreen(),
    InboxScreen(),
    MoreScreen(),
  ];
  final GlobalKey<FancyBottomNavBarState> bottomNavKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return WillPopScope(
          onWillPop: () async {
            if(Provider.of<ThemeProvider>(context, listen: true).pageIndex != 0) {
              bottomNavKey.currentState.setPage(0);
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            bottomNavigationBar: FancyBottomNavBar(
              key: bottomNavKey,
              initialSelection: value.pageIndex,
              isLtr: Provider.of<LocalizationProvider>(context).isLtr,
              isDark: Provider.of<ThemeProvider>(context).darkTheme,
              tabs: [
                FancyTabData(imagePath: Images.home_image, title: getTranslated('HOME', context)),
                FancyTabData(imagePath: Images.sos, title: getTranslated('PANIC_BUTTON', context)),
                FancyTabData(imagePath: Images.inbox_image, title: getTranslated('INBOX', context)),
                FancyTabData(imagePath: Images.more_image, title: getTranslated('MORE', context)),
              ],
              onTabChangedListener: (int index) {
                value.updatePage(index);
                pageController.jumpToPage(value.pageIndex);
              },
            ),
            body: PageView.builder(
              controller: pageController,
              itemCount: screens.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int i){
                return screens[i];
              },
            ),
          ),
        );  
      },
    );
  }
}