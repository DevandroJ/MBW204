import 'dart:convert';

RegionModel regionModelFromJson(String str) => RegionModel.fromJson(json.decode(str));

String regionModelToJson(RegionModel data) => json.encode(data.toJson());

class RegionModel {
  RegionModel({
    this.code,
    this.message,
    this.count,
    this.first,
    this.body,
  });

  int code;
  String message;
  int count;
  bool first;
  List<Body> body;

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<Body>.from(json["body"].map((x) => Body.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "count": count == null ? null : count,
    "first": first == null ? null : first,
    "body": body == null ? null : List<dynamic>.from(body.map((x) => x.toJson())),
  };
}

class Body {
  Body({
    this.id,
    this.status,
    this.created,
    this.name,
    this.classId,
  });

  String id;
  int status;
  String created;
  String name;
  String classId;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    id: json["id"] == null ? null : json["id"],
    status: json["status"] == null ? null : json["status"],
    created: json["created"] == null ? null : json["created"],
    name: json["name"] == null ? null : json["name"],
    classId: json["classId"] == null ? null : json["classId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "status": status == null ? null : status,
    "created": created == null ? null : created,
    "name": name == null ? null : name,
    "classId": classId == null ? null : classId,
  };
}
