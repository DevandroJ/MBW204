import 'dart:convert';

AddressModel addressModelFromJson(String str) => AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  AddressModel({
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
  List<AddressList> body;
  dynamic error;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<AddressList>.from(json["body"].map((x) => AddressList.fromJson(x))),
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

class AddressList {
  AddressList({
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

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
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
