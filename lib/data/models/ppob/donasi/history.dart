class BalanceHistoryDonationModel {
  BalanceHistoryDonationModel({
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
  List<BalanceHistoryDonationData> body;
  dynamic error;

  factory BalanceHistoryDonationModel.fromJson(Map<String, dynamic> json) => BalanceHistoryDonationModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<BalanceHistoryDonationData>.from(json["body"].map((x) => BalanceHistoryDonationData.fromJson(x))),
    error: json["error"],
  );
}

class BalanceHistoryDonationData {
  BalanceHistoryDonationData({
    this.id,
    this.userId,
    this.phoneNumber,
    this.name,
    this.amount,
    this.transactionId,
    this.classId,
  });

  int id;
  String userId;
  String phoneNumber;
  String name;
  double amount;
  String transactionId;
  String classId;

  factory BalanceHistoryDonationData.fromJson(Map<String, dynamic> json) => BalanceHistoryDonationData(
    id: json["id"] == null ? null : json["id"],
    userId: json["userId"] == null ? null : json["userId"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    name: json["name"] == null ? null : json["name"],
    amount: json["amount"] == null ? null : json["amount"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}
