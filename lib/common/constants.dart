import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String accessTokenKey = 'ACCESS_TOKEN';
  static const String refreshTokenKey = 'REFRESH_TOKEN';

  static const int apiTimeout = 10000;

  static const List<Map<String, dynamic>> moods = [
    {
      'code' : 'HAPPY',
      'label' : '행복해요',
      'icon' : Icons.sentiment_very_satisfied,
      'color' : Color(0xFFFFD54F),
    },
    {
      'code' : 'PEACE',
      'label' : '평온해요',
      'icon' : Icons.sentiment_satisfied,
      'color' : Color(0xFF81C784),
    },
    {
      'code' : 'SAD',
      'label' : '슬퍼요',
      'icon' : Icons.sentiment_dissatisfied,
      'color' : Color(0xFF64B5F6),
    },
    {
      'code' : 'ANXIETY',
      'label' : '불안해요',
      'icon' : Icons.sentiment_neutral,
      'color' : Color(0xFF9575CD),
    },
    {
      'code' : 'EXCITED',
      'label' : '신나요',
      'icon' : Icons.sentiment_very_satisfied_outlined,
      'color' : Color(0xFFFF8A65),
    },
  ];

  static Map<String, dynamic> getMoodData(String? code) {
    if(code == null) return moods[0];

    var match = moods.firstWhere(
        (m) => m['code'] == code,
      orElse : () => moods[0]
    );
    return match;
  }
}