import 'dart:convert';

import './category_model.dart';
import './seller_store_model.dart';

class ProductWarungModel {
  ProductWarungModel({
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
  List<ProductWarungList> body;

  factory ProductWarungModel.fromJson(Map<String, dynamic> json) =>
    ProductWarungModel(
      code: json["code"] == null ? null : json["code"],
      message: json["message"] == null ? null : json["message"],
      count: json["count"] == null ? null : json["count"],
      first: json["first"] == null ? null : json["first"],
      body: json["body"] == null ? null : List<ProductWarungList>.from(json["body"].map((x) => ProductWarungList.fromJson(x))),
    );

}

class ProductWarungList {
  ProductWarungList({
    this.id,
    this.name,
    this.images,
    this.category,
    this.price,
    this.adminCharge,
    this.pictures,
    this.owner,
    this.store,
    this.weight,
    this.description,
    this.stock,
    this.condition,
    this.minOrder,
    this.status,
    this.stats,
    this.discount,
    this.favored,
    this.classId,
  });

  String id;
  String name;
  String images;
  Category category;
  double price;
  double adminCharge;
  List<PictureProductWarung> pictures;
  String owner;
  Store store;
  int weight;
  String description;
  int stock;
  String condition;
  int minOrder;
  int status;
  Stats stats;
  Discount discount;
  bool favored;
  String classId;

  factory ProductWarungList.fromJson(Map<String, dynamic> json) =>
      ProductWarungList(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        price: json["price"] == null ? null : json["price"],
        adminCharge: json["adminCharge"] == null ? null : json["adminCharge"],
        pictures: json["pictures"] == null ? null : List<PictureProductWarung>.from(
          json["pictures"].map((x) => PictureProductWarung.fromJson(x))
        ),
        owner: json["owner"] == null ? null : json["owner"],
        store: json["store"] == null ? null : Store.fromJson(json["store"]),
        weight: json["weight"] == null ? null : json["weight"],
        description: json["description"] == null ? null : json["description"],
        stock: json["stock"] == null ? null : json["stock"],
        condition: json["condition"] == null ? null : json["condition"],
        minOrder: json["minOrder"] == null ? null : json["minOrder"],
        status: json["status"] == null ? null : json["status"],
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        discount: json["discount"] == null
            ? null
            : Discount.fromJson(json["discount"]),
        favored: false,
        classId: json["classId"] == null ? null : json["classId"],
      );


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['images'] = images;
    map['price'] = price;
    map['favored'] = favored;
    return map;
  }

  ProductWarungList.fromDb(Map map)
      : id = map['id'],
        name = map["name"],
        description = map['description'],
        images = map["images"],
        price = map["price"],
        favored = map["favored"] == 1 ? true : false;
}

class CategoryProductWarung {
  CategoryProductWarung({
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
  List<dynamic> childs;
  int numOfProducts;
  String classId;

  factory CategoryProductWarung.fromJson(Map<String, dynamic> json) =>
  CategoryProductWarung(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    picture: json["picture"] == null ? null : Picture.fromJson(json["picture"]),
    childs: json["childs"] == null ? null : List<dynamic>.from(json["childs"].map((x) => x)),
    numOfProducts: json["numOfProducts"] == null ? null : json["numOfProducts"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class PictureProductWarung {
  PictureProductWarung({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
  });

  String originalName;
  int fileLength;
  String path;
  String contentType;

  factory PictureProductWarung.fromJson(Map<String, dynamic> json) =>
      PictureProductWarung(
        originalName:
            json["originalName"] == null ? null : json["originalName"],
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

class Discount {
  Discount({
    this.discount,
    this.startDate,
    this.endDate,
    this.active,
  });

  double discount;
  String startDate;
  String endDate;
  bool active;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        discount: json["discount"] == null ? null : json["discount"],
        startDate: json["startDate"] == null ? null : json["startDate"],
        endDate: json["endDate"] == null ? null : json["endDate"],
        active: json["active"] == null ? null : json["active"],
      );

  Map<String, dynamic> toJson() => {
        "discount": discount == null ? null : discount,
        "startDate": startDate == null ? null : startDate,
        "endDate": endDate == null ? null : endDate,
        "active": active == null ? null : active,
      };
}

class Stats {
  Stats({
    this.ratingMax,
    this.ratingAvg,
    this.numOfReview,
    this.numOfSold,
    this.ratings,
  });

  double ratingMax;
  double ratingAvg;
  int numOfReview;
  int numOfSold;
  List<Rating> ratings;

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        ratingMax: json["ratingMax"] == null ? null : json["ratingMax"],
        ratingAvg:
            json["ratingAvg"] == null ? null : json["ratingAvg"].toDouble(),
        numOfReview: json["numOfReview"] == null ? null : json["numOfReview"],
        numOfSold: json["numOfSold"] == null ? null : json["numOfSold"],
        ratings: json["ratings"] == null
            ? null
            : List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ratingMax": ratingMax == null ? null : ratingMax,
        "ratingAvg": ratingAvg == null ? null : ratingAvg,
        "numOfReview": numOfReview == null ? null : numOfReview,
        "numOfSold": numOfSold == null ? null : numOfSold,
        "ratings": ratings == null
            ? null
            : List<dynamic>.from(ratings.map((x) => x.toJson())),
      };
}

class Rating {
  Rating({
    this.star,
    this.count,
  });

  double star;
  var count;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        star: json["star"] == null ? null : json["star"],
        count: json["count"] == null ? null : json["count"],
      );

  Map<String, dynamic> toJson() => {
        "star": star == null ? null : star,
        "count": count == null ? null : count,
      };
}

class Store {
  Store({
    this.id,
    this.owner,
    this.name,
    this.description,
    this.open,
    this.picture,
    this.status,
    this.province,
    this.city,
    this.postalCode,
    this.address,
    this.location,
    this.supportedCouriers,
    this.classId,
  });

  String id;
  String owner;
  String name;
  String description;
  bool open;
  Picture picture;
  int status;
  String province;
  String city;
  String postalCode;
  String address;
  List<double> location;
  List<SupportedCourier> supportedCouriers;
  String classId;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json["id"] == null ? null : json["id"],
    owner: json["owner"] == null ? null : json["owner"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    open: json["open"] == null ? null : json["open"],
    picture: json["picture"] == null ? null : Picture.fromJson(json["picture"]),
    status: json["status"] == null ? null : json["status"],
    province: json["province"] == null ? null : json["province"],
    city: json["city"] == null ? null : json["city"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    address: json["address"] == null ? null : json["address"],
    location: json["location"] == null ? null : List<double>.from(json["location"].map((x) => x.toDouble())),
    supportedCouriers: json["supportedCouriers"] == null ? null : List<SupportedCourier>.from(json["supportedCouriers"].map((x) => SupportedCourier.fromJson(x))),
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class SupportedCourierProduct {
  SupportedCourierProduct({
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

  factory SupportedCourierProduct.fromJson(Map<String, dynamic> json) =>
      SupportedCourierProduct(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
        checkPriceSupported: json["checkPriceSupported"] == null ? null: json["checkPriceSupported"],
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
