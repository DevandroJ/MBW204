import 'dart:convert';

TransactionWarungPaidModel transactionWarungPaidModelFromJson(String str) => TransactionWarungPaidModel.fromJson(json.decode(str));

String transactionWarungPaidModelToJson(TransactionWarungPaidModel data) => json.encode(data.toJson());

class TransactionWarungPaidModel {
  TransactionWarungPaidModel({
    this.code,
    this.message,
    this.count,
    this.first,
    this.body,
    this.error,
  });

  int code;
  String message;
  int count;
  bool first;
  List<TransactionWarungPaidList> body;
  dynamic error;

  factory TransactionWarungPaidModel.fromJson(Map<String, dynamic> json) =>
      TransactionWarungPaidModel(
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        count: json["count"] == null ? null : json["count"],
        first: json["first"] == null ? null : json["first"],
        body: json["body"] == null
            ? null
            : List<TransactionWarungPaidList>.from(
                json["body"].map((x) => TransactionWarungPaidList.fromJson(x))),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "count": count == null ? null : count,
        "first": first == null ? null : first,
        "body": body == null
            ? null
            : List<dynamic>.from(body.map((x) => x.toJson())),
        "error": error,
      };
}

class TransactionWarungPaidList {
  TransactionWarungPaidList({
    this.id,
    this.refId,
    this.trxId,
    this.storeId,
    this.store,
    this.orderStatus,
    this.deliveryCost,
    this.invoiceNo,
    this.products,
    this.destShippingAddress,
    this.user,
    this.created,
    this.doneDate,
    this.wayBill,
    this.totalPrice,
    this.classId,
    this.totalProductPrice,
  });

  String id;
  String refId;
  String trxId;
  String storeId;
  TransactionWarungPaidStore store;
  String orderStatus;
  TransactionWarungPaidDeliveryCost deliveryCost;
  String invoiceNo;
  List<ProductElement> products;
  DestShippingAddress destShippingAddress;
  TransactionWarungPaidUser user;
  String created;
  String doneDate;
  String wayBill;
  double totalPrice;
  String classId;
  double totalProductPrice;

  factory TransactionWarungPaidList.fromJson(Map<String, dynamic> json) =>
      TransactionWarungPaidList(
        id: json["id"] == null ? null : json["id"],
        refId: json["refId"] == null ? null : json["refId"],
        trxId: json["trxId"] == null ? null : json["trxId"],
        storeId: json["storeId"] == null ? null : json["storeId"],
        store: json["store"] == null
            ? null
            : TransactionWarungPaidStore.fromJson(json["store"]),
        orderStatus: json["orderStatus"] == null ? null : json["orderStatus"],
        deliveryCost: json["deliveryCost"] == null
            ? null
            : TransactionWarungPaidDeliveryCost.fromJson(json["deliveryCost"]),
        invoiceNo: json["invoiceNo"] == null ? null : json["invoiceNo"],
        products: json["products"] == null
            ? null
            : List<ProductElement>.from(
                json["products"].map((x) => ProductElement.fromJson(x))),
        destShippingAddress: json["destShippingAddress"] == null
            ? null
            : DestShippingAddress.fromJson(json["destShippingAddress"]),
        user: json["user"] == null
            ? null
            : TransactionWarungPaidUser.fromJson(json["user"]),
        created: json["created"] == null ? null : json["created"],
        doneDate: json["doneDate"] == null ? null : json["doneDate"],
        wayBill: json["wayBill"] == null ? null : json["wayBill"],
        totalPrice: json["totalPrice"] == null ? null : json["totalPrice"],
        classId: json["classId"] == null ? null : json["classId"],
        totalProductPrice: json["totalProductPrice"] == null
            ? null
            : json["totalProductPrice"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "refId": refId == null ? null : refId,
        "trxId": trxId == null ? null : trxId,
        "storeId": storeId == null ? null : storeId,
        "store": store == null ? null : store.toJson(),
        "orderStatus": orderStatus == null ? null : orderStatus,
        "deliveryCost": deliveryCost == null ? null : deliveryCost.toJson(),
        "invoiceNo": invoiceNo == null ? null : invoiceNo,
        "products": products == null
            ? null
            : List<dynamic>.from(products.map((x) => x.toJson())),
        "destShippingAddress":
            destShippingAddress == null ? null : destShippingAddress.toJson(),
        "user": user == null ? null : user.toJson(),
        "created": created == null ? null : created,
        "doneDate": doneDate == null ? null : doneDate,
        "wayBill": wayBill == null ? null : wayBill,
        "totalPrice": totalPrice == null ? null : totalPrice,
        "classId": classId == null ? null : classId,
        "totalProductPrice":
            totalProductPrice == null ? null : totalProductPrice,
      };
}

class TransactionWarungPaidDeliveryCost {
  TransactionWarungPaidDeliveryCost({
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

  factory TransactionWarungPaidDeliveryCost.fromJson(
          Map<String, dynamic> json) =>
      TransactionWarungPaidDeliveryCost(
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

class DestShippingAddress {
  DestShippingAddress({
    this.phoneNumber,
    this.address,
    this.province,
    this.city,
    this.subdistrict,
    this.postalCode,
    this.location,
  });

  String phoneNumber;
  String address;
  String province;
  String city;
  String subdistrict;
  String postalCode;
  List<double> location;

  factory DestShippingAddress.fromJson(Map<String, dynamic> json) =>
      DestShippingAddress(
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        address: json["address"] == null ? null : json["address"],
        province: json["province"] == null ? null : json["province"],
        city: json["city"] == null ? null : json["city"],
        subdistrict: json["subdistrict"] == null ? null : json["subdistrict"],
        postalCode: json["postalCode"] == null ? null : json["postalCode"],
        location: json["location"] == null
            ? null
            : List<double>.from(json["location"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "address": address == null ? null : address,
        "province": province == null ? null : province,
        "city": city == null ? null : city,
        "subdistrict": subdistrict == null ? null : subdistrict,
        "postalCode": postalCode == null ? null : postalCode,
        "location": location == null
            ? null
            : List<dynamic>.from(location.map((x) => x)),
      };
}

class ProductElement {
  ProductElement({
    this.productId,
    this.product,
    this.storeId,
    this.quantity,
    this.price,
    this.note,
    this.classId,
  });

  String productId;
  ProductProduct product;
  String storeId;
  int quantity;
  double price;
  String note;
  String classId;

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
        productId: json["productId"] == null ? null : json["productId"],
        product: json["product"] == null
            ? null
            : ProductProduct.fromJson(json["product"]),
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

class ProductProduct {
  ProductProduct({
    this.id,
    this.name,
    this.price,
    this.pictures,
    this.weight,
    this.discount,
    this.stock,
    this.stats,
    this.classId,
  });

  String id;
  String name;
  double price;
  List<TransactionWarungPaidPicture> pictures;
  int weight;
  TransactionPaidProductDiscount discount;
  int stock;
  TransactionWarungPaidStats stats;
  String classId;

  factory ProductProduct.fromJson(Map<String, dynamic> json) => ProductProduct(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"],
        pictures: json["pictures"] == null
            ? null
            : List<TransactionWarungPaidPicture>.from(json["pictures"]
                .map((x) => TransactionWarungPaidPicture.fromJson(x))),
        weight: json["weight"] == null ? null : json["weight"],
        discount: json["discount"] == null
            ? null
            : TransactionPaidProductDiscount.fromJson(json["discount"]),
        stock: json["stock"] == null ? null : json["stock"],
        stats: json["stats"] == null
            ? null
            : TransactionWarungPaidStats.fromJson(json["stats"]),
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
        "stats": stats == null ? null : stats.toJson(),
        "classId": classId == null ? null : classId,
      };
}

class TransactionPaidProductDiscount {
  TransactionPaidProductDiscount({
    this.discount,
    this.startDate,
    this.endDate,
    this.active,
  });

  double discount;
  String startDate;
  String endDate;
  bool active;

  factory TransactionPaidProductDiscount.fromJson(Map<String, dynamic> json) =>
      TransactionPaidProductDiscount(
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

class TransactionWarungPaidPicture {
  TransactionWarungPaidPicture({
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

  factory TransactionWarungPaidPicture.fromJson(Map<String, dynamic> json) =>
      TransactionWarungPaidPicture(
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

class TransactionWarungPaidStats {
  TransactionWarungPaidStats({
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
  List<TransactionWarungPaidRating> ratings;
  String classId;

  factory TransactionWarungPaidStats.fromJson(Map<String, dynamic> json) =>
      TransactionWarungPaidStats(
        ratingMax: json["ratingMax"] == null ? null : json["ratingMax"],
        ratingAvg: json["ratingAvg"] == null ? null : json["ratingAvg"],
        numOfReview: json["numOfReview"] == null ? null : json["numOfReview"],
        numOfSold: json["numOfSold"] == null ? null : json["numOfSold"],
        ratings: json["ratings"] == null
            ? null
            : List<TransactionWarungPaidRating>.from(json["ratings"]
                .map((x) => TransactionWarungPaidRating.fromJson(x))),
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

class TransactionWarungPaidRating {
  TransactionWarungPaidRating({
    this.star,
    this.count,
  });

  double star;
  var count;

  factory TransactionWarungPaidRating.fromJson(Map<String, dynamic> json) =>
      TransactionWarungPaidRating(
        star: json["star"] == null ? null : json["star"],
        count: json["count"] == null ? null : json["count"],
      );

  Map<String, dynamic> toJson() => {
        "star": star == null ? null : star,
        "count": count == null ? null : count,
      };
}

class TransactionWarungPaidStore {
  TransactionWarungPaidStore({
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
  TransactionWarungPaidPicture picture;
  int status;
  String province;
  String city;
  String postalCode;
  String address;
  List<double> location;
  List<TransactionWarungPaidSupportedCourier> supportedCouriers;
  String classId;

  factory TransactionWarungPaidStore.fromJson(Map<String, dynamic> json) =>
      TransactionWarungPaidStore(
        id: json["id"] == null ? null : json["id"],
        owner: json["owner"] == null ? null : json["owner"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        open: json["open"] == null ? null : json["open"],
        picture: json["picture"] == null
            ? null
            : TransactionWarungPaidPicture.fromJson(json["picture"]),
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
            : List<TransactionWarungPaidSupportedCourier>.from(
                json["supportedCouriers"].map(
                    (x) => TransactionWarungPaidSupportedCourier.fromJson(x))),
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
        "location": location == null
            ? null
            : List<dynamic>.from(location.map((x) => x)),
        "supportedCouriers": supportedCouriers == null
            ? null
            : List<dynamic>.from(supportedCouriers.map((x) => x.toJson())),
        "classId": classId == null ? null : classId,
      };
}

class TransactionWarungPaidSupportedCourier {
  TransactionWarungPaidSupportedCourier({
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

  factory TransactionWarungPaidSupportedCourier.fromJson(Map<String, dynamic> json) =>
    TransactionWarungPaidSupportedCourier(
      id: json["id"] == null ? null : json["id"],
      status: json["status"] == null ? null : json["status"],
      created: json["created"] == null ? null : json["created"],
      updated: json["updated"] == null ? null : json["updated"],
      name: json["name"] == null ? null : json["name"],
      image: json["image"] == null ? null : json["image"],
      checkPriceSupported: json["checkPriceSupported"] == null ? null : json["checkPriceSupported"],
      checkResiSupported: json["checkResiSupported"] == null ? null: json["checkResiSupported"],
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

class TransactionWarungPaidUser {
  TransactionWarungPaidUser({
    this.uid,
    this.fullname,
    this.username,
    this.address,
    this.email,
    this.created,
    this.avatar,
    this.classId,
  });

  String uid;
  String fullname;
  String username;
  String address;
  String email;
  DateTime created;
  String avatar;
  String classId;

  factory TransactionWarungPaidUser.fromJson(Map<String, dynamic> json) =>
    TransactionWarungPaidUser(
      uid: json["uid"] == null ? null : json["uid"],
      fullname: json["fullname"] == null ? null : json["fullname"],
      username: json["username"] == null ? null : json["username"],
      address: json["address"] == null ? null : json["address"],
      email: json["email"] == null ? null : json["email"],
      created: json["created"] == null ? null : DateTime.parse(json["created"]),
      avatar: json["avatar"] == null ? null : json["avatar"],
      classId: json["classId"] == null ? null : json["classId"],
    );

  Map<String, dynamic> toJson() => {
    "uid": uid == null ? null : uid,
    "fullname": fullname == null ? null : fullname,
    "username": username == null ? null : username,
    "address": address == null ? null : address,
    "email": email == null ? null : email,
    "created": created == null ? null : created.toIso8601String(),
    "avatar": avatar == null ? null : avatar,
    "classId": classId == null ? null : classId,
  };
}
