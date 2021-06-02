// To parse this JSON data, do
//
//     final productByCategoryModel = productByCategoryModelFromJson(jsonString);

import 'dart:convert';
import './links.dart';

ProductByCategoryModel productByCategoryModelFromJson(String str) => ProductByCategoryModel.fromJson(json.decode(str));

String productByCategoryModelToJson(ProductByCategoryModel data) => json.encode(data.toJson());

class ProductByCategoryModel {
    ProductByCategoryModel({
        this.data,
    });

    List<Datum> data;

    factory ProductByCategoryModel.fromJson(Map<String, dynamic> json) => ProductByCategoryModel(
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.category,
        this.productId,
        this.categoryId,
        this.price,
        this.basePrice,
        this.sku,
        this.name,
        this.description,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.links,
    });

    Category category;
    String productId;
    String categoryId;
    int price;
    int basePrice;
    String sku;
    String name;
    String description;
    String status;
    DateTime createdAt;
    DateTime updatedAt;
    Links links;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        productId: json["product_id"] == null ? null : json["product_id"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        price: json["price"] == null ? null : json["price"],
        basePrice: json["base_price"] == null ? null : json["base_price"],
        sku: json["sku"] == null ? null : json["sku"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "category": category == null ? null : category.toJson(),
        "product_id": productId == null ? null : productId,
        "category_id": categoryId == null ? null : categoryId,
        "price": price == null ? null : price,
        "base_price": basePrice == null ? null : basePrice,
        "sku": sku == null ? null : sku,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "links": links == null ? null : links.toJson(),
    };
}

class Category {
    Category({
        this.id,
        this.name,
        this.categoryImage,
        this.descriptions,
    });

    String id;
    String name;
    String categoryImage;
    String descriptions;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        categoryImage: json["category_image"] == null ? null : json["category_image"],
        descriptions: json["descriptions"] == null ? null : json["descriptions"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "category_image": categoryImage == null ? null : categoryImage,
        "descriptions": descriptions == null ? null : descriptions,
    };
}
