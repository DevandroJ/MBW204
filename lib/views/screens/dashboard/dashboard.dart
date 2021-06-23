import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/views/screens/sos/sos.dart';
import 'package:mbw204_club_ina/views/screens/feed/notification_demo.dart';
import 'package:mbw204_club_ina/views/screens/membernear/list.dart';
import 'package:mbw204_club_ina/providers/inbox.dart';
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

  final List<Widget> screens = [
    HomePage(),
    MemberNearScreen(whereFrom: "dashboard"),
    SosScreen(),
    EventScreen(),
    NotificatioDemoScreen(),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<InboxProvider>(context, listen: false).getInboxes(context);
    
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: screens
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
            if(i == 1 || i == 2 || i == 4) {
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
                Icons.people,
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
                  image: AssetImage(Images.home_sos)
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
            icon: Container(
              width: 50.0,
              height: 60.0,
              child: Icon(
                Icons.notifications,
                size: 24.0,
              ),
            )
          ),
        ],
          controller: tabController,
        ),
      ),
    );

  }
}
