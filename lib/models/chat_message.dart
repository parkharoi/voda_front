
class ChatMessage {
  final String text;
  final bool isUser; // true: 나(사용자), false: 윌로우(AI)
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}