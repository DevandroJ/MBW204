class NinjaModel {
  NinjaModel({
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
  List<String> body;
  dynamic error;

  factory NinjaModel.fromJson(Map<String, dynamic> json) => NinjaModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<String>.from(json["body"].map((x) => x)),
    error: json["error"],
  );
}


