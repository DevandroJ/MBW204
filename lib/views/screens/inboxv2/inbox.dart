import 'package:intl/intl.dart';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mbw204_club_ina/views/screens/inbox/detail.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/inbox.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>  with TickerProviderStateMixin {
  int tabbarview = 0;
  String tabbarname = "sos";
  TabController tabController;
    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title: Text(getTranslated("INBOX", context), 
              style: poppinsRegular.copyWith(color: Colors.black)),
              elevation: 0.0,
              pinned: false,
              centerTitle: false,
              floating: true,
            ),
            SliverToBoxAdapter(
              child: TabBar(
                onTap: (val) {
                  switch (val) {
                    case 0:
                      setState(() {
                        tabbarview = val;       
                        tabbarname = "sos";
                      });
                    break;
                    case 1:
                      setState(() {
                        tabbarview = val;       
                        tabbarname = "payment";
                      });
                    break;
                    case 2:
                      setState(() {
                        tabbarview = val;       
                        tabbarname = "other";
                      });
                    break;
                    default:
                  }
                },
                controller: tabController,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: ColorResources.getWhiteToBlack(context),
                indicator: BubbleTabIndicator(
                  indicatorHeight: 32.0,
                  indicatorRadius: 6.0,
                  indicatorColor: ColorResources.getPrimaryToWhite(context),
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                labelStyle: poppinsRegular,
                tabs: [
                  Tab(text: "SOS"),
                  Tab(text: "Pembayaran"),
                  Tab(text: "Lainnya"),
                ]
              ),
            )
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            if(tabbarname == "sos")
              return getInbox(context, "sos");
            if(tabbarname == "payment")
              return getInbox(context, "payment");
            return getInbox(context, "other");
          },
        )
        
  
      )
    );
  }
  Widget tabSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: TabBar(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ColorResources.getWhiteToBlack(context),
        indicator: BubbleTabIndicator(
          indicatorHeight: 32.0,
          indicatorRadius: 6.0,
          indicatorColor: ColorResources.getPrimaryToWhite(context),
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
        labelStyle: poppinsRegular,
        tabs: [
          Tab(text: "SOS"),
          Tab(text: "Pembayaran"),
          Tab(text: "Lainnya"),
        ]
      ),
    );
  }  

  Widget getInbox(BuildContext context, String type) {
    Provider.of<InboxProvider>(context, listen: false).getInboxes(context, type);
    return Consumer<InboxProvider>(
      builder: (BuildContext context, InboxProvider inboxProvider, Widget child) {
        if(inboxProvider.inboxStatus == InboxStatus.loading) {
          return Loader(
            color: ColorResources.BTN_PRIMARY_SECOND,
          );
        }
        if(inboxProvider.inboxStatus == InboxStatus.error) {
          return Center(
            child: Text(getTranslated("THERE_WAS_PROBLEM", context),
              style: poppinsRegular,
            ),
          );
        }
        if(inboxProvider.inboxStatus == InboxStatus.empty) {
          return RefreshIndicator(
            backgroundColor: ColorResources.BTN_PRIMARY_SECOND,
            color: ColorResources.WHITE,
            onRefresh: () {
              return Provider.of<InboxProvider>(context, listen: false).getInboxes(context, type);         
            },
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Center(
                    child: Text(getTranslated("NO_INBOX_AVAILABLE", context),
                      style: poppinsRegular,
                    ),
                  ),
                ),
              ]
            ),
          );
        }
        return RefreshIndicator(
          backgroundColor: ColorResources.BTN_PRIMARY_SECOND,
          color: ColorResources.WHITE,
          onRefresh: () {
            return Provider.of<InboxProvider>(context, listen: false).getInboxes(context, type);         
          },
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: inboxProvider.inboxes.length,
            itemBuilder: (BuildContext context, int i) {
              
            return Column(
                children: [
                  Card(
                    elevation: 0.0,
                    child: Container(
                      child: ListTile(
                        onTap: () {
                          Future.delayed(Duration.zero, () async {
                            await Provider.of<InboxProvider>(context, listen: false).updateInbox(context, inboxProvider.inboxes[i].inboxId, type);
                          });
                          if(inboxProvider.inboxes[i].subject == "Emergency") {
                            Provider.of<ProfileProvider>(context, listen: false).getSingleUser(context, inboxProvider.inboxes[i].senderId);

                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                      
                                return Dialog(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 330.0,
                                      child: Consumer<ProfileProvider>(
                                        builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                                          return Column(
                                            children: [

                                              SizedBox(height: 20.0),

                                              Container(
                                                child: profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                ? SizedBox(
                                                    width: 18.0,
                                                    height: 18.0,
                                                    child: CircularProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation<Color>(ColorResources.getPrimaryToWhite(context)),
                                                    ),
                                                  )
                                                : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                ? CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    backgroundImage: NetworkImage("assets/images/profile.png"),
                                                    radius: 30.0,
                                                  )
                                                : CachedNetworkImage(
                                                  imageUrl: "${AppConstants.BASE_URL_IMG}${profileProvider.getSingleUserProfilePic}",
                                                  imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                                    return CircleAvatar(
                                                      backgroundColor: Colors.transparent,
                                                      backgroundImage: imageProvider,
                                                      radius: 30.0,
                                                    );
                                                  },
                                                  errorWidget: (BuildContext context, String url, dynamic error) {
                                                    return CircleAvatar(
                                                      backgroundColor: Colors.transparent,
                                                      backgroundImage: AssetImage("assets/images/profile.png"),
                                                      radius: 30.0,
                                                    );
                                                  },
                                                  placeholder: (BuildContext context, String text) => SizedBox(
                                                    width: 18.0,
                                                    height: 18.0,
                                                    child: CircularProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation<Color>(ColorResources.getPrimaryToWhite(context)),
                                                    ),
                                                  ),
                                                )  
                                              ),

                                              SizedBox(height: 16.0),

                                              Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                                child: Card(
                                                  elevation: 3.0,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text("Nama"),
                                                            Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                            ? "..." 
                                                            : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                            ? "..." 
                                                            : profileProvider.singleUserData.fullname)
                                                          ]
                                                        ),
                                                        SizedBox(height: 12.0),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text("No HP"),
                                                            Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                            ? "..." 
                                                            : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                            ? "..." 
                                                            : profileProvider.singleUserData.phoneNumber)
                                                          ]
                                                        ),
                                                      ],
                                                    )
                                                  ),
                                                ),
                                              ),

                                              Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                                child: Card(
                                                  elevation: 3.0,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [

                                                        Text(inboxProvider.inboxes[i].body,
                                                          textAlign: TextAlign.justify,
                                                          style: poppinsRegular.copyWith(
                                                            height: 1.4
                                                          ),
                                                        ),

                                                        SizedBox(height: 10.0),

                                                        FractionallySizedBox(
                                                          widthFactor: 1.0,
                                                          child: Container(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                RaisedButton(
                                                                  elevation: 3.0,
                                                                  color: ColorResources.GREEN,
                                                                  onPressed: profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                                  ? () {} 
                                                                  : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                                  ? () {}
                                                                  : () async {
                                                                    try {
                                                                      await launch("whatsapp://send?phone=${profileProvider.getSingleUserPhoneNumber}");
                                                                    } catch(e) {
                                                                      print(e);
                                                                    }
                                                                  },
                                                                  child: Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                                    ? "..."
                                                                    : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                                    ? "..."
                                                                    : "Whatsapp",
                                                                    style: poppinsRegular.copyWith(
                                                                      color: ColorResources.WHITE
                                                                    ),
                                                                  ),
                                                                ),
                                                                RaisedButton(
                                                                  elevation: 3.0,
                                                                  color: ColorResources.BLUE,
                                                                  onPressed: profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                                  ? () {} 
                                                                  : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                                  ? () {}
                                                                  : () async {
                                                                    try {
                                                                      await launch("tel:${profileProvider.getSingleUserPhoneNumber}");
                                                                    } catch(e) {
                                                                      print(e);
                                                                    }
                                                                  },
                                                                  child: Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                                    ? "..."
                                                                    : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                                    ? "..."
                                                                    : "Phone",
                                                                    style: poppinsRegular.copyWith(
                                                                      color: ColorResources.WHITE
                                                                    ),
                                                                  )
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                        
                                                      
                                                      ],
                                                    )
                                                  ),
                                                ),
                                              )
                                  
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                                  
                              },
                              animationType: DialogTransitionType.scale,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 1),
                            );
                          } else {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => InboxDetailScreen(
                                type: inboxProvider.inboxes[i].type,
                                body: inboxProvider.inboxes[i].body,
                                subject: inboxProvider.inboxes[i].subject,
                                field1: inboxProvider.inboxes[i].field1,
                                field2: inboxProvider.inboxes[i].field2,
                                field5: inboxProvider.inboxes[i].field5,
                                field6: inboxProvider.inboxes[i].field6
                              )),
                            );
                          }
                        },
                        isThreeLine: true,
                        dense: true,
                        leading: inboxProvider.inboxes[i].subject == "Emergency"  
                        ? Image.asset(
                            Images.sos,
                            width: 25.0,
                            height: 25.0,
                            color: ColorResources.getPrimaryToWhite(context),
                          ) 
                        : inboxProvider.inboxes[i].type == "payment.waiting" ||
                          inboxProvider.inboxes[i].type == "payment.paid" || 
                          inboxProvider.inboxes[i].type == "payment.expired"
                        ? Image.asset(
                            Images.money,
                            width: 25.0,
                            height: 25.0,
                            color: ColorResources.SUCCESS,
                          ) 
                        :
                          Icon(
                          inboxProvider.inboxStatus == InboxStatus.loading  
                          ? Icons.label
                          : inboxProvider.inboxStatus == InboxStatus.error 
                          ? Icons.label
                          : Icons.info,
                          color: inboxProvider.inboxes[i].type == "payment.waiting" ||
                          inboxProvider.inboxes[i].type == "payment.paid" || 
                          inboxProvider.inboxes[i].type == "payment.expired"
                          ? ColorResources.SUCCESS
                          : ColorResources.BLUE,
                        ),
                        title: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            inboxProvider.inboxStatus == InboxStatus.loading 
                            ? "..."
                            : inboxProvider.inboxStatus == InboxStatus.error 
                            ? "..." 
                            : inboxProvider.inboxes[i].subject,
                            style: poppinsRegular.copyWith(
                              fontWeight: inboxProvider.inboxes[i].read 
                              ? FontWeight.normal 
                              : FontWeight.bold
                            ),  
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(inboxProvider.inboxStatus == InboxStatus.loading 
                              ? "..."
                              : inboxProvider.inboxStatus == InboxStatus.error 
                              ? "..."
                              : inboxProvider.inboxes[i].body,
                                overflow: inboxProvider.inboxes[i].subject == "Emergency" 
                              ? TextOverflow.fade
                              : TextOverflow.ellipsis,
                                style: poppinsRegular.copyWith(
                                  height: 1.6
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(inboxProvider.inboxStatus == InboxStatus.loading 
                              ? "..."
                              : inboxProvider.inboxStatus == InboxStatus.error 
                              ? "..."
                              : DateFormat('dd MMM yyyy kk:mm').format(inboxProvider.inboxes[i].created.add(Duration(hours: 7))),
                                style: poppinsRegular.copyWith(
                                  fontSize: 11.0
                                ),
                              ),
                            )
                          ],
                        ) 
                      ),
                    ),
                  ),
                  Divider()
                ]
              );
                          


            },
          ),
        );   
      },
    );
  }
}

