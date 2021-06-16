class ChatMessage {
  final String text;
  final bool isSender;

  ChatMessage({
    this.text = '',
    this.isSender,
  });
}

List<ChatMessage> demoChatMessages = [
  ChatMessage(
    text: "Hi John doe",
    isSender: false,
  ),
  ChatMessage(
    text: "Hello, How are you?",
    isSender: true,
  ),
];