import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/views/screens/store/cart_product.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/views/screens/store/buyer_transaction_order.dart';
import 'package:mbw204_club_ina/data/models/warung/ninja.dart';
import 'package:mbw204_club_ina/views/screens/store/seller_transaction_order.dart';
import 'package:mbw204_club_ina/data/models/warung/booking_courier.dart';
import 'package:mbw204_club_ina/data/models/warung/bank_payment_store.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/data/models/warung/couriers_model.dart';
import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';
import 'package:mbw204_club_ina/data/models/mediakey.dart';
import 'package:mbw204_club_ina/data/models/warung/card_add_model.dart';
import 'package:mbw204_club_ina/data/models/warung/category_product_model.dart';
import 'package:mbw204_club_ina/data/models/warung/checkout_cart_warung_model.dart';
import 'package:mbw204_club_ina/data/models/warung/product_single_warung_model.dart';
import 'package:mbw204_club_ina/data/models/warung/product_warung_model.dart';
import 'package:mbw204_club_ina/data/models/warung/review_product_model.dart';
import 'package:mbw204_club_ina/data/models/warung/review_product_single_model.dart';
import 'package:mbw204_club_ina/data/models/warung/shipping_couriers_model.dart';
import 'package:mbw204_club_ina/data/models/warung/shipping_tracking_model.dart';
import 'package:mbw204_club_ina/data/models/warung/transaction_warung_paid_model.dart';
import 'package:mbw204_club_ina/data/models/warung/transaction_warung_paid_single_model.dart';
import 'package:mbw204_club_ina/data/models/warung/transaction_warung_unpaid_model.dart';
import 'package:mbw204_club_ina/data/models/warung/seller_store_model.dart';
import 'package:webview_flutter/platform_interface.dart';

enum CategoryProductStatus { loading, loaded, empty, error } 
enum CategoryProductByParentStatus { loading, loaded, empty, error }
enum SellerStoreStatus { loading, loaded, empty, error }
enum CartStatus { loading, loaded, empty, error }
enum SingleProductStatus { loading, loaded, empty, error }
enum CourierStatus { idle, loading, loaded, error, empty }
enum CreateStoreStatus { idle, loading, loaded, error, empty }
enum PickupTimeslotsStatus { idle, loading, loaded, error, empty }
enum DeliveryTimeslotsStatus { idle, loading, loaded, error, empty }
enum DimenstionStatus { idle, loading, loaded, error, empty }
enum ApproximatelyStatus { idle, loading, loaded, error, empty }

class WarungProvider with ChangeNotifier {

  String descStore;
  String descAddSellerStore;
  String descEditSellerStore;

  String _categoryAddProductTitle;
  String get categoryAddProductTitle => _categoryAddProductTitle;

  String _categoryAddProductId;
  String get categoryAddProductId => _categoryAddProductId;

  String _categoryEditProductTitle;
  String get categoryEditProductTitle => _categoryEditProductTitle;

  String _categoryEditProductId;
  String get categoryEditProductId => _categoryEditProductId;

  CategoryProductStatus _categoryProductStatus = CategoryProductStatus.loading;
  CategoryProductStatus get categoryProductStatus => _categoryProductStatus;

  CreateStoreStatus _createStoreStatus = CreateStoreStatus.loading;
  CreateStoreStatus get createStoreStatus => _createStoreStatus;

  CartStatus _cartStatus = CartStatus.loading;
  CartStatus get cartStatus => _cartStatus;

  SingleProductStatus _singleProductStatus = SingleProductStatus.loading;
  SingleProductStatus get singleProductStatus => _singleProductStatus;

  SellerStoreStatus _sellerStoreStatus = SellerStoreStatus.loading;
  SellerStoreStatus get sellerStoreStatus => _sellerStoreStatus; 
   
  CourierStatus _courierStatus = CourierStatus.loading;
  CourierStatus get courierStatus => _courierStatus;

  PickupTimeslotsStatus _pickupTimeslotsStatus = PickupTimeslotsStatus.loading;
  PickupTimeslotsStatus get pickupTimeslotsStatus => _pickupTimeslotsStatus; 

  DeliveryTimeslotsStatus _deliveryTimeslotsStatus = DeliveryTimeslotsStatus.loading;
  DeliveryTimeslotsStatus get deliveryTimeslotsStatus => _deliveryTimeslotsStatus;

  DimenstionStatus _dimenstionStatus = DimenstionStatus.loading;
  DimenstionStatus get dimenstionStatus => _dimenstionStatus;

  ApproximatelyStatus _approximatelyStatus = ApproximatelyStatus.loading;
  ApproximatelyStatus get approximatelyStatus => _approximatelyStatus; 

  CategoryProductByParentStatus _categoryProductByParentStatus = CategoryProductByParentStatus.loading;
  CategoryProductByParentStatus get categoryProductByParentStatus => _categoryProductByParentStatus; 

  List<Map<String, Object>> assignCampaignListProduct = [];
  List<StoreElement> _cartStores = [];
  List<String> isCheckedKurir = [];

  List categoryHasManyProduct = []; 
  List<CategoryProductList> categoryProductList = [];
  
  List<CategoryProductList> _categoryProductByParentList = [];
  List<CategoryProductList> get categoryProductByParentList => [..._categoryProductByParentList];
  
  List<StoreElement> get cartStores => [..._cartStores];

  List<CouriersModelList> _couriersModelList = [];
  List<CouriersModelList> get couriersModelList => [..._couriersModelList];

  List _pickupTimeslots = [];
  List get pickupTimeslots => [..._pickupTimeslots];

  List _deliveryTimeslots = [];
  List get deliveryTimeslots => [..._deliveryTimeslots];

  List _approximatelyVolumes = [];
  List get approximatelyVolumes => [..._approximatelyVolumes];

  List _dimensionsSize = [];
  List get dimensionsSize => [..._dimensionsSize];

  String dataPickupTimeslots = "";
  String dataDeliveryTimeslots = "";
  String dataDimensionsSize = "";
  String dataApproximatelyVolumes = "";
  String dataDatePickup = DateTime.now().toIso8601String();
  int dataDimensionsHeight = 0;
  int dataDimensionsLength = 0;
  int dataDimensionsWidth = 0;

  CartBody cartBody;
  SellerStoreModel sellerStoreModel;

  void setStateCategoryProductParentStatus(CategoryProductByParentStatus categoryProductByParentStatus) {
    _categoryProductByParentStatus = categoryProductByParentStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
 
  void setStateCategoryProductStatus(CategoryProductStatus categoryProductStatus) {
    _categoryProductStatus = categoryProductStatus;
    Future.delayed(Duration.zero, () => notifyListeners());  
  }

  void setStateCartStatus(CartStatus cartStatus) {
    _cartStatus = cartStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCreateStoreStatus(CreateStoreStatus createStoreStatus) {
    _createStoreStatus = createStoreStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSingleProductStatus(SingleProductStatus singleProductStatus) {
    _singleProductStatus = singleProductStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
 
  void setStateSellerStoreStatus(SellerStoreStatus sellerStoreStatus) { 
    _sellerStoreStatus = sellerStoreStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCourierStatus(CourierStatus courierStatus) {
    _courierStatus = courierStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePickupTimeslotsStatus(PickupTimeslotsStatus pickupTimeslotsStatus) {
    _pickupTimeslotsStatus = pickupTimeslotsStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateDeliveryTimeslotsStatus(DeliveryTimeslotsStatus deliveryTimeslotsStatus) {
    _deliveryTimeslotsStatus = deliveryTimeslotsStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateDimenstionStatus(DimenstionStatus dimenstionStatus) {
    _dimenstionStatus = dimenstionStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateApproximatelyVolumesStatus(ApproximatelyStatus approximatelyStatus) {
    _approximatelyStatus = approximatelyStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
  
 
  Future<SellerStoreModel> getDataStore(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/seller/store/fetch");
     
      if(res.data["code"] == 404) {       
        throw DioError(error: 404);
      } 
      if(res.data["code"] == 500) {
        throw DioError(error: 500);
      } 

      SellerStoreModel _sellerStoreModel = SellerStoreModel.fromJson(res.data);
      sellerStoreModel = _sellerStoreModel;
      descStore = sellerStoreModel?.body?.description;
      setStateSellerStoreStatus(SellerStoreStatus.loaded);
      return _sellerStoreModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      if(e?.error == 404) {
        setStateSellerStoreStatus(SellerStoreStatus.empty);
      } else {
        setStateSellerStoreStatus(SellerStoreStatus.error);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<SellerStoreModel> postCreateDataStore(
    BuildContext context,
    File file, 
    String nameStore, 
    String province, 
    String city, 
    String village, 
    String postalCode, 
    String address, 
    String subDistrict,
    String email, 
    String phone, 
    [String deskripsi = ""]
  ) async {
    ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: ' Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(
        color: ColorResources.PRIMARY,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
    );
    pr.show();
    Map<String, dynamic> data = {
      "name": nameStore,
      "picture": {
        "originalName": basename(file.path),
        "fileLength": file.lengthSync(),
        "path": "/commerce/indomini/$phone/${basename(file.path)}",
        "contentType": lookupMimeType(basename(file.path))
      },
      "province": province,
      "city": city,
      "postalCode": postalCode,
      "village": village, 
      "address": address,
      "subdistrict": subDistrict,
      "email": email, 
      "phone": phone,
      "location": [Provider.of<LocationProvider>(context, listen: false).getCurrentLong, Provider.of<LocationProvider>(context, listen: false).getCurrentLat],
      "supportedCouriers": isCheckedKurir
    };
    if (deskripsi.trim().length > 0) {
      data.addAll({"description": deskripsi});
    }
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/seller/store/create", data: data);
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.SUCCESS,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Selamat! Toko Anda berhasil dibuka" 
      );
      SellerStoreModel sellerStoreModel = SellerStoreModel.fromJson(res.data);
      return sellerStoreModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<SellerStoreModel> postEditDataStore(
    BuildContext context,
    String idStore, 
    String nameStore, 
    String province, 
    String city, 
    String subDistrict,
    String village,
    String postalCode, 
    String address,  
    String email,
    String phone,
    bool statusToko, [File file]) async {
    ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
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
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
    );
    pr.show();
    Map<String, dynamic> data = {
      "id": idStore,
      "name": nameStore,
      "description": descStore,
      "province": province,
      "city": city,
      "subdistrict": subDistrict,
      "village": village,
      "postalCode": postalCode,
      "email": email,
      "phone": phone,
      "address": address,
      "supportedCouriers": isCheckedKurir,
      "open": statusToko,
      "location": [Provider.of<LocationProvider>(context, listen: false).getCurrentLong, Provider.of<LocationProvider>(context, listen: false).getCurrentLat],
    };
    String path = Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber;
    if (file != null) {
      data.addAll({
        "picture": {
          "originalName": basename(file.path),
          "fileLength": file.lengthSync(),
          "path": "/commerce/indomini/$path/${basename(file.path)}",
          "contentType": lookupMimeType(basename(file.path)),
          "classId": "media"
        }
      });
    }
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/seller/store/update", data: data);
      pr.hide();
      getDataStore(context);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.SUCCESS,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Toko berhasil diubah" 
      );
      Navigator.of(context).pop();
      final SellerStoreModel sellerStoreModel = SellerStoreModel.fromJson(res.data);
      return sellerStoreModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<CategoryProductModel> getDataCategoryProduct(BuildContext context, String typeProduct) async {
    try {
    
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/$typeProduct/product/categories");
      CategoryProductModel categoryProductModel = CategoryProductModel.fromJson(res.data);
    
      if(res.data['code'] == 404) {
        throw DioError(error: 404);
      } 

      if(res.data['code'] == 500) {
        throw DioError(error: 500);
      } 
      
      if(categoryHasManyProduct.length != categoryProductModel.body.length) {
        var categoryHasManyProductAssign = [];
        categoryProductList = [];
        categoryProductList.addAll(categoryProductModel.body);
        for (var item in categoryProductModel.body) {
          ProductWarungModel productWarungModel = await getDataProductByCategoryConsumen(context, "", item.id, 0);
          List<ProductWarungList> productWarungList = productWarungModel.body;
          categoryHasManyProductAssign.add({
            "id": item.id,
            "category": item.name,
            "items": productWarungList,
          });
        }
        categoryHasManyProduct = categoryHasManyProductAssign;
        setStateCategoryProductStatus(CategoryProductStatus.loaded);
      }
      return categoryProductModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
      if(e?.error == 404) {
        setStateCategoryProductStatus(CategoryProductStatus.empty);
      } else if(e?.error == 500) {
        setStateCategoryProductStatus(CategoryProductStatus.error);
      } else {
        setStateCategoryProductStatus(CategoryProductStatus.error);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<CategoryProductModel> getDataCategoryProductByParent(BuildContext context, String typeProduct, String parentId) async {
    try {
      setStateCategoryProductParentStatus(CategoryProductByParentStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/$typeProduct/product/categories?parentId=$parentId");
      CategoryProductModel categoryProductModel = CategoryProductModel.fromJson(res.data);
      _categoryProductByParentList = [];
      List<CategoryProductList> categoryProductByParentList = categoryProductModel.body;
      _categoryProductByParentList.addAll(categoryProductByParentList);
      setStateCategoryProductParentStatus(CategoryProductByParentStatus.loaded);
      if(categoryProductByParentList.length == 0) {
        setStateCategoryProductParentStatus(CategoryProductByParentStatus.empty);
      }
      return categoryProductModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    } catch (e) {
      print(e);
    }
  }

  Future<ProductWarungModel> getDataProductByCategoryConsumen(BuildContext context, String name, String idCategory, int page) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/commerce/product/filter?categoryId=$idCategory&search=$name&page=$page&size=10&sort=stock,desc");
      ProductWarungModel productWarungModel = ProductWarungModel.fromJson(res.data);
      return productWarungModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    } catch (e) {
      print(e);
    }
  }

  Future<ProductWarungModel> getDataSearchProduct(BuildContext context, String nameProduct, int page) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/commerce/product/filter?categoryId=all&page=0&size=10&sort=created,desc&search=$nameProduct");
      ProductWarungModel productWarungModel = ProductWarungModel.fromJson(res.data);
      return productWarungModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<ProductWarungModel> getDataProductByCategorySeller(BuildContext context, String idCategory, int page) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/seller/product/filter?categoryId=$idCategory&page=$page&size=10&sort=stock,desc");
      ProductWarungModel productWarungModel = ProductWarungModel.fromJson(res.data);
      return productWarungModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error']
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<ProductSingleWarungModel> getDataSingleProduct(BuildContext context, String idProduct, String typeProduct, String path) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/$typeProduct/product$path/$idProduct");
      
      if(res.data['code'] == 404) {
        throw DioError(error: 404);
      }
      if(res.data['code'] == 500) {
        throw DioError(error: 500);
      }
      
      ProductSingleWarungModel productSingleWarungModel = ProductSingleWarungModel.fromJson(res.data);
      descEditSellerStore = productSingleWarungModel?.body?.description;
      _categoryEditProductId = productSingleWarungModel?.body?.category?.id;
      _categoryEditProductTitle = productSingleWarungModel?.body?.category?.name;
      setStateSingleProductStatus(SingleProductStatus.loaded);
      return productSingleWarungModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
      if(e?.error == 404) {
        setStateSingleProductStatus(SingleProductStatus.empty);
      } else if(e?.error == 500) {
        setStateSingleProductStatus(SingleProductStatus.error);
      } else {
        setStateSingleProductStatus(SingleProductStatus.error);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<String> getMediaKeyMedia(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_FEED_MEDIA}/mediaKey");
      final MediaKey mediaKey = MediaKey.fromJson(res.data);
      return mediaKey?.body;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<Response> uploadImageProduct(BuildContext context, String mediaKey, String base64, File file) async {
    try {
      Dio dio = Dio();
      String url = "${AppConstants.BASE_URL_FEED_MEDIA}/$mediaKey/$base64?path=/commerce/indomini/${Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber}/${basename(file.path)}";
      Response res = await dio.post(url, data: file.readAsBytesSync());
      return res;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<ProductSingleWarungModel> postDataProductWarung(BuildContext context, String nameProduct, int price, List<File> files, int weight, int stock, String condition, String typeStuff, int minOrder, String idStore) async {
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
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
    );
    pr.show();
    List<Map<String, Object>> postsPictures = [];
    for (int i = 0; i < files.length; i++) {
      postsPictures.add({
        "originalName": basename(files[i].path),
        "fileLength": files[i].lengthSync(),
        "path": "/commerce/indomini/${Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber}/${basename(files[i].path)}",
        "contentType": lookupMimeType(basename(files[i].path))
      });
    }
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/seller/product/create", data: {
        "name": nameProduct,
        "categoryId": categoryAddProductId,
        "price": price,
        "pictures": postsPictures,
        "weight": weight,
        "description": descAddSellerStore,
        "stock": stock,
        "condition": condition,
        "minOrder": minOrder,
        "harmful" : typeStuff == "Berbahaya" ? true : false,
        "liquid" : typeStuff == "Cair" ? true : false,
        "flammable" : typeStuff == "Mudah Terbakar" ? true : false,
        "fragile" : typeStuff == "Mudah Pecah" ? true : false
      });
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.SUCCESS,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Produk telah ditambahkan",
      );
      int count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 1;
      });
      ProductSingleWarungModel productSingleWarungModel = ProductSingleWarungModel.fromJson(res.data);
      return productSingleWarungModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<ProductSingleWarungModel> postEditDataProductWarung(BuildContext context, String idProduct, String nameProduct, int price, List<File> files, int weight, int stock, String condition, int minOrder, String typeStuff) async {
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
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
    );
    pr.show();
    if (files != null || files.length > 0) {
      List<Map<String, Object>> postsPictures = [];
      for (int i = 0; i < files.length; i++) {
        postsPictures.add({
          "originalName": basename(files[i].path),
          "fileLength": files[i].lengthSync(),
          "path": "/commerce/indomini/${Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber}/${basename(files[i].path)}",
          "contentType": lookupMimeType(basename(files[i].path))
        });
      }
      try {
        Dio dio = await DioManager.shared.getClient(context);
        Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/seller/product/update", data: {
          "id": idProduct,
          "name": nameProduct,
          "categoryId": categoryEditProductId,
          "price": price,
          "pictures": postsPictures,
          "weight": weight,
          "description": descEditSellerStore,
          "stock": stock,
          "condition": condition,
          "minOrder": minOrder,
          "harmful" : typeStuff == "Berbahaya" ? true : false,
          "liquid" : typeStuff == "Cair" ? true : false,
          "flammable" : typeStuff == "Mudah Terbakar" ? true : false,
          "fragile" : typeStuff == "Mudah Pecah" ? true : false
        });
        pr.hide();
        Fluttertoast.showToast(
          backgroundColor: ColorResources.SUCCESS,
          textColor: ColorResources.WHITE,
          fontSize: 14.0,
          msg: "Produk telah diubah",
        );
        Navigator.of(context).pop();
        final ProductSingleWarungModel productSingleWarungModel = ProductSingleWarungModel.fromJson(res.data);
        return productSingleWarungModel;
      } on DioError catch(e) {
        print(e?.response?.statusCode);
        print(e?.response?.data);
        pr.hide();
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          textColor: ColorResources.WHITE,
          fontSize: 14.0,
          msg: e?.response?.data['error'],
        );
      } catch (e) {
        pr.hide();
        print(e);
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          textColor: ColorResources.WHITE,
          fontSize: 14.0,
          msg: "Failed: Internal Server Problem",
        );
      }
    } else {
      try {
        Dio dio = await DioManager.shared.getClient(context);
        Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/seller/product/update", data: {
          "id": idProduct,
          "name": nameProduct,
          "categoryId": categoryEditProductId,
          "price": price,
          "weight": weight,
          "description": descEditSellerStore,
          "stock": stock,
          "condition": condition,
          "minOrder": minOrder,
          "harmful" : typeStuff == "Berbahaya" ? true : false,
          "liquid" : typeStuff == "Cair" ? true : false,
          "flammable" : typeStuff == "Mudah Terbakar" ? true : false,
          "fragile" : typeStuff == "Mudah Pecah" ? true : false
        });
        pr.hide();
        Fluttertoast.showToast(
          backgroundColor: ColorResources.SUCCESS,
          textColor: ColorResources.WHITE,
          fontSize: 14.0,
          msg: "Produk telah diubah",
        );
        Navigator.of(context).pop();
        ProductSingleWarungModel productSingleWarungModel = ProductSingleWarungModel.fromJson(res.data);
        return productSingleWarungModel;
      } on DioError catch(e) {
        print(e?.response?.statusCode);
        print(e?.response?.data);
        pr.hide();
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          textColor: ColorResources.WHITE,
          fontSize: 14.0,
          msg: e?.response?.data['error'],
        );
      } catch (e) {
        print(e);
        pr.hide();
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          textColor: ColorResources.WHITE,
          fontSize: 14.0,
          msg: "Failed: Internal Server Problem",
        );
      }
    }
  }

  Future<ProductSingleWarungModel> postDeleteProductWarung(BuildContext context, String idProduct, int status) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/seller/product/update", data: {
        "id": idProduct,
        "status": status,
      });
      ProductSingleWarungModel productSingleWarungModel = ProductSingleWarungModel.fromJson(res.data);
      return productSingleWarungModel;
    } on DioError catch(e) {
      print(e?.response?.data);
      print(e?.response?.statusCode);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<CartModel> getCartInfo(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/commerce/cart/info");

      if(res.data['code'] == 404) {
        throw DioError(error: 404);
      }
      if(res.data['code'] == 500) {
        throw DioError(error: 500);
      }

      CartModel cartModel = CartModel.fromJson(res.data);
      _cartStores = [];
      List<StoreElement> cartStores = cartModel?.body?.stores;
      cartBody = cartModel?.body;
      _cartStores.addAll(cartStores);

      setStateCartStatus(CartStatus.loaded);   
      return cartModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      if(e?.error == 404) {
        setStateCartStatus(CartStatus.empty);
        cartBody = null;
      } 
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
      setStateCartStatus(CartStatus.error);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<CartModel> postAddCart(BuildContext context, String idProduct, int qty) async {
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: ' Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(
        color: ColorResources.PRIMARY,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
    );
    pr.show();
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/cart/add",
      data: {
        "productId": idProduct, 
        "quantity": qty, 
        "note": ""
      },
      options: Options(contentType: Headers.formUrlEncodedContentType));
      pr.hide();
      Navigator.push(context,
        MaterialPageRoute(builder: (context) {
        return CartProdukPage();
      }));
      CartModel cartModel = CartModel.fromJson(res.data);
      return cartModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future postEditQuantityCart(BuildContext context, String storeId, String idProduct, int qty, String type) async { 
    int storeIndex = cartStores.indexWhere((el) => el.storeId == storeId);
    int productIndex = cartStores[storeIndex].items.indexWhere((el) => el.productId == idProduct);
    cartStores[storeIndex].items[productIndex].quantity = qty;

    if(type == "increment") {
      cartBody.totalProductPrice += cartStores[storeIndex].items[productIndex].price;
      cartBody.numOfItems = cartStores.fold(cartBody.numOfItems, (previousValue, element) => previousValue + 1);
    } else if (type == "decrement") {
      cartBody.totalProductPrice -= cartStores[storeIndex].items[productIndex].price;
      cartBody.numOfItems = cartStores.fold(cartBody.numOfItems, (previousValue, element) => previousValue - 1);
    }
    Future.delayed(Duration.zero, () => notifyListeners());
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/cart/updateQty",
        data: {
          "productId": idProduct,
          "quantity": qty,
        },
      options: Options(contentType: Headers.formUrlEncodedContentType));
      CartModel cartModel = CartModel.fromJson(res.data);
      return cartModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future postEditNoteCart(BuildContext context, String idProduct, String note) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/cart/updateNote",
      data: {
        "productId": idProduct,
        "note": note,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType));
      getCartInfo(context);
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future postDeleteProductCart(BuildContext context, String idProduct) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/cart/delete",
      data: {
        "productId": idProduct,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType));
      getCartInfo(context);
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<CartModel> postEmptyProductCart(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/cart/empty");
      CartModel cartModel = CartModel.fromJson(res.data);
      return cartModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    } catch (e) {
      print(e);
    }
  }

  Future<CheckoutCartWarungModel> postCartCheckout(BuildContext context, String paymentChannel) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/cart/checkout",
      data: {
        "paymentChannel": paymentChannel,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType));
      CheckoutCartWarungModel checkoutCartWarungModel = CheckoutCartWarungModel.fromJson(res.data);
      return checkoutCartWarungModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<ShippingCouriersModel> getCourierShipping(BuildContext context, String storeId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/commerce/shipping/couriers?storeId=$storeId");
      ShippingCouriersModel shippingCouriersModel = ShippingCouriersModel.fromJson(res.data);
      return shippingCouriersModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<CartModel> postSetCouriers(BuildContext context, String idStore, String courierCostId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/cart/courier",
      data: {
        "storeId": idStore,
        "courierCostId": courierCostId
      },
      options: Options(contentType: Headers.formUrlEncodedContentType));
      CartModel cartModel = CartModel.fromJson(res.data);
      return cartModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error']
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<TransactionWarungUnpaidModel> getTransactionUnpaid(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/transaction/buyer/unpaids");
      TransactionWarungUnpaidModel transactionWarungUnpaidModel = TransactionWarungUnpaidModel.fromJson(res.data);
      return transactionWarungUnpaidModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error']
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<TransactionWarungPaidModel> getTransactionBuyerPaid(BuildContext context, String status) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/transaction/buyer/orders?orderStatus=$status");
      TransactionWarungPaidModel transactionWarungPaidModel = TransactionWarungPaidModel.fromJson(res.data);
      return transactionWarungPaidModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<TransactionWarungPaidSingleModel> getTransactionPaidSingle(BuildContext context, String idTrx, String typeUser) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/transaction/$typeUser/order/fetch/$idTrx");
      TransactionWarungPaidSingleModel transactionWarungPaidSingleModel = TransactionWarungPaidSingleModel.fromJson(res.data);
      return transactionWarungPaidSingleModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error']
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<TransactionWarungPaidModel> getTransactionSellerPaid(BuildContext context, String status) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/transaction/seller/orders?orderStatus=$status");
      TransactionWarungPaidModel transactionWarungPaidModel = TransactionWarungPaidModel.fromJson(res.data);
      return transactionWarungPaidModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<BookingCourierModel> bookingCourier(BuildContext context, String orderId, String courierId, [String pickupInstruction = "", 
    String deliveryInstuction = "", String deliveryTimeSlot = ""]) async {
    Map<String, dynamic> data = {};
    
    if(courierId == "jne") {
      data.addAll({
        "orderId" : orderId,
        "pickupDate" : "",
        "pickupTimeSlot" : "",
        "pickupApproxVolume" : "",
        "pickupInstruction" : "",
        "deliveryInstruction" : "",
        "deliveryTimeSlot" : ""
      });
    } else if(courierId == "ninja") {
      data.addAll({
        "orderId" : orderId,
        "pickupDate" : dataDatePickup,
        "pickupTimeSlot" : dataPickupTimeslots,
        "deliveryTimeSlot" : dataDeliveryTimeslots,
        "pickupApproxVolume" : dataApproximatelyVolumes,
        "dimensionHeight": dataDimensionsHeight,
        "dimensionLength": dataDimensionsLength,
        "dimensionSize": dataDimensionsSize,
        "dimensionWidth": dataDimensionsWidth,
        "pickupInstruction" : "",
        "deliveryInstruction" : "",
      });
    }
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: ' Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(
        color: ColorResources.PRIMARY,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
    );
    pr.show();
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/transaction/seller/order/booking",
        data: data
      );
      pr.hide();
      if(res.data['code'] == 500) {
        throw ServerErrorException(res.data['error']);
      }
      if(res.data['code'] == 305) {
        throw ServerErrorException(res.data['error']);
      }
      BookingCourierModel bookingCourierModel = BookingCourierModel.fromJson(res.data);
      if(courierId == "jne") {
        showAnimatedDialog(
          context: context, 
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 15.0, bottom: 15.0),
              height: 250.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Column(
                children: [
                  Text("Nomor Resi Anda ${bookingCourierModel.body.waybill}. Silahkan bawa paket anda ke Kurir / Agent JNE terdekat Anda.",
                    style: poppinsRegular.copyWith(
                      fontSize: 15.0
                    )
                  ),
                  SizedBox(height: 8.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: ColorResources.PRIMARY
                    ),
                    onPressed: () => Navigator.of(context).pop,
                    child: Text("OK"),
                  )
                ],
              ),
            );          
          },
        );
      } else {
        showAnimatedDialog(
          context: context, 
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 15.0, bottom: 15.0),
              height: 250.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Column(
                children: [
                  Text("Nomor Resi Anda ${bookingCourierModel.body.waybill}. Kurir terdekat akan jemput paket Anda",
                    style: poppinsRegular.copyWith(
                      fontSize: 15.0
                    )
                  ),
                  SizedBox(height: 8.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: ColorResources.PRIMARY
                    ),
                    onPressed: () => Navigator.of(context).pop,
                    child: Text("OK"),
                  )
                ],
              ),
            );          
          },
        );
      }
      dataDatePickup = null;
      dataPickupTimeslots = null;
      dataApproximatelyVolumes = null;
      dataDimensionsHeight = null;
      dataDimensionsLength = null;
      dataDimensionsWidth = null;
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SellerTransactionOrderScreen(index: 2);
      }));
      return bookingCourierModel;
    } on ServerErrorException catch(e) {
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "${e.toString()}",
      );
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch(e) {
      pr.hide();
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<TransactionWarungPaidSingleModel> postOrderPacking(BuildContext context, String orderId) async {
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
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
    );
    pr.show();
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/transaction/seller/order/packing",
        data: {"orderId": orderId},
        options: Options(contentType: Headers.formUrlEncodedContentType)
      );
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.SUCCESS,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg:"Konfirmasi pesanan berhasil",
      );
      Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
        return SellerTransactionOrderScreen(
          index: 1
        );
      }));
      TransactionWarungPaidSingleModel transactionWarungPaidSingleModel = TransactionWarungPaidSingleModel.fromJson(res.data);
      return transactionWarungPaidSingleModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg:e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg:"Failed: Internal Server Problem",
      );
    }
  }

  Future<TransactionWarungPaidSingleModel> postInputResi(BuildContext context, String orderId, String wayBill) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/transaction/seller/order/shipping",
      data: {
        "orderId": orderId, 
        "wayBill": wayBill
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType)
      );
      TransactionWarungPaidSingleModel transactionWarungPaidSingleModel = TransactionWarungPaidSingleModel.fromJson(res.data);
      return transactionWarungPaidSingleModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error']
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<TransactionWarungPaidSingleModel> postOrderDone(BuildContext context, String orderId) async {
    print(orderId);
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: ' Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(
        color: ColorResources.PRIMARY
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
    );
    pr.show();
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/transaction/buyer/order/done",
        data: {
          "orderId": orderId
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType
        )
      );
      print(res.data);
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.SUCCESS,
        textColor: Colors.white,
        fontSize: 14.0,
        msg: "Barang diterima berhasil dikonfirmasi",
      );
      await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext cn) => AlertDialog(
        contentTextStyle: poppinsRegular,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        content: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Terima kasih telah berbelanja di Toko kami, Uang akan diteruskan ke Penjual",
                    style: poppinsRegular.copyWith(
                      fontSize: 14.0, 
                      color: Colors.black
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                return TransactionOrderScreen(index: 5);
                              }));
                            },
                            child: Container(
                              height: 45.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: ColorResources.PRIMARY
                              ),
                              child: Center(
                                child: Text("Kasih Ulasan Produk",
                                  style: poppinsRegular.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      );
      TransactionWarungPaidSingleModel transactionWarungPaidSingleModel = TransactionWarungPaidSingleModel.fromJson(res.data);
      return transactionWarungPaidSingleModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);      
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      pr.hide();
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<ReviewProductModel> getReviewProductList(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/transaction/buyer/review/list");
      final ReviewProductModel reviewProductModel = ReviewProductModel.fromJson(res.data);
      return reviewProductModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<ReviewProductSingleModel> postDataReviewProduct(BuildContext context, String idProduct, double star, String review, List<File> files) async {
    List<Map<String, Object>> postsPictures = [];
    for (int i = 0; i < files.length; i++) {
      postsPictures.add({
        "originalName": basename(files[i].path),
        "fileLength": files[i].lengthSync(),
        "path": "/commerce/umart/$idProduct/${basename(files[i].path)}",
        "contentType": lookupMimeType(basename(files[i].path))
      });
    }
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/transaction/buyer/review/add", data: {
        "productId": idProduct,
        "star": star,
        "text": review,
        "photos": postsPictures,
      });
      ReviewProductSingleModel reviewProductSingleModel = ReviewProductSingleModel.fromJson(res.data);
      return reviewProductSingleModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<ShippingTrackingModel> getShippingTracking(BuildContext context, String idOrder) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/commerce/order/status?orderId=$idOrder");
      ShippingTrackingModel shippingTrackingModel = ShippingTrackingModel.fromJson(res.data);
      return shippingTrackingModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<CouriersModel> getDataCouriers(BuildContext context) async {
    try {
      setStateCourierStatus(CourierStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/seller/store/couriers");
      CouriersModel couriersModel = CouriersModel.fromJson(res.data);
      _couriersModelList = [];
      List<CouriersModelList> couriersModelList = couriersModel.body;
      _couriersModelList.addAll(couriersModelList);
      setStateCourierStatus(CourierStatus.loaded);
      return couriersModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error']
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<BankPaymentStore> getDataBank(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/commerce/payments");
      BankPaymentStore bankPaymentStore = BankPaymentStore.fromJson(res.data);
      return bankPaymentStore;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch(e) {
      print(e); 
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<NinjaModel> getPickupTimeslots(BuildContext context) async {
    try {
      setStatePickupTimeslotsStatus(PickupTimeslotsStatus.loading);
      _pickupTimeslots = [];
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE_PICKUP_TIMESLOTS}");
      NinjaModel ninjaModel = NinjaModel.fromJson(res.data);
      for (int i = 0; i < ninjaModel.body.length; i++) {
        _pickupTimeslots.add({
          "id": i.toString(),
          "name": ninjaModel.body[i]
        });
      }
      setStatePickupTimeslotsStatus(PickupTimeslotsStatus.loaded);
      return ninjaModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      setStatePickupTimeslotsStatus(PickupTimeslotsStatus.error);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch(e) {
      print(e);
      setStatePickupTimeslotsStatus(PickupTimeslotsStatus.error);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<NinjaModel> getDeliveryTimeslots(BuildContext context) async {
    try {
      setStateDeliveryTimeslotsStatus(DeliveryTimeslotsStatus.loading);
      _deliveryTimeslots = [];
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE_DELIVERY_TIMESLOTS}");
      NinjaModel ninjaModel = NinjaModel.fromJson(res.data);
      for (int i = 0; i < ninjaModel?.body?.length; i++) {
        _deliveryTimeslots.add({
          "id": i.toString(),
          "name": ninjaModel.body[i]
        });
      }
      setStateDeliveryTimeslotsStatus(DeliveryTimeslotsStatus.loaded);
      return ninjaModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      setStateDeliveryTimeslotsStatus(DeliveryTimeslotsStatus.error);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error'],
      );
    } catch(e) {
      print(e);
      setStateDeliveryTimeslotsStatus(DeliveryTimeslotsStatus.error);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  Future<NinjaModel> getDimenstionSize(BuildContext context) async {
    try {
      setStateDimenstionStatus(DimenstionStatus.loading);
      _dimensionsSize = [];
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE_DIMENSTION_SIZE}");
      NinjaModel ninjaModel = NinjaModel.fromJson(res.data);
      for (int i = 0; i < ninjaModel.body.length; i++) {
        _dimensionsSize.add({
          "id": i.toString(),
          "name": ninjaModel.body[i]
        });
      }
      setStateDimenstionStatus(DimenstionStatus.loaded);
      return ninjaModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      setStateDimenstionStatus(DimenstionStatus.error);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error']
      );
    } catch(e) {
      print(e);
      setStateDimenstionStatus(DimenstionStatus.error);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

   Future<NinjaModel> getApproximatelyVolumes(BuildContext context) async {
    try {
      setStateApproximatelyVolumesStatus(ApproximatelyStatus.loading);
      _approximatelyVolumes = [];
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE_APPROXIMATELY_VOLUMES}");
      NinjaModel ninjaModel = NinjaModel.fromJson(res.data);
      for (int i = 0; i < ninjaModel.body.length; i++) {
        _approximatelyVolumes.add({
          "id": i.toString(),
          "name": ninjaModel.body[i]
        });
      }
      setStateApproximatelyVolumesStatus(ApproximatelyStatus.loaded);
      return ninjaModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      setStateApproximatelyVolumesStatus(ApproximatelyStatus.error);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: e?.response?.data['error']
      );
    } catch(e) {
      print(e);
      setStateApproximatelyVolumesStatus(ApproximatelyStatus.error);
      Fluttertoast.showToast(
        backgroundColor: ColorResources.ERROR,
        textColor: ColorResources.WHITE,
        fontSize: 14.0,
        msg: "Failed: Internal Server Problem",
      );
    }
  }

  void changeCourier(bool val, String courierId) {
    if(val) {
      isCheckedKurir.add(courierId);
    } else {
      isCheckedKurir.remove(courierId);
    }
    notifyListeners();
  }

  void changeDescStore(String _descStore) {
    descStore = _descStore;
    notifyListeners();
  }

  void changeDescAddSellerStore(String _descAddSellerStore) {
    descAddSellerStore = _descAddSellerStore;
    notifyListeners();
  }

  void changeDescEditSellerStore(String _descEditSellerStore) {
    descEditSellerStore = _descEditSellerStore;
    notifyListeners();
  }

  void changeCategoryAddProductTitle(String categoryAddProductTitle, String categoryAddProductId) {
    _categoryAddProductId = categoryAddProductId;
    _categoryAddProductTitle = categoryAddProductTitle;
    notifyListeners();
  }

  void changeCategoryEditProductTitle(String categoryEditProductTitle, String categoryEditProductId) {
    _categoryEditProductId = categoryEditProductId;
    _categoryEditProductTitle = categoryEditProductTitle;
    notifyListeners();
  }

  void changePickupTimeSlots(String timeSlots) {
    dataPickupTimeslots = timeSlots;
    notifyListeners();
  }

  void changeDeliveryTimeSlots(String deliveryTimeSlots) {
    dataDeliveryTimeslots = deliveryTimeSlots;
    notifyListeners();
  }

  void changeDimensionsSize(String dimensionsSize) {
    dataDimensionsSize = dimensionsSize;
    notifyListeners();
  }

  void changeDatePickup(String datePickup) {
    dataDatePickup = datePickup;
    notifyListeners();
  }

  void changeDimensionsHeight(int dimensionsHeight) {
    dataDimensionsHeight = dimensionsHeight;
    notifyListeners();
  }

  void changeDimensionsLength(int dimensionsLength) {
    dataDimensionsLength = dimensionsLength;
    notifyListeners();
  }
  
  void changeDimensionsWidth(int dimensionsWidth) {
    dataDimensionsWidth = dimensionsWidth;
    notifyListeners();
  }

  void changeApproximatelyVolumes(String approximatelyVolumes) {
    dataApproximatelyVolumes = approximatelyVolumes;
    notifyListeners();
  }

}
