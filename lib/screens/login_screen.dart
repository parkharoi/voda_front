import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda_front/components/voda_text_field.dart';
import 'package:voda_front/viewmodels/auth_view_model.dart';
import '../common/app_colors.dart';
import 'home_screen.dart'; // 로그인 성공 시 이동할 곳

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "VODA",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // 이메일 입력
            VodaTextField(
              controller: _emailController,
              label: '이메일',
              icon: Icons.email_outlined,
              iconColor: AppColors.primary, //
            ),
            const SizedBox(height: 16),

            // 비밀번호 입력
            VodaTextField(
                controller: _passwordController,
                label: '비밀번호',
                icon: Icons.lock_outline,
                obscureText: true
            ),
            const SizedBox(height: 32),

            authViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: () async {
                // 1. 뷰모델에게 로그인 요청
                final success = await authViewModel.login(
                  _emailController.text,
                  _passwordController.text,
                );

                if (success && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('로그인 실패! 아이디/비번을 확인하세요.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "로그인",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}