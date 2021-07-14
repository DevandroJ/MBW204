import 'product_warung_model.dart';

class TransactionWarungPaidSingleModel {
  TransactionWarungPaidSingleModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  TransactionWarungPaidSingle body;
  dynamic error;

  factory TransactionWarungPaidSingleModel.fromJson(Map<String, dynamic> json) =>
  TransactionWarungPaidSingleModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : TransactionWarungPaidSingle.fromJson(json["body"]),
    error: json["error"],
  );

}

class TransactionWarungPaidSingle {
  TransactionWarungPaidSingle({
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
    this.classId,
    this.sellerProductPrice,
    this.totalProductPrice,
  });

  String id;
  String refId;
  String trxId;
  String storeId;
  Store store;
  String orderStatus;
  TransactionWarungPaidSingleDeliveryCost deliveryCost;
  String invoiceNo;
  List<TransactionWarungPaidSingleProductElement> products;
  TransactionWarungPaidSingleDestShippingAddress destShippingAddress;
  TransactionWarungPaidSingleUser user;
  String created;
  String doneDate;
  String wayBill;
  String classId;
  double sellerProductPrice;
  double totalProductPrice;

  factory TransactionWarungPaidSingle.fromJson(Map<String, dynamic> json) =>
    TransactionWarungPaidSingle(
      id: json["id"] == null ? null : json["id"],
      refId: json["refId"] == null ? null : json["refId"],
      trxId: json["trxId"] == null ? null : json["trxId"],
      storeId: json["storeId"] == null ? null : json["storeId"],
      store: json["store"] == null ? null : Store.fromJson(json["store"]),
      orderStatus: json["orderStatus"] == null ? null : json["orderStatus"],
      deliveryCost: json["deliveryCost"] == null ? null : TransactionWarungPaidSingleDeliveryCost.fromJson(json["deliveryCost"]),
      invoiceNo: json["invoiceNo"] == null ? null : json["invoiceNo"],
      products: json["products"] == null ? null : List<TransactionWarungPaidSingleProductElement>.from(json["products"].map((x) => TransactionWarungPaidSingleProductElement.fromJson(x))),
      destShippingAddress: json["destShippingAddress"] == null ? null : TransactionWarungPaidSingleDestShippingAddress.fromJson(json["destShippingAddress"]),
      user: json["user"] == null ? null : TransactionWarungPaidSingleUser.fromJson(json["user"]),
      created: json["created"] == null ? null : json["created"],
      doneDate: json["doneDate"] == null ? null : json["doneDate"],
      wayBill: json["wayBill"] == null ? null : json["wayBill"],
      classId: json["classId"] == null ? null : json["classId"],
      sellerProductPrice: json["sellerProductPrice"] == null ? null : json["sellerProductPrice"],
      totalProductPrice: json["totalProductPrice"] == null ? null : json["totalProductPrice"],
    );

}

class TransactionWarungPaidSingleDeliveryCost {
  TransactionWarungPaidSingleDeliveryCost({
    this.courierId,
    this.courierName,
    this.serviceName,
    this.serviceDesc,
    this.price,
    this.sellerPrice,
    this.estimateDays,
    this.classId,
  });

  String courierId;
  String courierName;
  String serviceName;
  String serviceDesc;
  double price;
  double sellerPrice;
  String estimateDays;
  String classId;

  factory TransactionWarungPaidSingleDeliveryCost.fromJson( Map<String, dynamic> json) =>
    TransactionWarungPaidSingleDeliveryCost(
      courierId: json["courierId"] == null ? null : json["courierId"],
      courierName: json["courierName"] == null ? null : json["courierName"],
      serviceName: json["serviceName"] == null ? null : json["serviceName"],
      serviceDesc: json["serviceDesc"] == null ? null : json["serviceDesc"],
      price: json["price"] == null ? null : json["price"],
      sellerPrice: json["sellerPrice"] == null ? null : json["sellerPrice"],
      estimateDays: json["estimateDays"] == null ? null : json["estimateDays"],
      classId: json["classId"] == null ? null : json["classId"],
    );
}

class TransactionWarungPaidSingleDestShippingAddress {
  TransactionWarungPaidSingleDestShippingAddress({
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

  factory TransactionWarungPaidSingleDestShippingAddress.fromJson(
          Map<String, dynamic> json) =>
      TransactionWarungPaidSingleDestShippingAddress(
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

class TransactionWarungPaidSingleProductElement {
  TransactionWarungPaidSingleProductElement({
    this.productId,
    this.product,
    this.storeId,
    this.quantity,
    this.sellerPrice,
    this.price,
    this.note,
    this.classId,
  });

  String productId;
  TransactionWarungPaidSingleProductProduct product;
  String storeId;
  int quantity;
  double sellerPrice;
  double price;
  String note;
  String classId;

  factory TransactionWarungPaidSingleProductElement.fromJson(Map<String, dynamic> json) =>
    TransactionWarungPaidSingleProductElement(
      productId: json["productId"] == null ? null : json["productId"],
      product: json["product"] == null ? null : TransactionWarungPaidSingleProductProduct.fromJson(json["product"]),
      storeId: json["storeId"] == null ? null : json["storeId"],
      quantity: json["quantity"] == null ? null : json["quantity"],
      sellerPrice: json["sellerPrice"] == null ? null : json["sellerPrice"],
      price: json["price"] == null ? null : json["price"],
      note: json["note"] == null ? null : json["note"],
      classId: json["classId"] == null ? null : json["classId"],
    );
}

class TransactionWarungPaidSingleProductProduct {
  TransactionWarungPaidSingleProductProduct({
    this.id,
    this.name,
    this.sellerPrice,
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
  double sellerPrice;
  double price;
  List<TransactionWarungPaidSinglePicture> pictures;
  int weight;
  TransactionWarungPaidSingleDiscount discount;
  int stock;
  int minOrder;
  TransactionWarungPaidSingleStats stats;
  String classId;

  factory TransactionWarungPaidSingleProductProduct.fromJson(Map<String, dynamic> json) =>
    TransactionWarungPaidSingleProductProduct(
      id: json["id"] == null ? null : json["id"],
      name: json["name"] == null ? null : json["name"],
      sellerPrice: json["sellerPrice"] == null ? null : json["sellerPrice"],
      price: json["price"] == null ? null : json["price"],
      pictures: json["pictures"] == null ? null : List<TransactionWarungPaidSinglePicture>.from(json["pictures"].map((x) => TransactionWarungPaidSinglePicture.fromJson(x))),
      weight: json["weight"] == null ? null : json["weight"],
      discount: json["discount"] == null ? null : TransactionWarungPaidSingleDiscount.fromJson(json["discount"]),
      stock: json["stock"] == null ? null : json["stock"],
      minOrder: json["minOrder"] == null ? null : json["minOrder"],
      stats: json["stats"] == null ? null : TransactionWarungPaidSingleStats.fromJson(json["stats"]),
      classId: json["classId"] == null ? null : json["classId"],
    );
}

class TransactionWarungPaidSingleDiscount {
  TransactionWarungPaidSingleDiscount({
    this.discount,
    this.startDate,
    this.endDate,
    this.active,
  });

  double discount;
  String startDate;
  String endDate;
  bool active;

  factory TransactionWarungPaidSingleDiscount.fromJson(
          Map<String, dynamic> json) =>
      TransactionWarungPaidSingleDiscount(
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

class TransactionWarungPaidSinglePicture {
  TransactionWarungPaidSinglePicture({
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

  factory TransactionWarungPaidSinglePicture.fromJson(
          Map<String, dynamic> json) =>
      TransactionWarungPaidSinglePicture(
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

class TransactionWarungPaidSingleStats {
  TransactionWarungPaidSingleStats({
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
  List<TransactionWarungPaidSingleRating> ratings;
  String classId;

  factory TransactionWarungPaidSingleStats.fromJson(
          Map<String, dynamic> json) =>
      TransactionWarungPaidSingleStats(
        ratingMax: json["ratingMax"] == null ? null : json["ratingMax"],
        ratingAvg: json["ratingAvg"] == null ? null : json["ratingAvg"],
        numOfReview: json["numOfReview"] == null ? null : json["numOfReview"],
        numOfSold: json["numOfSold"] == null ? null : json["numOfSold"],
        ratings: json["ratings"] == null
            ? null
            : List<TransactionWarungPaidSingleRating>.from(json["ratings"]
                .map((x) => TransactionWarungPaidSingleRating.fromJson(x))),
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

class TransactionWarungPaidSingleRating {
  TransactionWarungPaidSingleRating({
    this.star,
    this.count,
  });

  double star;
  var count;

  factory TransactionWarungPaidSingleRating.fromJson(
          Map<String, dynamic> json) =>
      TransactionWarungPaidSingleRating(
        star: json["star"] == null ? null : json["star"],
        count: json["count"] == null ? null : json["count"],
      );

  Map<String, dynamic> toJson() => {
        "star": star == null ? null : star,
        "count": count == null ? null : count,
      };
}

class TransactionWarungPaidSingleStore {
  TransactionWarungPaidSingleStore({
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
  TransactionWarungPaidSinglePicture picture;
  int status;
  String province;
  String city;
  String postalCode;
  String address;
  List<double> location;
  List<TransactionWarungPaidSingleSupportedCourier> supportedCouriers;
  String classId;

  factory TransactionWarungPaidSingleStore.fromJson(
          Map<String, dynamic> json) =>
      TransactionWarungPaidSingleStore(
        id: json["id"] == null ? null : json["id"],
        owner: json["owner"] == null ? null : json["owner"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        open: json["open"] == null ? null : json["open"],
        picture: json["picture"] == null
            ? null
            : TransactionWarungPaidSinglePicture.fromJson(json["picture"]),
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
            : List<TransactionWarungPaidSingleSupportedCourier>.from(
                json["supportedCouriers"].map((x) =>
                    TransactionWarungPaidSingleSupportedCourier.fromJson(x))),
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

class TransactionWarungPaidSingleSupportedCourier {
  TransactionWarungPaidSingleSupportedCourier({
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

  factory TransactionWarungPaidSingleSupportedCourier.fromJson(Map<String, dynamic> json) =>
    TransactionWarungPaidSingleSupportedCourier(
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

class TransactionWarungPaidSingleUser {
  TransactionWarungPaidSingleUser({
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
  String created;
  String avatar;
  String classId;

  factory TransactionWarungPaidSingleUser.fromJson(Map<String, dynamic> json) =>
    TransactionWarungPaidSingleUser(
      uid: json["uid"] == null ? null : json["uid"],
      fullname: json["fullname"] == null ? null : json["fullname"],
      username: json["username"] == null ? null : json["username"],
      address: json["address"] == null ? null : json["address"],
      email: json["email"] == null ? null : json["email"],
      created: json["created"] == null ? null : json["created"],
      avatar: json["avatar"] == null ? null : json["avatar"],
      classId: json["classId"] == null ? null : json["classId"],
    );

  Map<String, dynamic> toJson() => {
    "uid": uid == null ? null : uid,
    "fullname": fullname == null ? null : fullname,
    "username": username == null ? null : username,
    "address": address == null ? null : address,
    "email": email == null ? null : email,
    "created": created == null ? null : created,
    "avatar": avatar == null ? null : avatar,
    "classId": classId == null ? null : classId,
  };
}
