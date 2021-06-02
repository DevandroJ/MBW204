import 'dart:convert';

import 'seller_store_model.dart';

CategoryProductModel categoryProductModelFromJson(String str) => CategoryProductModel.fromJson(json.decode(str));

String categoryProductModelToJson(CategoryProductModel data) => json.encode(data.toJson());

class CategoryProductModel {
  CategoryProductModel({
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
  List<CategoryProductList> body;

  factory CategoryProductModel.fromJson(Map<String, dynamic> json) =>
      CategoryProductModel(
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        count: json["count"] == null ? null : json["count"],
        first: json["first"] == null ? null : json["first"],
        body: json["body"] == null
            ? null
            : List<CategoryProductList>.from(
                json["body"].map((x) => CategoryProductList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "count": count == null ? null : count,
        "first": first == null ? null : first,
        "body": body == null
            ? null
            : List<dynamic>.from(body.map((x) => x.toJson())),
      };
}

class CategoryProductList {
  CategoryProductList({
    this.id,
    this.name,
    this.picture,
    this.childs,
    this.numOfProducts,
    this.classId,
  });

  String id;
  String name;
  Picture picture;
  List<CategoryProductList> childs;
  int numOfProducts;
  String classId;

  factory CategoryProductList.fromJson(Map<String, dynamic> json) =>
  CategoryProductList(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    picture: json["picture"] == null ? null : Picture.fromJson(json["picture"]),
    childs: json["childs"] == null ? null : List<CategoryProductList>.from(json["childs"].map((x) => CategoryProductList.fromJson(x))),
    numOfProducts: json["numOfProducts"] == null ? null : json["numOfProducts"],
    classId: json["classId"] == null ? null : json["classId"],
  );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "picture": picture == null ? null : picture.toJson(),
        "childs": childs == null
            ? null
            : List<dynamic>.from(childs.map((x) => x.toJson())),
        "numOfProducts": numOfProducts == null ? null : numOfProducts,
        "classId": classId == null ? null : classId,
      };
}

class PictureCategory {
  PictureCategory({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
  });

  String originalName;
  int fileLength;
  String path;
  String contentType;

  factory PictureCategory.fromJson(Map<String, dynamic> json) =>
    PictureCategory(
      originalName: json["originalName"] == null ? null : json["originalName"],
      fileLength: json["fileLength"] == null ? null : json["fileLength"],
      path: json["path"] == null ? null : json["path"],
      contentType: json["contentType"] == null ? null : json["contentType"],
    );

  Map<String, dynamic> toJson() => {
    "originalName": originalName == null ? null : originalName,
    "fileLength": fileLength == null ? null : fileLength,
    "path": path == null ? null : path,
    "contentType": contentType == null ? null : contentType,
  };
}
