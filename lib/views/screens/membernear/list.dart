import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/providers/nearmember.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';

class MemberNearScreen extends StatefulWidget {

  final String whereFrom;
  MemberNearScreen({
    this.whereFrom
  });

  @override
  _MemberNearScreenState createState() => _MemberNearScreenState();
}

class _MemberNearScreenState extends State<MemberNearScreen> {

  Completer<GoogleMapController> mapsController = Completer();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(getTranslated("MEMBER_NEARS", context),
          style: poppinsRegular.copyWith(
            color: ColorResources.BLACK,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorResources.GRAY_LIGHT_PRIMARY,
        leading: widget.whereFrom == "dashboard" 
        ? SizedBox() 
        : InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ColorResources.BLACK,  
          ),
        ),
      ),
      body: ListView(
        children: [

          Stack(
            children: [

              ClipPath(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200.0,
                  color: ColorResources.GRAY_LIGHT_PRIMARY,
                ),
                clipper: CustomClipPath(),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 40.0, left: 15.0),
                  child: Text(getTranslated("FIND_THE_CLOSEST_MEMBER", context),
                    style: poppinsRegular.copyWith(
                      color: ColorResources.BTN_PRIMARY_SECOND
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pilih dengan peta",
                        style: poppinsRegular,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PlacePicker(
                              apiKey: AppConstants.API_KEY_GMAPS,
                              useCurrentLocation: true,
                              onPlacePicked: (result) async {        
                                await Provider.of<NearMemberProvider>(context, listen: false).updateNearMember(context, result);              
                                Navigator.of(context).pop();
                              },
                              autocompleteLanguage: "id",
                              initialPosition: null,
                            );
                          }));
                        },
                        child: Text("Ubah Lokasi",
                          style: poppinsRegular.copyWith(
                            color: ColorResources.BTN_PRIMARY_SECOND
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Consumer<NearMemberProvider>(
                builder: (BuildContext context, NearMemberProvider nearMemberProvider, Widget child) {
                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: 200.0,
                      margin: EdgeInsets.only(top: 110.0, left: 16.0, right: 16.0),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                        myLocationEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(nearMemberProvider.getCurrentLat, nearMemberProvider.getCurrentLong),
                          zoom: 15.0,
                        ),
                        markers: Set.from(nearMemberProvider.markers),
                        onMapCreated: (GoogleMapController controller) {
                          mapsController.complete(controller);
                          nearMemberProvider.googleMapController = controller;
                        },
                      ),
                    )
                  );
                },
              ),

              Consumer<NearMemberProvider>(
                builder: (BuildContext context, NearMemberProvider nearMemberProvider, Widget child) {
                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: 90.0,
                      margin: EdgeInsets.only(top: 312.0, left: 16.0, right: 16.0),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: ColorResources.WHITE
                        ),
                        child: Text(nearMemberProvider.nearMemberAddress,
                          softWrap: true,
                          style: poppinsRegular.copyWith(
                            height: 1.6,
                            fontSize: 12.0
                          )
                        ),
                      )
                    )
                  ); 
                },
              ),
            ],
          ),

          Consumer<NearMemberProvider>(
            builder: (BuildContext context, NearMemberProvider nearMemberProvider, Widget child) {
              if(nearMemberProvider.nearMemberStatus == NearMemberStatus.loading) {
                return Container(
                  margin: EdgeInsets.only(top: 60.0),
                  child: Loader(
                    color: ColorResources.BTN_PRIMARY,
                  ),
                );
              }
              if(nearMemberProvider.nearMemberStatus == NearMemberStatus.empty) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 60.0),
                    child: Text(getTranslated("NO_MEMBER_AVAILABLE", context),
                      style: poppinsRegular,
                    )
                  ),
                );
              }
            
              return Container(
                margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                width: double.infinity,
                height: 300.0,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1 / 2,
                  ), 
                  physics: NeverScrollableScrollPhysics(),
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
                        margin: EdgeInsets.only(top: 5.0, left: i == 0 ? 6.0 : 5.0, right: 5.0),
                        child: Column(
                          children: [
                            Container(
                              child: CachedNetworkImage(
                                imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${nearMemberProvider.nearMemberData[i].avatarUrl}",
                                imageBuilder: (BuildContext context, ImageProvider imageProvider) => CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: imageProvider, 
                                ),
                                placeholder: (BuildContext context, String url) => CircleAvatar(
                                  backgroundColor: ColorResources.WHITE,
                                  radius: 30.0,
                                  child: Loader(
                                    color: ColorResources.BTN_PRIMARY,
                                  ),
                                ),
                                errorWidget: (BuildContext context, String url, dynamic error) => 
                                CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: ColorResources.WHITE,
                                  backgroundImage: AssetImage('assets/images/profile-drawer.png'), 
                                )
                              ),
                            ),
                            Container(
                              width: 100.0,
                              margin: EdgeInsets.only(top: 4.0),
                              child: Text(nearMemberProvider.nearMemberData[i].fullname,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: poppinsRegular.copyWith(
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            Container(
                              width: 40.0,
                              child: Text('+ - ${timeago.format(minutes, locale: 'id')}',
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
                  },
                ),
              );
            },
          ),
    
        ],
      ),
    );
  }
}


class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 140);
    path.quadraticBezierTo(size.width / 2, size.height, 
    size.width, size.height - 140);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}