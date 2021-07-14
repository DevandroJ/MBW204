class BankPaymentStore {
  BankPaymentStore({
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
  List<Body> body;
  dynamic error;

  factory BankPaymentStore.fromJson(Map<String, dynamic> json) => BankPaymentStore(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<Body>.from(json["body"].map((x) => Body.fromJson(x))),
    error: json["error"],
  );
}

class Body {
  Body({
    this.channel,
    this.name,
    this.guide,
    this.paymentFee,
    this.logo,
  });

  String channel;
  String name;
  String guide;
  double paymentFee;
  String logo;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    channel: json["channel"] == null ? null : json["channel"],
    name: json["name"] == null ? null : json["name"],
    guide: json["guide"] == null ? null : json["guide"],
    paymentFee: json["paymentFee"] == null ? null : json["paymentFee"],
    logo: json["logo"] == null ? null : json["logo"],
  );
}
