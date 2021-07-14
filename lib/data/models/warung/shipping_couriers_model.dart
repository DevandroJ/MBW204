class ShippingCouriersModel {
  ShippingCouriersModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  ShippingCouriersList body;
  dynamic error;

  factory ShippingCouriersModel.fromJson(Map<String, dynamic> json) => ShippingCouriersModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : ShippingCouriersList.fromJson(json["body"]),
    error: json["error"],
  );
}

class ShippingCouriersList {
  ShippingCouriersList({
    this.id,
    this.cartId,
    this.origin,
    this.destination,
    this.weight,
    this.categories,
  });

  String id;
  String cartId;
  String origin;
  String destination;
  int weight;
  List<Category> categories;

  factory ShippingCouriersList.fromJson(Map<String, dynamic> json) => ShippingCouriersList(
    id: json["id"] == null ? null : json["id"],
    cartId: json["cartId"] == null ? null : json["cartId"],
    origin: json["origin"] == null ? null : json["origin"],
    destination: json["destination"] == null ? null : json["destination"],
    weight: json["weight"] == null ? null : json["weight"],
    categories: json["categories"] == null ? null : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );
}

class Category {
  Category({
    this.type,
    this.label,
    this.rates,
  });

  String type;
  String label;
  List<Rate> rates;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    type: json["type"] == null ? null : json["type"],
    label: json["label"] == null ? null : json["label"],
    rates: json["rates"] == null ? null : List<Rate>.from(json["rates"].map((x) => Rate.fromJson(x))),
  );
}

class Rate {
  Rate({
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

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
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
