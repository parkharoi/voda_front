// lib/viewmodels/chat_view_model.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voda_front/common/api_client.dart';
import 'package:voda_front/models/chat_message.dart';

class ChatViewModel extends ChangeNotifier {
  final ApiClient _client = ApiClient();

  // 대화 목록 (화면에 보여줄 리스트)
  final List<ChatMessage> _messages = [];

  // 로딩 상태 (윌로우가 생각 중일 때)
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  // 1. 메시지 전송 함수
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // (1) 내 메시지를 먼저 화면에 추가 (즉각 반응)
    _messages.add(ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    _isLoading = true;
    notifyListeners(); // 화면 갱신

    try {
      // (2) 서버로 전송
      // 백엔드가 { "message": "안녕" } 형태를 받는다고 가정
      final response = await _client.post(
        '/chat', // /api/v1은 ApiClient 설정에 따라 다를 수 있음. 확인 필요.
        body: {'message': text},
      );

      if (response.statusCode == 200) {
        // (3) 성공 시 윌로우의 답변을 리스트에 추가
        // 백엔드 응답이 { "response": "반가워요!" } 형태라고 가정
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final aiResponse = jsonResponse['data']['reply'];

        _messages.add(ChatMessage(
          // 만약 reply가 비어있다면 기본 메시지 출력
          text: aiResponse ?? "대답을 들을 수 없었어요.",
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
    } catch (e) {
      print("전송 오류: $e");
      _messages.add(ChatMessage(
        text: "오류가 발생했어요.",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}