import 'dart:convert';

import './region_model.dart';

AddressSingleModel addressSingleModelFromJson(String str) => AddressSingleModel.fromJson(json.decode(str));

String addressSingleModelToJson(AddressSingleModel data) => json.encode(data.toJson());

class AddressSingleModel {
  AddressSingleModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  Body body;
  dynamic error;

  factory AddressSingleModel.fromJson(Map<String, dynamic> json) => AddressSingleModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : Body.fromJson(json["body"]),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
      "code": code == null ? null : code,
      "message": message == null ? null : message,
      "body": body == null ? null : body.toJson(),
      "error": error,
  };
}

class AddressSingleList {
  AddressSingleList({
    this.id,
    this.phoneNumber,
    this.address,
    this.postalCode,
    this.province,
    this.city,
    this.subdistrict,
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
    bool defaultLocation;
    List<double> location;
    String name;
    String classId;

  factory AddressSingleList.fromJson(Map<String, dynamic> json) => AddressSingleList(
    id: json["id"] == null ? null : json["id"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    address: json["address"] == null ? null : json["address"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    province: json["province"] == null ? null : json["province"],
    city: json["city"] == null ? null : json["city"],
    subdistrict: json["subdistrict"] == null ? null : json["subdistrict"],
    defaultLocation: json["defaultLocation"] == null ? null : json["defaultLocation"],
    location: json["location"] == null ? null : List<double>.from(json["location"].map((x) => x.toDouble())),
    name: json["name"] == null ? null : json["name"],
    classId: json["classId"] == null ? null : json["classId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "address": address == null ? null : address,
    "postalCode": postalCode == null ? null : postalCode,
    "province": province == null ? null : province,
    "city": city == null ? null : city,
    "subdistrict": subdistrict == null ? null : subdistrict,
    "defaultLocation": defaultLocation == null ? null : defaultLocation,
    "location": location == null ? null : List<dynamic>.from(location.map((x) => x)),
    "name": name == null ? null : name,
    "classId": classId == null ? null : classId,
  };
}
