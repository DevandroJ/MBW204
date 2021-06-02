class HistoryBalanceModel {
  HistoryBalanceModel({
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
  List<HistoryBalanceData> body;
  dynamic error;

  factory HistoryBalanceModel.fromJson(Map<String, dynamic> json) => HistoryBalanceModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<HistoryBalanceData>.from(json["body"].map((x) => HistoryBalanceData.fromJson(x))),
    error: json["error"],
  );
}

class HistoryBalanceData {
  HistoryBalanceData({
    this.id,
    this.created,
    this.refId,
    this.type,
    this.preBalance,
    this.postBalance,
    this.amount,
    this.currency,
    this.description,
    this.appId,
    this.merchant,
  });

  String id;
  String created;
  String refId;
  String type;
  double preBalance;
  double postBalance;
  double amount;
  String currency;
  String description;
  String appId;
  String merchant;

  factory HistoryBalanceData.fromJson(Map<String, dynamic> json) => HistoryBalanceData(
    id: json["id"] == null ? null : json["id"],
    created: json["created"] == null ? null : json["created"],
    refId: json["refId"] == null ? null : json["refId"],
    type: json["type"] == null ? null : json["type"],
    preBalance: json["preBalance"] == null ? null : json["preBalance"],
    postBalance: json["postBalance"] == null ? null : json["postBalance"],
    amount: json["amount"] == null ? null : json["amount"],
    currency: json["currency"] == null ? null : json["currency"],
    description: json["description"] == null ? null : json["description"],
    appId: json["appId"] == null ? null : json["appId"],
    merchant: json["merchant"] == null ? null : json["merchant"],
  );
}