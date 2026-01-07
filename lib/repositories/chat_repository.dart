import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:voda_front/common/config/api_config.dart';
import 'package:voda_front/common/constants.dart';

class ChatRepository {
  final _storage = const FlutterSecureStorage();

  Future<String?> sendMessage(String message) async {
    try {
      final url = Uri.parse('${ApiConfig.apiUrl}/${ApiConfig.chatPath}');

      final accessToken = await _storage.read(key: AppConstants.accessTokenKey);
      if (accessToken == null) {
        print("로그인이 필요합니다.");
        return null;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // JSON 형식 명시
          'Authorization': 'Bearer $accessToken', // 토큰 인증
        },
        body: jsonEncode({'message': message}), // Map -> JSON 문자열 변환
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse['data']['reply'];
      } else {
        print("🔥 채팅 전송 실패 (Code: ${response.statusCode})");
        print("🔥 에러 내용: ${utf8.decode(response.bodyBytes)}");
        return null;
      }
    } catch (e) {
      print("🔥 채팅 통신 에러: $e");
      return null;
    }
  }

  // 일기 요약 요청
  Future<bool> requestAiSummary() async {
    try {

      final url = Uri.parse('${ApiConfig.apiUrl}${ApiConfig.diaryPath}/ai');

      final accessToken = await _storage.read(key: AppConstants.accessTokenKey);
      if (accessToken == null) return false;

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("🔥 요약 요청 실패 (Code: ${response.statusCode})");
        print("🔥 에러 내용: ${utf8.decode(response.bodyBytes)}");
        return false;
      }
    } catch (e) {
      print("🔥 요약 통신 에러: $e");
      return false;
    }
  }
}