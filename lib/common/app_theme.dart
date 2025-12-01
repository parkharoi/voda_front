
import 'package:flutter/material.dart';
import 'package:voda_front/common/app_colors.dart';

class AppTheme {

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,

        appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
        color: AppColors.textBlack,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        ),
          iconTheme: IconThemeData(color: AppColors.textBlack),
      ),
    );
  }
}