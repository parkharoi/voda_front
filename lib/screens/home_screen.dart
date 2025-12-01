import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // 캘린더 패키지
import 'package:intl/date_symbol_data_local.dart'; // 한국어 날짜용
import '../common/app_colors.dart'; // ✨ 핑크색 가져오기

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // ✨ 세미콜론(;) 필수!

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 임시 데이터 (나중에 ViewModel 연결 예정)
  final List<String> _dummyDiaries = [
    "오늘은 기분이 참 좋은 날이었다.",
    "플러터 공부가 생각보다 재밌다.",
    "서버 연결 성공! 이제 데이터를 불러오자.",
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(); // 날짜 포맷 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("나의 기록"), // 테마(AppTheme) 덕분에 폰트 자동 적용됨
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 설정 화면 이동
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. 캘린더 영역
          _buildCalendar(),

          const SizedBox(height: 20),

          // 2. 리스트 영역 (Expanded 필수)
          Expanded(
            child: _buildDiaryList(),
          ),
        ],
      ),

      // 3. 하단 탭바 (모양만 잡아둠)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary, // ✨ 선택된 아이콘 핑크색!
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: '작성'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이'),
        ],
      ),

      // ✨ 작성 버튼 (플로팅 버튼) - 핑크색 적용
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 글쓰기 화면으로 이동
        },
        backgroundColor: AppColors.primary, // 핑크색
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // 📅 캘린더 위젯
  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'ko_KR', // 한국어
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,

      // 헤더 스타일 (2025년 11월)
      headerStyle: const HeaderStyle(
        formatButtonVisible: false, // 2주/1주 보기 버튼 숨김
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'NeoDunggeunmoCode', // 폰트 강제 지정 (확실하게)
        ),
      ),

      // 달력 스타일링
      calendarStyle: const CalendarStyle(
        // 오늘 날짜: 핑크색 동그라미
        todayDecoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        // 선택한 날짜: 진한 회색 동그라미
        selectedDecoration: BoxDecoration(
          color: AppColors.textBlack,
          shape: BoxShape.circle,
        ),
        // 주말 색상 (선택사항)
        weekendTextStyle: TextStyle(color: Colors.red),
      ),

      // 날짜 선택 로직
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
    );
  }

  // 📝 리스트 위젯
  Widget _buildDiaryList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _dummyDiaries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200), // 연한 테두리
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // 감정 아이콘
              const Text("🥰", style: TextStyle(fontSize: 28)),
              const SizedBox(width: 16),

              // 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "11월 ${29 - index}일",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _dummyDiaries[index],
                      style: const TextStyle(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textGray),
            ],
          ),
        );
      },
    );
  }
}