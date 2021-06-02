import 'feedenumvalues.dart';

enum PostType { TEXT, DOCUMENT, LINK, IMAGE, VIDEO, STICKER }

final postTypeValues = EnumValues({
  "TEXT": PostType.TEXT,
  "LINK": PostType.LINK,
  "DOCUMENT": PostType.DOCUMENT,
  "IMAGE": PostType.IMAGE,
  "VIDEO": PostType.VIDEO,
  "STICKER": PostType.STICKER
});