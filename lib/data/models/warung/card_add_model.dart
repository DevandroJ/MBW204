import 'dart:convert';

import 'seller_store_model.dart';

CartModel cartAddModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartAddModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  CartBody body;
  dynamic error;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        body: json["body"] == null ? null : CartBody.fromJson(json["body"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "body": body == null ? null : body.toJson(),
        "error": error,
      };
}

class CartBody {
  CartBody({
    this.id,
    this.userId,
    this.stores,
    this.numOfItems,
    this.serviceCharge,
    this.shippingAddress,
    this.totalProductPrice,
    this.totalDeliveryCost,
    this.classId,
  });

  String id;
  String userId;
  List<StoreElement> stores;
  int numOfItems;
  double serviceCharge;
  ShippingAddress shippingAddress;
  double totalProductPrice;
  double totalDeliveryCost;
  String classId;

  factory CartBody.fromJson(Map<String, dynamic> json) => CartBody(
        id: json["id"] == null ? null : json["id"],
        userId: json["userId"] == null ? null : json["userId"],
        stores: json["stores"] == null
            ? null
            : List<StoreElement>.from(
                json["stores"].map((x) => StoreElement.fromJson(x))),
        numOfItems: json["numOfItems"] == null ? null : json["numOfItems"],
        serviceCharge:
            json["serviceCharge"] == null ? null : json["serviceCharge"],
        shippingAddress: json["shippingAddress"] == null
            ? null
            : ShippingAddress.fromJson(json["shippingAddress"]),
        totalProductPrice: json["totalProductPrice"] == null
            ? null
            : json["totalProductPrice"],
        totalDeliveryCost: json["totalDeliveryCost"] == null
            ? null
            : json["totalDeliveryCost"],
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "userId": userId == null ? null : userId,
        "stores": stores == null
            ? null
            : List<dynamic>.from(stores.map((x) => x.toJson())),
        "serviceCharge": serviceCharge == null ? null : serviceCharge,
        "shippingAddress":
            shippingAddress == null ? null : shippingAddress.toJson(),
        "classId": classId == null ? null : classId,
      };
}

class ShippingAddress {
  ShippingAddress({
    this.id,
    this.phoneNumber,
    this.address,
    this.postalCode,
    this.province,
    this.city,
    this.subdistrict,
    this.defaultLocation,
    this.location,
    this.name,
    this.classId,
  });

  String id;
  String phoneNumber;
  String address;
  String postalCode;
  String province;
  String city;
  String subdistrict;
  bool defaultLocation;
  List<double> location;
  String name;
  String classId;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        id: json["id"] == null ? null : json["id"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        address: json["address"] == null ? null : json["address"],
        postalCode: json["postalCode"] == null ? null : json["postalCode"],
        province: json["province"] == null ? null : json["province"],
        city: json["city"] == null ? null : json["city"],
        subdistrict: json["subdistrict"] == null ? null : json["subdistrict"],
        defaultLocation:
            json["defaultLocation"] == null ? null : json["defaultLocation"],
        location: json["location"] == null
            ? null
            : List<double>.from(json["location"].map((x) => x.toDouble())),
        name: json["name"] == null ? null : json["name"],
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "address": address == null ? null : address,
        "postalCode": postalCode == null ? null : postalCode,
        "province": province == null ? null : province,
        "city": city == null ? null : city,
        "subdistrict": subdistrict == null ? null : subdistrict,
        "defaultLocation": defaultLocation == null ? null : defaultLocation,
        "location": location == null
            ? null
            : List<dynamic>.from(location.map((x) => x)),
        "name": name == null ? null : name,
        "classId": classId == null ? null : classId,
      };
}

class StoreElement {
  StoreElement({
    this.storeId,
    this.store,
    this.deliveryCost,
    this.items,
    this.classId,
  });

  String storeId;
  StoreStore store;
  DeliveryCost deliveryCost;
  List<ItemCartAdd> items;
  String classId;

  factory StoreElement.fromJson(Map<String, dynamic> json) => StoreElement(
        storeId: json["storeId"] == null ? null : json["storeId"],
        store:
            json["store"] == null ? null : StoreStore.fromJson(json["store"]),
        deliveryCost: json["deliveryCost"] == null
            ? null
            : DeliveryCost.fromJson(json["deliveryCost"]),
        items: json["items"] == null
            ? null
            : List<ItemCartAdd>.from(
                json["items"].map((x) => ItemCartAdd.fromJson(x))),
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "storeId": storeId == null ? null : storeId,
        "store": store == null ? null : store.toJson(),
        "deliveryCost": deliveryCost == null ? null : deliveryCost.toJson(),
        "items": items == null
            ? null
            : List<dynamic>.from(items.map((x) => x.toJson())),
        "classId": classId == null ? null : classId,
      };
}

class DeliveryCost {
  DeliveryCost({
    this.courierId,
    this.courierName,
    this.serviceName,
    this.serviceDesc,
    this.price,
    this.estimateDays,
    this.classId,
  });

  String courierId;
  String courierName;
  String serviceName;
  String serviceDesc;
  double price;
  String estimateDays;
  String classId;

  factory DeliveryCost.fromJson(Map<String, dynamic> json) => DeliveryCost(
        courierId: json["courierId"] == null ? null : json["courierId"],
        courierName: json["courierName"] == null ? null : json["courierName"],
        serviceName: json["serviceName"] == null ? null : json["serviceName"],
        serviceDesc: json["serviceDesc"] == null ? null : json["serviceDesc"],
        price: json["price"] == null ? null : json["price"],
        estimateDays:
            json["estimateDays"] == null ? null : json["estimateDays"],
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "courierId": courierId == null ? null : courierId,
        "courierName": courierName == null ? null : courierName,
        "serviceName": serviceName == null ? null : serviceName,
        "serviceDesc": serviceDesc == null ? null : serviceDesc,
        "price": price == null ? null : price,
        "estimateDays": estimateDays == null ? null : estimateDays,
        "classId": classId == null ? null : classId,
      };
}

class ItemCartAdd {
  ItemCartAdd({
    this.productId,
    this.product,
    this.storeId,
    this.quantity,
    this.price,
    this.note,
    this.classId,
  });

  String productId;
  ProductAddCart product;
  String storeId;
  int quantity;
  double price;
  String note;
  String classId;

  factory ItemCartAdd.fromJson(Map<String, dynamic> json) => ItemCartAdd(
        productId: json["productId"] == null ? null : json["productId"],
        product: json["product"] == null
            ? null
            : ProductAddCart.fromJson(json["product"]),
        storeId: json["storeId"] == null ? null : json["storeId"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        price: json["price"] == null ? null : json["price"],
        note: json["note"] == null ? null : json["note"],
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId == null ? null : productId,
        "product": product == null ? null : product.toJson(),
        "storeId": storeId == null ? null : storeId,
        "quantity": quantity == null ? null : quantity,
        "price": price == null ? null : price,
        "note": note == null ? null : note,
        "classId": classId == null ? null : classId,
      };
}

class ProductAddCart {
  ProductAddCart({
    this.id,
    this.name,
    this.price,
    this.pictures,
    this.weight,
    this.discount,
    this.stock,
    this.minOrder,
    this.stats,
    this.classId,
  });

  String id;
  String name;
  double price;
  List<PictureAddCart> pictures;
  int weight;
  DiscountCart discount;
  int stock;
  int minOrder;
  StatsAddCart stats;
  String classId;

  factory ProductAddCart.fromJson(Map<String, dynamic> json) => ProductAddCart(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"],
        pictures: json["pictures"] == null
            ? null
            : List<PictureAddCart>.from(
                json["pictures"].map((x) => PictureAddCart.fromJson(x))),
        weight: json["weight"] == null ? null : json["weight"],
        discount: json["discount"] == null
            ? null
            : DiscountCart.fromJson(json["discount"]),
        stock: json["stock"] == null ? null : json["stock"],
        minOrder: json["minOrder"] == null ? null : json["minOrder"],
        stats:
            json["stats"] == null ? null : StatsAddCart.fromJson(json["stats"]),
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "price": price == null ? null : price,
        "pictures": pictures == null
            ? null
            : List<dynamic>.from(pictures.map((x) => x.toJson())),
        "weight": weight == null ? null : weight,
        "discount": discount,
        "stock": stock == null ? null : stock,
        "minOrder": minOrder == null ? null : minOrder,
        "stats": stats == null ? null : stats.toJson(),
        "classId": classId == null ? null : classId,
      };
}

class PictureAddCart {
  PictureAddCart({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
    this.classId,
  });

  String originalName;
  int fileLength;
  String path;
  String contentType;
  String classId;

  factory PictureAddCart.fromJson(Map<String, dynamic> json) => PictureAddCart(
        originalName:
            json["originalName"] == null ? null : json["originalName"],
        fileLength: json["fileLength"] == null ? null : json["fileLength"],
        path: json["path"] == null ? null : json["path"],
        contentType: json["contentType"] == null ? null : json["contentType"],
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "originalName": originalName == null ? null : originalName,
        "fileLength": fileLength == null ? null : fileLength,
        "path": path == null ? null : path,
        "contentType": contentType == null ? null : contentType,
        "classId": classId == null ? null : classId,
      };
}

class DiscountCart {
  DiscountCart({
    this.discount,
    this.startDate,
    this.endDate,
    this.active,
  });

  double discount;
  String startDate;
  String endDate;
  bool active;

  factory DiscountCart.fromJson(Map<String, dynamic> json) => DiscountCart(
        discount: json["discount"] == null ? null : json["discount"],
        startDate: json["startDate"] == null ? null : json["startDate"],
        endDate: json["endDate"] == null ? null : json["endDate"],
        active: json["active"] == null ? null : json["active"],
      );

  Map<String, dynamic> toJson() => {
        "discount": discount == null ? null : discount,
        "startDate": startDate == null ? null : startDate,
        "endDate": endDate == null ? null : endDate,
        "active": active == null ? null : active,
      };
}

class StatsAddCart {
  StatsAddCart({
    this.ratingMax,
    this.ratingAvg,
    this.numOfReview,
    this.numOfSold,
    this.ratings,
    this.classId,
  });

  double ratingMax;
  double ratingAvg;
  int numOfReview;
  int numOfSold;
  List<RatingAddCart> ratings;
  String classId;

  factory StatsAddCart.fromJson(Map<String, dynamic> json) => StatsAddCart(
        ratingMax: json["ratingMax"] == null ? null : json["ratingMax"],
        ratingAvg: json["ratingAvg"] == null ? null : json["ratingAvg"],
        numOfReview: json["numOfReview"] == null ? null : json["numOfReview"],
        numOfSold: json["numOfSold"] == null ? null : json["numOfSold"],
        ratings: json["ratings"] == null
            ? null
            : List<RatingAddCart>.from(
                json["ratings"].map((x) => RatingAddCart.fromJson(x))),
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "ratingMax": ratingMax == null ? null : ratingMax,
        "ratingAvg": ratingAvg == null ? null : ratingAvg,
        "numOfReview": numOfReview == null ? null : numOfReview,
        "numOfSold": numOfSold == null ? null : numOfSold,
        "ratings": ratings == null
            ? null
            : List<dynamic>.from(ratings.map((x) => x.toJson())),
        "classId": classId == null ? null : classId,
      };
}

class RatingAddCart {
  RatingAddCart({
    this.star,
    this.count,
  });

  double star;
  var count;

  factory RatingAddCart.fromJson(Map<String, dynamic> json) => RatingAddCart(
        star: json["star"] == null ? null : json["star"],
        count: json["count"] == null ? null : json["count"],
      );

  Map<String, dynamic> toJson() => {
        "star": star == null ? null : star,
        "count": count == null ? null : count,
      };
}

class StoreStore {
  StoreStore({
    this.id,
    this.owner,
    this.name,
    this.description,
    this.open,
    this.picture,
    this.status,
    this.province,
    this.city,
    this.postalCode,
    this.address,
    this.location,
    this.supportedCouriers,
    this.classId,
  });

  String id;
  String owner;
  String name;
  String description;
  bool open;
  Picture picture;
  int status;
  String province;
  String city;
  String postalCode;
  String address;
  List<double> location;
  List<SupportedCourierAddCart> supportedCouriers;
  String classId;

  factory StoreStore.fromJson(Map<String, dynamic> json) => StoreStore(
        id: json["id"] == null ? null : json["id"],
        owner: json["owner"] == null ? null : json["owner"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        open: json["open"] == null ? null : json["open"],
        picture:
            json["picture"] == null ? null : Picture.fromJson(json["picture"]),
        status: json["status"] == null ? null : json["status"],
        province: json["province"] == null ? null : json["province"],
        city: json["city"] == null ? null : json["city"],
        postalCode: json["postalCode"] == null ? null : json["postalCode"],
        address: json["address"] == null ? null : json["address"],
        location: json["location"] == null
            ? null
            : List<double>.from(json["location"].map((x) => x.toDouble())),
        supportedCouriers: json["supportedCouriers"] == null
            ? null
            : List<SupportedCourierAddCart>.from(json["supportedCouriers"]
                .map((x) => SupportedCourierAddCart.fromJson(x))),
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "owner": owner == null ? null : owner,
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "open": open == null ? null : open,
    "picture": picture == null ? null : picture.toJson(),
    "status": status == null ? null : status,
    "province": province == null ? null : province,
    "city": city == null ? null : city,
    "postalCode": postalCode == null ? null : postalCode,
    "address": address == null ? null : address,
    "location": location == null ? null : List<dynamic>.from(location.map((x) => x)),
    "supportedCouriers": supportedCouriers == null ? null : List<dynamic>.from(supportedCouriers.map((x) => x.toJson())),
    "classId": classId == null ? null : classId,
  };
}

class SupportedCourierAddCart {
  SupportedCourierAddCart({
    this.id,
    this.status,
    this.created,
    this.updated,
    this.name,
    this.image,
    this.checkPriceSupported,
    this.checkResiSupported,
    this.classId,
  });

  String id;
  int status;
  String created;
  String updated;
  String name;
  String image;
  bool checkPriceSupported;
  bool checkResiSupported;
  String classId;

  factory SupportedCourierAddCart.fromJson(Map<String, dynamic> json) =>
    SupportedCourierAddCart(
      id: json["id"] == null ? null : json["id"],
      status: json["status"] == null ? null : json["status"],
      created: json["created"] == null ? null : json["created"],
      updated: json["updated"] == null ? null : json["updated"],
      name: json["name"] == null ? null : json["name"],
      image: json["image"] == null ? null : json["image"],
      checkPriceSupported: json["checkPriceSupported"] == null ? null : json["checkPriceSupported"],
      checkResiSupported: json["checkResiSupported"] == null ? null : json["checkResiSupported"],
      classId: json["classId"] == null ? null : json["classId"],
    );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "status": status == null ? null : status,
    "created": created == null ? null : created,
    "updated": updated == null ? null : updated,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "checkPriceSupported": checkPriceSupported == null ? null : checkPriceSupported,
    "checkResiSupported": checkResiSupported == null ? null : checkResiSupported,
    "classId": classId == null ? null : classId,
  };
}
