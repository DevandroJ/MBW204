class ResponseSendMessageConversationModel {
  ResponseSendMessageConversationModel({
    this.code,
    this.message,
    this.body,
  });

  int code;
  String message;
  ResponseSendMessageConversationModelData body;

  factory ResponseSendMessageConversationModel.fromJson(Map<String, dynamic> json) => ResponseSendMessageConversationModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : ResponseSendMessageConversationModelData.fromJson(json["body"]),
  );
}

class ResponseSendMessageConversationModelData {
  ResponseSendMessageConversationModelData({
    this.conversationId,
    this.chatId,
    this.messageStatus,
    this.classId,
  });

  String conversationId;
  String chatId;
  String messageStatus;
  String classId;

  factory ResponseSendMessageConversationModelData.fromJson(Map<String, dynamic> json) => ResponseSendMessageConversationModelData(
    conversationId: json["conversationId"] == null ? null : json["conversationId"],
    chatId: json["chatId"] == null ? null : json["chatId"],
    messageStatus: json["messageStatus"] == null ? null : json["messageStatus"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}
