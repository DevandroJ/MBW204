class ShippingTrackingModel {
  ShippingTrackingModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  Body body;
  dynamic error;

  factory ShippingTrackingModel.fromJson(Map<String, dynamic> json) => ShippingTrackingModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : Body.fromJson(json["body"]),
    error: json["error"],
  );
}

class Body {
    Body({
        this.id,
        this.status,
        this.created,
        this.updated,
        this.orderId,
        this.userId,
        this.storeId,
        this.orderStatusInfos,
        this.wayBillDelivery,
        this.completed,
        this.classId,
    });

    String id;
    int status;
    String created;
    String updated;
    String orderId;
    String userId;
    String storeId;
    List<OrderStatusInfo> orderStatusInfos;
    WayBillDelivery wayBillDelivery;
    bool completed;
    String classId;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    id: json["id"] == null ? null : json["id"],
    status: json["status"] == null ? null : json["status"],
    created: json["created"] == null ? null : json["created"],
    updated: json["updated"] == null ? null : json["updated"],
    orderId: json["orderId"] == null ? null : json["orderId"],
    userId: json["userId"] == null ? null : json["userId"],
    storeId: json["storeId"] == null ? null : json["storeId"],
    orderStatusInfos: json["orderStatusInfos"] == null ? null : List<OrderStatusInfo>.from(json["orderStatusInfos"].map((x) => OrderStatusInfo.fromJson(x))),
    wayBillDelivery: json["wayBillDelivery"] == null ? null : WayBillDelivery.fromJson(json["wayBillDelivery"]),
    completed: json["completed"] == null ? null : json["completed"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class OrderStatusInfo {
  OrderStatusInfo({
    this.date,
    this.progress,
    this.handledBy,
  });

  String date;
  String progress;
  String handledBy;

  factory OrderStatusInfo.fromJson(Map<String, dynamic> json) => OrderStatusInfo(
    date: json["date"] == null ? null : json["date"],
    progress: json["progress"] == null ? null : json["progress"],
    handledBy: json["handledBy"] == null ? null : json["handledBy"],
  );
}

class WayBillDelivery {
  WayBillDelivery({
    this.waybill,
    this.delivered,
    this.waybillDate,
    this.shipperName,
    this.receiverName,
    this.receivedDate,
    this.courierId,
    this.courierName,
    this.serviceCode,
    this.destination,
    this.origin,
    this.status,
    this.manifests,
  });

  String waybill;
  bool delivered;
  DateTime waybillDate;
  String shipperName;
  String receiverName;
  dynamic receivedDate;
  String courierId;
  String courierName;
  String serviceCode;
  String destination;
  String origin;
  String status;
  List<Manifest> manifests;

  factory WayBillDelivery.fromJson(Map<String, dynamic> json) => WayBillDelivery(
    waybill: json["waybill"] == null ? null : json["waybill"],
    delivered: json["delivered"] == null ? null : json["delivered"],
    waybillDate: json["waybillDate"] == null ? null : DateTime.parse(json["waybillDate"]),
    shipperName: json["shipperName"] == null ? null : json["shipperName"],
    receiverName: json["receiverName"] == null ? null : json["receiverName"],
    receivedDate: json["receivedDate"],
    courierId: json["courierId"] == null ? null : json["courierId"],
    courierName: json["courierName"] == null ? null : json["courierName"],
    serviceCode: json["serviceCode"] == null ? null : json["serviceCode"],
    destination: json["destination"] == null ? null : json["destination"],
    origin: json["origin"] == null ? null : json["origin"],
    status: json["status"] == null ? null : json["status"],
    manifests: json["manifests"] == null ? null : List<Manifest>.from(json["manifests"].map((x) => Manifest.fromJson(x))),
  );
}

class Manifest {
  Manifest({
    this.description,
    this.date,
  });

  String description;
  DateTime date;

  factory Manifest.fromJson(Map<String, dynamic> json) => Manifest(
    description: json["description"] == null ? null : json["description"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );
}
