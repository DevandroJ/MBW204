import 'dart:convert';

ShippingCouriersModel shippingCouriersModelFromJson(String str) => ShippingCouriersModel.fromJson(json.decode(str));

String shippingCouriersModelToJson(ShippingCouriersModel data) => json.encode(data.toJson());

class ShippingCouriersModel {
  ShippingCouriersModel({
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
  List<ShippingCouriersList> body;
  dynamic error;

  factory ShippingCouriersModel.fromJson(Map<String, dynamic> json) =>
    ShippingCouriersModel(
      code: json["code"] == null ? null : json["code"],
      message: json["message"] == null ? null : json["message"],
      count: json["count"] == null ? null : json["count"],
      first: json["first"] == null ? null : json["first"],
      body: json["body"] == null ? null: List<ShippingCouriersList>.from(json["body"].map((x) => ShippingCouriersList.fromJson(x))),
      error: json["error"],
    );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "count": count == null ? null : count,
    "first": first == null ? null : first,
    "body": body == null ? null : List<dynamic>.from(body.map((x) => x.toJson())),
    "error": error,
  };
}

class ShippingCouriersList {
  ShippingCouriersList({
    this.id,
    this.timeToLive,
    this.code,
    this.name,
    this.services,
    this.cartId,
  });

  String id;
  int timeToLive;
  String code;
  String name;
  List<Service> services;
  String cartId;

  factory ShippingCouriersList.fromJson(Map<String, dynamic> json) =>
  ShippingCouriersList(
    id: json["id"] == null ? null : json["id"],
    timeToLive: json["timeToLive"] == null ? null : json["timeToLive"],
    code: json["code"] == null ? null : json["code"],
    name: json["name"] == null ? null : json["name"],
    services: json["services"] == null ? null: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
    cartId: json["cartId"] == null ? null : json["cartId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "timeToLive": timeToLive == null ? null : timeToLive,
    "code": code == null ? null : code,
    "name": name == null ? null : name,
    "services": services == null ? null : List<dynamic>.from(services.map((x) => x.toJson())),
    "cartId": cartId == null ? null : cartId,
  };
}

class Service {
  Service({
    this.service,
    this.description,
    this.costs,
  });

  String service;
  String description;
  List<Cost> costs;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    service: json["service"] == null ? null : json["service"],
    description: json["description"] == null ? null : json["description"],
    costs: json["costs"] == null ? null : List<Cost>.from(json["costs"].map((x) => Cost.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "service": service == null ? null : service,
    "description": description == null ? null : description,
    "costs": costs == null ? null : List<dynamic>.from(costs.map((x) => x.toJson())),
  };
}

class Cost {
  Cost({
    this.id,
    this.price,
    this.etd,
    this.note,
  });

  String id;
  double price;
  String etd;
  String note;

  factory Cost.fromJson(Map<String, dynamic> json) => Cost(
    id: json["id"] == null ? null : json["id"],
    price: json["price"] == null ? null : json["price"],
    etd: json["etd"] == null ? null : json["etd"],
    note: json["note"] == null ? null : json["note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "price": price == null ? null : price,
    "etd": etd == null ? null : etd,
    "note": note == null ? null : note,
  };
}
