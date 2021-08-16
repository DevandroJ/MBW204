import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:mbw204_club_ina/container.dart';

import 'package:mbw204_club_ina/data/models/feed/groupsmetadata.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/socket.dart';
import 'package:mbw204_club_ina/views/screens/feed/edit_groups.dart';
import 'package:mbw204_club_ina/views/screens/feed/groups_member.dart';
import 'package:mbw204_club_ina/views/screens/feed/notification.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/input_post_component.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/news_component.dart';

class GroupsDetailScreen extends StatefulWidget {
  final GroupsMetaDataListBody groupsMetaDataListBody;

  GroupsDetailScreen({this.groupsMetaDataListBody});

  @override
  _GroupsDetailScreenState createState() => _GroupsDetailScreenState();
}

class _GroupsDetailScreenState extends State<GroupsDetailScreen> with TickerProviderStateMixin {
  FeedState groupsState = getIt<FeedState>();
  TabController tabController;
  GlobalKey g1Key = GlobalKey();
  GlobalKey g2Key = GlobalKey();
  GlobalKey g3Key = GlobalKey();

  Widget bannersection(BuildContext context) {
    return SliverToBoxAdapter(child: Observer(
      builder: (_) {
        if (groupsState.singleGroupStatus == SingleGroupStatus.loading) {
          return Container(
            height: 80.0,
            child: Center(
              child: SizedBox(
                width: 15.0,
                height: 15.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
            )
          );
        }
        if (groupsState.singleGroupStatus == SingleGroupStatus.empty) {
          return Center(child: Text('Belum ada group'));
        }
        return Stack(overflow: Overflow.visible, children: [
          Container(
            height: 150.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    image: groupsState.singleGroup.body.background?.path == null
                        ? AssetImage('assets/logo.png')
                        : NetworkImage("${AppConstants.BASE_URL_IMG}${groupsState.singleGroup.body.background.path}"))),
          ),
          Positioned(
            top: 20.0,
            left: 20.0,
            child: Container(
            child: CircleAvatar(
              backgroundColor: Colors.red,
              backgroundImage: groupsState.singleGroup.body.profilePic?.path ==
                      null
                  ? AssetImage('assets/logo.png')
                  : NetworkImage(
                      '${AppConstants.BASE_URL_IMG}${groupsState.singleGroup.body.profilePic.path}'),
              radius: 48.0,
            )),
          ),
          Positioned(
            top: 90.0,
            left: 115.0,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditGroupScreen(groupsState.singleGroup.body.id),
                  ),
                );
              },
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Colors.red,
              child: Text('Edit', style: TextStyle(color: Colors.white)),
            ),
          ),
          Positioned(
            top: 90.0,
            left: 210.0,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupsMemberScreen(
                      groupId: groupsState.singleGroup.body.id
                    )
                  ),
                );
              },
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Colors.red,
              child:
                  Text('Group Members', style: TextStyle(color: Colors.white)),
            ),
          )
        ]);
      },
    ));
  }

  Widget tabbarviewsection(BuildContext context) {
    return TabBarView(controller: tabController, children: [
      Observer(builder: (_) {
        if (groupsState.groupsMostRecentStatusC == GroupsMostRecentStatusC.loading) {
          return Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              )
            )
          );
        }
        if (groupsState.groupsMostRecentStatusC == GroupsMostRecentStatusC.empty) {
          return Center(child: Text('Belum ada post'));
        }
        return NotificationListener<ScrollNotification>(
          child: ListView.builder(
            key: g1Key,
            physics: BouncingScrollPhysics(),
            itemCount: groupsState.g1child.nextCursor != null
                ? groupsState.g1ListC.length + 1
                : groupsState.g1ListC.length,
            itemBuilder: (BuildContext content, int i) {
              if (groupsState.g1ListC.length == i) {
                return Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    )
                  )
                );
              }
              return NewsComponent(
                i: i,
                groupsBody: groupsState.g1ListC,
              );
            },
          ),
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              if (groupsState.g1child.nextCursor != null) {
                groupsState.fetchGroupsMostRecentChildLoad(
                    groupsState.g1child.nextCursor);
              }
            }
            return false;
          },
        );
      }),
      Observer(builder: (_) {
        if (groupsState.groupsMostPopularStatusC == GroupsMostPopularStatusC.loading) {
          return Center(
            child: SizedBox(
              width: 15.0,
              height: 15.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red)
              )
            )
          );
        }
        if (groupsState.groupsMostPopularStatusC == GroupsMostPopularStatusC.empty) {
          return Center(child: Text('Belum ada post'));
        }
        return NotificationListener<ScrollNotification>(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            key: g2Key,
            itemCount: groupsState.g2child.nextCursor != null
                ? groupsState.g2ListC.length + 1
                : groupsState.g2ListC.length,
            itemBuilder: (BuildContext content, int i) {
              if (groupsState.g2ListC.length == i) {
                return Center(
                child: SizedBox(
                    width: 15.0,
                    height: 15.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    )
                  )
                );
              }
              return NewsComponent(
                i: i,
                groupsBody: groupsState.g2ListC,
              );
            },
          ),
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              if (groupsState.g2child.nextCursor != null) {
                groupsState.fetchGroupsMostPopularChildLoad(
                    groupsState.g2child.nextCursor);
              }
            }
            return false;
          },
        );
      }),
      Observer(builder: (_) {
        if (groupsState.groupsSelfStatusC == GroupsSelfStatusC.loading) {
          return Center(
            child: SizedBox(
              width: 15.0,
              height: 15.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              )
            )
          );
        }
        if (groupsState.groupsSelfStatusC == GroupsSelfStatusC.empty) {
          return Center(child: Text('Belum ada post'));
        }
        return NotificationListener<ScrollNotification>(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            key: g3Key,
            itemCount: groupsState.g3child.nextCursor != null
                ? groupsState.g3ListC.length + 1
                : groupsState.g3ListC.length,
            itemBuilder: (BuildContext content, int i) {
              if (groupsState.g3ListC.length == i) {
                return Center(
                  child: SizedBox(
                    width: 15.0,
                    height: 15.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    )
                  )
                );
              }
              return NewsComponent(
                i: i,
                groupsBody: groupsState.g3ListC,
              );
            },
          ),
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              if (groupsState.g3child.nextCursor != null) {
                groupsState.fetchGroupsSelfChildLoad(groupsState.g3child.nextCursor);
              }
            }
            return false;
          },
        );
      }),
    ]);
  }

  Widget tabsection(BuildContext context) {
    return SliverToBoxAdapter(
      child: TabBar(
          controller: tabController,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BubbleTabIndicator(
            indicatorHeight: 30.0,
            indicatorColor: Colors.red,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: [
            Tab(text: 'LATEST'),
            Tab(text: 'POPULAR'),
            Tab(text: 'ME'),
          ]),
    );
  }

  void initState() {
    super.initState();
    (() async {
      await groupsState.fetchGroup(widget.groupsMetaDataListBody.id);
      await groupsState.fetchGroupsMostRecentChild(widget.groupsMetaDataListBody.id);
      await groupsState.fetchGroupsMostPopularChild(widget.groupsMetaDataListBody.id);
      await groupsState.fetchGroupsSelfChild(widget.groupsMetaDataListBody.id);
    })();
    tabController = TabController(length: 3, vsync: this, initialIndex: 2);
  }

  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
              return [
                SliverAppBar(
                  brightness: Brightness.light,
                  backgroundColor: Colors.white,
                  title: Observer(builder: (_) {
                    if (groupsState.singleGroupStatus ==
                        SingleGroupStatus.loading) {
                      return Container();
                    }
                    return Text(groupsState.singleGroup.body.name,
                        style: TextStyle(color: Colors.black));
                  }),
                  leading: IconButton(
                    icon: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  elevation: 0.0,
                  pinned: false,
                  centerTitle: false,
                  floating: true,
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
                bannersection(context),
                InputPostComponent(
                  groupId: widget.groupsMetaDataListBody.id,
                  globalKey: null,
                ),
                tabsection(context),
              ];
            },
            body: tabbarviewsection(context)));
  }
}
