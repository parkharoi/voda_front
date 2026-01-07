import 'package:flutter/material.dart';
import 'package:voda_front/models/chat_message.dart';
import 'package:voda_front/repositories/chat_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _repository = ChatRepository();

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isSummarizing = false;
  static const int minMessageCountForSummary = 5;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSummarizing => _isSummarizing;
  bool get canSummarize => _messages.length >= minMessageCountForSummary;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    _isLoading = true;
    notifyListeners();

    final aiReply = await _repository.sendMessage(text);

    if (aiReply != null) {
      _messages.add(ChatMessage(
        text: aiReply,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } else {
      _messages.add(ChatMessage(
        text: "윌로우와 연결이 원활하지 않아요. 😢",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }

    _isLoading = false;
    notifyListeners();
  }

  // 요약 요청
  Future<bool> requestAiSummary() async {
    if (_isSummarizing) return false;

    _isSummarizing = true;
    notifyListeners();

    final success = await _repository.requestAiSummary();

    _isSummarizing = false;
    notifyListeners();

    return success;
  }
}