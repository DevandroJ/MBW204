import 'dart:convert';

CheckoutCartWarungModel checkoutCartWarungModelFromJson(String str) => CheckoutCartWarungModel.fromJson(json.decode(str));

String checkoutCartWarungModelToJson(CheckoutCartWarungModel data) => json.encode(data.toJson());

class CheckoutCartWarungModel {
  CheckoutCartWarungModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  ResultCheckoutCart body;
  dynamic error;

  factory CheckoutCartWarungModel.fromJson(Map<String, dynamic> json) =>
    CheckoutCartWarungModel(
      code: json["code"] == null ? null : json["code"],
      message: json["message"] == null ? null : json["message"],
      body: json["body"] == null ? null : ResultCheckoutCart.fromJson(json["body"]),
      error: json["error"],
    );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "body": body == null ? null : body.toJson(),
    "error": error,
  };
}

class ResultCheckoutCart {
  ResultCheckoutCart({
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

  factory ResultCheckoutCart.fromJson(Map<String, dynamic> json) =>
  ResultCheckoutCart(
    paymentChannel: json["paymentChannel"] == null ? null : json["paymentChannel"],
    paymentCode: json["paymentCode"] == null ? null : json["paymentCode"],
    paymentRefId: json["paymentRefId"] == null ? null : json["paymentRefId"],
    paymentGuide: json["paymentGuide"] == null ? null : json["paymentGuide"],
    paymentAdminFee: json["paymentAdminFee"] == null ? null : json["paymentAdminFee"],
    paymentStatus: json["paymentStatus"] == null ? null : json["paymentStatus"],
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
