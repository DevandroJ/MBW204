import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:provider/provider.dart';

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

class HomePage extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
 
  @override
  Widget build(BuildContext context) {

    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    TabController tabController;
    
    Provider.of<FcmProvider>(context, listen: false).initializing(context);
    Provider.of<FcmProvider>(context, listen: false).initFcm(context);
    Provider.of<LocationProvider>(context, listen: false).getCurrentPosition(context);
    Provider.of<LocationProvider>(context, listen: false).insertUpdateLatLng(context);
    Provider.of<BannerProvider>(context, listen: false).getBanner(context);
    Provider.of<InboxProvider>(context, listen: false).getInboxes(context);
    Provider.of<ProfileProvider>(context, listen: false).getUserProfile(context);
    Provider.of<PPOBProvider>(context, listen: false).getBalance(context);
    
    return WillPopScope(
      onWillPop: () {
        return SystemNavigator.pop();
      },
      child: Scaffold(
        key: scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        endDrawer: DrawerWidget(),
        body: Stack(
          children: [
            
            Container(
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
                       
                      },
                    ),
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int i) {
                      return InkWell(
                        onTap: () { 
                        },
                        child: Container(
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
                            child: Image.network("https://lektur.id/wp-content/uploads/2020/04/dummy.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      );                  
                    },
                  ),

                  Positioned(
                    bottom: 5.0,
                    left: 0.0,
                    right: 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TabPageSelectorIndicator(
                          backgroundColor: ColorResources.WHITE,
                          borderColor: Colors.white,
                          size: 10.0,
                        )
                      ]
                    ),
                  ),

                ],
              )
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
                            children: [
                              Expanded(
                                child: SearchWidget(
                                  hintText: "Search",
                                )
                              ),
                              SizedBox(width: 10.0),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 28.0,
                                  height: 28.0,
                                  decoration: BoxDecoration(
                                    color: ColorResources.GREY,
                                    borderRadius: BorderRadius.circular(20.0)
                                  ),
                                  child: Icon(
                                    Icons.chat,
                                    color: ColorResources.BLACK,
                                    size: 17.0,
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
                        height: 170.0,
                      ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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

                                Container(
                                  height: 30, 
                                  child: VerticalDivider(color: ColorResources.DIM_GRAY)
                                ),

                                Row(
                                  children: [
                                    Container(
                                      height: 20.0,
                                      child: Image.asset(Images.mart)
                                    ),
                                    SizedBox(width: 10.0),
                                    Text("MBW Mart")
                                  ],
                                ),

                                Container(
                                  height: 30, 
                                  child: VerticalDivider(color: ColorResources.DIM_GRAY)
                                ),

                                Row(
                                  children: [
                                    Container(
                                      height: 20.0,
                                      child: Image.asset(Images.ppob)
                                    ),
                                    SizedBox(width: 10.0),
                                    Text("PPOB")
                                  ],
                                ),

                                Container(
                                  height: 30, 
                                  child: VerticalDivider(color: ColorResources.DIM_GRAY)
                                ),

                                Row(
                                  children: [
                                    Container(
                                      height: 20.0,
                                      child: Image.asset(Images.search_member)
                                    ),
                                    SizedBox(width: 10.0),
                                    Text("Search\nMember")
                                  ],
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
                          unselectedLabelColor: ColorResources.BLACK,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: ColorResources.YELLOW_PRIMARY,
                          labelStyle: poppinsRegular,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ColorResources.BLACK,
                          ),
                          tabs: [
                            Tab(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: ColorResources.BLACK, 
                                    width: 1.0
                                  )
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Favorite News"),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: ColorResources.BLACK, 
                                    width: 1.0
                                  )
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Latest News"),
                                ),
                              ),
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
                            child: Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 3,
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
                                        onTap: () {

                                        },
                                        child: Stack(
                                          children: [

                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: "https://akcdn.detik.net.id/community/media/visual/2021/05/29/aksi-panggung-abdee-slank_169.jpeg?w=700&q=90",
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
                                                  child: Text("Akhirnya Erick Thohir Bersuara Alasan Abdee Slank Jadi Komisaris Telkom",
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
                            )
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: ColorResources.WHITE,
                            ),
                            child: Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 3,
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
                                        onTap: () {

                                        },
                                        child: Stack(
                                          children: [

                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: "https://akcdn.detik.net.id/community/media/visual/2021/05/29/aksi-panggung-abdee-slank_169.jpeg?w=700&q=90",
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
                                                  child: Text("Akhirnya Erick Thohir Bersuara Alasan Abdee Slank Jadi Komisaris Telkom",
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
                            )
                          ),



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
