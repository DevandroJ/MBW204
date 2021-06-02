import 'dart:convert';

ShippingTrackingModel shippingTrackingModelFromJson(String str) => ShippingTrackingModel.fromJson(json.decode(str));

String shippingTrackingModelToJson(ShippingTrackingModel data) => json.encode(data.toJson());

class ShippingTrackingModel {
  ShippingTrackingModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  ShippingTrackingResult body;
  dynamic error;

  factory ShippingTrackingModel.fromJson(Map<String, dynamic> json) =>
      ShippingTrackingModel(
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        body: json["body"] == null
            ? null
            : ShippingTrackingResult.fromJson(json["body"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "body": body == null ? null : body.toJson(),
        "error": error,
      };
}

class ShippingTrackingResult {
  ShippingTrackingResult({
    this.delivered,
    this.summary,
    this.details,
    this.deliveryStatus,
    this.manifest,
  });

  bool delivered;
  Summary summary;
  Details details;
  DeliveryStatus deliveryStatus;
  List<Manifest> manifest;

  factory ShippingTrackingResult.fromJson(Map<String, dynamic> json) =>
      ShippingTrackingResult(
        delivered: json["delivered"] == null ? null : json["delivered"],
        summary:
            json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        details:
            json["details"] == null ? null : Details.fromJson(json["details"]),
        deliveryStatus: json["delivery_status"] == null
            ? null
            : DeliveryStatus.fromJson(json["delivery_status"]),
        manifest: json["manifest"] == null
            ? null
            : List<Manifest>.from(
                json["manifest"].map((x) => Manifest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "delivered": delivered == null ? null : delivered,
        "summary": summary == null ? null : summary.toJson(),
        "details": details == null ? null : details.toJson(),
        "delivery_status":
            deliveryStatus == null ? null : deliveryStatus.toJson(),
        "manifest": manifest == null
            ? null
            : List<dynamic>.from(manifest.map((x) => x.toJson())),
      };
}

class DeliveryStatus {
  DeliveryStatus({
    this.status,
    this.podReceiver,
    this.podDate,
    this.podTime,
  });

  String status;
  String podReceiver;
  DateTime podDate;
  String podTime;

  factory DeliveryStatus.fromJson(Map<String, dynamic> json) => DeliveryStatus(
        status: json["status"] == null ? null : json["status"],
        podReceiver: json["pod_receiver"] == null ? null : json["pod_receiver"],
        podDate:
            json["pod_date"] == null ? null : DateTime.parse(json["pod_date"]),
        podTime: json["pod_time"] == null ? null : json["pod_time"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "pod_receiver": podReceiver == null ? null : podReceiver,
        "pod_date": podDate == null
            ? null
            : "${podDate.year.toString().padLeft(4, '0')}-${podDate.month.toString().padLeft(2, '0')}-${podDate.day.toString().padLeft(2, '0')}",
        "pod_time": podTime == null ? null : podTime,
      };
}

class Details {
  Details({
    this.waybillNumber,
    this.waybillDate,
    this.waybillTime,
    this.weight,
    this.origin,
    this.destination,
    this.shippperName,
    this.shipperAddress1,
    this.shipperAddress2,
    this.shipperAddress3,
    this.shipperCity,
    this.receiverName,
    this.receiverAddress1,
    this.receiverAddress2,
    this.receiverAddress3,
    this.receiverCity,
  });

  String waybillNumber;
  DateTime waybillDate;
  String waybillTime;
  String weight;
  String origin;
  String destination;
  String shippperName;
  String shipperAddress1;
  String shipperAddress2;
  String shipperAddress3;
  String shipperCity;
  String receiverName;
  String receiverAddress1;
  String receiverAddress2;
  String receiverAddress3;
  String receiverCity;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        waybillNumber:
            json["waybill_number"] == null ? null : json["waybill_number"],
        waybillDate: json["waybill_date"] == null
            ? null
            : DateTime.parse(json["waybill_date"]),
        waybillTime: json["waybill_time"] == null ? null : json["waybill_time"],
        weight: json["weight"] == null ? null : json["weight"],
        origin: json["origin"] == null ? null : json["origin"],
        destination: json["destination"] == null ? null : json["destination"],
        shippperName:
            json["shippper_name"] == null ? null : json["shippper_name"],
        shipperAddress1:
            json["shipper_address1"] == null ? null : json["shipper_address1"],
        shipperAddress2:
            json["shipper_address2"] == null ? null : json["shipper_address2"],
        shipperAddress3:
            json["shipper_address3"] == null ? null : json["shipper_address3"],
        shipperCity: json["shipper_city"] == null ? null : json["shipper_city"],
        receiverName:
            json["receiver_name"] == null ? null : json["receiver_name"],
        receiverAddress1: json["receiver_address1"] == null
            ? null
            : json["receiver_address1"],
        receiverAddress2: json["receiver_address2"] == null
            ? null
            : json["receiver_address2"],
        receiverAddress3: json["receiver_address3"] == null
            ? null
            : json["receiver_address3"],
        receiverCity:
            json["receiver_city"] == null ? null : json["receiver_city"],
      );

  Map<String, dynamic> toJson() => {
        "waybill_number": waybillNumber == null ? null : waybillNumber,
        "waybill_date": waybillDate == null
            ? null
            : "${waybillDate.year.toString().padLeft(4, '0')}-${waybillDate.month.toString().padLeft(2, '0')}-${waybillDate.day.toString().padLeft(2, '0')}",
        "waybill_time": waybillTime == null ? null : waybillTime,
        "weight": weight == null ? null : weight,
        "origin": origin == null ? null : origin,
        "destination": destination == null ? null : destination,
        "shippper_name": shippperName == null ? null : shippperName,
        "shipper_address1": shipperAddress1 == null ? null : shipperAddress1,
        "shipper_address2": shipperAddress2 == null ? null : shipperAddress2,
        "shipper_address3": shipperAddress3 == null ? null : shipperAddress3,
        "shipper_city": shipperCity == null ? null : shipperCity,
        "receiver_name": receiverName == null ? null : receiverName,
        "receiver_address1": receiverAddress1 == null ? null : receiverAddress1,
        "receiver_address2": receiverAddress2 == null ? null : receiverAddress2,
        "receiver_address3": receiverAddress3 == null ? null : receiverAddress3,
        "receiver_city": receiverCity == null ? null : receiverCity,
      };
}

class Manifest {
  Manifest({
    this.manifestCode,
    this.manifestDescription,
    this.manifestDate,
    this.manifestTime,
    this.cityName,
  });

  String manifestCode;
  String manifestDescription;
  DateTime manifestDate;
  String manifestTime;
  String cityName;

  factory Manifest.fromJson(Map<String, dynamic> json) => Manifest(
        manifestCode:
            json["manifest_code"] == null ? null : json["manifest_code"],
        manifestDescription: json["manifest_description"] == null
            ? null
            : json["manifest_description"],
        manifestDate: json["manifest_date"] == null
            ? null
            : DateTime.parse(json["manifest_date"]),
        manifestTime:
            json["manifest_time"] == null ? null : json["manifest_time"],
        cityName: json["city_name"] == null ? null : json["city_name"],
      );

  Map<String, dynamic> toJson() => {
        "manifest_code": manifestCode == null ? null : manifestCode,
        "manifest_description":
            manifestDescription == null ? null : manifestDescription,
        "manifest_date": manifestDate == null
            ? null
            : "${manifestDate.year.toString().padLeft(4, '0')}-${manifestDate.month.toString().padLeft(2, '0')}-${manifestDate.day.toString().padLeft(2, '0')}",
        "manifest_time": manifestTime == null ? null : manifestTime,
        "city_name": cityName == null ? null : cityName,
      };
}

class Summary {
  Summary({
    this.courierCode,
    this.courierName,
    this.waybillNumber,
    this.serviceCode,
    this.waybillDate,
    this.shipperName,
    this.receiverName,
    this.origin,
    this.destination,
    this.status,
  });

  String courierCode;
  String courierName;
  String waybillNumber;
  String serviceCode;
  DateTime waybillDate;
  String shipperName;
  String receiverName;
  String origin;
  String destination;
  String status;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        courierCode: json["courier_code"] == null ? null : json["courier_code"],
        courierName: json["courier_name"] == null ? null : json["courier_name"],
        waybillNumber:
            json["waybill_number"] == null ? null : json["waybill_number"],
        serviceCode: json["service_code"] == null ? null : json["service_code"],
        waybillDate: json["waybill_date"] == null
            ? null
            : DateTime.parse(json["waybill_date"]),
        shipperName: json["shipper_name"] == null ? null : json["shipper_name"],
        receiverName:
            json["receiver_name"] == null ? null : json["receiver_name"],
        origin: json["origin"] == null ? null : json["origin"],
        destination: json["destination"] == null ? null : json["destination"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "courier_code": courierCode == null ? null : courierCode,
        "courier_name": courierName == null ? null : courierName,
        "waybill_number": waybillNumber == null ? null : waybillNumber,
        "service_code": serviceCode == null ? null : serviceCode,
        "waybill_date": waybillDate == null
            ? null
            : "${waybillDate.year.toString().padLeft(4, '0')}-${waybillDate.month.toString().padLeft(2, '0')}-${waybillDate.day.toString().padLeft(2, '0')}",
        "shipper_name": shipperName == null ? null : shipperName,
        "receiver_name": receiverName == null ? null : receiverName,
        "origin": origin == null ? null : origin,
        "destination": destination == null ? null : destination,
        "status": status == null ? null : status,
      };
}
