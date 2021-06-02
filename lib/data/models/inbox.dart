class InboxModel {
  InboxModel({
    this.body,
    this.code,
    this.message,
  });

  List<InboxModelData> body;
  int code;
  String message;

  factory InboxModel.fromJson(Map<String, dynamic> json) => InboxModel(
    body: json["body"] == null ? null : List<InboxModelData>.from(json["body"].map((x) => InboxModelData.fromJson(x))),
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
  );
}

class InboxModelData {
  InboxModelData({
    this.inboxId,
    this.recepientId,
    this.senderId,
    this.subject,
    this.body,
    this.type,
    this.field1,
    this.field2,
    this.field3,
    this.field4,
    this.field5,
    this.field6,
    this.field7,
    this.read,
    this.created,
    this.updated,
  });

  String inboxId;
  String recepientId;
  String senderId;
  String subject;
  String body;
  String type;
  String field1;
  String field2;
  String field3;
  String field4;
  String field5;
  String field6;
  String field7;
  bool read;
  DateTime created;
  DateTime updated;

  factory InboxModelData.fromJson(Map<String, dynamic> json) => InboxModelData(
    inboxId: json["inboxId"] == null ? null : json["inboxId"],
    recepientId: json["recepientId"] == null ? null : json["recepientId"],
    senderId: json["senderId"] == null ? null : json["senderId"],
    subject: json["subject"] == null ? null : json["subject"],
    body: json["body"] == null ? null : json["body"],
    type: json["type"] == null ? null : json["type"],
    field1: json["field1"] == null ? null : json["field1"],
    field2: json["field2"] == null ? null : json["field2"],
    field3: json["field3"] == null ? null : json["field3"],
    field4: json["field4"] == null ? null : json["field4"],
    field5: json["field5"] == null ? null : json["field5"],
    field6: json["field6"] == null ? null : json["field6"],
    field7: json["field7"] == null ? null : json["field7"],
    read: json["read"] == null ? null : json["read"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
  );
}
