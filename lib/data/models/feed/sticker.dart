class Sticker {
  Sticker({
    this.code,
    this.message,
    this.count,
    this.hasNext,
    this.first,
    this.body,
  });

  int code;
  String message;
  int count;
  bool hasNext;
  bool first;
  List<StickerBody> body;

  factory Sticker.fromJson(Map<String, dynamic> json) => Sticker(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    hasNext: json["hasNext"],
    first: json["first"],
    body: List<StickerBody>.from(json["body"].map((x) => StickerBody.fromJson(x))),
  );
}

class StickerBody {
  StickerBody({
    this.group,
    this.count,
    this.stickers,
    this.classId,
  });

  String group;
  int count;
  List<StickerElement> stickers;
  String classId;

  factory StickerBody.fromJson(Map<String, dynamic> json) => StickerBody(
    group: json["group"],
    count: json["count"],
    stickers: List<StickerElement>.from(json["stickers"].map((x) => StickerElement.fromJson(x))),
    classId: json["classId"],
  );
}

class StickerElement {
  StickerElement({
    this.name,
    this.url,
    this.ext,
    this.classId,
  });

  String name;
  String url;
  Ext ext;
  ClassId classId;

  factory StickerElement.fromJson(Map<String, dynamic> json) => StickerElement(
    name: json["name"],
    url: json["url"],
    ext: extValues.map[json["ext"]],
    classId: classIdValues.map[json["classId"]],
  );
}

enum ClassId { OSTICKER }

final classIdValues = EnumValues({
  "osticker": ClassId.OSTICKER
});

enum Ext { WEBP, PNG }

final extValues = EnumValues({
  "png": Ext.PNG,
  "webp": Ext.WEBP
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
        reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
