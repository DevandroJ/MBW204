import "package:dio/dio.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';
import 'package:mbw204_club_ina/data/models/warung/address_model.dart';
import 'package:mbw204_club_ina/data/models/warung/address_single_model.dart';
import 'package:mbw204_club_ina/data/models/warung/couriers_model.dart';
import 'package:mbw204_club_ina/data/models/warung/region_model.dart';
import 'package:mbw204_club_ina/data/models/warung/region_subdistrict_model.dart';

class RegionProvider with ChangeNotifier {

  Future<RegionModel> getRegion(BuildContext context, String nameType) async {
    final Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/region/$nameType");
      final RegionModel regionModel = RegionModel.fromJson(res.data);
      return regionModel;
    } catch (e) {
      print(e);
    }
  }

  Future<RegionModel> getCity(BuildContext context, String idProvince) async {
    Dio _dio = await DioManager.shared.getClient(context);
    try {
      Response res = await _dio.get("${AppConstants.BASE_URL_ECOMMERCE}/region/city?provinceId=$idProvince");
      final RegionModel regionModel = RegionModel.fromJson(res.data);
      return regionModel;
    } catch (e) {
      print(e);
    }
  }

  Future<RegionSubdistrictModel> getSubdistrict(BuildContext context, String idCity) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/region/subdistrict?cityId=$idCity");
      final RegionSubdistrictModel regionSubdistrictModel = RegionSubdistrictModel.fromJson(res.data);
      return regionSubdistrictModel;
    } catch (e) {
      print(e);
    }
  }

  Future<CouriersModel> getDataCouriers(BuildContext context) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/seller/store/couriers");
      final CouriersModel couriersModel = CouriersModel.fromJson(res.data);
      return couriersModel;
    } catch (e) {
      print(e);
    }
  }

  Future<AddressModel> getDataAddress(BuildContext context) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/commerce/shipping/addresses");
      final AddressModel addressModel = AddressModel.fromJson(res.data);
      return addressModel;
    } catch (e) {
      print(e);
    }
  }

  Future<AddressSingleModel> postDataAddress(
    BuildContext context,
    String typeAlamat,
    String noPonsel,
    String address,
    String province,
    String city,
    String postalCode,
    String subdistrict,
    List<double> lokasi,
  ) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response _res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/shipping/add",
      data: {
        "name": typeAlamat,
        "phoneNumber": noPonsel,
        "address": address,
        "postalCode": postalCode,
        "province": province,
        "city": city,
        "subdistrict": subdistrict,
        "defaultLocation": true,
        "location": lokasi
      });
      final AddressSingleModel addressSingleModel = AddressSingleModel.fromJson(_res.data);
      return addressSingleModel;
    } catch (e) {
      print(e);
    }
  }

  Future<AddressSingleModel> postEditDataAddress(
    BuildContext context, 
    String idAddress,
    String typeAlamat,
    String noPonsel,
    String address,
    String province,
    String city,
    String postalCode,
    String subdistrict,
    List<double> lokasi,
  ) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response _res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/shipping/update",
      data: {
        "id": idAddress,
        "name": typeAlamat,
        "phoneNumber": noPonsel,
        "address": address,
        "postalCode": postalCode,
        "province": province,
        "city": city,
        "subdistrict": subdistrict,
        "defaultLocation": true,
        "location": lokasi
      });
      final AddressSingleModel addressSingleModel = AddressSingleModel.fromJson(_res.data);
      return addressSingleModel;
    } catch (e) {
      print(e);
    }
  }

  Future<AddressSingleModel> selectedAddress(BuildContext context, String idAddress, bool defaultLocation) async {
    final Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/shipping/update",
      data: {
        "id": idAddress, 
        "defaultLocation": defaultLocation
      });
      final AddressSingleModel addressSingleModel = AddressSingleModel.fromJson(res.data);
      return addressSingleModel;
    } catch (e) {
      print(e);
    }
  }
}
