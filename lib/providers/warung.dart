import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';

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

enum CategoryProductStatus { loading, loaded, empty, error } 
enum CategoryProductByParentStatus { loading, loaded, empty, error }
enum SellerStoreStatus { loading, loaded, empty, error }
enum CartStatus { loading, loaded, empty, error }
enum SingleProductStatus { loading, loaded, empty, error }

class WarungProvider with ChangeNotifier {

  CategoryProductStatus _categoryProductStatus = CategoryProductStatus.loading;
  CategoryProductStatus get categoryProductStatus => _categoryProductStatus;

  CartStatus _cartStatus = CartStatus.loading;
  CartStatus get cartStatus => _cartStatus;

  SingleProductStatus _singleProductStatus = SingleProductStatus.loading;
  SingleProductStatus get singleProductStatus => _singleProductStatus;

  SellerStoreStatus _sellerStoreStatus = SellerStoreStatus.loading;
  SellerStoreStatus get sellerStoreStatus => _sellerStoreStatus; 

  void setStateCategoryProductStatus(CategoryProductStatus categoryProductStatus) {
    _categoryProductStatus = categoryProductStatus;
    Future.delayed(Duration.zero, () => notifyListeners());  
  }

  void setStateCartStatus(CartStatus cartStatus) {
    _cartStatus = cartStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSingleProductStatus(SingleProductStatus singleProductStatus) {
    _singleProductStatus = singleProductStatus;
  }
 
  void setStateSellerStoreStatus(SellerStoreStatus sellerStoreStatus) { 
    _sellerStoreStatus = sellerStoreStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  CategoryProductByParentStatus categoryProductByParentStatus = CategoryProductByParentStatus.loading;

  List<Map<String, Object>> assignCampaignListProduct = [];

  List<StoreElement> _cartStores = [];
  List<CategoryProductList> _categoryProductList = [];
  List<CategoryProductList> _categoryProductByParentList = [];

  List<CategoryProductList> get categoryProductList => _categoryProductList;
  List<CategoryProductList> get categoryProductByParentList => _categoryProductByParentList;
  List<StoreElement> get cartStores => _cartStores;

  CartBody cartBody;
  SellerStoreModel sellerStoreModel;
  
  Future<SellerStoreModel> getDataStore(BuildContext context, String person) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/seller/store/fetch");

      if(person == "seller") {
        if(res.data["code"] == 404) {       
          throw DioError(error: 404);
        } 
      }

      if(res.data["code"] == 500) {
        throw DioError(error: 500);
      } 

      SellerStoreModel _sellerStoreModel = SellerStoreModel.fromJson(res.data);
      sellerStoreModel = _sellerStoreModel;
      setStateSellerStoreStatus(SellerStoreStatus.loaded);
      return _sellerStoreModel;
    } on DioError catch(e) {
      print(e);
      if(e.error == 404) {
        setStateSellerStoreStatus(SellerStoreStatus.empty);
      } else if(e.error == 500) {
        setStateSellerStoreStatus(SellerStoreStatus.error);
      } else {
        setStateSellerStoreStatus(SellerStoreStatus.error);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<SellerStoreModel> postCreateDataStore(BuildContext context, String nameStore, String provinsi, String kota, String kodePos, String alamat, List<String> kurir, List<double> lokasi, [String deskripsi = ""]) async {
    Map<String, dynamic> data = {
      "name": nameStore,
      "province": provinsi,
      "city": kota,
      "postalCode": kodePos,
      "address": alamat,
      "location": lokasi,
      "supportedCouriers": kurir
    };
    if (deskripsi.trim().length > 0) {
      data.addAll({"description": deskripsi});
    }
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/seller/store/create", data: data);
      SellerStoreModel sellerStoreModel = SellerStoreModel.fromJson(res.data);
      return sellerStoreModel;
    } on DioError catch(e) {
      print(e.response.statusCode);
      print(e.response.data);
    } catch (e) {
      print(e);
    }
  }

  Future<SellerStoreModel> postEditDataStore(BuildContext context, String idStore, String nameStore, String provinsi, String kota, String kodePos, String alamat, String deskripsi, bool statusToko, [List<String> kurir, List<double> lokasi, File files]) async {
    Dio dio = await DioManager.shared.getClient(context);
    Map<String, dynamic> data = {
      "id": idStore,
      "name": nameStore,
      "description": deskripsi,
      "open": statusToko,
      "province": provinsi,
      "city": kota,
      "postalCode": kodePos,
      "address": alamat,
      "location": lokasi,
    };
    if (files != null) {
      data.addAll({
        "picture": {
          "originalName": basename(files.path),
          "fileLength": files.lengthSync(),
          "path": "/commerce/umart/$idStore/${basename(files.path)}",
          "contentType": lookupMimeType(basename(files.path)),
          "classId": "media"
        }
      });
    }
    if (kurir.length > 0) {
      data.addAll({"supportedCouriers": kurir});
    }
    if (lokasi.length > 0) {
      data.addAll({"location": lokasi});
    }
    try {
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/seller/store/update", data: data);
      final SellerStoreModel sellerStoreModel = SellerStoreModel.fromJson(res.data);
      return sellerStoreModel;
    } catch (e) {
      print(e);
    }
  }

  Future<CategoryProductModel> getDataCategoryProduct(BuildContext context, String typeProduct) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/$typeProduct/product/categories");

      if(res.data['code'] == 404) {
        throw DioError(error: 404);
      } 

      if(res.data['code'] == 500) {
        throw DioError(error: 500);
      } 

      CategoryProductModel _categoryProductModel = CategoryProductModel.fromJson(res.data);
      _categoryProductList = [];
      List<CategoryProductList> categoryProductList = _categoryProductModel?.body;
      _categoryProductList.addAll(categoryProductList);
      
      setStateCategoryProductStatus(CategoryProductStatus.loaded);
      return _categoryProductModel;
    } on DioError catch(e) {
      print(e.response.data);
      if(e.error == 404) {
        setStateCategoryProductStatus(CategoryProductStatus.empty);
      } else if(e.error == 500) {
        setStateCategoryProductStatus(CategoryProductStatus.error);
      } else {
        setStateCategoryProductStatus(CategoryProductStatus.error);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<CategoryProductModel> getDataCategoryProductByParent(BuildContext context, String typeProduct, String parentId) async {
    try {
      categoryProductByParentStatus = CategoryProductByParentStatus.loading;
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/$typeProduct/product/categories?parentId=$parentId");
      CategoryProductModel categoryProductModel = CategoryProductModel.fromJson(res.data);
      _categoryProductByParentList = [];
      List<CategoryProductList> categoryProductByParentList = categoryProductModel.body;
      _categoryProductByParentList.addAll(categoryProductByParentList);
      categoryProductByParentStatus = CategoryProductByParentStatus.loaded;
      if(categoryProductByParentList.length == 0) {
        categoryProductByParentStatus = CategoryProductByParentStatus.empty;
        Future.delayed(Duration(seconds: 1), () => notifyListeners());
      }
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
      return categoryProductModel;
    } catch (e) {
      print(e);
    }
  }

  Future<ProductWarungModel> getDataProductByCategoryConsumen(BuildContext context, String idCategory, int page) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/commerce/product/filter?categoryId=$idCategory&page=$page&size=10&sort=stock,desc");
      final ProductWarungModel productWarungModel = ProductWarungModel.fromJson(res.data);
      return productWarungModel;
    } catch (e) {
      print(e);
    }
  }

  Future<ProductWarungModel> getDataSearchProduct(BuildContext context, String nameProduct, int page) async {
    final Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/commerce/product/filter?categoryId=all&page=0&size=10&sort=created,desc&search=$nameProduct");
      final ProductWarungModel productWarungModel = ProductWarungModel.fromJson(res.data);
      return productWarungModel;
    } catch (e) {
      print(e);
    }
  }

  Future<ProductWarungModel> getDataProductByCategorySeller(BuildContext context, String idCategory, int page) async {
    final Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/seller/product/filter?categoryId=$idCategory&page=$page&size=10&sort=stock,desc");
      final ProductWarungModel productWarungModel = ProductWarungModel.fromJson(res.data);
      return productWarungModel;
    } catch (e) {
      print(e);
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
      setStateSingleProductStatus(SingleProductStatus.loaded);
      return productSingleWarungModel;
    } on DioError catch(e) {
      if(e.error == 404) {
        setStateSingleProductStatus(SingleProductStatus.empty);
      } else if(e.error == 500) {
        setStateSingleProductStatus(SingleProductStatus.error);
      } else {
        setStateSingleProductStatus(SingleProductStatus.error);
      }
      print("GET SINGLE PRODUCT ERROR IS = ${e.error}");
    } catch (e) {
      print(e);
    }
  }

  Future<String> getMediaKeyMedia(BuildContext context) async {
    final Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_FEED_MEDIA}/mediaKey");
      final MediaKey mediaKey = MediaKey.fromJson(res.data);
      return mediaKey.body;
    } catch (e) {
      print(e);
    }
  }

  Future<Response> uploadImageProduct(BuildContext context, String mediaKey, String base64, String idStore, File file) async {
    Dio dio = Dio();
    try {
      String url = "${AppConstants.BASE_URL_FEED_MEDIA}/$mediaKey/$base64?path=/commerce/umart/$idStore/${basename(file.path)}";
      Response res = await dio.post(url, data: file.readAsBytesSync());
      return res;
    } catch (e) {
      print(e);
    }
  }

  Future<ProductSingleWarungModel> postDataProductWarung(BuildContext context, String nameProduct, String idCategory, int price, List<File> files, int weight, String description, int stock, String condition, int minOrder, String idStore) async {
    Dio dio = await DioManager.shared.getClient(context);
    List<Map<String, Object>> postsPictures = [];
    for (int i = 0; i < files.length; i++) {
      postsPictures.add({
        "originalName": basename(files[i].path),
        "fileLength": files[i].lengthSync(),
        "path": "/commerce/umart/$idStore/${basename(files[i].path)}",
        "contentType": lookupMimeType(basename(files[i].path))
      });
    }
    try {
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/seller/product/create", data: {
        "name": nameProduct,
        "categoryId": idCategory,
        "price": price,
        "pictures": postsPictures,
        "weight": weight,
        "description": description,
        "stock": stock,
        "condition": condition,
        "minOrder": minOrder
      });
      final ProductSingleWarungModel productSingleWarungModel = ProductSingleWarungModel.fromJson(res.data);
      return productSingleWarungModel;
    } catch (e) {
      print(e);
    }
  }

  Future<ProductSingleWarungModel> postEditDataProductWarung(BuildContext context, String idProduct, String nameProduct, String idCategory, int price, List<File> files, int weight, String description, int stock, String condition, int minOrder, String idStore) async {
    Dio dio = await DioManager.shared.getClient(context);
    if (files != null || files.length > 0) {
      List<Map<String, Object>> postsPictures = [];
      for (int i = 0; i < files.length; i++) {
        postsPictures.add({
          "originalName": basename(files[i].path),
          "fileLength": files[i].lengthSync(),
          "path": "/commerce/umart/$idStore/${basename(files[i].path)}",
          "contentType": lookupMimeType(basename(files[i].path))
        });
      }
      try {
        Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/seller/product/update", data: {
          "id": idProduct,
          "name": nameProduct,
          "categoryId": idCategory,
          "price": price,
          "pictures": postsPictures,
          "weight": weight,
          "description": description,
          "stock": stock,
          "condition": condition,
          "minOrder": minOrder
        });
        final ProductSingleWarungModel productSingleWarungModel = ProductSingleWarungModel.fromJson(res.data);
        return productSingleWarungModel;
      } catch (e) {
        print(e);
      }
    } else {
      try {
        Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/seller/product/update", data: {
          "id": idProduct,
          "name": nameProduct,
          "categoryId": idCategory,
          "price": price,
          "weight": weight,
          "description": description,
          "stock": stock,
          "condition": condition,
          "minOrder": minOrder
        });
        final ProductSingleWarungModel productSingleWarungModel = ProductSingleWarungModel.fromJson(res.data);
        return productSingleWarungModel;
      } catch (e) {
        print(e);
      }
    }
  }

  Future<ProductSingleWarungModel> postDeleteProductWarung(BuildContext context, String idProduct, int status) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/seller/product/update", data: {
        "id": idProduct,
        "status": status,
      });
      final ProductSingleWarungModel productSingleWarungModel = ProductSingleWarungModel.fromJson(res.data);
      return productSingleWarungModel;
    } catch (e) {
      print(e);
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
      List<StoreElement> cartStores = cartModel.body?.stores;
      cartBody = cartModel.body;
      _cartStores.addAll(cartStores);

      setStateCartStatus(CartStatus.loaded);   
      return cartModel;
    } on DioError catch(e) {
      if(e.error == 404) {
        setStateCartStatus(CartStatus.empty);
        cartBody = null;
      } else if(e.error == 500) {
        setStateCartStatus(CartStatus.error);
      } else {
        setStateCartStatus(CartStatus.error);
      }
      print("GET CART INFO STATUS IS = ${e.error}");
    } catch (e) {
      print(e);
    }
  }

  Future<CartModel> postAddCart(BuildContext context, String idProduct, int qty) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/cart/add",
      data: {
        "productId": idProduct, 
        "quantity": qty, 
        "note": ""
      },
      options: Options(contentType: Headers.formUrlEncodedContentType));
      final CartModel cartModel = CartModel.fromJson(res.data);
      return cartModel;
    } catch (e) {
      print(e);
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
      print(e.response.statusCode);
      print(e.response.data);
    } catch (e) {
      print(e);
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
      print(e.response.statusCode);
      print(e.response.data);
    } catch (e) {
      print(e);
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
    } catch (e) {
      print(e);
    }
  }

  Future<CartModel> postEmptyProductCart(BuildContext context) async {
    final Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/cart/empty");
      final CartModel cartModel = CartModel.fromJson(res.data);
      return cartModel;
    } catch (e) {
      print(e);
    }
  }

  Future<CheckoutCartWarungModel> postCartCheckout(BuildContext context, String paymentChannel) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/cart/checkout",
      data: {
        "paymentChannel": paymentChannel,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType));
      final CheckoutCartWarungModel checkoutCartWarungModel = CheckoutCartWarungModel.fromJson(res.data);
      return checkoutCartWarungModel;
    } catch (e) {
      print(e);
    }
  }

  Future<ShippingCouriersModel> getCourierShipping(BuildContext context, String storeId) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/commerce/shipping/couriers?storeId=$storeId");
      final ShippingCouriersModel shippingCouriersModel = ShippingCouriersModel.fromJson(res.data);
      return shippingCouriersModel;
    } catch (e) {
      print(e);
    }
  }

  Future<CartModel> postSetCouriers(BuildContext context, String idStore, String courierCostId) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response _res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/commerce/cart/courier",
      data: {
        "storeId": idStore,
        "courierCostId": courierCostId
      },
      options: Options(contentType: Headers.formUrlEncodedContentType));
      final CartModel cartModel = CartModel.fromJson(_res.data);
      return cartModel;
    } catch (e) {
      print(e);
    }
  }

  Future<TransactionWarungUnpaidModel> getTransactionUnpaid(BuildContext context) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/transaction/buyer/unpaids");
      final TransactionWarungUnpaidModel transactionWarungUnpaidModel = TransactionWarungUnpaidModel.fromJson(res.data);
      return transactionWarungUnpaidModel;
    } catch (e) {
      print(e);
    }
  }

  Future<TransactionWarungPaidModel> getTransactionBuyerPaid(BuildContext context, String status) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/transaction/buyer/orders?orderStatus=$status");
      final TransactionWarungPaidModel transactionWarungPaidModel = TransactionWarungPaidModel.fromJson(res.data);
      return transactionWarungPaidModel;
    } catch (e) {
      print(e);
    }
  }

  Future<TransactionWarungPaidSingleModel> getTransactionPaidSingle(BuildContext context, String idTrx, String typeUser) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/transaction/$typeUser/order/fetch/$idTrx");
      final TransactionWarungPaidSingleModel transactionWarungPaidSingleModel = TransactionWarungPaidSingleModel.fromJson(res.data);
      return transactionWarungPaidSingleModel;
    } catch (e) {
      print(e);
    }
  }

  Future<TransactionWarungPaidModel> getTransactionSellerPaid(BuildContext context, String status) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/transaction/seller/orders?orderStatus=$status");
      TransactionWarungPaidModel transactionWarungPaidModel = TransactionWarungPaidModel.fromJson(res.data);
      return transactionWarungPaidModel;
    } catch (e) {
      print(e);
    }
  }

  Future<TransactionWarungPaidSingleModel> postOrderPacking(BuildContext context, String orderId) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/transaction/seller/order/packing",
        data: {"orderId": orderId},
        options: Options(contentType: Headers.formUrlEncodedContentType)
      );
      final TransactionWarungPaidSingleModel transactionWarungPaidSingleModel = TransactionWarungPaidSingleModel.fromJson(res.data);
      return transactionWarungPaidSingleModel;
    } catch (e) {
      print(e);
    }
  }

  Future<TransactionWarungPaidSingleModel> postInputResi(BuildContext context, String orderId, String wayBill) async {
    Dio _dio = await DioManager.shared.getClient(context);
    try {
      Response res = await _dio.post("${AppConstants.BASE_URL_ECOMMERCE}/transaction/seller/order/shipping",
      data: {
        "orderId": orderId, 
        "wayBill": wayBill
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType)
      );
      final TransactionWarungPaidSingleModel transactionWarungPaidSingleModel = TransactionWarungPaidSingleModel.fromJson(res.data);
      return transactionWarungPaidSingleModel;
    } catch (e) {
      print(e);
    }
  }

  Future<TransactionWarungPaidSingleModel> postOrderDone(BuildContext context, String orderId) async {
    Dio dio = await DioManager.shared.getClient(context);

    try {
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/transaction/buyer/order/done",
        data: {
          "orderId": orderId
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType
        )
      );
      final TransactionWarungPaidSingleModel transactionWarungPaidSingleModel = TransactionWarungPaidSingleModel.fromJson(res.data);
      return transactionWarungPaidSingleModel;
    } catch (e) {
      print(e);
    }
  }

  Future<ReviewProductModel> getReviewProductList(BuildContext context) async {
    Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/transaction/buyer/review/list");
      final ReviewProductModel reviewProductModel = ReviewProductModel.fromJson(res.data);
      return reviewProductModel;
    } catch (e) {
      print(e);
    }
  }

  Future<ReviewProductSingleModel> postDataReviewProduct(BuildContext context, String idProduct, double star, String review, List<File> files) async {
    Dio dio = await DioManager.shared.getClient(context);
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
      Response res = await dio.post("${AppConstants.BASE_URL_ECOMMERCE}/transaction/buyer/review/add", data: {
        "productId": idProduct,
        "star": star,
        "text": review,
        "photos": postsPictures,
      });
      final ReviewProductSingleModel reviewProductSingleModel = ReviewProductSingleModel.fromJson(res.data);
      return reviewProductSingleModel;
    } catch (e) {
      print(e);
    }
  }

  Future<ShippingTrackingModel> getShippingTracking(BuildContext context, String idOrder) async {
    final Dio dio = await DioManager.shared.getClient(context);
    try {
      Response res = await dio.get("${AppConstants.BASE_URL_ECOMMERCE}/commerce/shipping/track?orderId=$idOrder");
      final ShippingTrackingModel shippingTrackingModel = ShippingTrackingModel.fromJson(res.data);
      return shippingTrackingModel;
    } catch (e) {
      print(e);
    }
  }
}
