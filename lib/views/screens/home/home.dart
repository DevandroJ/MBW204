import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mbw204_club_ina/providers/fcm.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/providers/inbox.dart';
import 'package:mbw204_club_ina/providers/banner.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/screens/home/widgets/banners.dart';
import 'package:mbw204_club_ina/views/screens/home/widgets/category.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/data/models/feed/feedposttype.dart';
import 'package:mbw204_club_ina/views/screens/feed/post_detail.dart';
import 'package:mbw204_club_ina/views/screens/feed/feed_index.dart';

class HomePage extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
 
  @override
  Widget build(BuildContext context) {

    FeedState feedState = getIt<FeedState>();
    feedState.fetchGroupsMostRecent();

    bool isPanelClose = true;
    
    Provider.of<FcmProvider>(context, listen: false).initializing(context);
    Provider.of<FcmProvider>(context, listen: false).initFcm(context);
    Provider.of<LocationProvider>(context, listen: false).getCurrentPosition(context);
    Provider.of<LocationProvider>(context, listen: false).insertUpdateLatLng(context);
    Provider.of<BannerProvider>(context, listen: false).getBanner(context);
    Provider.of<InboxProvider>(context, listen: false).getInboxes(context);
    Provider.of<ProfileProvider>(context, listen: false).getUserProfile(context);
    Provider.of<PPOBProvider>(context, listen: false).getBalance(context);
    
    return Scaffold(
      body: SafeArea(
        child: StatefulBuilder(
          builder: (BuildContext context, Function setState) {
            return SlidingUpPanel( 
            onPanelClosed: () => setState(() => isPanelClose = true),
            onPanelOpened: () => setState(() => isPanelClose = false),
            maxHeight: 310.0,
            minHeight: 50.0,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0)
            ),
            panel: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 10.0                      
              ),
            decoration: BoxDecoration(
              color: ColorResources.WHITE,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0  
                )
              ]
            ),
            child: Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 3.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        color: ColorResources.getPrimaryToBlack(context),
                        borderRadius: BorderRadius.circular(5.0)
                      ),                         
                    )
                  ),

                  SizedBox(height: 5.0),

                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 3.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        color: ColorResources.getPrimaryToBlack(context),
                        borderRadius: BorderRadius.circular(5.0)
                      ),                         
                    )
                  ),

                  SizedBox(height: 5.0),
                  
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 3.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        color: ColorResources.getPrimaryToBlack(context),
                        borderRadius: BorderRadius.circular(5.0)
                      ),                         
                    )
                  ),
                
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: isPanelClose ? 0.0 : 1.0,
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          CategoryView(isHomePage: true),

                        ],
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
          body: CustomScrollView(
            controller: scrollController,
            slivers: [

              SliverAppBar(
                floating: true,
                elevation: 0.0,
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: ColorResources.getBgBlack(context),
                title: Row(
                  children: [

                    Image.asset(
                      Images.logo,
                      height: 35.0, 
                    ),

                    SizedBox(width: 8.0),
                    
                    Text("IndoMini Club",
                      style: titilliumRegular.copyWith(
                        fontSize: 17.0,
                        color: ColorResources.WHITE
                      )        
                    )

                  ]
                )
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Consumer<LocationProvider>(
                      builder: (BuildContext context, LocationProvider locationProvider, Widget child) {
                        return Container(
                          margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
                          child: Row(
                            children: [
                              
                              Expanded(
                                child: SizedBox.shrink(),
                              ),

                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return PlacePicker(
                                      apiKey: AppConstants.API_KEY_GMAPS,
                                      useCurrentLocation: true,
                                      onPlacePicked: (result) async {
                                        await locationProvider.updateCurrentPosition(context, result);  
                                        Navigator.of(context).pop();
                                      },
                                      autocompleteLanguage: "id",
                                      initialPosition: null,
                                    );
                                  }));
                                },
                                child: Icon(
                                  Icons.location_city, 
                                  color: ColorResources.getPrimaryToWhite(context),
                                  size: 20.0
                                ),
                              ),
                              
                              SizedBox(width: 10.0),

                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return PlacePicker(
                                      apiKey: AppConstants.API_KEY_GMAPS,
                                      useCurrentLocation: true,
                                      onPlacePicked: (result) async {
                                        await locationProvider.updateCurrentPosition(context, result);  
                                        Navigator.of(context).pop();
                                      },
                                      autocompleteLanguage: "id",
                                      initialPosition: null,
                                    );
                                  }));
                                },
                                child: Padding(
                                padding: EdgeInsets.only(
                                  top: Dimensions.PADDING_SIZE_SMALL,
                                  bottom: Dimensions.PADDING_SIZE_SMALL
                                ),
                                child: Container( 
                                  width: 320.0,
                                  child: Text(
                                      locationProvider.getCurrentNameAddress == "Location no Selected" 
                                      ? getTranslated("LOCATION_NO_SELECTED", context) 
                                      : locationProvider.getCurrentNameAddress, 
                                      overflow: TextOverflow.ellipsis,
                                      style: titilliumRegular,
                                    ),
                                  )
                                ),
                              )

                            ]
                          ),
                        );
                      },
                    ),

                    BannersView(),

                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                      width: double.infinity,
                      child: Column(
                        children: [
                          
                          Container(
                            color: ColorResources.WHITE,
                            child: Observer(
                              builder: (_) {
                                if (feedState.groupsMostRecentStatus == GroupsMostRecentStatus.loading) {
                                  return Loader(
                                    color: ColorResources.getPrimaryToBlack(context),
                                  );
                                }
                                if (feedState.groupsMostRecentStatus == GroupsMostRecentStatus.empty) {
                                  return Center(
                                    child: Text(getTranslated("THERE_IS_NO_POST", context), style: titilliumRegular)
                                  );
                                }
                                if (feedState.groupsMostRecentStatus == GroupsMostRecentStatus.error) {
                                  return Center(
                                    child: Text(getTranslated("THERE_WAS_PROBLEM", context), style: titilliumRegular)
                                  );
                                }
                                return LimitedBox(
                                  maxHeight: 260.0,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    separatorBuilder: (BuildContext context, int i) {
                                      return Container(
                                        color: Colors.blueGrey[50],
                                        height: 10.0,
                                      );
                                    },
                                    physics: BouncingScrollPhysics(),
                                    itemCount: feedState.g1List.take(4).length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return InkWell(
                                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FeedIndex())),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            ListTile(
                                              dense: true,
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.transparent,
                                                backgroundImage: NetworkImage("${AppConstants.BASE_URL_FEED_IMG}/${feedState.g1List[i].user.profilePic.path}"),
                                                radius: 20.0,
                                              ),
                                              title: Text(feedState.g1List[i].user.nickname,
                                                style: titilliumRegular.copyWith(
                                                  color: ColorResources.BLACK
                                                ),
                                              ),
                                              subtitle: Text(timeago.format((DateTime.parse(feedState.g1List[i].created).toLocal()), locale: 'id'),
                                                style: titilliumRegular.copyWith(
                                                  fontSize: 12.0,
                                                  color: Colors.grey
                                                ),
                                              ),
                                            ),

                                            if(feedState.g1List[i].postType == PostType.IMAGE)
                                              Container(
                                                width: 250.0,
                                                margin: EdgeInsets.only(left: 70.0, bottom: 20.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ReadMoreText("${feedState.g1List[i].user.nickname} telah mengupload gambar ",
                                                      style: titilliumRegular.copyWith(
                                                        fontSize: 14.0,
                                                        color: ColorResources.BLACK
                                                      ),
                                                      trimLines: 2,
                                                      colorClickableText: Colors.black,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText: 'Tampilkan Lebih',
                                                      trimExpandedText: 'Tutup',
                                                      moreStyle: TextStyle(
                                                        fontSize: 14.0, 
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                      lessStyle: TextStyle(
                                                        fontSize: 14.0, 
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                ) 
                                              ),

                                            if(feedState.g1List[i].postType == PostType.VIDEO)
                                              Container(
                                                width: 250.0,
                                                margin: EdgeInsets.only(left: 70.0, bottom: 20.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ReadMoreText("${feedState.g1List[i].user.nickname} telah mengupload video ",
                                                      style: titilliumRegular.copyWith(
                                                        fontSize: 14.0,
                                                        color: ColorResources.BLACK
                                                      ),
                                                      trimLines: 2,
                                                      colorClickableText: Colors.black,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText: 'Tampilkan Lebih',
                                                      trimExpandedText: 'Tutup',
                                                      moreStyle: TextStyle(
                                                        fontSize: 14.0, 
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                      lessStyle: TextStyle(
                                                        fontSize: 14.0, 
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                ) 
                                              ),
                                            
                                            if(feedState.g1List[i].postType == PostType.DOCUMENT)
                                              Container(
                                                width: 250.0,
                                                margin: EdgeInsets.only(left: 70.0, bottom: 20.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ReadMoreText("${feedState.g1List[i].user.nickname} telah mengupload file ",
                                                      style: titilliumRegular.copyWith(
                                                        fontSize: 14.0,
                                                        color: ColorResources.BLACK
                                                      ),
                                                      trimLines: 2,
                                                      colorClickableText: Colors.black,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText: 'Tampilkan Lebih',
                                                      trimExpandedText: 'Tutup',
                                                      moreStyle: TextStyle(
                                                        fontSize: 14.0, 
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                      lessStyle: TextStyle(
                                                        fontSize: 14.0, 
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                ) 
                                              ),

                                            if(feedState.g1List[i].postType == PostType.LINK)
                                              Container(
                                                width: 250.0,
                                                margin: EdgeInsets.only(left: 70.0, bottom: 20.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ReadMoreText("${feedState.g1List[i].user.nickname} telah membagikan sebuah link ",
                                                      style: titilliumRegular.copyWith(
                                                      fontSize: 14.0,
                                                        color: ColorResources.BLACK
                                                      ),
                                                      trimLines: 2,
                                                      colorClickableText: Colors.black,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText: 'Tampilkan Lebih',
                                                      trimExpandedText: 'Tutup',
                                                      moreStyle: TextStyle(
                                                        fontSize: 14.0, 
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                      lessStyle: TextStyle(
                                                        fontSize: 14.0, 
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                ) 
                                              ),

                                            if(feedState.g1List[i].postType == PostType.VIDEO)
                                              Container(
                                                width: 250.0,
                                                margin: EdgeInsets.only(left: 70.0, bottom: 20.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ReadMoreText("${feedState.g1List[i].user.nickname} telah mengupload video ",
                                                      style: titilliumRegular.copyWith(
                                                        fontSize: 14.0,
                                                        color: ColorResources.BLACK
                                                      ),
                                                      trimLines: 2,
                                                      colorClickableText: Colors.black,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText: 'Tampilkan Lebih',
                                                      trimExpandedText: 'Tutup',
                                                      moreStyle: TextStyle(
                                                        fontSize: 14.0, 
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                      lessStyle: TextStyle(
                                                        fontSize: 14.0, 
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                ) 
                                              ),

                                            if(feedState.g1List[i].postType == PostType.TEXT)
                                              Container(
                                                width: 250.0,
                                                margin: EdgeInsets.only(left: 70.0, bottom: 20.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ReadMoreText(feedState.g1List[i].content.text,
                                                      style: titilliumRegular.copyWith(
                                                        fontSize: 14.0,
                                                        color: ColorResources.BLACK
                                                      ),
                                                      trimLines: 2,
                                                      colorClickableText: Colors.black,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText: 'Tampilkan Lebih',
                                                      trimExpandedText: 'Tutup',
                                                      moreStyle: TextStyle(
                                                        fontSize: 14.0, 
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                      lessStyle: TextStyle(
                                                        fontSize: 14.0, 
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                ) 
                                              ),

                                            Container(
                                              margin: EdgeInsets.only(bottom: 10.0, left: 16.0, right: 16.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 40.0,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Text(feedState.g1List[i].numOfLikes.toString(), 
                                                            style: titilliumRegular.copyWith(
                                                              fontSize: 14.0,
                                                              color: ColorResources.BLACK
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () => feedState.like(feedState.g1List[i].id, "POST"),
                                                          child: Container(
                                                            padding: EdgeInsets.all(5.0),
                                                            child: Icon(
                                                              Icons.thumb_up,
                                                              size: 16.0,
                                                              color: feedState.g1List[i].liked.isNotEmpty ? ColorResources.BLUE : ColorResources.BLACK
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailScreen(
                                                        postId: feedState.g1List[i].id),
                                                      ));
                                                    },
                                                    child: Text('${feedState.g1List[i].numOfComments.toString()} ${getTranslated("COMMENT", context)}',
                                                      style: titilliumRegular.copyWith(
                                                        fontSize: 14.0,
                                                        color: ColorResources.BLACK
                                                      ),
                                                    ),
                                                  )
                                                ]
                                              )
                                            ), 

                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            )
                          ),
                        ],
                      ),
                    )

                    // News
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_SMALL, 20, Dimensions.PADDING_SIZE_SMALL, Dimensions.PADDING_SIZE_SMALL),
                    //   child: Container(
                    //     margin: EdgeInsets.only(left: 6.0),
                    //     child: Text("News") 
                    //   )
                    // ),

                  ]
                )
              )
            ],
          )
        );
      },
    )

        
        // CustomScrollView(
        //   controller: scrollController,
          
        //   slivers: [

        //     SliverAppBar(
        //       floating: true,
        //       elevation: 0.0,
        //       centerTitle: false,
        //       automaticallyImplyLeading: false,
        //       backgroundColor: ColorResources.PRIMARY,
        //       title: Row(
        //         children: [
        //           Image.asset(
        //             Images.logo,
        //             height: 35.0, 
        //           ),
        //           SizedBox(width: 8.0),
        //           Text("IndoMini Club",
        //             style: TextStyle(
        //               fontSize: 17.0
        //             ),
        //           )
        //         ]
        //       )
        //     ),

            
                 
        //           // Banner
        //           Padding(
        //             padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
        //             child: BannersView(),
        //           ),

        //           // News
        //           Padding(
        //             padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_SMALL, 20, Dimensions.PADDING_SIZE_SMALL, Dimensions.PADDING_SIZE_SMALL),
        //             child: Container(
        //               margin: EdgeInsets.only(left: 6.0),
        //               child: Text("News") 
        //             )
        //           ),

        //           // News View
        //           NewsView(),

        //           // Category
        //           // Padding(
        //           //   padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_SMALL, 20.0, Dimensions.PADDING_SIZE_SMALL, 0.0),
        //           //   child: Container(
        //           //     margin: EdgeInsets.only(left: 6.0),
        //           //     child: Text(getTranslated("CATEGORY", context)) 
        //           //   )
        //           // ),

        //           Padding(
        //             padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_SMALL, 15.0, Dimensions.PADDING_SIZE_SMALL, 30.0),
        //             child: SlidingUpPanel( 
        //               onPanelClosed: () {
        //               },
        //               onPanelOpened: () {
        //               },
        //               maxHeight: 400.0,
        //               borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(20.0),
        //                 topRight: Radius.circular(20.0)
        //               ),
        //               panel: Container(
        //                 padding: EdgeInsets.symmetric(
        //                   horizontal: 15.0,
        //                   vertical: 10.0                      
        //                 ),
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.only(
        //                     topLeft: Radius.circular(20.0),
        //                     topRight: Radius.circular(20.0)
        //                   ),
        //                   boxShadow: [
        //                     BoxShadow(
        //                       color: Colors.grey,
        //                       blurRadius: 2.0  
        //                     )
        //                   ]
        //                 )    
        //               )  
        //              )
        //           )

        //           // Category View
        //           // Padding(
        //           //   padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_SMALL, 15.0, Dimensions.PADDING_SIZE_SMALL, 30.0),
        //           //   child: CategoryView(isHomePage: true),
        //           // ),

        //         ]
        //       ),
        //     )
        //   ],
        // ),


      ),
    );
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
