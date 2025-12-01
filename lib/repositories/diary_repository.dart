import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:voda_front/common/config/api_config.dart';
import 'package:voda_front/common/constants.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';

class DiaryRepository {
  final _storage = const FlutterSecureStorage();

  Future<bool> createDiary(File? imageFile, Map<String, dynamic> diaryData) async {
    final url = Uri.parse('${ApiConfig.apiUrl}${ApiConfig.diaryPath}');

    final accessToken = await _storage.read(key: AppConstants.accessTokenKey);
    if (accessToken == null) throw Exception("로그인이 필요합니다.");

    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer $accessToken';

    request.files.add(
      http.MultipartFile.fromString(
        'data',
        jsonEncode(diaryData),
        contentType: MediaType('application', 'json'),
      ),
    );

    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: imageFile.path.split('/').last,
        contentType: MediaType('image', 'jpeg')
      );
      request.files.add(multipartFile);
    }

    print("🚀 일기 작성 요청: URL=$url");
    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ 일기 작성 성공!");
        return true;
      } else {
        print("🔥 실패 상태 코드: ${response.statusCode}");
        print("🔥 실패 원인(Body): ${utf8.decode(response.bodyBytes)}");
        return false;
      }
    } catch (e) {
      print("🔥 에러 발생: $e");
      return false;
    }
  }
}