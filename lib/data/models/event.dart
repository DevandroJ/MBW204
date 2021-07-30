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
    this.eventId,
    this.description,
    this.eventDate,
    this.eventEndDate,
    this.arrayEventDate,
    this.status,
    this.location,
    this.start,
    this.end,
    this.summary,
    this.path,
    this.userJoined,
  });

  int eventId;
  String description;
  DateTime eventDate;
  DateTime eventEndDate;
  List<DateTime> arrayEventDate;
  bool status;
  String location;
  String start;
  String end;
  String summary;
  String path;
  bool userJoined;
  bool paid;

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    eventId: json["event_id"] == null ? null : json["event_id"],
    description: json["description"] == null ? null : json["description"],
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    eventEndDate: json["event_end_date"] == null ? null : DateTime.parse(json["event_end_date"]),
    arrayEventDate: List<DateTime>.from(json["array_date"].map((x) => DateTime.parse(x))),
    status: json["status"] == null ? null : json["status"],
    location: json["location"] == null ? null : json["location"],
    start: json["start"] == null ? null : json["start"],
    end: json["end"] == null ? null : json["end"],
    summary: json["summary"] == null ? null : json["summary"],
    path: json["path"] == null ? null : json["path"],
    userJoined: json["user_joined"] == null ? null : json["user_joined"],
  );
}
