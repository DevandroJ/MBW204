class BannerModel {
  BannerModel({
    this.body,
    this.code,
    this.message,
  });

  List<BannerData> body;
  int code;
  String message;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    body: List<BannerData>.from(json["body"].map((x) => BannerData.fromJson(x))),
    code: json["code"],
    message: json["message"],
  );

}

class BannerData {
  BannerData({
    this.carouselId,
    this.name,
    this.placement,
    this.picture,
    this.linkUrl,
    this.status,
    this.createdBy,
    this.created,
    this.updated,
    this.media,
  });

  int carouselId;
  String name;
  int placement;
  int picture;
  String linkUrl;
  bool status;
  String createdBy;
  DateTime created;
  DateTime updated;
  List<Media> media;

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
    carouselId: json["carousel_id"],
    name: json["name"],
    placement: json["placement"],
    picture: json["picture"],
    linkUrl: json["link_url"],
    status: json["status"],
    createdBy: json["created_by"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
    media: List<Media>.from(json["Media"].map((x) => Media.fromJson(x))),
  );
}

class Media {
  Media({
    this.mediaId,
    this.status,
    this.contentType,
    this.fileLength,
    this.originalName,
    this.path,
    this.createdBy,
    this.created,
    this.updated,
  });

  int mediaId;
  String status;
  String contentType;
  int fileLength;
  String originalName;
  String path;
  String createdBy;
  DateTime created;
  DateTime updated;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    mediaId: json["media_id"],
    status: json["status"],
    contentType: json["content_type"],
    fileLength: json["file_length"],
    originalName: json["original_name"],
    path: json["path"],
    createdBy: json["created_by"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
  );
}
