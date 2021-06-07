class ChatMessage {
  final String text;
  final bool isSender;

  ChatMessage({
    this.text = '',
    this.isSender,
  });
}

List demoChatMessages = [
  ChatMessage(
    text: "Hi Sajol,",
    isSender: false,
  ),
  ChatMessage(
    text: "Hello, How are you?",
    isSender: true,
  ),
  ChatMessage(
    text: "Im Fine, Thankyou",
    isSender: false,
  ),
  ChatMessage(
    text: "What happened",
    isSender: true,
  ),
  ChatMessage(
    text: "Error happend",
    isSender: true,
  ),
  ChatMessage(
    text: "This looks great man!!",
    isSender: false,
  ),
  ChatMessage(
    text: "Glad you like it",
    isSender: true,
  ),
];