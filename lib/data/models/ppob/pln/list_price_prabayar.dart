class ListPricePraBayarModel {
  ListPricePraBayarModel({
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
  List<ListPricePraBayarData> body;
  dynamic error;

  factory ListPricePraBayarModel.fromJson(Map<String, dynamic> json) => ListPricePraBayarModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<ListPricePraBayarData>.from(json["body"].map((x) => ListPricePraBayarData.fromJson(x))),
    error: json["error"],
  );
}

class ListPricePraBayarData {
  ListPricePraBayarData({
    this.productId,
    this.name,
    this.description,
    this.price,
    this.type,
    this.group,
    this.category,
    this.totalAdminFee,
    this.classId,
  });

  String productId;
  String name;
  String description;
  double price;
  String type;
  String group;
  String category;
  double totalAdminFee;
  String classId;

  factory ListPricePraBayarData.fromJson(Map<String, dynamic> json) => ListPricePraBayarData(
    productId: json["productId"] == null ? null : json["productId"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    price: json["price"] == null ? null : json["price"],
    type: json["type"] == null ? null : json["type"],
    group: json["group"] == null ? null : json["group"],
    category: json["category"] == null ? null : json["category"],
    totalAdminFee: json["totalAdminFee"] == null ? null : json["totalAdminFee"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}
