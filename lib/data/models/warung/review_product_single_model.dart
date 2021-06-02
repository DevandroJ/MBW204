import 'dart:convert';

ReviewProductSingleModel reviewProductSingleModelFromJson(String str) => ReviewProductSingleModel.fromJson(json.decode(str));

String reviewProductSingleModelToJson(ReviewProductSingleModel data) => json.encode(data.toJson());

class ReviewProductSingleModel {
  ReviewProductSingleModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  ReviewProductSingle body;
  dynamic error;

  factory ReviewProductSingleModel.fromJson(Map<String, dynamic> json) =>
      ReviewProductSingleModel(
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        body: json["body"] == null
            ? null
            : ReviewProductSingle.fromJson(json["body"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "body": body == null ? null : body.toJson(),
        "error": error,
      };
}

class ReviewProductSingle {
  ReviewProductSingle({
    this.id,
    this.userId,
    this.review,
    this.photos,
    this.star,
    this.classId,
  });

  String id;
  String userId;
  String review;
  List<ReviewPhoto> photos;
  double star;
  String classId;

  factory ReviewProductSingle.fromJson(Map<String, dynamic> json) =>
      ReviewProductSingle(
        id: json["id"] == null ? null : json["id"],
        userId: json["userId"] == null ? null : json["userId"],
        review: json["review"] == null ? null : json["review"],
        photos: json["photos"] == null
            ? null
            : List<ReviewPhoto>.from(
                json["photos"].map((x) => ReviewPhoto.fromJson(x))),
        star: json["star"] == null ? null : json["star"],
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "userId": userId == null ? null : userId,
    "review": review == null ? null : review,
    "photos": photos == null ? null : List<dynamic>.from(photos.map((x) => x.toJson())),
    "star": star == null ? null : star,
    "classId": classId == null ? null : classId,
  };
}

class ReviewPhoto {
  ReviewPhoto({
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

  factory ReviewPhoto.fromJson(Map<String, dynamic> json) => ReviewPhoto(
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
