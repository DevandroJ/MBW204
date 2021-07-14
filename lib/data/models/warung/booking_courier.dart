class BookingCourierModel {
  BookingCourierModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  BookingCourierData body;
  dynamic error;

  factory BookingCourierModel.fromJson(Map<String, dynamic> json) => BookingCourierModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : BookingCourierData.fromJson(json["body"]),
    error: json["error"],
  );
}

class BookingCourierData {
  BookingCourierData({
    this.deliveryCost,
    this.waybill,
    this.created,
  });

  DeliveryCost deliveryCost;
  String waybill;
  String created;

  factory BookingCourierData.fromJson(Map<String, dynamic> json) => BookingCourierData(
    deliveryCost: json["deliveryCost"] == null ? null : DeliveryCost.fromJson(json["deliveryCost"]),
    waybill: json["waybill"] == null ? null : json["waybill"],
    created: json["created"] == null ? null : json["created"],
  );
}

class DeliveryCost {
  DeliveryCost({
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

  factory DeliveryCost.fromJson(Map<String, dynamic> json) => DeliveryCost(
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
