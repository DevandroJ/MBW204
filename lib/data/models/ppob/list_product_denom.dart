class ListProductDenomModel {
  ListProductDenomModel({
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
  List<ListProductDenomData> body;
  dynamic error;

  factory ListProductDenomModel.fromJson(Map<String, dynamic> json) => ListProductDenomModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<ListProductDenomData>.from(json["body"].map((x) => ListProductDenomData.fromJson(x))),
    error: json["error"],
  );
}

class ListProductDenomData {
  ListProductDenomData({
    this.productId,
    this.name,
    this.description,
    this.price,
    this.type,
    this.group,
    this.category,
    this.adminFee,
    this.classId,
  });

  String productId;
  String name;
  String description;
  double price;
  String type;
  String group;
  String category;
  double adminFee;
  String classId;

  factory ListProductDenomData.fromJson(Map<String, dynamic> json) => ListProductDenomData(
    productId: json["productId"] == null ? null : json["productId"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    price: json["price"] == null ? null : json["price"],
    type: json["type"] == null ? null : json["type"],
    group: json["group"] == null ? null : json["group"],
    category: json["category"] == null ? null : json["category"],
    adminFee: json["adminFee"] == null ? null : json["adminFee"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}
