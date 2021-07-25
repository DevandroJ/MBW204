import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/views/screens/feed/feed_index.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
import 'package:mbw204_club_ina/providers/inbox.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/views/screens/sos/sos.dart';
import 'package:mbw204_club_ina/views/screens/inboxv2/inbox.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/screens/event/event.dart';
import 'package:mbw204_club_ina/views/screens/home/home.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> with SingleTickerProviderStateMixin  {
 
  TabController tabController;

  List<Widget> screens = [
    HomePage(),
    FeedIndex(),
    SosScreen(),
    EventScreen(),
    InboxScreen(),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    Future.delayed(Duration.zero, () {
      Provider.of<InboxProvider>(context, listen: false).getInboxes(context, "purchase");
      Provider.of<InboxProvider>(context, listen: false).getInboxes(context, "payment");
      Provider.of<InboxProvider>(context, listen: false).getInboxes(context, "sos");
      Provider.of<InboxProvider>(context, listen: false).getInboxes(context, "other");
      Provider.of<InboxProvider>(context, listen: false).getInboxes(context, "disbursement");
      Provider.of<InboxProvider>(context, listen: false).getInboxes(context, "order");
    });
  }

  @override
  Widget build(BuildContext context) {
        
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: screens,
         physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0)
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 2.0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: TabBar(
          labelColor: ColorResources.BLACK,
          unselectedLabelColor: Colors.grey[400],
          labelStyle: TextStyle(fontSize: 13.0),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide.none,
          ),
          onTap: (int i) {
            if(i== 1 || i == 2 || i == 4) {
              if(!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                 tabController.animateTo(0);
                 return showAnimatedDialog(
                  context: context, 
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      backgroundColor: ColorResources.BLACK,
                      child: Container(
                        height: 250.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Silahkan Login atau Buat Akun\nUntuk Bergabung!",
                              style: poppinsRegular.copyWith(
                                color: ColorResources.WHITE,
                                fontSize: 16.0
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              width: double.infinity,
                              height: 40.0,
                              margin: EdgeInsets.only(left: 16.0, right: 16.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorResources.GRAY_LIGHT_PRIMARY,
                                  width: 1.0
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                                  image: DecorationImage(
                                    alignment: Alignment.centerLeft,
                                    image: AssetImage(Images.wheel_btn)
                                  )
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  backgroundColor: Colors.transparent
                                ),
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen())),
                                child: Text("Login",
                                  style: poppinsRegular.copyWith(
                                    color: ColorResources.GRAY_LIGHT_PRIMARY
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                );
              } 
            }
            // } else {
            //   if(i == 1) {
            //     tabController.animateTo(0);
            //     return showAnimatedDialog(
            //       context: context, 
            //       barrierDismissible: true,
            //       builder: (BuildContext context) {
            //         return Dialog(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10.0)
            //           ),
            //           backgroundColor: ColorResources.BLACK,
            //           child: Container(
            //             height: 250.0,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Text("Under Maintenance",
            //                   style: poppinsRegular.copyWith(
            //                     color: ColorResources.WHITE,
            //                     fontSize: 16.0
            //                   ),
            //                   textAlign: TextAlign.center,
            //                 ),
            //               ],
            //             ),
            //           ),
            //         );
            //       }
            //     );
            //   }
            // }
          },
        tabs: [
          Tab(
            icon: Container(
              width: 50.0,
              height: 60.0,
              child: Icon(
                Icons.home,
                size: 24.0,
              ),
            )
          ),
          Tab(
            icon: Container(
              width: 50.0,
              height: 60.0,
              child: Icon(
                Icons.forum,
                size: 24.0,
              ),
            )
          ),
          Tab(
            icon: Container(
              width: 50.0,
              height: 60.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/onboarding-sos.png')
                )
              ),
            )
          ),
          Tab(
            icon: Container(
              width: 45.0,
              child: Center(
              child: Icon(
                Icons.event,
                  size: 24.0,
                )
              )
            ),
          ),
          Tab(
            icon: Consumer<InboxProvider>(
              builder: (BuildContext context, InboxProvider inboxProvider, Widget child) {
                return Badge(
                  badgeColor: ColorResources.BTN_PRIMARY_SECOND,
                  position: BadgePosition.topEnd(top: -4.0, end: 26.0),
                  animationDuration: Duration(milliseconds: 300),
                  animationType: BadgeAnimationType.slide,
                  badgeContent: Text(
                    inboxProvider.inboxStatus == InboxStatus.loading 
                    ? "..." 
                    : inboxProvider.inboxStatus == InboxStatus.error 
                    ? "..."
                    : inboxProvider.readCount.toString(),
                    style: poppinsRegular.copyWith(
                      color: ColorResources.WHITE
                    ),
                  ),
                  child: Container(
                    width: 50.0,
                    height: 60.0,
                    child: Icon(
                      Icons.message,
                      size: 24.0,
                    ),
                  ),
                );
              },
            )
          ),
        ],
          controller: tabController,
        ),
      ),
    );

  }
}
