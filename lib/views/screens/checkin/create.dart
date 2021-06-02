import 'dart:async';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/helpers/show_snackbar.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/checkin.dart';
import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/views/basewidget/textfield/custom_textfield.dart';

class CreateCheckInScreen extends StatefulWidget {
  @override
  _CreateCheckInScreenState createState() => _CreateCheckInScreenState();
}

class _CreateCheckInScreenState extends State<CreateCheckInScreen> {
  Completer<GoogleMapController> mapsController = Completer();
  TextEditingController captionTextController = TextEditingController();
  TextEditingController dateTextController = TextEditingController();
  TextEditingController datetimeTextStartController = TextEditingController();
  TextEditingController datetimeTextEndController = TextEditingController();
  List<Marker> markers = [];
  
  refresh() {
    setState(() {});
  }

  void createCheckIn(context) async {
    try {
      if(captionTextController.text.trim().isEmpty) {
        throw CustomException("CAPTION_IS_REQUIRED");
      }
      if(dateTextController.text.trim().isEmpty) {
        throw CustomException("DATE_IS_REQUIRED");
      }
      if(datetimeTextStartController.text.trim().isEmpty) {
        throw CustomException("DATE_TIME_START_IS_REQUIRED"); 
      }
      if(datetimeTextEndController.text.trim().isEmpty) {
        throw CustomException("DATE_TIME_END_IS_REQUIRED"); 
      }
      String caption = captionTextController.text;
      String date = dateTextController.text;
      String start = datetimeTextStartController.text;
      String end = datetimeTextEndController.text;
      String placeName = Provider.of<LocationProvider>(context, listen: false).getCurrentNameAddressCreateCheckIn;
      double lat = Provider.of<LocationProvider>(context, listen: false).getCurrentLatCreateCheckIn;
      double long = Provider.of<LocationProvider>(context, listen: false).getCurrentLongCreateCheckIn;
      await Provider.of<CheckInProvider>(context, listen: false).createCheckIn(context, caption, date, start, end, placeName, lat, long);
    } on CustomException catch(e) {
      String error = e.toString();
      ShowSnackbar.snackbar(context, getTranslated(error, context), "", ColorResources.ERROR);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).getCurrentPosition(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: [
          
          CustomAppBar(title: getTranslated("CREATE_CHECK_IN", context)),
          
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0, bottom: 25.0),
            child: Column(
              children: [

                Container(
                  margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT, 
                    right: Dimensions.MARGIN_SIZE_DEFAULT
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.description, 
                                  color: ColorResources.getPrimaryToWhite(context), 
                                  size: 20.0
                                ),
                                SizedBox(
                                  width: Dimensions.MARGIN_SIZE_EXTRA_SMALL
                                ),
                                Text(getTranslated('CAPTION', context), style: titilliumRegular)
                              ],
                            ),
                            SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                            CustomTextField(
                              textInputType: TextInputType.text,
                              hintText: "Caption Here",
                              isShortBio: true,
                              controller: captionTextController
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                
                Container(
                  margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT, 
                    right: Dimensions.MARGIN_SIZE_DEFAULT
                  ),
                  child:  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range, 
                                  color: ColorResources.getPrimaryToWhite(context), 
                                  size: 20.0
                                ),
                                SizedBox(
                                  width: Dimensions.MARGIN_SIZE_EXTRA_SMALL
                                ),
                                Text(getTranslated('SET_DATE', context), style: titilliumRegular)
                              ],
                            ),
                            SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),                              
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1), 
                                    spreadRadius: 1.0, 
                                    blurRadius: 3.0, 
                                    offset: Offset(0.0, 1.0)
                                  )
                                ],
                              ),
                              child: DateTimePicker(
                                type: DateTimePickerType.date,
                                dateMask: 'd MMM, yyyy',
                                controller: dateTextController,
                                dateHintText: "Set Date",
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                icon: Icon(Icons.event),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                                  hintText: "Set Date",
                                  hintStyle: titilliumRegular.copyWith(color: Theme.of(context).hintColor),
                                  counterText: "",
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                                dateLabelText: 'Date',
                                onChanged: (val) {},
                                validator: (val) {
                                  return null;
                                },
                                onSaved: (val) => {}
                              ) 
                            ),
                          ],
                        )
                      ),
                    ],
                  ), 
                ),

                SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),

                Container(
                  margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT, 
                    right: Dimensions.MARGIN_SIZE_DEFAULT
                  ),
                  child:  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range, 
                                  color: ColorResources.getPrimaryToWhite(context), 
                                  size: 20.0
                                ),
                                SizedBox(
                                  width: Dimensions.MARGIN_SIZE_EXTRA_SMALL
                                ),
                                Text(getTranslated('SET_TIME_START', context), style: titilliumRegular)
                              ],
                            ),
                            SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),                              
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1), 
                                    spreadRadius: 1.0, 
                                    blurRadius: 3.0, 
                                    offset: Offset(0.0, 1.0)
                                  )
                                ],
                              ),
                              child: DateTimePicker(
                                type: DateTimePickerType.time,
                                dateMask: 'd MMM, yyyy',
                                controller: datetimeTextStartController,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                icon: Icon(Icons.event),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                                  hintText: "Set Time Start",
                                  hintStyle: titilliumRegular.copyWith(color: Theme.of(context).hintColor),
                                  counterText: "",
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                                dateLabelText: 'Date',
                                onChanged: (val) {},
                                validator: (val) {
                                  return null;
                                },
                                onSaved: (val) => {}
                              ) 
                            ),
                          ],
                        )
                      ),
                    ],
                  ), 
                ),

                SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),

                Container(
                  margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT, 
                    right: Dimensions.MARGIN_SIZE_DEFAULT
                  ),
                  child:  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range, 
                                  color: ColorResources.getPrimaryToWhite(context),
                                  size: 20.0
                                ),
                                SizedBox(
                                  width: Dimensions.MARGIN_SIZE_EXTRA_SMALL
                                ),
                                Text(getTranslated('SET_TIME_END', context), style: titilliumRegular)
                              ],
                            ),
                            SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),                              
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1), 
                                    spreadRadius: 1.0, 
                                    blurRadius: 3.0, 
                                    offset: Offset(0.0, 1.0)
                                  )
                                ],
                              ),
                              child: DateTimePicker(
                                type: DateTimePickerType.time,
                                dateMask: 'd MMM, yyyy',
                                controller: datetimeTextEndController,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                icon: Icon(Icons.event),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                                  hintText: "Set Time End",
                                  hintStyle: titilliumRegular.copyWith(color: Theme.of(context).hintColor),
                                  counterText: "",
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                                dateLabelText: 'Date',
                                onChanged: (val) {},
                                validator: (val) {
                                  return null;
                                },
                                onSaved: (val) => {}
                              ) 
                            ),
                          ],
                        )
                      ),
                    ],
                  ), 
                ),

                SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),

                Consumer<LocationProvider>(
                  builder: (BuildContext context, LocationProvider locationProvider, Widget child) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_city, 
                                color: ColorResources.getPrimaryToWhite(context), 
                                size: 20.0
                              ),
                              SizedBox(
                                width: Dimensions.MARGIN_SIZE_EXTRA_SMALL
                              ),
                              Text(getTranslated('LOCATION', context), style: titilliumRegular)
                            ],
                          ),
                          SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                          Expanded(
                            child: SizedBox.shrink()
                          ),
                          Container(
                            child: GestureDetector(
                              onTap: () { 
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return PlacePicker(
                                    apiKey: AppConstants.API_KEY_GMAPS,
                                    useCurrentLocation: true,
                                    onPlacePicked: (result) async {
                                      await Provider.of<LocationProvider>(context, listen: false).updateNewCameraPositionCreateCheckIn(result);  
                                      Navigator.of(context).pop();
                                    },
                                    autocompleteLanguage: "id",
                                    initialPosition: null,
                                  );
                                }));
                              },
                              child: Text(getTranslated("SET_LOCATION", context),
                                style: titilliumRegular
                              )
                            ),
                          )
                        ],
                      ),
                    ); 
                  },
                ),
    
                Consumer<LocationProvider>(
                  builder: (BuildContext context, LocationProvider locationProvider, Widget child) {
                  markers.add(Marker(
                    markerId: MarkerId("currentPosition"),
                    position: LatLng(locationProvider.getCurrentLatCreateCheckIn, locationProvider.getCurrentLongCreateCheckIn),
                    icon: BitmapDescriptor.defaultMarker,
                  ));
                  return Container(  
                    width: double.infinity,
                    height: 200.0,
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Stack( 
                      children: [
                        GoogleMap(
                          mapType: MapType.normal,
                          gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                          myLocationEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(locationProvider.getCurrentLatCreateCheckIn, locationProvider.getCurrentLongCreateCheckIn),
                            zoom: 15.0,
                          ),
                          markers: Set.from(markers),
                          onMapCreated: (GoogleMapController controller) {
                            mapsController.complete(controller);
                            locationProvider.controller = controller;
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.0, right: 40.0, left: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: ColorResources.WHITE
                            ),
                            width: 210.0,
                            height: 90.0,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text(locationProvider.getCurrentNameAddressCreateCheckIn,
                                style: titilliumRegular.copyWith(
                                  color: ColorResources.BLACK,
                                  height: 1.4
                                )
                              ),
                            ),
                          ),
                        )
                      ]
                    )
                  );
                },
              ),

              SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
              
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.MARGIN_SIZE_LARGE, 
                  vertical: Dimensions.MARGIN_SIZE_SMALL
                ),
                child: Builder( 
                  builder: (c) => TextButton(
                    onPressed: () => createCheckIn(c),
                    child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorResources.getPrimaryToWhite(context),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), 
                          spreadRadius: 1.0, 
                          blurRadius: 7.0, 
                          offset: Offset(0, 1)
                        ), 
                      ],
                      borderRadius: BorderRadius.circular(10.0)),
                        child: Consumer<CheckInProvider>(
                          builder: (BuildContext context, CheckInProvider checkInProvider, Widget child) {
                            return checkInProvider.checkInStatusCreate == CheckInStatusCreate.loading ? Loader(
                              color: ColorResources.WHITE,
                            ) : Text(getTranslated("CREATE_CHECK_IN", context),
                            style: titilliumSemiBold.copyWith(
                              fontSize: 16.0,
                              color: ColorResources.getWhiteToBlack(context),
                            )
                          );
                          },
                        )
                      ),
                    )
                  ),
                )

              ],  
            )
          )    
        ],
      )
    );
  }
}