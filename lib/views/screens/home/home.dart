import 'dart:ui';

// import 'package:badges/badges.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mbw204_club_ina/providers/inbox.dart';
import 'package:mbw204_club_ina/views/screens/inbox/inbox.dart';
import 'package:mbw204_club_ina/utils/socket.dart';
import 'package:mbw204_club_ina/providers/chat.dart';
import 'package:mbw204_club_ina/views/screens/store/store_index.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/views/screens/media/media.dart';
import 'package:mbw204_club_ina/views/screens/ppob/ppob.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/screens/news/detail.dart';
import 'package:mbw204_club_ina/providers/nearmember.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/screens/nearmember/list.dart';
import 'package:mbw204_club_ina/views/basewidget/search.dart';
import 'package:mbw204_club_ina/views/screens/home/widgets/drawer.dart';
import 'package:mbw204_club_ina/providers/fcm.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/providers/banner.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/providers/news.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();    
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  TabController tabController;
  bool isEvent = false;
  bool lastStatus = true;

  bool get isShrink {
    return scrollController.hasClients && scrollController.offset > (245.0 - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<FcmProvider>(context, listen: false).initializing(context);
      Provider.of<FcmProvider>(context, listen: false).initFcm(context);
      Provider.of<LocationProvider>(context, listen: false).getCurrentPosition(context);
      Provider.of<NearMemberProvider>(context, listen: false).getCurrentPosition(context);
      Provider.of<LocationProvider>(context, listen: false).insertUpdateLatLng(context);
      Provider.of<BannerProvider>(context, listen: false).getBanner(context);
      Provider.of<ProfileProvider>(context, listen: false).getUserProfile(context);
      Provider.of<PPOBProvider>(context, listen: false).getBalance(context);
      Provider.of<NearMemberProvider>(context, listen: false).getNearMember(context); 
      Provider.of<NewsProvider>(context, listen: false).getNews(context, false); 
      Provider.of<ChatProvider>(context, listen: false).fetchListChat(context);
    });
    // scrollController = ScrollController();
    // scrollController.addListener(() {
    //   if (isShrink != lastStatus) {
    //     setState(() => lastStatus = isShrink);
    //   }
    // });
    SocketHelper.shared.connect(context);
  }

  Future<bool> onWillPop() {
    SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<InboxProvider>(context, listen: false).getInboxes(context, "payment");
    Provider.of<InboxProvider>(context, listen: false).getInboxes(context, "sos");
    Provider.of<InboxProvider>(context, listen: false).getInboxes(context, "other");

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        endDrawer: DrawerWidget(),
        body: SafeArea(
          child: DefaultTabController(
            length: 2,
            child: SafeArea(
              child: RefreshIndicator(
                backgroundColor: ColorResources.WHITE,
                color: ColorResources.BTN_PRIMARY,
                onRefresh: () {
                  return Future.delayed(Duration(seconds: 1), () {
                    Provider.of<FcmProvider>(context, listen: false).initializing(context);
                    Provider.of<FcmProvider>(context, listen: false).initFcm(context);
                    Provider.of<LocationProvider>(context, listen: false).getCurrentPosition(context);
                    Provider.of<LocationProvider>(context, listen: false).insertUpdateLatLng(context);
                    Provider.of<BannerProvider>(context, listen: false).getBanner(context);
                    Provider.of<ProfileProvider>(context, listen: false).getUserProfile(context);
                    Provider.of<PPOBProvider>(context, listen: false).getBalance(context);
                    Provider.of<NewsProvider>(context, listen: false).refresh(context, isEvent);
                    Provider.of<NearMemberProvider>(context, listen: false).getNearMember(context);
                  });               
                },
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                  
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      centerTitle: false,
                      expandedHeight: 25.h,
                      elevation: 0.0,
                      title: Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        width: MediaQuery.of(context).size.width,
                        child: SearchWidget(
                          hintText: "${getTranslated("SEARCH_EVENT", context)}",
                        ),
                      ),
                      actions: [
                        Container(
                          margin: EdgeInsets.only(top: 14.0, bottom: 14.0),
                          child: InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InboxScreen())),
                            child: Container(
                              width: 28.0,
                              height: 28.0,
                              margin: EdgeInsets.only(right: 10.sp),
                              decoration: BoxDecoration(
                                color: ColorResources.GREY,
                                borderRadius: BorderRadius.circular(20.0)
                              ),
                              child: 
                              // Badge(
                              //   position: BadgePosition(
                              //     top: -9.0,
                              //     end: 14.0
                              //   ),
                              //   badgeContent: Text("2",
                              //     style: poppinsRegular.copyWith(color: Colors.white),
                              //   ),
                              //   child: 
                                
                                Icon(
                                  Icons.chat,
                                  color: ColorResources.BLACK,
                                  size: 18.0,
                                ),
                              // ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 14.0, bottom: 14.0),
                          child: InkWell(
                            onTap: () => scaffoldKey.currentState.openEndDrawer(),
                            child: Container(
                              width: 28.0,
                              height: 28.0,
                              margin: EdgeInsets.only(right: 10.sp),
                              decoration: BoxDecoration(
                                color: ColorResources.GREY,
                                borderRadius: BorderRadius.circular(50.0)
                              ),
                              child: Icon(
                                Icons.menu,
                                color: ColorResources.BLACK,
                                size: 18.0,
                              )
                            ),
                          ),
                        )
                      ], 
                      backgroundColor: Colors.transparent,
                      flexibleSpace: Consumer<BannerProvider>(
                        builder: (BuildContext context, BannerProvider bannerProvider, Widget child) {
                          
                          if(bannerProvider.bannerStatus == BannerStatus.loading) {
                            return Container(
                              width: double.infinity,
                              height: 30.h,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[200],
                                    highlightColor: Colors.grey[200],
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: ColorResources.WHITE,
                                      )
                                    ),
                                  ),
                                ],
                              ) 
                            );
                          }

                          if(bannerProvider.bannerStatus == BannerStatus.empty)      
                            return Container(
                              width: double.infinity,
                              height: 30.h,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 120.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(getTranslated("NO_BANNER_AVAILABLE", context),
                                        style: poppinsRegular,
                                      ),
                                    ),
                                  )
                                ],
                              ) 
                            );

                          if(bannerProvider.bannerStatus == BannerStatus.error)      
                            return Container(
                              width: double.infinity,
                              height: 30.h,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 120.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                                        style: poppinsRegular,
                                      ),
                                    ),
                                  )
                                ],
                              ) 
                            );
                      
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              
                              CarouselSlider.builder(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 1.0,
                                  onPageChanged: (int index, CarouselPageChangedReason reason) {
                                    bannerProvider.setCurrentIndex(index);
                                  },
                                ),
                                itemCount: bannerProvider.bannerListMap.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return Container(
                                    width: double.infinity,
                                    child: CachedNetworkImage(
                                    imageUrl: "${AppConstants.BASE_URL_IMG}/${bannerProvider.bannerListMap[i]["path"]}",
                                    fit: BoxFit.cover,
                                    ),
                                  );                  
                                },
                              ),

                              Positioned(
                                bottom: 1.5.h,
                                left: 0.0,
                                right: 0.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: bannerProvider.bannerListMap.map((banner) {
                                    int index = bannerProvider.bannerListMap.indexOf(banner);
                                    return TabPageSelectorIndicator(
                                      backgroundColor: index == bannerProvider.currentIndex 
                                      ? ColorResources.BTN_PRIMARY 
                                      : ColorResources.WHITE,
                                      borderColor: Colors.white,
                                      size: 10.0,
                                    );
                                  }).toList(),
                                ),
                              ),

                            ],
                          );
                        },
                      ),
                    ),

                    // SliverPersistentHeader(
                    //   floating: false,
                    //   pinned: true,
                    //   delegate: SliverDelegate(
                    //     child: Container(
                    //       padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 16.0, right: 16.0),
                    //       decoration: BoxDecoration(
                    //         color: isShrink ? ColorResources.BTN_PRIMARY : Colors.transparent
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) 
                    //             Expanded(
                    //               child: SearchWidget(
                    //                 hintText: "${getTranslated("SEARCH_EVENT", context)}",
                    //               ),
                    //             ),
                    //           // SizedBox(width: 10.0),
                    //           // InkWell(
                    //           //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InboxScreen())),
                    //           //   child: Container(
                    //           //     width: 28.0,
                    //           //     height: 28.0,
                    //           //     decoration: BoxDecoration(
                    //           //       color: ColorResources.GREY,
                    //           //       borderRadius: BorderRadius.circular(20.0)
                    //           //     ),
                    //           //     child: Badge(
                    //           //       position: BadgePosition(
                    //           //         top: -9.0,
                    //           //         end: 14.0
                    //           //       ),
                    //           //       badgeContent: Text("2",
                    //           //         style: poppinsRegular.copyWith(color: Colors.white),
                    //           //       ),
                    //           //       child: Icon(
                    //           //         Icons.chat,
                    //           //         color: ColorResources.BLACK,
                    //           //         size: 17.0,
                    //           //       ),
                    //           //     ),
                    //           //   ),
                    //           // ),
                    //           SizedBox(width: 10.0),
                    //           InkWell(
                    //             onTap: () => scaffoldKey.currentState.openEndDrawer(),
                    //             child: Container(
                    //               width: 28.0,
                    //               height: 28.0,
                    //               decoration: BoxDecoration(
                    //                 color: ColorResources.GREY,
                    //                 borderRadius: BorderRadius.circular(20.0)
                    //               ),
                    //               child: Icon(
                    //                 Icons.menu,
                    //                 color: ColorResources.BLACK,
                    //                 size: 17.0,
                    //               ),
                    //             ),
                    //           ),
                    //         ]
                    //       )
                    //     )
                    //   )
                    // ),


              //       SliverToBoxAdapter(
              //         child:               Consumer<BannerProvider>(
              //   builder: (BuildContext context, BannerProvider bannerProvider, Widget child) {
                  
              //     if(bannerProvider.bannerStatus == BannerStatus.loading) {
              //       return Container(
              //         width: double.infinity,
              //         height: 30.h,
              //         child: Stack(
              //           fit: StackFit.expand,
              //           children: [
              //             Shimmer.fromColors(
              //               baseColor: Colors.grey[200],
              //               highlightColor: Colors.grey[200],
              //               child: Container(
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                   color: ColorResources.WHITE,
              //                 )
              //               ),
              //             ),
              //           ],
              //         ) 
              //       );
              //     }

              //     if(bannerProvider.bannerStatus == BannerStatus.empty)      
              //       return Container(
              //         width: double.infinity,
              //         height: 30.h,
              //         child: Stack(
              //           fit: StackFit.expand,
              //           children: [
              //             Container(
              //               margin: EdgeInsets.only(top: 120.0),
              //               child: Align(
              //                 alignment: Alignment.center,
              //                 child: Text("No Banner Available"),
              //               ),
              //             )
              //           ],
              //         ) 
              //       );
              
              //     return Container(
              //       width: double.infinity,
              //       child: Stack(
              //         children: [
                        
              //           CarouselSlider.builder(
              //             options: CarouselOptions(
              //               autoPlay: true,
              //               enlargeCenterPage: true,
              //               aspectRatio: 16 / 9,
              //               viewportFraction: 1.0,
              //               onPageChanged: (int index, CarouselPageChangedReason reason) {
              //                 bannerProvider.setCurrentIndex(index);
              //               },
              //             ),
              //             itemCount: bannerProvider.bannerListMap.length,
              //             itemBuilder: (BuildContext context, int i) {
              //               return Container(
              //                 width: double.infinity,
              //                 child: CachedNetworkImage(
              //                 imageUrl: "${AppConstants.BASE_URL_IMG}/${bannerProvider.bannerListMap[i]["path"]}",
              //                 fit: BoxFit.cover,
              //                 ),
              //               );                  
              //             },
              //           ),

              //           Positioned(
              //             bottom: 1.5.h,
              //             left: 0.0,
              //             right: 0.0,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: bannerProvider.bannerListMap.map((banner) {
              //                 int index = bannerProvider.bannerListMap.indexOf(banner);
              //                 return TabPageSelectorIndicator(
              //                   backgroundColor: index == bannerProvider.currentIndex 
              //                   ? ColorResources.BTN_PRIMARY 
              //                   : ColorResources.WHITE,
              //                   borderColor: Colors.white,
              //                   size: 10.0,
              //                 );
              //               }).toList(),
              //             ),
              //           ),

              //         ],
              //       )
              //     );
              //   },
              // ),
              //       ),

                    // SliverToBoxAdapter(
                    //   child: SizedBox(
                    //     height: 20.h
                    //   ),
                    // ),

                    SliverToBoxAdapter(
                      child: Consumer<AuthProvider>(
                        builder: (BuildContext context, AuthProvider authProvider, Widget child) {
                          if(authProvider.isLoggedIn()) {
                            return Container(
                              width: double.infinity,
                              height: 140.0,
                              decoration: BoxDecoration(
                                color: ColorResources.WHITE
                              ),
                              margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Consumer<NearMemberProvider>(
                                    builder: (BuildContext context, NearMemberProvider nearMemberProvider, Widget child) {
                                      if(nearMemberProvider.nearMemberStatus == NearMemberStatus.loading) {
                                        return Expanded(
                                          child: Loader(
                                            color: ColorResources.BTN_PRIMARY_SECOND,
                                          ),
                                        );
                                      }
                                      if(nearMemberProvider.nearMemberStatus == NearMemberStatus.empty) {
                                        return Expanded(
                                          child: Center(
                                            child: Text(getTranslated("NO_MEMBER_AVAILABLE", context),
                                              style: poppinsRegular,
                                            ),
                                          ),
                                        );
                                      }
                                      if(nearMemberProvider.nearMemberStatus == NearMemberStatus.error) {
                                        return Expanded(
                                          child: Center(
                                            child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                                              style: poppinsRegular,
                                            ),
                                          ),
                                        );
                                      }
                                    
                                      return Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ColorResources.WHITE,
                                            borderRadius: BorderRadius.circular(8.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 20,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.only(top: 15.0),
                                            child: ListView.builder(
                                              physics: AlwaysScrollableScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: nearMemberProvider.nearMemberData.length,
                                              itemBuilder: (BuildContext context, int i) {
                                                DateTime minutes = DateTime.now().subtract(Duration(minutes: int.parse(nearMemberProvider.nearMemberData[i].lastseenMinute)));
                                                return InkWell(
                                                  onTap: () {                                             
                                                    Provider.of<ProfileProvider>(context, listen: false).getSingleUser(context, nearMemberProvider.nearMemberData[i].userId);
                                                    showAnimatedDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (BuildContext context) {
                                                        return Dialog(
                                                          child: Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Container(
                                                              height: 180.0,
                                                              child: Consumer<ProfileProvider>(
                                                                builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                                                                  return Column(
                                                                    children: [
                                                                      
                                                                      SizedBox(height: 20.0),

                                                                      Container(
                                                                        child: CachedNetworkImage(
                                                                          imageUrl: "${AppConstants.BASE_URL_IMG}${profileProvider.getSingleUserProfilePic}",
                                                                          imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                                                            return CircleAvatar(
                                                                              backgroundImage: imageProvider,
                                                                              radius: 30.0,
                                                                            );
                                                                          },
                                                                          errorWidget: (BuildContext context, String url, dynamic error) {
                                                                            return Container(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                  color: ColorResources.BLACK,
                                                                                  width: 0.5
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(30.0)
                                                                              ),
                                                                              child: SvgPicture.asset('assets/images/svg/user.svg',
                                                                                width: 32.0,
                                                                                height: 32.0,
                                                                              ),
                                                                            );
                                                                          },
                                                                          placeholder: (BuildContext context, String text) => Loader(
                                                                            color: ColorResources.WHITE,
                                                                          )
                                                                        ),
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
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                                                ? "..." 
                                                                                : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                                                ? "..." 
                                                                                : profileProvider.singleUserData.fullname,
                                                                                  style: poppinsRegular,
                                                                                ),
                                                                                Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                                                ? "..." 
                                                                                : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                                                ? "..." 
                                                                                : "+- ${double.parse(nearMemberProvider.nearMemberData[i].distance) != null ? double.parse(nearMemberProvider.nearMemberData[i].distance) > 1000 ? (double.parse(nearMemberProvider.nearMemberData[i].distance) / 1000).toStringAsFixed(1) : double.parse(nearMemberProvider.nearMemberData[i].distance).toStringAsFixed(1) : 0} ${double.parse(nearMemberProvider.nearMemberData[i].distance) != null ? double.parse(nearMemberProvider.nearMemberData[i].distance) > 1000 ? 'KM' : 'Meters' : 0}",
                                                                                  style: poppinsRegular,
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ),
                                                                        ),
                                                                      ),                                                 

                                                                    ],
                                                                  );    
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        );           
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 0.0, left: i == 0 ? 6.0 : 5.0, right: 5.0),
                                                    child: Column(
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl: "${AppConstants.BASE_URL_IMG}${nearMemberProvider.nearMemberData[i].avatarUrl}",
                                                          imageBuilder: (BuildContext context, ImageProvider imageProvider) => CircleAvatar(
                                                            radius: 25.0,
                                                            backgroundImage: imageProvider
                                                          ),
                                                          placeholder: (BuildContext context, String url) => Container(
                                                            padding: EdgeInsets.all(8.0),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: ColorResources.BLACK,
                                                                width: 0.5
                                                              ),
                                                              borderRadius: BorderRadius.circular(30.0)
                                                            ),
                                                            child: SvgPicture.asset('assets/images/svg/user.svg',
                                                              width: 32.0,
                                                              height: 32.0,
                                                            ),
                                                          ),                                                
                                                          errorWidget: (BuildContext context, String url, dynamic error) => Container(
                                                            padding: EdgeInsets.all(8.0),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: ColorResources.BLACK,
                                                                width: 0.5
                                                              ),
                                                              borderRadius: BorderRadius.circular(30.0)
                                                            ),
                                                            child: SvgPicture.asset('assets/images/svg/user.svg',
                                                              width: 32.0,
                                                              height: 32.0,
                                                            ),
                                                          )
                                                        ),
                                                        Container(
                                                          width: 100.0,
                                                          margin: EdgeInsets.only(top: 4.0),
                                                          child: Text(nearMemberProvider.nearMemberData[i].fullname.toString(),
                                                          textAlign: TextAlign.center,
                                                            softWrap: true,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: poppinsRegular.copyWith(
                                                              fontSize: 11.0,
                                                            ),
                                                          ),
                                                        ),
                                                        Text('+- ${double.parse(nearMemberProvider.nearMemberData[i].distance) != null ? double.parse(nearMemberProvider.nearMemberData[i].distance) > 1000 ? (double.parse(nearMemberProvider.nearMemberData[i].distance) / 1000).toStringAsFixed(1) : double.parse(nearMemberProvider.nearMemberData[i].distance).toStringAsFixed(1) : 0} ${double.parse(nearMemberProvider.nearMemberData[i].distance) != null ? double.parse(nearMemberProvider.nearMemberData[i].distance) > 1000 ? 'KM' : 'Meters' : 0}',
                                                          softWrap: true,
                                                          textAlign: TextAlign.center,
                                                          style: poppinsRegular.copyWith(
                                                            color:Theme.of(context).hintColor,
                                                            fontSize: 11.0
                                                          )
                                                        ),
                                                        Text("(${timeago.format(minutes, locale: 'id')})",
                                                          style: poppinsRegular.copyWith(
                                                            fontSize: 8.0
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                  
                                ],
                              )
                            );
                          }
                          return Container();
                            // width: double.infinity,
                            // height: 80.0,
                            // margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                            // decoration: BoxDecoration(
                            //   color: ColorResources.WHITE
                            // ),                            
                            // Center(
                            //   child: RichText(
                            //     text: TextSpan(
                            //       text: "Anda harus ",
                            //       style: poppinsRegular.copyWith(
                            //         color: ColorResources.BLACK
                            //       ),
                            //       children: <TextSpan>[
                            //         TextSpan(text: 'Login',
                            //           style: poppinsRegular.copyWith(
                            //             color: ColorResources.BTN_PRIMARY_SECOND,
                            //             fontWeight: FontWeight.bold
                            //           ),
                            //           recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context,
                            //             MaterialPageRoute(builder: (context) => SignInScreen()),
                            //           ) 
                            //         ),
                            //         TextSpan(text: ' untuk melihat ini',
                            //           style: poppinsRegular.copyWith(
                            //           color: ColorResources.BLACK
                            //         ),
                            //         )
                            //       ]
                            //     ),
                            //   )
                            // )

                            
                          // );
                        },
                      )
                  
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 12.0, right: 12.0),
                        decoration: BoxDecoration(
                          color: ColorResources.WHITE
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: Provider.of<AuthProvider>(context, listen: false).isLoggedIn() ? MainAxisAlignment.spaceAround : MainAxisAlignment.start,
                              children: [
                                
                                InkWell(
                                  onTap: () {
                                    // if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                      return Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => MediaScreen()),
                                      );
                                    // } else {
                                    //   return showAnimatedDialog(
                                    //     context: context, 
                                    //     barrierDismissible: true,
                                    //     builder: (BuildContext context) {
                                    //       return Dialog(
                                    //         shape: RoundedRectangleBorder(
                                    //           borderRadius: BorderRadius.circular(10.0)
                                    //         ),
                                    //         backgroundColor: ColorResources.BLACK,
                                    //         child: Container(
                                    //           height: 250.0,
                                    //           child: Column(
                                    //             crossAxisAlignment: CrossAxisAlignment.center,
                                    //             mainAxisAlignment: MainAxisAlignment.center,
                                    //             children: [
                                    //               Text("Silahkan Login atau Buat Akun\nUntuk Bergabung!",
                                    //                 style: poppinsRegular.copyWith(
                                    //                   color: ColorResources.WHITE,
                                    //                   fontSize: 16.0
                                    //                 ),
                                    //                 textAlign: TextAlign.center,
                                    //               ),
                                    //               SizedBox(height: 10.0),
                                    //               Container(
                                    //                 width: double.infinity,
                                    //                 height: 40.0,
                                    //                 margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                    //                 decoration: BoxDecoration(
                                    //                   border: Border.all(
                                    //                     color: ColorResources.GRAY_LIGHT_PRIMARY,
                                    //                     width: 1.0
                                    //                   ),
                                    //                   borderRadius: BorderRadius.circular(30.0),
                                    //                     image: DecorationImage(
                                    //                       alignment: Alignment.centerLeft,
                                    //                       image: AssetImage(Images.wheel_btn)
                                    //                     )
                                    //                 ),
                                    //                 child: TextButton(
                                    //                   style: TextButton.styleFrom(
                                    //                     shape: RoundedRectangleBorder(
                                    //                       borderRadius: BorderRadius.circular(30.0),
                                    //                     ),
                                    //                     backgroundColor: Colors.transparent
                                    //                   ),
                                    //                   onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen())),
                                    //                   child: Text("Login",
                                    //                     style: poppinsRegular.copyWith(
                                    //                       color: ColorResources.GRAY_LIGHT_PRIMARY
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               )
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       );
                                    //     }
                                    //   );
                                    // }
                                  },
                                  child: Container(
                                    margin: Provider.of<AuthProvider>(context, listen: false).isLoggedIn() ? EdgeInsets.zero : EdgeInsets.only(left: 16.0, right: 16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 20.0,
                                              child: Image.asset(Images.media)
                                            ),
                                            SizedBox(width: 6.0),
                                            Text("Media",
                                              style: poppinsRegular.copyWith(
                                                fontSize: 11.0
                                              )
                                            )
                                          ],
                                        ),
                                        if(!Provider.of<AuthProvider>(context, listen: false).isLoggedIn())
                                          SizedBox(width: 8.0),
                                        if(!Provider.of<AuthProvider>(context, listen: false).isLoggedIn())
                                          Container(
                                            width: 250.0,
                                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                            decoration: BoxDecoration(
                                              color: ColorResources.BLACK,
                                              borderRadius: BorderRadius.circular(10.0)
                                            ),
                                            child: Image.asset(Images.logo,
                                              width: 70.0,
                                              height: 70.0,
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ),

                                if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn())
                                  Container(
                                    height: 30.0, 
                                    child: VerticalDivider(
                                      color: ColorResources.DIM_GRAY
                                    )
                                  ),

                                if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn())
                                  InkWell(
                                    onTap: () {
                                      if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                        return Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => StoreScreen()),
                                        );
                                      } else {
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
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 20.0,
                                          child: Image.asset(Images.mart)
                                        ),
                                        SizedBox(width: 10.0),
                                        Text("W204 Mart", 
                                          style: poppinsRegular.copyWith(
                                            fontSize: 11.0
                                          )
                                        )
                                      ],
                                    ),
                                  ),

                                if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn())
                                  Container(
                                    height: 30.0, 
                                    child: VerticalDivider(
                                      color: ColorResources.DIM_GRAY
                                    )
                                  ),
                                  
                                if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn())
                                  InkWell(
                                    onTap: () {
                                      if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                        return Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => PPOBScreen())
                                        );
                                      } else {
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
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 20.0,
                                          child: Image.asset(Images.ppob)
                                        ),
                                        SizedBox(width: 10.0),
                                        Text("PPOB",
                                          style: poppinsRegular.copyWith(
                                            fontSize: 11.0
                                          )
                                        )
                                      ],
                                    ),
                                  ),

                                if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn())
                                  Container(
                                    height: 30.0, 
                                    child: VerticalDivider(
                                      color: ColorResources.DIM_GRAY
                                    )
                                  ),
                                
                                if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn())
                                  InkWell(
                                    onTap: () {
                                      if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                        return Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => MemberNearScreen()),
                                        );
                                      } else {
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
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 20.0,
                                          child: Image.asset(Images.search_member)
                                        ),
                                        SizedBox(width: 10.0),
                                        Container(
                                          width: 80.0,
                                          child: Text(getTranslated("SEARCH_MEMBER", context),
                                            style: poppinsRegular.copyWith(
                                              fontSize: 11.0
                                            )
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                
                              ],
                            ),

                            Divider(
                              color: ColorResources.DIM_GRAY,
                            ),  
                          ],
                        ),
                      ),
                    ),

                    SliverPersistentHeader(
                      pinned: true,
                      delegate: StickyTabBarDelegate(
                        TabBar(
                          onTap: (val) {
                            switch (val) {
                              case 0:
                                Provider.of<NewsProvider>(context, listen: false).setStateGetNewsStatus(GetNewsStatus.loading);
                                Provider.of<NewsProvider>(context, listen: false).getNews(context, false);
                                setState(() => isEvent = false);
                              break;
                              case 1:
                                Provider.of<NewsProvider>(context, listen: false).setStateGetNewsStatus(GetNewsStatus.loading);
                                Provider.of<NewsProvider>(context, listen: false).getNews(context, true);
                                setState(() => isEvent = true);
                              break;
                              default:
                            }
                          },
                          controller: tabController,
                          indicatorColor: ColorResources.BLACK,
                          labelColor: ColorResources.BLACK,
                          unselectedLabelColor: ColorResources.GRAY_PRIMARY,
                          tabs: [
                            Tab(       
                              text: getTranslated("FAVORITE_NEWS", context)                            
                            ),
                            Tab(
                              text: getTranslated("EVENT_NEWS", context),
                            ),
                          ],
                        ),
                      )
                    ),

                    SliverFillRemaining(
                      child: TabBarView(
                        children: [

                          newsComponent(context),
                          newsComponent(context)

                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: ColorResources.WHITE,
                          //   ),
                          //   child: Container(
                          //     margin: EdgeInsets.only(top: 10.0),
                          //     child: ListView.builder(
                          //       physics: NeverScrollableScrollPhysics(),
                          //       itemCount: 3,
                          //       itemBuilder: (BuildContext context, int i) {
                          //         return Container(
                          //           color: ColorResources.WHITE,
                          //           width: double.infinity,
                          //           margin: EdgeInsets.only(left: 16.0, right: 16.0),
                          //           child: Card(
                          //             elevation: 2.0,
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(10.0)
                          //             ),
                          //             child: InkWell(
                          //               onTap: () {

                          //               },
                          //               child: Stack(
                          //                 children: [

                          //                   Row(
                          //                     crossAxisAlignment: CrossAxisAlignment.start,
                          //                     children: [
                          //                       CachedNetworkImage(
                          //                         imageUrl: "https://akcdn.detik.net.id/community/media/visual/2021/05/29/aksi-panggung-abdee-slank_169.jpeg?w=700&q=90",
                          //                           imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                          //                           width: 120.0,
                          //                           height: 80.0,
                          //                           decoration: BoxDecoration(
                          //                             borderRadius: BorderRadius.circular(10.0),
                          //                             image: DecorationImage(
                          //                               image: imageProvider, 
                          //                               fit: BoxFit.cover
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                       SizedBox(width: 10.0),
                          //                       Container(
                          //                         width: 200.0,
                          //                         margin: EdgeInsets.only(top: 10.0),
                          //                         child: Text("Akhirnya Erick Thohir Bersuara Alasan Abdee Slank Jadi Komisaris Telkom",
                          //                           softWrap: true,
                          //                           overflow: TextOverflow.ellipsis,
                          //                           style: poppinsRegular.copyWith(
                          //                             fontWeight: FontWeight.bold
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),

                          //                   Positioned(
                          //                     top: 55.0,
                          //                     right: 10.0,
                          //                     child: Text("Baca Selengkapnya",
                          //                       style: poppinsRegular.copyWith(
                          //                         fontWeight: FontWeight.normal,
                          //                         fontSize: 12.0
                          //                       ),
                          //                     )
                          //                   )

                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //     ),
                          //   )
                          // ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}

Widget newsComponent(BuildContext context) {
  return Consumer<NewsProvider>(
    builder: (BuildContext context, NewsProvider newsProvider, Widget child) {
      
      if(newsProvider.getNewsStatus == GetNewsStatus.loading) {
        return Loader(
          color: ColorResources.BTN_PRIMARY_SECOND,
        );
      }

      if(newsProvider.getNewsStatus == GetNewsStatus.empty) {
        return Center(
          child: Text(getTranslated("THERE_IS_NO_NEWS", context), 
            style: poppinsRegular,
          ),
        );
      }

      return Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: newsProvider.newsBody.length,
          itemBuilder: (BuildContext context, int i) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: ColorResources.WHITE,
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5
                ),
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Stack(
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: "${AppConstants.BASE_URL_IMG}/${newsProvider.newsBody[i].media[0].path}",
                          imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                          width: 120.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: imageProvider, 
                              fit: BoxFit.cover
                            ),
                          ),
                        ),
                        placeholder: (BuildContext context, String url) {
                          return Container(
                            width: 120.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: AssetImage('assets/images/default_image.png'), 
                                fit: BoxFit.cover
                              ),
                            ),
                          );                          
                        },
                        errorWidget: (BuildContext context, String url, dynamic error) {
                          return Container(
                            width: 120.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: AssetImage('assets/images/default_image.png'), 
                                fit: BoxFit.cover
                              ),
                            ),
                          );                                              
                        },
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        width: 180.0,
                        margin: EdgeInsets.only(top: 10.0),
                        child: Text(newsProvider.newsBody[i].title,
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular.copyWith(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),

                  Positioned(
                    top: 55.0,
                    right: 10.0,
                    child: InkWell(
                      onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetailNewsScreen(
                        title: newsProvider.newsBody[i].title,
                        content: newsProvider.newsBody[i].content,
                        date: newsProvider.newsBody[i].created,
                        imageUrl: newsProvider.newsBody[i].media[0].path,
                      ))),
                      child: Text(getTranslated("READ_MORE", context),
                        style: poppinsRegular.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0
                        ),
                      ),
                    )
                  )

                ],
              ),
            );
          },
        ),
      ); 
    },
  );
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {

  Widget child;
  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }

}
