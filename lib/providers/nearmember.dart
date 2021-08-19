import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/data/models/nearmember.dart';
import 'package:mbw204_club_ina/data/repository/nearmember.dart';

enum NearMemberStatus { loading, loaded, empty, error }

class NearMemberProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final NearMemberRepo nearMemberRepo;
  NearMemberProvider({ 
    @required this.sharedPreferences,
    @required this.nearMemberRepo, 
  });
  
  NearMemberStatus _nearMemberStatus = NearMemberStatus.loading;
  NearMemberStatus get nearMemberStatus => _nearMemberStatus;
  
  GoogleMapController googleMapController;

  List<Marker> markers = [];

  List<NearMemberData> _nearMemberData = [];
  List<NearMemberData> get nearMemberData => [..._nearMemberData];

  void setStateNearMemberStatus(NearMemberStatus nearMemberStatus) {
    _nearMemberStatus = nearMemberStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
  
  Future getNearMember(BuildContext context) async {
    try { 
      List<NearMemberData> nd = await nearMemberRepo.getNearMember(context, Provider.of<LocationProvider>(context, listen: false).getCurrentLat, Provider.of<LocationProvider>(context, listen: false).getCurrentLong);
      if(_nearMemberData.length != nd.length) {
        _nearMemberData.clear();
        _nearMemberData.addAll(nd);
        setStateNearMemberStatus(NearMemberStatus.loaded);
        if(_nearMemberData.isEmpty) {
          setStateNearMemberStatus(NearMemberStatus.empty);
        }
      } 
    } on NullException catch(_) {
      setStateNearMemberStatus(NearMemberStatus.empty);
    } catch(_) {
      setStateNearMemberStatus(NearMemberStatus.error);
    }
  }

  Future getCurrentPosition(BuildContext context) async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      sharedPreferences.setDouble("lat", position.latitude);
      sharedPreferences.setDouble("long", position.longitude);
      markers.add(Marker(
        markerId: MarkerId("currentPosition"),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarker,
      ));
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      sharedPreferences.setString("currentNameAddress", "${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      sharedPreferences.setString("nearMemberAddress", "${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      print(e);
    } 
  }

  Future updateNearMember(BuildContext context, PickResult position) async {
    markers.add(
      Marker(
        markerId: MarkerId("nearMemberPosition"),
        position: LatLng(position.geometry.location.lat, position.geometry.location.lng),
        icon: BitmapDescriptor.defaultMarker,
      )
    );
    List<Placemark> placemarks = await placemarkFromCoordinates(position.geometry.location.lat, position.geometry.location.lng);
    Placemark place = placemarks[0]; 
    sharedPreferences.setString("nearMemberAddress", "${place.thoroughfare} ${place.subThoroughfare} ${place.locality} ${place.postalCode}");
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.geometry.location.lat, position.geometry.location.lng),
          zoom: 15.0
        )
      )
    );
    notifyListeners();
  }

  String get nearMemberAddress => sharedPreferences.getString("nearMemberAddress") ?? "Lokasi belum dipilih";

  double get getCurrentNearMemberLat => sharedPreferences.getDouble("lat") ?? 0.0;
  
  double get getCurrentNearMemberLong => sharedPreferences.getDouble("long") ?? 0.0;
  
}