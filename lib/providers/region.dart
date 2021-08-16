import "package:dio/dio.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/models/warung/address_model.dart';
import 'package:mbw204_club_ina/data/models/warung/address_single_model.dart';
import 'package:mbw204_club_ina/data/models/warung/region_model.dart';
import 'package:mbw204_club_ina/data/models/warung/region_subdistrict_model.dart';
import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dio.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

enum GetAddressStatus { loading, loaded, idle, empty, error, }

class RegionProvider with ChangeNotifier {

  GetAddressStatus _getAddressStatus = GetAddressStatus.loading;
  GetAddressStatus get getAddressStatus => _getAddressStatus;

  List<AddressList> _addressList = [];
  List<AddressList> get addresList => [..._addressList];

  void setStateGetAddressStatus(GetAddressStatus getAddressStatus) {
    _getAddressStatus = getAddressStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<RegionModel> getRegion(BuildContext context, String nameType) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/region/$nameType");
      RegionModel regionModel = RegionModel.fromJson(res.data);
      return regionModel;
    } catch (e) {
      print(e);
    }
  }

  Future<RegionModel> getCity(BuildContext context, String idProvince) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/region/city?provinceId=$idProvince");
      RegionModel regionModel = RegionModel.fromJson(res.data);
      return regionModel;
    } catch (e) {
      print(e);
    }
  }

  Future<RegionSubdistrictModel> getSubdistrict(BuildContext context, String idCity) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/region/subdistrict?cityId=$idCity");
      RegionSubdistrictModel regionSubdistrictModel = RegionSubdistrictModel.fromJson(res.data);
      return regionSubdistrictModel;
    } catch (e) {
      print(e);
    }
  }

  Future<AddressModel> getDataAddress(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/commerce/shipping/addresses");
      print(res.data);
      AddressModel addressModel = AddressModel.fromJson(res.data);
      _addressList = [];
      _addressList.addAll(addressModel.body);
      setStateGetAddressStatus(GetAddressStatus.loaded);
      if(_addressList.isEmpty) {
        setStateGetAddressStatus(GetAddressStatus.empty);
      }
      return addressModel;
    } on DioError catch(e) {
      setStateGetAddressStatus(GetAddressStatus.error);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        msg: "Failed: Internal Server Problem",
        fontSize: 14.0
      );
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } catch (e) {
      print(e);
    }
  }

  Future<AddressSingleModel> postDataAddress(
    BuildContext context,
    String typeAddress,
    String address,
    String province,
    String city,
    String subdistrict,
    String village,
    String postalCode,
  ) async {
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
      pr.style(
        message: 'Mohon Tunggu...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Loader(
          color: ColorResources.PRIMARY,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: poppinsRegular.copyWith(
          color: Colors.black, 
          fontSize: 14.0, 
          fontWeight: FontWeight.w400
        ),
        messageTextStyle: poppinsRegular.copyWith(
          color: Colors.black, 
          fontSize: 14.0, 
          fontWeight: FontWeight.w600
        )
      );
      pr.show();
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response _res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/shipping/add",
      data: {
        "name": typeAddress,
        "phoneNumber": Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber,
        "address": address,
        "postalCode": postalCode,
        "province": province,
        "city": city,
        "village": village,
        "subdistrict": subdistrict,
        "defaultLocation": true,
        "location": [Provider.of<LocationProvider>(context, listen: false).getCurrentLong, Provider.of<LocationProvider>(context, listen: false).getCurrentLat] 
      });
      if(_res.data["code"] == 411) {
        throw ServerErrorException(_res.data["error"]);
      }
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.SUCCESS,
        fontSize: 14.0,
        msg: "Alamat berhasil ditambah",
      );
      Navigator.of(context).pop();
      getDataAddress(context);
      final AddressSingleModel addressSingleModel = AddressSingleModel.fromJson(_res.data);
      return addressSingleModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      pr.hide();
    } on ServerErrorException catch(e) {
       Fluttertoast.showToast(
        fontSize: 14.0,
        msg: e.toString(),
        backgroundColor: ColorResources.ERROR
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
        backgroundColor: ColorResources.ERROR
      );
    }
  }

  Future<AddressSingleModel> postEditDataAddress(
    BuildContext context,
    String idAddress,
    String typeAddress,
    String address,
    String province,
    String city,
    String subdistrict,
    String village,
    String postalCode,
    bool defaultLocation,
  ) async {
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: 'Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(
        color: ColorResources.PRIMARY,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 14.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 14.0, 
        fontWeight: FontWeight.w600
      )
    );
    pr.show();
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response _res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/shipping/update",
      data: {
        "id": idAddress,
        "name": typeAddress,
        "phoneNumber": Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber,
        "address": address,
        "postalCode": postalCode,
        "province": province,
        "city": city,
        "village": village,
        "subdistrict": subdistrict,
        "defaultLocation": defaultLocation,
        "location": [Provider.of<LocationProvider>(context, listen: false).getCurrentLat, Provider.of<LocationProvider>(context, listen: false).getCurrentLong] 
      });
      pr.hide();
      Navigator.of(context).pop();
      Future.delayed(Duration(seconds: 1), () {
        getDataAddress(context);
      });
      Fluttertoast.showToast(
        backgroundColor: ColorResources.SUCCESS,
        fontSize: 14.0,
        msg: "Alamat berhasil diubah",
      );
      getDataAddress(context);
      final AddressSingleModel addressSingleModel = AddressSingleModel.fromJson(_res.data);
      return addressSingleModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      pr.hide();
      Fluttertoast.showToast(
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
        backgroundColor: ColorResources.ERROR
      );
    } catch (e) {
      print(e);
    }
  }

  Future<AddressSingleModel> selectedAddress(BuildContext context, List<AddressList> addressList, int i) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/shipping/update",
      data: {
        "id": addresList[i].id, 
        "defaultLocation": true
      });
      getDataAddress(context);
      AddressSingleModel addressSingleModel = AddressSingleModel.fromJson(res.data);
      return addressSingleModel;
    } on DioError catch (e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } catch(e) {
      print(e);
    }
  }
}
