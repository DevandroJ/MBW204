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
}

class CartBody {
  CartBody({
    this.id,
    this.userId,
    this.numOfItems,
    this.stores,
    this.serviceCharge,
    this.shippingAddress,
    this.totalProductPrice,
    this.totalDeliveryCost,
    this.classId,
  });

  String id;
  String userId;
  int numOfItems;
  List<StoreElement> stores;
  double serviceCharge;
  ShippingAddress shippingAddress;
  double totalProductPrice;
  double totalDeliveryCost;
  String classId;

  factory CartBody.fromJson(Map<String, dynamic> json) => CartBody(
    id: json["id"] == null ? null : json["id"],
    userId: json["userId"] == null ? null : json["userId"],
    numOfItems: json["numOfItems"] == null ? null : json["numOfItems"],
    stores: json["stores"] == null ? null : List<StoreElement>.from(json["stores"].map((x) => StoreElement.fromJson(x))),
    serviceCharge: json["serviceCharge"] == null ? null : json["serviceCharge"],
    shippingAddress: json["shippingAddress"] == null ? null : ShippingAddress.fromJson(json["shippingAddress"]),
    totalProductPrice: json["totalProductPrice"] == null ? null : json["totalProductPrice"],
    totalDeliveryCost: json["totalDeliveryCost"] == null ? null : json["totalDeliveryCost"],
    classId: json["classId"] == null ? null : json["classId"],
  );
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
    this.village,
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
  String village;
  bool defaultLocation;
  List<double> location;
  String name;
  String classId;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    id: json["id"] == null ? null : json["id"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    address: json["address"] == null ? null : json["address"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    province: json["province"] == null ? null : json["province"],
    city: json["city"] == null ? null : json["city"],
    subdistrict: json["subdistrict"] == null ? null : json["subdistrict"],
    village: json["village"] == null ? null : json["village"],
    defaultLocation: json["defaultLocation"] == null ? null : json["defaultLocation"],
    location: json["location"] == null ? null : List<double>.from(json["location"].map((x) => x.toDouble())),
    name: json["name"] == null ? null : json["name"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class StoreElement {
  StoreElement({
    this.storeId,
    this.invoiceNo,
    this.store,
    this.shippingRate,
    this.items,
    this.classId,
  });

  String storeId;
  String invoiceNo;
  StoreStore store;
  ShippingRate shippingRate;
  List<Item> items;
  String classId;

  factory StoreElement.fromJson(Map<String, dynamic> json) => StoreElement(
    storeId: json["storeId"] == null ? null : json["storeId"],
    invoiceNo: json["invoiceNo"] == null ? null : json["invoiceNo"],
    store: json["store"] == null ? null : StoreStore.fromJson(json["store"]),
    shippingRate: json["shippingRate"] == null ? null : ShippingRate.fromJson(json["shippingRate"]),
    items: json["items"] == null ? null : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class Item {
  Item({
    this.productId,
    this.product,
    this.storeId,
    this.quantity,
    this.price,
    this.sellerPrice,
    this.note,
    this.classId,
  });

  String productId;
  Product product;
  String storeId;
  int quantity;
  double price;
  double sellerPrice;
  String note;
  String classId;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    productId: json["productId"] == null ? null : json["productId"],
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    storeId: json["storeId"] == null ? null : json["storeId"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    price: json["price"] == null ? null : json["price"],
    sellerPrice: json["sellerPrice"] == null ? null : json["sellerPrice"],
    note: json["note"] == null ? null : json["note"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class Product {
  Product({
    this.id,
    this.name,
    this.price,
    this.pictures,
    this.weight,
    this.discount,
    this.stock,
    this.minOrder,
    this.stats,
    this.harmful,
    this.liquid,
    this.flammable,
    this.fragile,
    this.classId,
  });

  String id;
  String name;
  double price;
  List<Picture> pictures;
  int weight;
  dynamic discount;
  int stock;
  int minOrder;
  Stats stats;
  bool harmful;
  bool liquid;
  bool flammable;
  bool fragile;
  String classId;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    price: json["price"] == null ? null : json["price"],
    pictures: json["pictures"] == null ? null : List<Picture>.from(json["pictures"].map((x) => Picture.fromJson(x))),
    weight: json["weight"] == null ? null : json["weight"],
    discount: json["discount"],
    stock: json["stock"] == null ? null : json["stock"],
    minOrder: json["minOrder"] == null ? null : json["minOrder"],
    stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
    harmful: json["harmful"] == null ? null : json["harmful"],
    liquid: json["liquid"] == null ? null : json["liquid"],
    flammable: json["flammable"] == null ? null : json["flammable"],
    fragile: json["fragile"] == null ? null : json["fragile"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class Picture {
  Picture({
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

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    originalName: json["originalName"] == null ? null : json["originalName"],
    fileLength: json["fileLength"] == null ? null : json["fileLength"],
    path: json["path"] == null ? null : json["path"],
    contentType: json["contentType"] == null ? null : json["contentType"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class Stats {
  Stats({
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
  List<Rating> ratings;
  String classId;

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    ratingMax: json["ratingMax"] == null ? null : json["ratingMax"],
    ratingAvg: json["ratingAvg"] == null ? null : json["ratingAvg"],
    numOfReview: json["numOfReview"] == null ? null : json["numOfReview"],
    numOfSold: json["numOfSold"] == null ? null : json["numOfSold"],
    ratings: json["ratings"] == null ? null : List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class Rating {
  Rating({
    this.star,
    this.count,
  });

  var star;
  var count;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    star: json["star"] == null ? null : json["star"],
    count: json["count"] == null ? null : json["count"],
  );
}

class ShippingRate {
  ShippingRate({
    this.rateId,
    this.courierId,
    this.courierName,
    this.courierLogo,
    this.serviceName,
    this.serviceDesc,
    this.serviceType,
    this.serviceLevel,
    this.price,
    this.estimateDays,
  });

  String rateId;
  String courierId;
  String courierName;
  String courierLogo;
  String serviceName;
  String serviceDesc;
  String serviceType;
  String serviceLevel;
  double price;
  String estimateDays;

  factory ShippingRate.fromJson(Map<String, dynamic> json) => ShippingRate(
    rateId: json["rateId"] == null ? null : json["rateId"],
    courierId: json["courierId"] == null ? null : json["courierId"],
    courierName: json["courierName"] == null ? null : json["courierName"],
    courierLogo: json["courierLogo"] == null ? null : json["courierLogo"],
    serviceName: json["serviceName"] == null ? null : json["serviceName"],
    serviceDesc: json["serviceDesc"] == null ? null : json["serviceDesc"],
    serviceType: json["serviceType"] == null ? null : json["serviceType"],
    serviceLevel: json["serviceLevel"] == null ? null : json["serviceLevel"],
    price: json["price"] == null ? null : json["price"],
    estimateDays: json["estimateDays"] == null ? null : json["estimateDays"],
  );
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
    this.subdistrict,
    this.village,
    this.postalCode,
    this.address,
    this.email,
    this.phone,
    this.level,
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
  String subdistrict;
  String village;
  String postalCode;
  String address;
  String email;
  String phone;
  String level;
  List<double> location;
  List<SupportedCourier> supportedCouriers;
  String classId;

  factory StoreStore.fromJson(Map<String, dynamic> json) => StoreStore(
    id: json["id"] == null ? null : json["id"],
    owner: json["owner"] == null ? null : json["owner"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    open: json["open"] == null ? null : json["open"],
    picture: json["picture"] == null ? null : Picture.fromJson(json["picture"]),
    status: json["status"] == null ? null : json["status"],
    province: json["province"] == null ? null : json["province"],
    city: json["city"] == null ? null : json["city"],
    subdistrict: json["subdistrict"] == null ? null : json["subdistrict"],
    village: json["village"] == null ? null : json["village"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    address: json["address"] == null ? null : json["address"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    level: json["level"] == null ? null : json["level"],
    location: json["location"] == null ? null : List<double>.from(json["location"].map((x) => x.toDouble())),
    supportedCouriers: json["supportedCouriers"] == null ? null : List<SupportedCourier>.from(json["supportedCouriers"].map((x) => SupportedCourier.fromJson(x))),
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class SupportedCourier {
  SupportedCourier({
    this.id,
    this.name,
    this.image,
    this.checkPriceSupported,
    this.checkResiSupported,
    this.classId,
  });

  String id;
  String name;
  String image;
  bool checkPriceSupported;
  bool checkResiSupported;
  String classId;

  factory SupportedCourier.fromJson(Map<String, dynamic> json) => SupportedCourier(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    checkPriceSupported: json["checkPriceSupported"] == null ? null : json["checkPriceSupported"],
    checkResiSupported: json["checkResiSupported"] == null ? null : json["checkResiSupported"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}
