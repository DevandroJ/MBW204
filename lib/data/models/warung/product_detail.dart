// To parse this JSON data, do
//
//     final productDetailModel = productDetailModelFromJson(jsonString);

import 'dart:convert';

ProductDetailModel productDetailModelFromJson(String str) => ProductDetailModel.fromJson(json.decode(str));

String productDetailModelToJson(ProductDetailModel data) => json.encode(data.toJson());

class ProductDetailModel {
    ProductDetailModel({
        this.status,
        this.message,
        this.data,
    });

    int status;
    String message;
    List<ProductDetail> data;

    factory ProductDetailModel.fromJson(Map<String, dynamic> json) => ProductDetailModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : List<ProductDetail>.from(json["data"].map((x) => ProductDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ProductDetail {
    ProductDetail({
        this.id,
        this.productName,
        this.productDescription,
        this.productCondition,
        this.latitude,
        this.longitude,
        this.location,
        this.productImage,
        this.productPrice,
        this.isActive,
        this.isSold,
        this.userId,
        this.categoryId,
        this.isHighlight,
        this.createdAt,
        this.updatedAt,
        this.user,
    });

    String id;
    String productName;
    String productDescription;
    bool productCondition;
    String latitude;
    String longitude;
    String location;
    String productImage;
    int productPrice;
    bool isActive;
    bool isSold;
    String userId;
    String categoryId;
    bool isHighlight;
    DateTime createdAt;
    DateTime updatedAt;
    User user;

    factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        id: json["id"] == null ? null : json["id"],
        productName: json["product_name"] == null ? null : json["product_name"],
        productDescription: json["product_description"] == null ? null : json["product_description"],
        productCondition: json["product_condition"] == null ? null : json["product_condition"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        location: json["location"] == null ? null : json["location"],
        productImage: json["product_image"] == null ? null : json["product_image"],
        productPrice: json["product_price"] == null ? null : json["product_price"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        isSold: json["is_sold"] == null ? null : json["is_sold"],
        userId: json["user_id"] == null ? null : json["user_id"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        isHighlight: json["is_highlight"] == null ? null : json["is_highlight"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "product_name": productName == null ? null : productName,
        "product_description": productDescription == null ? null : productDescription,
        "product_condition": productCondition == null ? null : productCondition,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "location": location == null ? null : location,
        "product_image": productImage == null ? null : productImage,
        "product_price": productPrice == null ? null : productPrice,
        "is_active": isActive == null ? null : isActive,
        "is_sold": isSold == null ? null : isSold,
        "user_id": userId == null ? null : userId,
        "category_id": categoryId == null ? null : categoryId,
        "is_highlight": isHighlight == null ? null : isHighlight,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "user": user == null ? null : user.toJson(),
    };
}

class User {
    User({
        this.uid,
        this.fullName,
        this.username,
        this.nra,
        this.ynci,
        this.alamat,
        this.noKtp,
        this.noSim,
        this.closestName,
        this.closestNo,
        this.golDarah,
        this.shortBio,
        this.avatarUrl,
        this.email,
        this.authKey,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.links,
    });

    String uid;
    String fullName;
    String username;
    String nra;
    String ynci;
    String alamat;
    String noKtp;
    String noSim;
    String closestName;
    String closestNo;
    String golDarah;
    String shortBio;
    String avatarUrl;
    String email;
    String authKey;
    int status;
    DateTime createdAt;
    DateTime updatedAt;
    Links links;

    factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"] == null ? null : json["uid"],
        fullName: json["full_name"] == null ? null : json["full_name"],
        username: json["username"] == null ? null : json["username"],
        nra: json["nra"] == null ? null : json["nra"],
        ynci: json["ynci"] == null ? null : json["ynci"],
        alamat: json["alamat"] == null ? null : json["alamat"],
        noKtp: json["no_ktp"] == null ? null : json["no_ktp"],
        noSim: json["no_sim"] == null ? null : json["no_sim"],
        closestName: json["closest_name"] == null ? null : json["closest_name"],
        closestNo: json["closest_no"] == null ? null : json["closest_no"],
        golDarah: json["gol_darah"] == null ? null : json["gol_darah"],
        shortBio: json["short_bio"] == null ? null : json["short_bio"],
        avatarUrl: json["avatar_url"] == null ? null : json["avatar_url"],
        email: json["email"] == null ? null : json["email"],
        authKey: json["auth_key"] == null ? null : json["auth_key"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "uid": uid == null ? null : uid,
        "full_name": fullName == null ? null : fullName,
        "username": username == null ? null : username,
        "nra": nra == null ? null : nra,
        "ynci": ynci == null ? null : ynci,
        "alamat": alamat == null ? null : alamat,
        "no_ktp": noKtp == null ? null : noKtp,
        "no_sim": noSim == null ? null : noSim,
        "closest_name": closestName == null ? null : closestName,
        "closest_no": closestNo == null ? null : closestNo,
        "gol_darah": golDarah == null ? null : golDarah,
        "short_bio": shortBio == null ? null : shortBio,
        "avatar_url": avatarUrl == null ? null : avatarUrl,
        "email": email == null ? null : email,
        "auth_key": authKey == null ? null : authKey,
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "links": links == null ? null : links.toJson(),
    };
}

class Links {
    Links({
        this.self,
    });

    String self;

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: json["self"] == null ? null : json["self"],
    );

    Map<String, dynamic> toJson() => {
        "self": self == null ? null : self,
    };
}
