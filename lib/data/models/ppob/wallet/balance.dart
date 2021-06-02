class BalanceModel {
  BalanceModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  BalanceBody body;
  dynamic error;

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : BalanceBody.fromJson(json["body"]),
    error: json["error"],
  );
}

class BalanceBody {
  BalanceBody({
    this.id,
    this.accountId,
    this.balance,
    this.currency,
  });

  String id;
  String accountId;
  double balance;
  String currency;

  factory BalanceBody.fromJson(Map<String, dynamic> json) => BalanceBody(
    id: json["id"] == null ? null : json["id"],
    accountId: json["accountId"] == null ? null : json["accountId"],
    balance: json["balance"] == null ? null : json["balance"],
    currency: json["currency"] == null ? null : json["currency"],
  );
}
