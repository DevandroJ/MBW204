class EventModel {
  EventModel({
    this.body,
    this.code,
    this.message,
  });

  List<EventData> body;
  int code;
  String message;

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    body: json["body"] == null ? null : List<EventData>.from(json["body"].map((x) => EventData.fromJson(x))),
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
  );
}

class EventData {
  EventData({
    this.eventDate,
    this.description,
  });

  DateTime eventDate;
  List<String> description;

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    description: json["description"] == null ? null : List<String>.from(json["description"].map((x) => x)),
  );
}
