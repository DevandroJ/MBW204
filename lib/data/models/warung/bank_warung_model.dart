import 'dart:convert';

BankWarungModel bankWarungModelFromJson(String str) => BankWarungModel.fromJson(json.decode(str));

String bankWarungModelToJson(BankWarungModel data) => json.encode(data.toJson());

class BankWarungModel {
  BankWarungModel({
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
  List<ResultBankList> body;
  dynamic error;

  factory BankWarungModel.fromJson(Map<String, dynamic> json) =>
    BankWarungModel(
      code: json["code"] == null ? null : json["code"],
      message: json["message"] == null ? null : json["message"],
      count: json["count"] == null ? null : json["count"],
      first: json["first"] == null ? null : json["first"],
      body: json["body"] == null ? null: List<ResultBankList>.from(json["body"].map((x) => ResultBankList.fromJson(x))),
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

class ResultBankList {
  ResultBankList({
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

  factory ResultBankList.fromJson(Map<String, dynamic> json) => ResultBankList(
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
