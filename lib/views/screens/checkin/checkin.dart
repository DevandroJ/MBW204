import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/checkin/detail.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/checkin.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/views/screens/checkin/create.dart';

class CheckInScreen extends StatefulWidget {
  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {

  Completer<GoogleMapController> mapsController = Completer();
  TextEditingController descriptionTextController = TextEditingController();
  List<Marker> markers = [];

  Future join(int checkInId) async {
    try {
      await Provider.of<CheckInProvider>(context, listen: false).joinCheckIn(context, checkInId);
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    Provider.of<CheckInProvider>(context, listen: false).getCheckIn(context);
    String userId = Provider.of<ProfileProvider>(context, listen:  false).getUserId;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: getTranslated('CHECK_IN', context)),

            Consumer<CheckInProvider>(
              builder: (BuildContext context, CheckInProvider checkInProvider, Widget child) {
                if(checkInProvider.checkInStatus == CheckInStatus.loading)
                  return Expanded(
                    child: Loader(
                      color: ColorResources.getPrimaryToWhite(context),
                    )
                  );
                
                if(checkInProvider.checkInStatus == CheckInStatus.empty) 
                  return Expanded(
                    child: Center(
                      child: Text(getTranslated("NO_CHECKIN_AVAILABLE", context))
                    )
                  );

                return Expanded(
                  child: ListView.separated(
                  separatorBuilder: (BuildContext context, int i) {
                    return Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Divider(
                        thickness: 0.8,
                      ),
                    );
                  },
                  physics: BouncingScrollPhysics(),
                  itemCount: checkInProvider.checkInDataAssign.length,
                  itemBuilder: (BuildContext context, int i) {
                    markers.add(Marker(
                      markerId: MarkerId(i.toString()),
                      position: LatLng(double.parse(checkInProvider.checkInDataAssign[i]["lat"]), double.parse(checkInProvider.checkInDataAssign[i]["long"])),
                      icon: BitmapDescriptor.defaultMarker,
                    ));
                    return Container(
                      height: 300.0,
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                      child: Stack(
                        children: [

                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                child: Card(
                                  elevation: .8,
                                  child: Container(
                                    child: Scrollbar(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Container(
                                              width: double.infinity,
                                              height: 150.0,
                                              child: GoogleMap(
                                                mapType: MapType.normal,
                                                myLocationEnabled: false,
                                                initialCameraPosition: CameraPosition(
                                                  target: LatLng(double.parse(checkInProvider.checkInDataAssign[i]["lat"]), double.parse(checkInProvider.checkInDataAssign[i]["long"])),
                                                  zoom: 15.0,
                                                ),
                                                markers: Set.from(markers),
                                                onMapCreated: (GoogleMapController controller) {
                                                  mapsController.complete(controller);
                                                },
                                              )
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(top: 15.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: infoCheckIn("CAPTION", checkInProvider.checkInDataAssign[i]["caption"]),
                                                      ),
                                                      checkInProvider.checkInDataAssign[i]["user_id"] == userId 
                                                      ? Container() 
                                                      : checkInProvider.checkInDataAssign[i]["joined"] 
                                                      ? RaisedButton(
                                                          elevation: 3.0,
                                                          color: ColorResources.DIM_GRAY,
                                                          onPressed: () {},
                                                          child: Text("Already Joined",
                                                            style: TextStyle(
                                                              color: ColorResources.WHITE
                                                            ),
                                                          ),
                                                        ) 
                                                      : Selector<CheckInProvider, CheckInStatusJoin>(
                                                        builder: (BuildContext context, CheckInStatusJoin checkInStatusJoin, Widget child) {
                                                          return RaisedButton(
                                                            elevation: 3.0,
                                                            color: ColorResources.GREEN,
                                                            onPressed: () => join(checkInProvider.checkInDataAssign[i]["checkin_id"]),
                                                            child: checkInStatusJoin == CheckInStatusJoin.loading ? Loader(
                                                              color: ColorResources.WHITE,
                                                            ) : Text("Join",
                                                              style: TextStyle(
                                                                color: ColorResources.WHITE
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      selector: (BuildContext context, CheckInProvider checkInProvider) => checkInProvider.checkInStatusJoin),
                                                      SizedBox(width: 14.0),
                                                    ],
                                                  ),
                                                  
                                                  infoCheckIn("PLACE", checkInProvider.checkInDataAssign[i]["place_name"]),
                                                  
                                                  ListTile(
                                                    leading: Text("${getTranslated("DATE", context)} :",
                                                      style: titilliumRegular.copyWith(
                                                        fontSize: 14.0
                                                      )
                                                    ),
                                                    title: Text("${ DateFormat("dd MMM yyyy").format(checkInProvider.checkInDataAssign[i]["date"].add(Duration(hours: 7)))} ${checkInProvider.checkInDataAssign[i]["start"]} s/d ${checkInProvider.checkInDataAssign[i]["end"]}",
                                                      style: titilliumRegular.copyWith(
                                                        fontSize: 14.0,
                                                      )
                                                    ),
                                                    horizontalTitleGap: 8.0,
                                                    dense: true,
                                                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            
                                            Container(
                                              margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 140.0,
                                                    margin: EdgeInsets.only(bottom: 10.0),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: '* (${checkInProvider.checkInDataAssign[i]["total"]}) ',
                                                        style: titilliumRegular.copyWith(
                                                          color: ColorResources.getDimGrayToWhite(context), 
                                                          fontSize: 13.0
                                                        ),
                                                        children: [ 
                                                        TextSpan(
                                                          text: 'Lihat ',
                                                          recognizer: TapGestureRecognizer()..onTap = () {
                                                            Map<String, dynamic> basket = Provider.of(context, listen: false);
                                                            basket.addAll({
                                                              "checkInId": checkInProvider.checkInDataAssign[i]["checkin_id"].toString()
                                                            });
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => CheckInDetailScreen()));
                                                          },
                                                          style: TextStyle(
                                                            color: ColorResources.BLUE, 
                                                            fontStyle: FontStyle.italic,
                                                            fontSize: 13.0
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: 'siapa saja yang telah bergabung',
                                                          style: titilliumRegular.copyWith(
                                                            color: ColorResources.getDimGrayToWhite(context), 
                                                            fontSize: 13.0
                                                          ),
                                                        )
                                                      ]
                                                    )
                                                  ))
                                                ],
                                              ),
                                            ),

                                          ],
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        ]
                      )
                    );
                  })
                );                
              }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateCheckInScreen())),
        backgroundColor: ColorResources.getPrimaryToWhite(context),
        elevation: 1.0,
        child: Icon(
          Icons.add_business_rounded,
          color: Theme.of(context).accentColor,
        ),
      ), 
    );
  }

  Widget infoCheckIn(String key, String value) {
    return ListTile(
      leading: Text("${getTranslated(key, context)} :",
        style: titilliumRegular.copyWith(
          fontSize: 14.0
        )
      ),
      title: Text(value,
        style: titilliumRegular.copyWith(
          fontSize: 14.0,
        )
      ),
      horizontalTitleGap: 8.0,
      dense: true,
      visualDensity: VisualDensity(horizontal: 0.0, vertical: -4),
    );
  }
}
