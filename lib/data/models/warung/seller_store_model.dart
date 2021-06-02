import 'dart:convert';

SellerStoreModel sellerStoreModelFromJson(String str) => SellerStoreModel.fromJson(json.decode(str));

String sellerStoreModelToJson(SellerStoreModel data) => json.encode(data.toJson());

class SellerStoreModel {
  SellerStoreModel({
    this.code,
    this.message,
    this.body,
  });

  int code;
  String message;
  ResultSingleStore body;

  factory SellerStoreModel.fromJson(Map<String, dynamic> json) =>
      SellerStoreModel(
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        body: json["body"] == null
            ? null
            : ResultSingleStore.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "body": body == null ? null : body.toJson(),
      };
}

class ResultSingleStore {
  ResultSingleStore({
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

  factory ResultSingleStore.fromJson(Map<String, dynamic> json) =>
      ResultSingleStore(
        id: json["id"] == null ? null : json["id"],
        owner: json["owner"] == null ? null : json["owner"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        open: json["open"] == null ? null : json["open"],
        picture:
            json["picture"] == null ? null : Picture.fromJson(json["picture"]),
        status: json["status"] == null ? null : json["status"],
        province: json["province"] == null ? null : json["province"],
        city: json["city"] == null ? null : json["city"],
        postalCode: json["postalCode"] == null ? null : json["postalCode"],
        address: json["address"] == null ? null : json["address"],
        location: json["location"] == null
            ? null
            : List<double>.from(json["location"].map((x) => x)),
        supportedCouriers: json["supportedCouriers"] == null
            ? null
            : List<SupportedCourier>.from(json["supportedCouriers"]
                .map((x) => SupportedCourier.fromJson(x))),
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "owner": owner == null ? null : owner,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "open": open == null ? null : open,
        "picture": picture == null ? null : picture.toJson(),
        "status": status == null ? null : status,
        "province": province == null ? null : province,
        "city": city == null ? null : city,
        "postalCode": postalCode == null ? null : postalCode,
        "address": address == null ? null : address,
        "location": location == null
            ? null
            : List<dynamic>.from(location.map((x) => x)),
        "supportedCouriers": supportedCouriers == null
            ? null
            : List<dynamic>.from(supportedCouriers.map((x) => x.toJson())),
        "classId": classId == null ? null : classId,
      };
}

class Picture {
  Picture({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
  });

  String originalName;
  int fileLength;
  String path;
  String contentType;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
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

class SupportedCourier {
  SupportedCourier({
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

  factory SupportedCourier.fromJson(Map<String, dynamic> json) =>
      SupportedCourier(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
        checkPriceSupported: json["checkPriceSupported"] == null
            ? null
            : json["checkPriceSupported"],
        checkResiSupported: json["checkResiSupported"] == null
            ? null
            : json["checkResiSupported"],
        classId: json["classId"] == null ? null : json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
        "checkPriceSupported":
            checkPriceSupported == null ? null : checkPriceSupported,
        "checkResiSupported":
            checkResiSupported == null ? null : checkResiSupported,
        "classId": classId == null ? null : classId,
      };
}
