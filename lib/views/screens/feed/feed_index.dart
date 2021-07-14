import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/feed/add_groups.dart';
import 'package:mbw204_club_ina/views/screens/feed/all_member.dart';
import 'package:mbw204_club_ina/views/screens/feed/groups_detail.dart';
import 'package:mbw204_club_ina/views/screens/feed/notification.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/input_post_component.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/news_component.dart';

class FeedIndex extends StatefulWidget {
  @override
  _FeedIndexState createState() => _FeedIndexState();
}

class _FeedIndexState extends State<FeedIndex> with TickerProviderStateMixin {
  FeedState feedState = getIt<FeedState>();
  TabController tabController;
  GlobalKey g1Key = GlobalKey();
  GlobalKey g2Key = GlobalKey();
  GlobalKey g3Key = GlobalKey();
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey1 = GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey2 = GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey3 = GlobalKey<RefreshIndicatorState>();
  TextEditingController postTextEditingController = TextEditingController();
  TextEditingController commentTextEditingController = TextEditingController();
  FocusNode groupsFocusNode = FocusNode();
  FocusNode commentFocusNode = FocusNode();

  Future refresh() async {
    Future.delayed(Duration.zero, () {
      feedState.fetchGroupsMostRecent();
      feedState.fetchGroupsMostPopular();
      feedState.fetchGroupsSelf();
    });
  }

  Future<bool> onWillPop() async {
    return (showDialog(context: context,
      builder: (context) => AlertDialog(
        title: Text(getTranslated("EXIT_PAGE", context),
          style: TextStyle(
            color: ColorResources.getPrimaryToWhite(context), 
            fontWeight: FontWeight.bold
          ),
        ),
        content: Text(getTranslated("EXIT_PAGE_FROM_COMMUNITY", context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(getTranslated("NO", context)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(getTranslated("YES", context))
          ),
        ],
      ),
    )) ??
    false;
  }

  Widget groupslistSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
        child: Observer(builder: (_) {
          if (feedState.groupsMetaDataStatus == GroupsMetaDataStatus.loading) {
            return Container(
              height: 80.0,
              child: Loader(
                color: ColorResources.getPrimaryToWhite(context),
              )
            );
          }
          if (feedState.groupsMetaDataStatus == GroupsMetaDataStatus.empty) {
            return Container(
              height: 100.0,
              child: Center(
                child: Text('Belum ada grup')
              ),
            );
          }
          return Container(
            height: 100.0,
              child: NotificationListener<ScrollNotification>(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: feedState.groupsMetaData.nextCursor != null ? feedState.groupsMetaDataList.length + 1 : feedState.groupsMetaDataList.length,
                  itemBuilder: (BuildContext context, int i) {
                    if (feedState.groupsMetaDataList.length == i) {
                      return Center(
                        child: SizedBox(
                          width: 15.0,
                          height: 15.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(ColorResources.getPrimaryToWhite(context)),
                          )
                        )
                      );
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => GroupsDetailScreen(
                            groupsMetaDataListBody: feedState.groupsMetaDataList[i],
                          ),
                        ));
                      },
                      child: Container(
                        width: 110.0,
                        child: Column(
                          children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: feedState.groupsMetaDataList[i].profilePic?.path == null
                            ? AssetImage('assets/logo.png')
                            : NetworkImage('${AppConstants.BASE_URL_IMG}${feedState.groupsMetaDataList[i].profilePic.path}'),
                          ),
                          SizedBox(height: 8.0),
                          Text(feedState.groupsMetaDataList[i].name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black)
                          )
                        ]
                      )
                    ));
                  },
                ),
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    if (feedState.groupsMetaData.nextCursor != null) {
                      feedState.fetchGroupsMetaDataListLoad(feedState.groupsMetaData.nextCursor);
                    }
                  }
                  return false;
                },
              ));
        }),
      ),
    );
  }

  Widget memberAndAddGroupsSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
            child: RawMaterialButton(
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => AddGroupsScreen(),
                ),
              );
            },
            elevation: 0.0,
            fillColor: ColorResources.getPrimaryToWhite(context),
            child: Text('+',
              style: TextStyle(
                fontSize: 20.0, 
                color: Colors.white
              ),
            ),
            padding: EdgeInsets.all(10.0),
            shape: CircleBorder(),
          )),
          Container(
            child: RaisedButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllMemberScreen()),
                );
              },
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: ColorResources.getPrimaryToWhite(context),
              child: Text('All Member', style: TextStyle(color: Colors.white)),
            ),
          )
        ]),
      ),
    );
  }

  Widget tabSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: TabBar(
        controller: tabController,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ColorResources.getWhiteToBlack(context),
        indicator: BubbleTabIndicator(
          indicatorHeight: 30.0,
          indicatorRadius: 10.0,
          indicatorColor: ColorResources.getPrimaryToWhite(context),
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
        labelStyle: poppinsRegular,
      tabs: [
        Tab(text: getTranslated("LATEST", context)),
        Tab(text: getTranslated("POPULAR", context)),
        Tab(text: getTranslated("ME", context)),
      ]),
    );
  }

  Widget tabbarviewsection(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: tabController,
      children: [
        Observer(builder: (_) {
          if (feedState.groupsMostRecentStatus == GroupsMostRecentStatus.loading) {
            return Loader(
              color: ColorResources.getPrimaryToWhite(context),
            );
          }
          if (feedState.groupsMostRecentStatus == GroupsMostRecentStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_POST", context), style: poppinsRegular)
            );
          }
          if (feedState.groupsMostRecentStatus == GroupsMostRecentStatus.error) {
            return Center(
              child: Text(getTranslated("THERE_WAS_PROBLEM", context), style: poppinsRegular,)
            );
          }
          return NotificationListener<ScrollNotification>(
            child: RefreshIndicator(
              backgroundColor: ColorResources.getPrimaryToWhite(context),
              color: ColorResources.getWhiteToBlack(context),
              key: refreshIndicatorKey1,
                onRefresh: refresh,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int i) {
                    return Container(
                      color: Colors.blueGrey[50],
                      height: 40.0,
                    );
                  },
                  physics: AlwaysScrollableScrollPhysics(),
                  key: g1Key,
                  itemCount: feedState.g1.nextCursor != null ? feedState.g1List.length + 1 : feedState.g1List.length,
                  itemBuilder: (BuildContext content, int i) {
                  if (feedState.g1List.length == i) {
                    return Loader(
                      color: ColorResources.getPrimaryToWhite(context)
                    );
                  }
                  return NewsComponent(
                    i: i,
                    groupsBody: feedState.g1List,
                  );
                }
              ),
            ),
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                if (feedState.g1.nextCursor != null) {
                  feedState.fetchGroupsMostRecentLoad(feedState.g1.nextCursor);
                  feedState.g1.nextCursor = null;
                }
              }
              return false;
            },
          );
        }),
        Observer(builder: (_) {
          if (feedState.groupsMostPopularStatus == GroupsMostPopularStatus.loading) {
            return Loader(
              color: ColorResources.getPrimaryToWhite(context)
            );
          }
          if (feedState.groupsMostPopularStatus == GroupsMostPopularStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_POST", context),
                style: poppinsRegular,
              )
            );
          }
          if (feedState.groupsMostPopularStatus == GroupsMostPopularStatus.error) {
            return Center(
              child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                style: poppinsRegular,
              )
            );
          }
          return NotificationListener<ScrollNotification>(
            child: RefreshIndicator(
              key: refreshIndicatorKey2,
              backgroundColor: ColorResources.getPrimaryToWhite(context),
              color: ColorResources.getWhiteToBlack(context),
              onRefresh: refresh,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int i) {
                  return Container(
                    color: Colors.blueGrey[50],
                    height: 40.0,
                  );
                },
                physics: AlwaysScrollableScrollPhysics(),
                key: g2Key,
                itemCount: feedState.g2.nextCursor != null ? feedState.g2List.length + 1 : feedState.g2List.length,
                itemBuilder: (BuildContext content, int i) {
                  if (feedState.g2List.length == i) {
                    return Loader(
                      color: ColorResources.getPrimaryToWhite(context),
                    );
                  }
                  return NewsComponent(
                    i: i,
                    groupsBody: feedState.g2List,
                  );
                },
              ),
            ),
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                if (feedState.g2.nextCursor != null) {
                  feedState.fetchGroupsMostPopularLoad(feedState.g2.nextCursor);
                  feedState.g2.nextCursor = null;
                }
              }
              return false;
            },
          );
        }),
        Observer(builder: (_) {
          if (feedState.groupsSelfStatus == GroupsSelfStatus.loading) {
            return Loader(
              color: ColorResources.getPrimaryToWhite(context),
            );
          }
          if (feedState.groupsSelfStatus == GroupsSelfStatus.empty) {
            return Center(
              child: Text(
                getTranslated("THERE_IS_NO_POST", context),
                style: poppinsRegular,
              )
            );
          }
          if (feedState.groupsSelfStatus == GroupsSelfStatus.error) {
            return Center(
              child: Text('Ups! Server sedang ada gangguan, Mohon tunggu...')
            );
          }
          return NotificationListener<ScrollNotification>(
            child: RefreshIndicator(
              key: refreshIndicatorKey3,
              backgroundColor: ColorResources.getPrimaryToWhite(context),
              color: ColorResources.getWhiteToBlack(context),
              onRefresh: refresh,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int i) {
                  return Container(
                    color: Colors.blueGrey[50],
                    height: 40.0,
                  );
                },
                key: g3Key,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: feedState.g3.nextCursor != null ? feedState.g3List.length + 1 : feedState.g3List.length,
                itemBuilder: (BuildContext content, int i) {
                  if (feedState.g3List.length == i) {
                    return Loader(
                      color: ColorResources.getPrimaryToWhite(context),
                    );
                  }
                  return NewsComponent(
                    i: i,
                    groupsBody: feedState.g3List,
                  );
                },
              ),
            ),
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                if (feedState.g3.nextCursor != null) {
                  feedState.fetchGroupsSelfLoad(feedState.g3.nextCursor);
                  feedState.g3.nextCursor = null;
                }
              }
              return false;
            },
          );
        }),
      ]
    );
  }

  void initState() {
    super.initState();
    (() async {
      // await feedState.fetchGroupsMetaDataList();
      await feedState.fetchGroupsMostRecent();
      await feedState.fetchGroupsMostPopular();
      await feedState.fetchGroupsSelf();
    })();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  void dipsose() {
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
     onWillPop: onWillPop,
     child: Scaffold(
      body: NestedScrollView(
        physics: ScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
        return [
          SliverAppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title: Text('Community Feed',
             style: poppinsRegular.copyWith(
               color: ColorResources.BLACK,
               fontSize: 16.0
              )
            ),
            leading: IconButton(
              icon: Icon(
                Platform.isIOS 
                ? Icons.arrow_back_ios 
                : Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.notifications,
                  color: ColorResources.getPrimaryToBlack(context)
                ),
              ),
            ],
            elevation: 0.0,
            forceElevated: true,
            pinned: true,
            centerTitle: false,
            floating: true,
          ),
          // groupslistSection(context),
          // memberAndAddGroupsSection(context),
          InputPostComponent(null),
          tabSection(context)
          ];
        },
        body: tabbarviewsection(context),
        )
      )
    );
  }
}
