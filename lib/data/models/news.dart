class NewsModel {
  NewsModel({
    this.body,
    this.code,
    this.message,
  });

  List<NewsBody> body;
  int code;
  String message;

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
    body: json["body"] == null ? null : List<NewsBody>.from(json["body"].map((x) => NewsBody.fromJson(x))),
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
  );
}

class NewsBody {
  NewsBody({
    this.articleId,
    this.content,
    this.highlight,
    this.title,
    this.type,
    this.picture,
    this.status,
    this.createdBy,
    this.created,
    this.updated,
    this.media,
  });

  int articleId;
  String content;
  int highlight;
  String title;
  String type;
  int picture;
  bool status;
  String createdBy;
  DateTime created;
  DateTime updated;
  List<Media> media;

  factory NewsBody.fromJson(Map<String, dynamic> json) => NewsBody(
    articleId: json["article_id"] == null ? null : json["article_id"],
    content: json["content"] == null ? null : json["content"],
    highlight: json["highlight"] == null ? null : json["highlight"],
    title: json["title"] == null ? null : json["title"],
    type: json["type"] == null ? null : json["type"],
    picture: json["picture"] == null ? null : json["picture"],
    status: json["status"] == null ? null : json["status"],
    createdBy: json["created_by"] == null ? null : json["created_by"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
    media: json["Media"] == null ? null : List<Media>.from(json["Media"].map((x) => Media.fromJson(x))),
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
    mediaId: json["media_id"] == null ? null : json["media_id"],
    status: json["status"] == null ? null : json["status"],
    contentType: json["content_type"] == null ? null : json["content_type"],
    fileLength: json["file_length"] == null ? null : json["file_length"],
    originalName: json["original_name"] == null ? null : json["original_name"],
    path: json["path"] == null ? null : json["path"],
    createdBy: json["created_by"] == null ? null : json["created_by"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
  );
}
