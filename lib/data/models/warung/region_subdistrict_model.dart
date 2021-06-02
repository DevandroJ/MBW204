import 'dart:convert';

RegionSubdistrictModel regionSubdistrictModelFromJson(String str) => RegionSubdistrictModel.fromJson(json.decode(str));

String regionSubdistrictModelToJson(RegionSubdistrictModel data) => json.encode(data.toJson());

class RegionSubdistrictModel {
  RegionSubdistrictModel({
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
  List<RegionSubdistrictList> body;
  dynamic error;

  factory RegionSubdistrictModel.fromJson(Map<String, dynamic> json) =>
    RegionSubdistrictModel(
      code: json["code"] == null ? null : json["code"],
      message: json["message"] == null ? null : json["message"],
      count: json["count"] == null ? null : json["count"],
      first: json["first"] == null ? null : json["first"],
      body: json["body"] == null ? null: List<RegionSubdistrictList>.from(json["body"].map((x) => RegionSubdistrictList.fromJson(x))),
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

class RegionSubdistrictList {
  RegionSubdistrictList({
    this.id,
    this.name,
    this.city,
    this.classId,
    this.province,
  });

  String id;
  String name;
  RegionSubdistrictList city;
  String classId;
  RegionSubdistrictList province;

  factory RegionSubdistrictList.fromJson(Map<String, dynamic> json) =>
  RegionSubdistrictList(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    city: json["city"] == null ? null : RegionSubdistrictList.fromJson(json["city"]),
    classId: json["classId"] == null ? null : json["classId"],
    province: json["province"] == null ? null : RegionSubdistrictList.fromJson(json["province"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "city": city == null ? null : city.toJson(),
    "classId": classId == null ? null : classId,
    "province": province == null ? null : province.toJson(),
  };
}
