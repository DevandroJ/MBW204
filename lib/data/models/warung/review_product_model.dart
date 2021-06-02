import 'dart:convert';

ReviewProductModel reviewProductModelFromJson(String str) => ReviewProductModel.fromJson(json.decode(str));

String reviewProductModelToJson(ReviewProductModel data) => json.encode(data.toJson());

class ReviewProductModel {
  ReviewProductModel({
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
  List<ReviewProductList> body;
  dynamic error;

  factory ReviewProductModel.fromJson(Map<String, dynamic> json) =>
  ReviewProductModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<ReviewProductList>.from(json["body"].map((x) => ReviewProductList.fromJson(x))),
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

class ReviewProductList {
  ReviewProductList({
    this.id,
    this.name,
    this.pictures,
    this.date,
    this.review,
    this.classId,
  });

  String id;
  String name;
  List<ReviewProductPicture> pictures;
  String date;
  String review;
  String classId;

  factory ReviewProductList.fromJson(Map<String, dynamic> json) =>
  ReviewProductList(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    pictures: json["pictures"] == null ? null : List<ReviewProductPicture>.from(json["pictures"].map((x) => ReviewProductPicture.fromJson(x))),
    date: json["date"] == null ? null : json["date"],
    review: json["review"] == null ? null : json["review"],
    classId: json["classId"] == null ? null : json["classId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "pictures": pictures == null ? null : List<dynamic>.from(pictures.map((x) => x.toJson())),
    "date": date == null ? null : date,
    "review": review == null ? null : review,
    "classId": classId == null ? null : classId,
  };
}

class ReviewProductPicture {
  ReviewProductPicture({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
    this.classId,
  });

  String originalName;
  int fileLength;
  String path;
  String contentType;
  String classId;

  factory ReviewProductPicture.fromJson(Map<String, dynamic> json) =>
    ReviewProductPicture(
      originalName: json["originalName"] == null ? null : json["originalName"],
      fileLength: json["fileLength"] == null ? null : json["fileLength"],
      path: json["path"] == null ? null : json["path"],
      contentType: json["contentType"] == null ? null : json["contentType"],
      classId: json["classId"] == null ? null : json["classId"],
    );

  Map<String, dynamic> toJson() => {
    "originalName": originalName == null ? null : originalName,
    "fileLength": fileLength == null ? null : fileLength,
    "path": path == null ? null : path,
    "contentType": contentType == null ? null : contentType,
    "classId": classId == null ? null : classId,
  };
}
