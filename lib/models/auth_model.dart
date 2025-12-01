class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class TokenInfo {
  final String grantType;
  final String accessToken;
  final String refreshToken;

  TokenInfo({
    required this.grantType,
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokenInfo.fromJson(Map<String, dynamic> json) {
    return TokenInfo(
      grantType: json['grantType'] ?? 'Bearer',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}