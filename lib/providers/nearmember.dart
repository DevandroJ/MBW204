import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
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

  GoogleMapController googleMapController;

  List<Marker> markers = [];

  List<NearMemberData> _nearMemberData = [];
  List<NearMemberData> get nearMemberData => [..._nearMemberData];

  NearMemberStatus _nearMemberStatus = NearMemberStatus.loading;
  NearMemberStatus get nearMemberStatus => _nearMemberStatus;

  void setStateNearMemberStatus(NearMemberStatus nearMemberStatus) {
    _nearMemberStatus = nearMemberStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
  
  Future getNearMember(BuildContext context) async {
    try { 
      List<NearMemberData> nearMemberData = await nearMemberRepo.getNearMember(context, Provider.of<LocationProvider>(context, listen: false).getCurrentLat, Provider.of<LocationProvider>(context, listen: false).getCurrentLong);
      if(_nearMemberData.length != nearMemberData.length) {
        _nearMemberData.clear();
        _nearMemberData.addAll(nearMemberData);
        setStateNearMemberStatus(NearMemberStatus.loaded);
        if(_nearMemberData.isEmpty) {
          setStateNearMemberStatus(NearMemberStatus.empty);
        }
      }
      setStateNearMemberStatus(NearMemberStatus.loaded);
    } catch(e) {
      setStateNearMemberStatus(NearMemberStatus.error);
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