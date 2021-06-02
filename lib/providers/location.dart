import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';

class LocationProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  LocationProvider({@required this.sharedPreferences});

  GoogleMapController controller;
  String currentNameAddress;
  double lat;
  double long;

  Future insertUpdateLatLng(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.BASE_URL}/data/user", data: {
        "fcmSecret": await firebaseMessaging.getToken(),
        "latitude": getCurrentLat.toString(),
        "longitude": getCurrentLong.toString()
      });
    } on DioError catch(e) {
      print(e?.response?.data);
      print(e?.response?.statusCode);
    } catch(e) {
      print(e);
    }
  }

  Future getCurrentPosition(BuildContext context) async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      sharedPreferences.setDouble("latCreateCheckIn", position.latitude);
      sharedPreferences.setDouble("longCreateCheckIn", position.longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      Map<String, dynamic> basket = Provider.of(context, listen: false);
      basket.addAll({
        "geo-position": {
          'address': getCurrentNameAddress,
          'addressView': getCurrentNameAddress,
          'lat': position.latitude,
          'long': position.longitude,
        }
      });
      sharedPreferences.setString("currentNameAddress", "${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      sharedPreferences.setString("currentNameAddressCreateCheckIn", "${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      print(e);
    } 
  }

  Future updateCurrentPosition(BuildContext context, PickResult position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.geometry.location.lat, position.geometry.location.lng);
      Placemark place = placemarks[0]; 
      lat = position.geometry.location.lat;
      long = position.geometry.location.lng;
      currentNameAddress = "${place.thoroughfare} ${place.subThoroughfare} ${place.locality} ${place.postalCode}";
      sharedPreferences.setDouble("lat", lat);
      sharedPreferences.setDouble("long", long);
      sharedPreferences.setString("currentNameAddress", currentNameAddress);
      await insertUpdateLatLng(context);
      Map<String, dynamic> basket = Provider.of(context, listen: false);
        basket.addAll({
          "geo-position": {
            'address': getCurrentNameAddress,
            'addressView': getCurrentNameAddress,
            'lat': lat,
            'long': long,
          }
        });
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      print(e);
    }
  }

  Future updateNewCameraPositionCreateCheckIn(PickResult position) async {
    sharedPreferences.setDouble("latCreateCheckIn", position.geometry.location.lat);
    sharedPreferences.setDouble("longCreateCheckIn", position.geometry.location.lng);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(getCurrentLatCreateCheckIn, getCurrentLongCreateCheckIn);
      Placemark place = placemarks[0];   
      sharedPreferences.setString("currentNameAddressCreateCheckIn", "${place.thoroughfare} ${place.subThoroughfare} ${place.locality} ${place.postalCode}");
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(getCurrentLatCreateCheckIn, getCurrentLongCreateCheckIn),
            zoom: 15.0
          )
        )
      );
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      print(e);
    }
  }

  String get getCurrentNameAddressCreateCheckIn => sharedPreferences.getString("currentNameAddressCreateCheckIn") ?? "";     

  double get getCurrentLatCreateCheckIn => sharedPreferences.getDouble("latCreateCheckIn") ?? 0.0;

  double get getCurrentLongCreateCheckIn => sharedPreferences.getDouble("longCreateCheckIn") ?? 0.0;

  String get getCurrentNameAddress => currentNameAddress ?? sharedPreferences.getString("currentNameAddress") ?? "Location no Selected"; 

  double get getCurrentLat => lat ?? sharedPreferences.getDouble("lat") ?? 0.0;
  
  double get getCurrentLong => long ?? sharedPreferences.getDouble("long") ?? 0.0;
  
}
