import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/views/screens/media/media.dart';
import 'package:mbw204_club_ina/views/screens/ppob/ppob.dart';
import 'package:mbw204_club_ina/views/screens/warung/warung_index.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/screens/news/detail.dart';
import 'package:mbw204_club_ina/providers/nearmember.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/screens/inbox/inbox.dart';
import 'package:mbw204_club_ina/views/screens/membernear/list.dart';
import 'package:mbw204_club_ina/views/basewidget/search.dart';
import 'package:mbw204_club_ina/views/screens/home/widgets/drawer.dart';
import 'package:mbw204_club_ina/providers/fcm.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/providers/inbox.dart';
import 'package:mbw204_club_ina/providers/banner.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<FcmProvider>(context, listen: false).initializing(context);
      Provider.of<FcmProvider>(context, listen: false).initFcm(context);
      Provider.of<LocationProvider>(context, listen: false).getCurrentPosition(context);
      Provider.of<LocationProvider>(context, listen: false).insertUpdateLatLng(context);
      Provider.of<BannerProvider>(context, listen: false).getBanner(context);
      Provider.of<InboxProvider>(context, listen: false).getInboxes(context);
      Provider.of<ProfileProvider>(context, listen: false).getUserProfile(context);
      Provider.of<PPOBProvider>(context, listen: false).getBalance(context);
      Provider.of<NewsProvider>(context, listen: false).getNews(context);
      Provider.of<NearMemberProvider>(context, listen: false).getNearMember(context);  
    });
  }

  Future<bool> onWillPop() {
    SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        endDrawer: DrawerWidget(),
        body: Stack(
          children: [
          
            Consumer<BannerProvider>(
              builder: (BuildContext context, BannerProvider bannerProvider, Widget child) {
                
                if(bannerProvider.bannerStatus == BannerStatus.loading) {
                  return Container(
                    width: double.infinity,
                    height: 230.0,
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
                    height: 230.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 120.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("No Banner Available"),
                          ),
                        )
                      ],
                    ) 
                  );
            
                return Container(
                  width: double.infinity,
                  height: 230.0,
                  child: Stack(
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)
                              ),
                              child: CachedNetworkImage(
                              imageUrl: "${AppConstants.BASE_URL_IMG}/${bannerProvider.bannerListMap[i]["path"]}",
                              fit: BoxFit.cover,
                              ),
                            ),
                          );                  
                        },
                      ),

                      Positioned(
                        bottom: 5.0,
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
                  )
                );
              },
            ),
           
            DefaultTabController(
              length: 2,
              child: SafeArea(
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [

                    SliverAppBar(
                      floating: true,
                      elevation: 0.0,
                      centerTitle: false,
                      toolbarHeight: 10, 
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent
                    ),

                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverDelegate(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL, 
                          ),
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) 
                              Expanded(
                                child: SearchWidget(
                                  hintText: "${getTranslated("SEARCH", context)} Event",
                                )
                              ),
                              SizedBox(width: 10.0),
                              InkWell(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InboxScreen())),
                                child: Container(
                                  width: 28.0,
                                  height: 28.0,
                                  decoration: BoxDecoration(
                                    color: ColorResources.GREY,
                                    borderRadius: BorderRadius.circular(20.0)
                                  ),
                                  child: Badge(
                                    position: BadgePosition(
                                      top: -9.0,
                                      end: 14.0
                                    ),
                                    badgeContent: Text("2",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    child: Icon(
                                      Icons.chat,
                                      color: ColorResources.BLACK,
                                      size: 17.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              InkWell(
                                onTap: () => scaffoldKey.currentState.openEndDrawer(),
                                child: Container(
                                  width: 28.0,
                                  height: 28.0,
                                  decoration: BoxDecoration(
                                    color: ColorResources.GREY,
                                    borderRadius: BorderRadius.circular(20.0)
                                  ),
                                  child: Icon(
                                    Icons.menu,
                                    color: ColorResources.BLACK,
                                    size: 17.0,
                                  ),
                                ),
                              ),
                            ]
                          )
                        )
                      )
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 150.0,
                      ),
                    ),

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

                                  Container(
                                    alignment: Alignment.centerRight,
                                    margin: EdgeInsets.only(top: 10.0, right: 10.0),
                                    child: InkWell(
                                      onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => MemberNearScreen(whereFrom: "home"))),
                                      child: Text(getTranslated("ALL_MEMBER", context),
                                      textAlign: TextAlign.end,
                                        style: poppinsRegular.copyWith(
                                          fontSize: 13.0
                                        ),
                                      ),
                                    ),
                                  ),

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
                                        child: ListView.builder(
                                          physics: AlwaysScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: nearMemberProvider.nearMemberData.length,
                                          itemBuilder: (BuildContext context, int i) {
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
                                                                        backgroundImage: NetworkImage("assets/images/profile-drawer.png"),
                                                                        radius: 30.0,
                                                                      )
                                                                    : CachedNetworkImage(
                                                                      imageUrl: "${AppConstants.BASE_URL_IMG}${profileProvider.getSingleUserProfilePic}",
                                                                      imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                                                        return CircleAvatar(
                                                                          backgroundImage: imageProvider,
                                                                          radius: 30.0,
                                                                        );
                                                                      },
                                                                      errorWidget: (BuildContext context, String url, dynamic error) {
                                                                        return CircleAvatar(
                                                                          backgroundColor: ColorResources.WHITE,
                                                                          backgroundImage: AssetImage("assets/images/profile-drawer.png"),
                                                                          radius: 30.0,
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
                                                    Container(
                                                      child: CachedNetworkImage(
                                                        imageUrl: "${AppConstants.BASE_URL_IMG}${nearMemberProvider.nearMemberData[i].avatarUrl}",
                                                        imageBuilder: (BuildContext context, ImageProvider imageProvider) => CircleAvatar(
                                                          radius: 25.0,
                                                          backgroundImage: imageProvider
                                                        ),
                                                        placeholder: (BuildContext context, String url) => CircleAvatar(
                                                          backgroundColor: ColorResources.WHITE,
                                                          radius: 25.0,
                                                          child: Loader(
                                                            color: ColorResources.BTN_PRIMARY,
                                                          ),
                                                        ),                                                
                                                        errorWidget: (BuildContext context, String url, dynamic error) => CircleAvatar(
                                                          radius: 25.0,
                                                          backgroundColor: ColorResources.WHITE,
                                                          backgroundImage: AssetImage('assets/images/profile-drawer.png')
                                                        ),
                                                      ),
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
                                                    Container(
                                                      width: 40.0,
                                                      child: Text('+ - ${double.parse(nearMemberProvider.nearMemberData[i].distance) != null ? double.parse(nearMemberProvider.nearMemberData[i].distance) > 1000 ? (double.parse(nearMemberProvider.nearMemberData[i].distance) / 1000).toStringAsFixed(1) : double.parse(nearMemberProvider.nearMemberData[i].distance).toStringAsFixed(1) : 0} ${double.parse(nearMemberProvider.nearMemberData[i].distance) != null ? double.parse(nearMemberProvider.nearMemberData[i].distance) > 1000 ? 'KM' : 'Meters' : 0}',
                                                        softWrap: true,
                                                        maxLines: 2,
                                                        textAlign: TextAlign.center,
                                                        style: poppinsRegular.copyWith(
                                                          color:Theme.of(context).hintColor,
                                                          fontSize: 11.0
                                                        )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
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
                            //       style: TextStyle(
                            //         color: ColorResources.BLACK
                            //       ),
                            //       children: <TextSpan>[
                            //         TextSpan(text: 'Login',
                            //           style: TextStyle(
                            //             color: ColorResources.BTN_PRIMARY_SECOND,
                            //             fontWeight: FontWeight.bold
                            //           ),
                            //           recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context,
                            //             MaterialPageRoute(builder: (context) => SignInScreen()),
                            //           ) 
                            //         ),
                            //         TextSpan(text: ' untuk melihat ini',
                            //           style: TextStyle(
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
                        margin: EdgeInsets.only(left: 16.0, right: 16.0),
                        decoration: BoxDecoration(
                          color: ColorResources.WHITE
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: Provider.of<AuthProvider>(context, listen: false).isLoggedIn() ? MainAxisAlignment.spaceAround : MainAxisAlignment.start,
                              children: [
                                
                                InkWell(
                                  onTap: () {
                                    if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                      return Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => MediaScreen()),
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
                                      Row(
                                        children: [
                                          Container(
                                            height: 20.0,
                                            child: Image.asset(Images.media)
                                          ),
                                          SizedBox(width: 10.0),
                                          Text("Media")
                                        ],
                                      ),
                                      if(!Provider.of<AuthProvider>(context, listen: false).isLoggedIn())
                                        SizedBox(width: 10.0),
                                      if(!Provider.of<AuthProvider>(context, listen: false).isLoggedIn())
                                        Container(
                                          width: 284.0,
                                          padding: EdgeInsets.only(left: 12.0, right: 12.0),
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
                                          MaterialPageRoute(builder: (context) => JualBeliPage()),
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
                                        Text("MBW Mart")
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
                                        Text("PPOB")
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
                                        Text("Search\nMember")
                                      ],
                                    ),
                                  ),
                                
                              ],
                            ),

                            SizedBox(
                              height: 10.0,
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
                          controller: tabController,
                          indicatorColor: ColorResources.BLACK,
                          labelColor: ColorResources.BLACK,
                          unselectedLabelColor: ColorResources.GRAY_PRIMARY,
                          tabs: [
                            Tab(       
                              text: getTranslated("FAVORITE_NEWS", context)                            
                            ),
                            Tab(
                              text: getTranslated("LATEST_NEWS", context),
                            ),
                          ],
                        ),
                      )
                    ),

                    SliverFillRemaining(
                      child: TabBarView(
                        children: [

                          Container(
                            decoration: BoxDecoration(
                              color: ColorResources.WHITE,
                            ),
                            child: Consumer<NewsProvider>(
                              builder: (BuildContext context, NewsProvider newsProvider, Widget child) {
                                
                                if(newsProvider.getNewsStatus == GetNewsStatus.loading) {
                                  return Loader(
                                    color: ColorResources.BTN_PRIMARY_SECOND,
                                  );
                                }

                                if(newsProvider.getNewsStatus == GetNewsStatus.empty) {
                                  return Center(
                                    child: Text("No News Available", 
                                      style: poppinsRegular,
                                    ),
                                  );
                                }

                                return Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: newsProvider.newsBody.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Container(
                                        color: ColorResources.WHITE,
                                        width: double.infinity,
                                        margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                        child: Card(
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(10.0),
                                            onTap: () => Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => DetailNewsScreen(
                                                title: newsProvider.newsBody[i].title,
                                                content: newsProvider.newsBody[i].content,
                                                date: newsProvider.newsBody[i].created,
                                                imageUrl: newsProvider.newsBody[i].media[0].path,
                                              )),
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
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    Container(
                                                      width: 200.0,
                                                      margin: EdgeInsets.only(top: 10.0),
                                                      child: Text(newsProvider.newsBody[i].title,
                                                        softWrap: true,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                Positioned(
                                                  top: 55.0,
                                                  right: 10.0,
                                                  child: Text(getTranslated("READ_MORE", context),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 12.0
                                                    ),
                                                  )
                                                )

                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ); 
                              },
                            )
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: ColorResources.WHITE,
                            ),
                            child: Consumer<NewsProvider>(
                              builder: (BuildContext context, NewsProvider newsProvider, Widget child) {
                                
                                if(newsProvider.getNewsStatus == GetNewsStatus.loading) {
                                  return Loader(
                                    color: ColorResources.BTN_PRIMARY_SECOND,
                                  );
                                }

                                if(newsProvider.getNewsStatus == GetNewsStatus.empty) {
                                  return Center(
                                    child: Text("No News Available", 
                                      style: poppinsRegular,
                                    ),
                                  );
                                }

                                return Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: newsProvider.newsBody.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Container(
                                        color: ColorResources.WHITE,
                                        width: double.infinity,
                                        margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                        child: Card(
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(10.0),
                                            onTap: () => Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => DetailNewsScreen(
                                                title: newsProvider.newsBody[i].title,
                                                content: newsProvider.newsBody[i].content,
                                                date: newsProvider.newsBody[i].created,
                                                imageUrl: newsProvider.newsBody[i].media[0].path,
                                              )),
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
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    Container(
                                                      width: 200.0,
                                                      margin: EdgeInsets.only(top: 10.0),
                                                      child: Text(newsProvider.newsBody[i].title,
                                                        softWrap: true,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                Positioned(
                                                  top: 55.0,
                                                  right: 10.0,
                                                  child: Text("Baca Selengkapnya",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 12.0
                                                    ),
                                                  )
                                                )

                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ); 
                              },
                            )
                          ),

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
                          //                           style: TextStyle(
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
                          //                       style: TextStyle(
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

          ],
        )
      ),
    );
  }
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
