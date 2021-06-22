import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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