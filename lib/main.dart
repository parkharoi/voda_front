import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:voda_front/common/app_theme.dart';
import 'package:voda_front/screens/login_screen.dart';
import 'package:voda_front/viewmodels/auth_view_model.dart';
import 'package:voda_front/viewmodels/diary_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => DiaryViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VODA',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}