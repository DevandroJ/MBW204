import 'dart:convert';

TransactionWarungUnpaidModel transactionWarungUnpaidModelFromJson(String str) => TransactionWarungUnpaidModel.fromJson(json.decode(str));

String transactionWarungUnpaidModelToJson(TransactionWarungUnpaidModel data) => json.encode(data.toJson());

class TransactionWarungUnpaidModel {
  TransactionWarungUnpaidModel({
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
  List<TransactionWarungUnpaidList> body;
  dynamic error;

  factory TransactionWarungUnpaidModel.fromJson(Map<String, dynamic> json) =>
      TransactionWarungUnpaidModel(
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        count: json["count"] == null ? null : json["count"],
        first: json["first"] == null ? null : json["first"],
        body: json["body"] == null
            ? null
            : List<TransactionWarungUnpaidList>.from(json["body"]
                .map((x) => TransactionWarungUnpaidList.fromJson(x))),
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

class TransactionWarungUnpaidList {
  TransactionWarungUnpaidList({
    this.id,
    this.refId,
    this.transactionStatus,
    this.paymentChannel,
    this.paymentRef,
    this.stores,
    this.shippingAddress,
    this.serviceCharge,
    this.totalProductPrice,
    this.totalDeliveryCost,
    this.totalPrice,
    this.billed,
    this.billCreated,
    this.classId,
  });

  String id;
  String refId;
  String transactionStatus;
  PaymentChannel paymentChannel;
  PaymentRef paymentRef;
  List<TransactionUnpaidStoreElement> stores;
  TransactionUnpaidShippingAddress shippingAddress;
  double serviceCharge;
  double totalProductPrice;
  double totalDeliveryCost;
  double totalPrice;
  bool billed;
  String billCreated;
  String classId;

  factory TransactionWarungUnpaidList.fromJson(Map<String, dynamic> json) =>
      TransactionWarungUnpaidList(
        id: json["id"] == null ? null : json["id"],
        refId: json["refId"] == null ? null : json["refId"],
        transactionStatus: json["transactionStatus"] == null
            ? null
            : json["transactionStatus"],
        paymentChannel: json["paymentChannel"] == null
            ? null
            : PaymentChannel.fromJson(json["paymentChannel"]),
        paymentRef: json["paymentRef"] == null
            ? null
            : PaymentRef.fromJson(json["paymentRef"]),
        stores: json["stores"] == null
            ? null
            : List<TransactionUnpaidStoreElement>.from(json["stores"]
                .map((x) => TransactionUnpaidStoreElement.fromJson(x))),
        shippingAddress: json["shippingAddress"] == null
            ? null
            : TransactionUnpaidShippingAddress.fromJson(
                json["shippingAddress"]),
        serviceCharge:
            json["serviceCharge"] == null ? null : json["serviceCharge"],
        totalPrice: json["totalPrice"] == null ? null : json["totalPrice"],
        totalProductPrice: json["totalProductPrice"] == null
            ? null
            : json["totalProductPrice"],
        totalDeliveryCost: json["totalDeliveryCost"] == null
            ? null
            : json["totalDeliveryCost"],
        billed: json["billed"] == null ? null : json["billed"],
        billCreated: json["billCreated"] == null ? null : json["billCreated"],
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "refId": refId == null ? null : refId,
        "transactionStatus":
            transactionStatus == null ? null : transactionStatus,
        "paymentChannel":
            paymentChannel == null ? null : paymentChannel.toJson(),
        "paymentRef": paymentRef == null ? null : paymentRef.toJson(),
        "stores": stores == null
            ? null
            : List<dynamic>.from(stores.map((x) => x.toJson())),
        "shippingAddress":
            shippingAddress == null ? null : shippingAddress.toJson(),
        "serviceCharge": serviceCharge == null ? null : serviceCharge,
        "totalPrice": totalPrice == null ? null : totalPrice,
        "totalProductPrice":
            totalProductPrice == null ? null : totalProductPrice,
        "totalDeliveryCost":
            totalDeliveryCost == null ? null : totalDeliveryCost,
        "billed": billed == null ? null : billed,
        "billCreated": billCreated == null ? null : billCreated,
        "classId": classId == null ? null : classId,
      };
}

class PaymentChannel {
  PaymentChannel({
    this.channel,
    this.name,
    this.guide,
    this.paymentFee,
    this.logo,
  });

  String channel;
  String name;
  String guide;
  double paymentFee;
  String logo;

  factory PaymentChannel.fromJson(Map<String, dynamic> json) => PaymentChannel(
        channel: json["channel"] == null ? null : json["channel"],
        name: json["name"] == null ? null : json["name"],
        guide: json["guide"] == null ? null : json["guide"],
        paymentFee: json["paymentFee"] == null ? null : json["paymentFee"],
        logo: json["logo"] == null ? null : json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "channel": channel == null ? null : channel,
        "name": name == null ? null : name,
        "guide": guide == null ? null : guide,
        "paymentFee": paymentFee == null ? null : paymentFee,
        "logo": logo == null ? null : logo,
      };
}

class PaymentRef {
  PaymentRef({
    this.paymentChannel,
    this.paymentCode,
    this.paymentRefId,
    this.paymentGuide,
    this.paymentAdminFee,
    this.paymentStatus,
    this.refNo,
    this.currency,
    this.billingUid,
    this.amount,
  });

  String paymentChannel;
  String paymentCode;
  String paymentRefId;
  String paymentGuide;
  String paymentAdminFee;
  String paymentStatus;
  String refNo;
  String currency;
  String billingUid;
  double amount;

  factory PaymentRef.fromJson(Map<String, dynamic> json) => PaymentRef(
        paymentChannel:
            json["paymentChannel"] == null ? null : json["paymentChannel"],
        paymentCode: json["paymentCode"] == null ? null : json["paymentCode"],
        paymentRefId:
            json["paymentRefId"] == null ? null : json["paymentRefId"],
        paymentGuide:
            json["paymentGuide"] == null ? null : json["paymentGuide"],
        paymentAdminFee:
            json["paymentAdminFee"] == null ? null : json["paymentAdminFee"],
        paymentStatus:
            json["paymentStatus"] == null ? null : json["paymentStatus"],
        refNo: json["refNo"] == null ? null : json["refNo"],
        currency: json["currency"] == null ? null : json["currency"],
        billingUid: json["billingUid"] == null ? null : json["billingUid"],
        amount: json["amount"] == null ? null : json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "paymentChannel": paymentChannel == null ? null : paymentChannel,
        "paymentCode": paymentCode == null ? null : paymentCode,
        "paymentRefId": paymentRefId == null ? null : paymentRefId,
        "paymentGuide": paymentGuide == null ? null : paymentGuide,
        "paymentAdminFee": paymentAdminFee == null ? null : paymentAdminFee,
        "paymentStatus": paymentStatus == null ? null : paymentStatus,
        "refNo": refNo == null ? null : refNo,
        "currency": currency == null ? null : currency,
        "billingUid": billingUid == null ? null : billingUid,
        "amount": amount == null ? null : amount,
      };
}

class TransactionUnpaidShippingAddress {
  TransactionUnpaidShippingAddress({
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

  factory TransactionUnpaidShippingAddress.fromJson(
          Map<String, dynamic> json) =>
      TransactionUnpaidShippingAddress(
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

class TransactionUnpaidStoreElement {
  TransactionUnpaidStoreElement({
    this.storeId,
    this.invoiceNo,
    this.store,
    this.deliveryCost,
    this.items,
    this.classId,
  });

  String storeId;
  String invoiceNo;
  TransactionUnpaidStoreStore store;
  TransactionUnpaidDeliveryCost deliveryCost;
  List<TransactionUnpaidItem> items;
  String classId;

  factory TransactionUnpaidStoreElement.fromJson(Map<String, dynamic> json) =>
      TransactionUnpaidStoreElement(
        storeId: json["storeId"] == null ? null : json["storeId"],
        invoiceNo: json["invoiceNo"] == null ? null : json["invoiceNo"],
        store: json["store"] == null
            ? null
            : TransactionUnpaidStoreStore.fromJson(json["store"]),
        deliveryCost: json["deliveryCost"] == null
            ? null
            : TransactionUnpaidDeliveryCost.fromJson(json["deliveryCost"]),
        items: json["items"] == null
            ? null
            : List<TransactionUnpaidItem>.from(
                json["items"].map((x) => TransactionUnpaidItem.fromJson(x))),
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "storeId": storeId == null ? null : storeId,
        "invoiceNo": invoiceNo == null ? null : invoiceNo,
        "store": store == null ? null : store.toJson(),
        "deliveryCost": deliveryCost == null ? null : deliveryCost.toJson(),
        "items": items == null
            ? null
            : List<dynamic>.from(items.map((x) => x.toJson())),
        "classId": classId == null ? null : classId,
      };
}

class TransactionUnpaidDeliveryCost {
  TransactionUnpaidDeliveryCost({
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

  factory TransactionUnpaidDeliveryCost.fromJson(Map<String, dynamic> json) =>
      TransactionUnpaidDeliveryCost(
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

class TransactionUnpaidItem {
  TransactionUnpaidItem({
    this.productId,
    this.product,
    this.storeId,
    this.quantity,
    this.price,
    this.note,
    this.classId,
  });

  String productId;
  TransactionUnpaidProduct product;
  String storeId;
  int quantity;
  double price;
  String note;
  String classId;

  factory TransactionUnpaidItem.fromJson(Map<String, dynamic> json) =>
      TransactionUnpaidItem(
        productId: json["productId"] == null ? null : json["productId"],
        product: json["product"] == null
            ? null
            : TransactionUnpaidProduct.fromJson(json["product"]),
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

class TransactionUnpaidProduct {
  TransactionUnpaidProduct({
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
  List<TransactionUnpaidPicture> pictures;
  int weight;
  TransactionUnpaidProductDiscount discount;
  int stock;
  TransactionUnpaidStats stats;
  String classId;

  factory TransactionUnpaidProduct.fromJson(Map<String, dynamic> json) =>
      TransactionUnpaidProduct(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"],
        pictures: json["pictures"] == null
            ? null
            : List<TransactionUnpaidPicture>.from(json["pictures"]
                .map((x) => TransactionUnpaidPicture.fromJson(x))),
        weight: json["weight"] == null ? null : json["weight"],
        discount: json["discount"] == null
            ? null
            : TransactionUnpaidProductDiscount.fromJson(json["discount"]),
        stock: json["stock"] == null ? null : json["stock"],
        stats: json["stats"] == null
            ? null
            : TransactionUnpaidStats.fromJson(json["stats"]),
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
        "discount": discount == null ? null : discount.toJson(),
        "stock": stock == null ? null : stock,
        "stats": stats == null ? null : stats.toJson(),
        "classId": classId == null ? null : classId,
      };
}

class TransactionUnpaidProductDiscount {
  TransactionUnpaidProductDiscount({
    this.discount,
    this.startDate,
    this.endDate,
    this.active,
  });

  double discount;
  String startDate;
  String endDate;
  bool active;

  factory TransactionUnpaidProductDiscount.fromJson(
          Map<String, dynamic> json) =>
      TransactionUnpaidProductDiscount(
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

class TransactionUnpaidPicture {
  TransactionUnpaidPicture({
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

  factory TransactionUnpaidPicture.fromJson(Map<String, dynamic> json) =>
      TransactionUnpaidPicture(
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

class TransactionUnpaidStats {
  TransactionUnpaidStats({
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
  List<TransactionUnpaidRating> ratings;
  String classId;

  factory TransactionUnpaidStats.fromJson(Map<String, dynamic> json) =>
      TransactionUnpaidStats(
        ratingMax: json["ratingMax"] == null ? null : json["ratingMax"],
        ratingAvg: json["ratingAvg"] == null ? null : json["ratingAvg"],
        numOfReview: json["numOfReview"] == null ? null : json["numOfReview"],
        numOfSold: json["numOfSold"] == null ? null : json["numOfSold"],
        ratings: json["ratings"] == null
            ? null
            : List<TransactionUnpaidRating>.from(json["ratings"]
                .map((x) => TransactionUnpaidRating.fromJson(x))),
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

class TransactionUnpaidRating {
  TransactionUnpaidRating({
    this.star,
    this.count,
  });

  double star;
  var count;

  factory TransactionUnpaidRating.fromJson(Map<String, dynamic> json) =>
      TransactionUnpaidRating(
        star: json["star"] == null ? null : json["star"],
        count: json["count"] == null ? null : json["count"],
      );

  Map<String, dynamic> toJson() => {
        "star": star == null ? null : star,
        "count": count == null ? null : count,
      };
}

class TransactionUnpaidStoreStore {
  TransactionUnpaidStoreStore({
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
  TransactionUnpaidPicture picture;
  int status;
  String province;
  String city;
  String postalCode;
  String address;
  List<double> location;
  List<TransactionUnpaidSupportedCourier> supportedCouriers;
  String classId;

  factory TransactionUnpaidStoreStore.fromJson(Map<String, dynamic> json) =>
    TransactionUnpaidStoreStore(
      id: json["id"] == null ? null : json["id"],
      owner: json["owner"] == null ? null : json["owner"],
      name: json["name"] == null ? null : json["name"],
      description: json["description"] == null ? null : json["description"],
      open: json["open"] == null ? null : json["open"],
      picture: json["picture"] == null ? null : TransactionUnpaidPicture.fromJson(json["picture"]),
      status: json["status"] == null ? null : json["status"],
      province: json["province"] == null ? null : json["province"],
      city: json["city"] == null ? null : json["city"],
      postalCode: json["postalCode"] == null ? null : json["postalCode"],
      address: json["address"] == null ? null : json["address"],
      location: json["location"] == null ? null : List<double>.from(json["location"].map((x) => x.toDouble())),
      supportedCouriers: json["supportedCouriers"] == null ? null : List<TransactionUnpaidSupportedCourier>.from(json["supportedCouriers"].map((x) => TransactionUnpaidSupportedCourier.fromJson(x))),
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

class TransactionUnpaidSupportedCourier {
  TransactionUnpaidSupportedCourier({
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

  factory TransactionUnpaidSupportedCourier.fromJson( Map<String, dynamic> json) => TransactionUnpaidSupportedCourier(
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
