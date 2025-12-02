import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voda_front/common/app_colors.dart';
import 'package:voda_front/models/diary_model.dart';
import 'package:voda_front/viewmodels/auth_view_model.dart';
import 'package:voda_front/viewmodels/diary_view_model.dart';
import 'package:voda_front/screens/login_screen.dart';
import 'package:voda_front/screens/diary_write_screen.dart';
import 'package:voda_front/widgets/home_header.dart';
import 'package:voda_front/widgets/home_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DiaryViewModel>(context, listen: false)
          .fetchMonthlyDiaries(_focusedDay.year, _focusedDay.month);
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    final diaryViewModel = Provider.of<DiaryViewModel>(context);

    // 선택된 날짜의 일기 데이터 찾기
    final dateKey = DateTime.utc(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    final List<Diary>? dailyDiaries = diaryViewModel.diaryMap[dateKey];
    final Diary? selectedDiary = (dailyDiaries != null && dailyDiaries.isNotEmpty)
        ? dailyDiaries.first
        : null;

    return Scaffold(
      backgroundColor: Colors.white, // 배경색
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // (1) 상단 헤더
                    HomeHeader(
                      selectedDay: _selectedDay,
                      onLogout: () => _showLogoutDialog(context),
                    ),

                    const SizedBox(height: 20),

                    // (2) 캘린더 (이제 같이 스크롤됨!)
                    HomeCalendar(
                      focusedDay: _focusedDay,
                      selectedDay: _selectedDay,
                      onDaySelected: _onDaySelected,
                      onPageChanged: (focused) {
                        setState(() => _focusedDay = focused);
                        diaryViewModel.fetchMonthlyDiaries(focused.year, focused.month);
                      },
                      eventLoader: (day) {
                        final key = DateTime.utc(day.year, day.month, day.day);
                        return diaryViewModel.diaryMap[key] ?? [];
                      },
                    ),

                    const SizedBox(height: 20),

                    // (3) 감정 통계 카드
                    _buildEmotionStatsCard(diaryViewModel.diaryMap.values.expand((e) => e).toList()),

                    const SizedBox(height: 20),

                    // (4) 응원 배너
                    _buildCheeringBanner(),

                    const SizedBox(height: 20),

                    // (5) 일기 미리보기 카드
                    _buildDiaryPreviewCard(selectedDiary),

                    const SizedBox(height: 40), // 버튼에 가려지지 않게 여백 추가
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade100)), // 구분선
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: _buildBottomButtons(context),
            ),
          ],
        ),
      ),
    );
  }

  // --- 아래는 위젯 디자인 코드들 (그대로 유지) ---

  // [감정 통계 카드]
  Widget _buildEmotionStatsCard(List<Diary> allDiaries) {
    int happyCount = 0, peaceCount = 0, sadCount = 0, anxietyCount = 0, excitedCount = 0;
    for (var diary in allDiaries) {
      if (diary.moodEmoji == "🥰" || diary.moodEmoji == "😊") happyCount++;
      else if (diary.moodEmoji == "😌") peaceCount++;
      else if (diary.moodEmoji == "😢") sadCount++;
      else if (diary.moodEmoji == "😨") anxietyCount++;
      else if (diary.moodEmoji == "🥳") excitedCount++;
    }
    int total = allDiaries.length > 0 ? allDiaries.length : 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          const Text("나의 감정 기록 📊", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textBlack)),
          const SizedBox(height: 20),
          _buildStatRow("행복해요", "😊", happyCount, total, Colors.amber),
          _buildStatRow("평온해요", "😌", peaceCount, total, Colors.green.shade300),
          _buildStatRow("슬퍼요", "😢", sadCount, total, Colors.blue.shade300),
          _buildStatRow("불안해요", "😨", anxietyCount, total, Colors.red.shade300),
          _buildStatRow("신나요", "🥳", excitedCount, total, Colors.purple.shade300),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String emoji, int count, int total, Color color) {
    double percent = count / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36, height: 36, alignment: Alignment.center,
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 60, child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(height: 8, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4))),
                FractionallySizedBox(
                  widthFactor: percent > 0 ? percent : 0.01,
                  child: Container(height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text("${count}회 (${(percent * 100).toStringAsFixed(0)}%)", style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
        ],
      ),
    );
  }

  // [응원 배너]
  Widget _buildCheeringBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(20)),
      child: const Text(
        "당신의 긍정 에너지가 주변을 밝게 만들어요! 오늘도 파이팅! 💫",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textBlack, height: 1.5),
      ),
    );
  }

  // [일기 미리보기 카드]
  Widget _buildDiaryPreviewCard(Diary? diary) {
    if (diary == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
        child: Column(
          children: const [
            Icon(Icons.edit_note_rounded, size: 40, color: Colors.grey),
            SizedBox(height: 10),
            Text("작성된 일기가 없어요.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    final dateStr = DateFormat('M월 d일 EEEE', 'ko_KR').format(diary.date);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateStr, style: const TextStyle(color: AppColors.textGray, fontSize: 13)),
              Text(diary.moodEmoji, style: const TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 12),
          Text(diary.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textBlack)),
          const SizedBox(height: 4),
          Text(diary.content ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: AppColors.textBlack, height: 1.5)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // 상세 페이지 이동
            },
            child: const Text("더 보기 →", style: TextStyle(color: Color(0xFFFF8895), fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  // [하단 버튼]
  Widget _buildBottomButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity, height: 55,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DiaryWriteScreen(selectedDate: _selectedDay)));
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text("새 일기 작성", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8895), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity, height: 55,
          child: OutlinedButton.icon(
            onPressed: () {
              // 챗봇 화면 이동
            },
            icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFFFF8895)),
            label: const Text("윌로우와 대화하기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF8895))),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFF8895)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), backgroundColor: Colors.white),
          ),
        ),
      ],
    );
  }

  // 로그아웃 다이얼로그
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("로그아웃", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("정말 로그아웃 하시겠습니까?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소", style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<AuthViewModel>(context, listen: false).logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
              }
            },
            child: const Text("확인", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}