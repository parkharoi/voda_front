import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda_front/models/diary_model.dart';
import 'package:voda_front/viewmodels/auth_view_model.dart';
import 'package:voda_front/screens/login_screen.dart';
import 'package:voda_front/widgets/home_header.dart';
import 'package:voda_front/widgets/home_calendar.dart';
import 'package:voda_front/widgets/home_diary_list.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // 나중에 ViewModel과 API로 대체될 더미 데이터
  final Map<DateTime, List<Diary>> _diaries = {};

  List<Diary> _getDiariesForDay(DateTime day) {
    return _diaries[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 1. 상단 헤더 (날짜 + 로그아웃)
              HomeHeader(
                selectedDay: _selectedDay,
                onLogout: () => _showLogoutDialog(context),
              ),

              const SizedBox(height: 30),

              // 2. 캘린더 위젯
              HomeCalendar(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                onDaySelected: _onDaySelected,
                eventLoader: _getDiariesForDay,
              ),

              const SizedBox(height: 30),

              // 3. 일기 리스트 위젯
              Expanded(
                child: HomeDiaryList(
                  selectedDate: _selectedDay,
                  diaries: _getDiariesForDay(_selectedDay),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("로그아웃", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("정말 로그아웃 하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<AuthViewModel>(context, listen: false).logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              }
            },
            child: const Text("확인", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}