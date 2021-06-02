import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  List<Category> data;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    this.id,
    this.categoryName,
    this.categoryDescription,
    this.categoryImage,
    this.categoryAction,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String categoryName;
  String categoryDescription;
  String categoryImage;
  String categoryAction;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] == null ? null : json["id"],
    categoryName: json["category_name"] == null ? null : json["category_name"],
    categoryDescription: json["category_description"] == null ? null : json["category_description"],
    categoryImage: json["category_image"] == null ? null : json["category_image"],
    categoryAction: json["category_action"] == null ? null : json["category_action"],
    isActive: json["is_active"] == null ? null : json["is_active"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "category_name": categoryName == null ? null : categoryName,
    "category_description": categoryDescription == null ? null : categoryDescription,
    "category_image": categoryImage == null ? null : categoryImage,
    "category_action": categoryAction == null ? null : categoryAction,
    "is_active": isActive == null ? null : isActive,
    "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
    "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
