class BalanceDonationModel {
  BalanceDonationModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  BalanceDonationData body;
  dynamic error;

  factory BalanceDonationModel.fromJson(Map<String, dynamic> json) => BalanceDonationModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : BalanceDonationData.fromJson(json["body"]),
    error: json["error"],
  );
}

class BalanceDonationData {
  BalanceDonationData({
    this.total,
    this.lastDonation,
    this.classId,
  });

  double total;
  String lastDonation;
  String classId;

  factory BalanceDonationData.fromJson(Map<String, dynamic> json) => BalanceDonationData(
    total: json["total"] == null ? null : json["total"],
    lastDonation: json["lastDonation"] == null ? null : json["lastDonation"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}
