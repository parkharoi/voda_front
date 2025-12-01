
import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  // 인스턴스화 방지 (실수로 AppColors() 라고 쓰는 것 방지)
  AppColors._();
  
  static const Color primary = Color(0xFFFF8E99);
  static const Color secondaryPink = Color(0xFFFFB5B5);

  //배경색
  static const Color background = Colors.white;

  //텍스트
  static const Color textBlack = Color(0xFF333333);
  static const Color textGray = Color(0xFF9E9E9E);

  //캘린더
  static const Color calendarToday = Color(0xFF555555);
  static const Color calendarSelected = primary;
}