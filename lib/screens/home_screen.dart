import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voda_front/screens/diary_write_screen.dart';
import 'package:voda_front/screens/login_screen.dart';
import 'package:voda_front/viewmodels/auth_view_model.dart';
import '../common/app_colors.dart';
import '../models/diary_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final Map<DateTime, List<Diary>> _diaries = {
  };

  List<Diary> _getDiariesForDay(DateTime day) {
    return _diaries[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final String selectedDateText = DateFormat('M월 d일 EEEE', 'ko_KR').format(_selectedDay);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "나의 일기",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height :4),
                      Text(
                        selectedDateText,
                        style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textGray,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),

                  // 일단 사용자 아이콘에 로그아웃 기능 연결
                  GestureDetector(
                    onTap: () {
                      _showLogoutDialog(context); //팝업
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 캘린더 영역
              _buildCalendar(),

              const SizedBox(height: 30),

              // 하단 영역
              Expanded(
                child: _buildBottomContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 캘린더 위젯
  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'ko_KR',
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      eventLoader: _getDiariesForDay,

      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
        todayTextStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        todayDecoration: BoxDecoration(color: Colors.transparent),
        selectedDecoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        markerDecoration: BoxDecoration(
          color: AppColors.secondaryPink,
          shape: BoxShape.circle,
        ),
        markerSize: 5,
        markersAlignment: Alignment.bottomCenter,
      ),

      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextFormatter: (date, locale) => DateFormat('yyyy.MM', locale).format(date),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
        leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.textBlack),
        rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.textBlack),
      ),
      rowHeight: 50,
    );
  }

  // 📝 하단 컨텐츠
  Widget _buildBottomContent() {
    final selectedDiaries = _getDiariesForDay(_selectedDay);

    if (selectedDiaries.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.edit_note_rounded, size: 60, color: AppColors.textGray),
          const SizedBox(height: 16),
          const Text(
            "작성된 일기가 없어요.",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textGray,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiaryWriteScreen(
                      selectedDate: _selectedDay,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "오늘의 일기 쓰기",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      );
    }

    return ListView.separated(
      itemCount: selectedDiaries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final diary = selectedDiaries[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Text(diary.moodEmoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      diary.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      diary.content,
                      style: const TextStyle(color: AppColors.textGray, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ✨ [추가] 로그아웃 다이얼로그 함수
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("로그아웃", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("정말 로그아웃 하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // 취소
            child: const Text("취소", style: TextStyle(color: AppColors.textGray)),
          ),
          TextButton(
            onPressed: () async {
              // 1. 다이얼로그 닫기
              Navigator.pop(context);

              // 2. 뷰모델에게 로그아웃 요청 (토큰 삭제)
              await Provider.of<AuthViewModel>(context, listen: false).logout();

              // 3. 로그인 화면으로 강제 이동 (뒤로가기 방지)
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false, // 이전 화면 스택 모두 삭제
                );
              }
            },
            child: const Text("확인", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}