import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:voda_front/common/config/api_config.dart';
import 'package:voda_front/common/constants.dart';

class ApiClient{
  final _storage = const FlutterSecureStorage();

  //헤더 자동 만들기
  Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: AppConstants.accessTokenKey);
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      // Todo :토큰이 없으면 null이 들어가니 주의 (null 처리 로직 추가 가능)
    };
  }

  //get
  Future<http.Response> get(String path, {Map<String, String>? queryParams}) async {
    final url = Uri.parse('${ApiConfig.apiUrl}$path')
        .replace(queryParameters: queryParams);

    final headers = await _getHeaders();
    print("GET 요청: $url");
    return await http.get(url, headers: headers);
  }


  //post
  Future<http.Response> post(String path, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('${ApiConfig.apiUrl}$path');
    final headers = await _getHeaders();

    print("POST 요청: $url");
    return await http.post(
        url,
        headers: headers,
        body: bool != null ? jsonEncode(body) : null
    );
  }
}
