import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

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
        title: Text("Member Nears",
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
                  child: Text("Find the closest member",
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
                          target: nearMemberProvider.latLng,
                          zoom: 15,
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
                    child: Text("Belum ada anggota",
                      style: poppinsRegular,
                    )
                  ),
                );
              }
              return Container(
                margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                width: double.infinity,
                height: 300.0,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1 / 1,
                  ), 
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                      margin: EdgeInsets.only(top: 5.0, left: i == 0 ? 6.0 : 5.0, right: 5.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Container(
                              child: CachedNetworkImage(
                                imageUrl: "https://cdn0-production-images-kly.akamaized.net/0r0vo4waPk9g2ZOtSePxceTuoyE=/640x480/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/706185/original/Daniel-Radcliffe-140710.gif",
                                imageBuilder: (context, imageProvider) => Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover
                                    )
                                  ),
                              
                                ),
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                    width: 18.0,
                                    height: 18.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(ColorResources.YELLOW_PRIMARY),
                                    )
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(),
                              ),
                            ),
                          ),
                          Container(
                            width: 65.0,
                            margin: EdgeInsets.only(top: 3.0),
                            child: Text("Agam",
                            textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: poppinsRegular.copyWith(
                                fontSize: 11.0,
                              ),
                            ),
                          ),
                        ],
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