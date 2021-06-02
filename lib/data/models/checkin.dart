class CheckInModel {
  CheckInModel({
    this.body,
    this.code,
    this.message,
  });

  List<CheckInData> body;
  int code;
  String message;

  factory CheckInModel.fromJson(Map<String, dynamic> json) => CheckInModel(
    body: List<CheckInData>.from(json["body"].map((x) => CheckInData.fromJson(x))),
    code: json["code"],
    message: json["message"],
  );

}

class CheckInData {
  CheckInData({
    this.checkinId,
    this.fullname,
    this.caption,
    this.placeName,
    this.date,
    this.start,
    this.end,
    this.lat,
    this.long,
    this.userId
  });

  int checkinId;
  String fullname;
  String caption;
  String placeName;
  DateTime date;
  String start;
  String end;
  String lat;
  String long;
  String userId;

  factory CheckInData.fromJson(Map<String, dynamic> json) => CheckInData(
    checkinId: json["checkin_id"],
    fullname: json["fullname"],
    caption: json["caption"],
    placeName: json["place_name"],
    date: DateTime.parse(json["date"]),
    start: json["start"],
    end: json["end"],
    lat: json["lat"],
    long: json["long"],
    userId: json["user_id"]
  );
}