// To parse this JSON data, do
//
//     final bankModel = bankModelFromJson(jsonString);

import 'dart:convert';

BankModel bankModelFromJson(String str) => BankModel.fromJson(json.decode(str));

String bankModelToJson(BankModel data) => json.encode(data.toJson());

class BankModel {
    BankModel({
        this.data,
    });

    List<Datum> data;

    factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.channel,
        this.name,
        this.guide,
        this.paymentCode,
        this.paymentName,
        this.paymentDescription,
        this.paymentLogo,
        this.paymentUrl,
        this.paymentUrlV2,
        this.totalAdminFee,
        this.isDirect,
        this.status,
        this.updatedAt,
        this.createdAt,
    });

    String channel;
    String name;
    String guide;
    dynamic paymentCode;
    dynamic paymentName;
    dynamic paymentDescription;
    String paymentLogo;
    String paymentUrl;
    String paymentUrlV2;
    String totalAdminFee;
    bool isDirect;
    int status;
    DateTime updatedAt;
    DateTime createdAt;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        channel: json["channel"] == null ? null : json["channel"],
        name: json["name"] == null ? null : json["name"],
        guide: json["guide"] == null ? null : json["guide"],
        paymentCode: json["payment_code"],
        paymentName: json["payment_name"],
        paymentDescription: json["payment_description"],
        paymentLogo: json["payment_logo"] == null ? null : json["payment_logo"],
        paymentUrl: json["payment_url"] == null ? null : json["payment_url"],
        paymentUrlV2: json["payment_url_v2"] == null ? null : json["payment_url_v2"],
        totalAdminFee: json["total_admin_fee"] == null ? null : json["total_admin_fee"],
        isDirect: json["is_direct"] == null ? null : json["is_direct"],
        status: json["status"] == null ? null : json["status"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "channel": channel == null ? null : channel,
        "name": name == null ? null : name,
        "guide": guide == null ? null : guide,
        "payment_code": paymentCode,
        "payment_name": paymentName,
        "payment_description": paymentDescription,
        "payment_logo": paymentLogo == null ? null : paymentLogo,
        "payment_url": paymentUrl == null ? null : paymentUrl,
        "payment_url_v2": paymentUrlV2 == null ? null : paymentUrlV2,
        "is_direct": isDirect == null ? null : isDirect,
        "status": status == null ? null : status,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    };
}
