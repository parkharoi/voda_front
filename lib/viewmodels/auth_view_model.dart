
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:voda_front/common/constants.dart';
import 'package:voda_front/models/auth_model.dart';
import 'package:voda_front/repositories/auth_repository.dart';

//로그인 로직 처리
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository  = AuthRepository();

  //Todo : 블로그 글 쓰기
  final _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TokenInfo? _token; //받아온 토큰(로그인 증명서)

  //로그인 함수
  Future<bool> login(String email, String password) async {
    //_isLoading = true; (변수 바뀌었는데 화면 그대로)
    _isLoading = true;
    //플러터 UI는 수동이라 이렇게 알려줘야 한다 상태 바뀌었어 ! 라고
    notifyListeners();

    try{
      //서버에서 토큰 받기
      _token = await _repository.login(email, password);

    if(_token != null) {
      await _storage.write(
          key: AppConstants.accessTokenKey,
          value: _token!.accessToken);
      await _storage.write(
          key: AppConstants.refreshTokenKey,
          value: _token!.refreshToken);
    }
      return true;
    }catch(e) {
      print("로그인 실패 : $e");
      return false;
    }finally {
      //통신 끝나면 false
      _isLoading = false;
      //바뀐거 다시 알려
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    _token = null;
    notifyListeners();
  }
}