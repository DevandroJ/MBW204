import 'dart:convert';

CouriersModel couriersModelFromJson(String str) => CouriersModel.fromJson(json.decode(str));

String couriersModelToJson(CouriersModel data) => json.encode(data.toJson());

class CouriersModel {
  CouriersModel({
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
  List<CouriersModelList> body;
  dynamic error;

  factory CouriersModel.fromJson(Map<String, dynamic> json) => CouriersModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<CouriersModelList>.from(json["body"].map((x) => CouriersModelList.fromJson(x))),
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

class CouriersModelList {
  CouriersModelList({
    this.id,
    this.name,
    this.image,
    this.checkPriceSupported,
    this.checkResiSupported,
    this.classId,
  });

  String id;
  String name;
  String image;
  bool checkPriceSupported;
  bool checkResiSupported;
  String classId;

  factory CouriersModelList.fromJson(Map<String, dynamic> json) =>
    CouriersModelList(
      id: json["id"] == null ? null : json["id"],
      name: json["name"] == null ? null : json["name"],
      image: json["image"] == null ? null : json["image"],
      checkPriceSupported: json["checkPriceSupported"] == null ? null : json["checkPriceSupported"],
      checkResiSupported: json["checkResiSupported"] == null ? null : json["checkResiSupported"],
      classId: json["classId"] == null ? null : json["classId"],
    );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "checkPriceSupported": checkPriceSupported == null ? null : checkPriceSupported,
    "checkResiSupported": checkResiSupported == null ? null : checkResiSupported,
    "classId": classId == null ? null : classId,
  };
}
