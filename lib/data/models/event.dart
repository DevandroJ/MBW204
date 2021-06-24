// class EventModel {
//   EventModel({
//     this.body,
//     this.code,
//     this.message,
//   });

//   List<EventData> body;
//   int code;
//   String message;

//   factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
//     body: json["body"] == null ? null : List<EventData>.from(json["body"].map((x) => EventData.fromJson(x))),
//     code: json["code"] == null ? null : json["code"],
//     message: json["message"] == null ? null : json["message"],
//   );
// }

// class EventData {
//   EventData({
//     this.eventDate,
//     this.description,
//   });

//   DateTime eventDate;
//   List<String> description;

//   factory EventData.fromJson(Map<String, dynamic> json) => EventData(
//     eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
//     description: json["description"] == null ? null : List<String>.from(json["description"].map((x) => x)),
//   );
// }


// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

// class EventModel {
//   EventModel({
//     this.body,
//     this.code,
//     this.message,
//   });

//   List<EventData> body;
//   int code;
//   String message;

//   factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
//     body: json["body"] == null ? null : List<EventData>.from(json["body"].map((x) => EventData.fromJson(x))),
//     code: json["code"] == null ? null : json["code"],
//     message: json["message"] == null ? null : json["message"],
//   );
// }

// class EventData {
//   EventData({
//     this.eventId,
//     this.description,
//     this.eventDate,
//     this.status,
//     this.location,
//     this.start,
//     this.end,
//     this.summary,
//     this.picture,
//     this.createdBy,
//     this.created,
//     this.updated,
//     this.media,
//   });

//   int eventId;
//   String description;
//   DateTime eventDate;
//   bool status;
//   String location;
//   String start;
//   String end;
//   String summary;
//   int picture;
//   String createdBy;
//   DateTime created;
//   DateTime updated;
//   List<EventMedia> media;

//   factory EventData.fromJson(Map<String, dynamic> json) => EventData(
//     eventId: json["event_id"] == null ? null : json["event_id"],
//     description: json["description"] == null ? null : json["description"],
//     eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
//     status: json["status"] == null ? null : json["status"],
//     location: json["location"] == null ? null : json["location"],
//     start: json["start"] == null ? null : json["start"],
//     end: json["end"] == null ? null : json["end"],
//     summary: json["summary"] == null ? null : json["summary"],
//     picture: json["picture"] == null ? null : json["picture"],
//     createdBy: json["created_by"] == null ? null : json["created_by"],
//     created: json["created"] == null ? null : DateTime.parse(json["created"]),
//     updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
//     media: json["Media"] == null ? null : List<EventMedia>.from(json["Media"].map((x) => EventMedia.fromJson(x))),
//   );   
// }

// class EventMedia {
//   EventMedia({
//     this.mediaId,
//     this.status,
//     this.contentType,
//     this.fileLength,
//     this.originalName,
//     this.path,
//     this.createdBy,
//     this.created,
//     this.updated,
//   });

//   int mediaId;
//   String status;
//   String contentType;
//   int fileLength;
//   String originalName;
//   String path;
//   String createdBy;
//   DateTime created;
//   DateTime updated;

//   factory EventMedia.fromJson(Map<String, dynamic> json) => EventMedia(
//     mediaId: json["media_id"] == null ? null : json["media_id"],
//     status: json["status"] == null ? null : json["status"],
//     contentType: json["content_type"] == null ? null : json["content_type"],
//     fileLength: json["file_length"] == null ? null : json["file_length"],
//     originalName: json["original_name"] == null ? null : json["original_name"],
//     path: json["path"] == null ? null : json["path"],
//     createdBy: json["created_by"] == null ? null : json["created_by"],
//     created: json["created"] == null ? null : DateTime.parse(json["created"]),
//     updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
//   );
// }

// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

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
  bool status;
  String location;
  String start;
  String end;
  String summary;
  String path;
  bool userJoined;

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    eventId: json["event_id"] == null ? null : json["event_id"],
    description: json["description"] == null ? null : json["description"],
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    status: json["status"] == null ? null : json["status"],
    location: json["location"] == null ? null : json["location"],
    start: json["start"] == null ? null : json["start"],
    end: json["end"] == null ? null : json["end"],
    summary: json["summary"] == null ? null : json["summary"],
    path: json["path"] == null ? null : json["path"],
    userJoined: json["user_joined"] == null ? null : json["user_joined"],
  );
}
