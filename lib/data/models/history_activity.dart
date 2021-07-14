class HistoryActivityModel {
  HistoryActivityModel({
    this.body,
    this.code,
    this.message,
  });

  List<HistoryActivityData> body;
  int code;
  String message;

  factory HistoryActivityModel.fromJson(Map<String, dynamic> json) => HistoryActivityModel(
    body: json["body"] == null ? null : List<HistoryActivityData>.from(json["body"].map((x) => HistoryActivityData.fromJson(x))),
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
  );
}

class HistoryActivityData {
  HistoryActivityData({
    this.historyActivityId,
    this.userId,
    this.description,
    this.created,
    this.updated,
  });

  int historyActivityId;
  String userId;
  String description;
  DateTime created;
  DateTime updated;

  factory HistoryActivityData.fromJson(Map<String, dynamic> json) => HistoryActivityData(
    historyActivityId: json["history_activity_id"] == null ? null : json["history_activity_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    description: json["description"] == null ? null : json["description"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
  );
}
