import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voda_front/viewmodels/diary_view_model.dart';
import 'dart:io'; // 파일 이미지를 보여주기 위해 필요

// 필요한 경우 색상 상수 파일 import (없으면 아래 하드코딩된 색상 사용)
// import '../common/app_colors.dart';

class DiaryWriteScreen extends StatefulWidget {
  final DateTime selectedDate;

  // 수정 시 필요한 데이터들 (선택사항)
  final String? existingTitle;
  final String? existingContent;
  final int? existingMoodIndex;

  const DiaryWriteScreen({
    super.key,
    required this.selectedDate,
    this.existingTitle,
    this.existingContent,
    this.existingMoodIndex,
  });

  @override
  State<DiaryWriteScreen> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends State<DiaryWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _selectedMoodIndex = 0; // 0: 행복해요 (기본값)

  // 기분 데이터 (디자인용)
  final List<Map<String, dynamic>> _moods = [
    {'label': '행복해요', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.amber},
    {'label': '평온해요', 'icon': Icons.sentiment_satisfied, 'color': Colors.orangeAccent},
    {'label': '슬퍼요', 'icon': Icons.sentiment_dissatisfied, 'color': Colors.blueGrey},
    {'label': '불안해요', 'icon': Icons.sentiment_neutral, 'color': Colors.blue},
    {'label': '신나요', 'icon': Icons.sentiment_very_satisfied_outlined, 'color': Colors.yellow},
  ];

  @override
  void initState() {
    super.initState();
    // 기존 데이터가 있다면 채워넣기
    if (widget.existingTitle != null) _titleController.text = widget.existingTitle!;
    if (widget.existingContent != null) _contentController.text = widget.existingContent!;
    if (widget.existingMoodIndex != null) _selectedMoodIndex = widget.existingMoodIndex!;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel 가져오기
    final diaryViewModel = Provider.of<DiaryViewModel>(context);

    // 날짜 포맷팅 (예: 12월 4일 목요일)
    String dateString = DateFormat('M월 d일 EEEE', 'ko_KR').format(widget.selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            diaryViewModel.clearImage(); // 이미지 초기화
            Navigator.pop(context);
          },
          child: const Text('취소', style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
        leadingWidth: 70,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 헤더 (타이틀 및 날짜)
            const Text(
              '새 일기',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              dateString,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // 2. 기분 선택 섹션
            const Text(
              '오늘 기분이 어때요?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _moods.length,
                separatorBuilder: (context, index) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final mood = _moods[index];
                  final isSelected = _selectedMoodIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMoodIndex = index;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.grey[100] : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            mood['icon'],
                            color: mood['color'],
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mood['label'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.black : Colors.grey,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // 3. [추가됨] 제목 입력 섹션
            const Text(
              '제목',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '제목을 입력하세요',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 4. 내용 입력 섹션
            const Text(
              '무슨 생각을 하고 있나요?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            Container(
              height: 180,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '오늘 하루, 생각, 감정 등을 자유롭게 적어보세요...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 5. 사진 추가 섹션 (ViewModel 연결)
            const Text(
              '사진 추가 (선택사항)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => diaryViewModel.pickImage(), // 뷰모델의 이미지 피커 호출
              child: Container(
                height: 200, // 높이를 조금 키워 이미지가 잘 보이게 함
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                ),
                child: diaryViewModel.selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    diaryViewModel.selectedImage!,
                    fit: BoxFit.cover,
                  ),
                )
                    : Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 6. 저장 버튼 (ViewModel 연결)
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: diaryViewModel.isUploading
                    ? null
                    : () async {
                  // 유효성 검사
                  if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('제목과 내용을 입력해주세요.')),
                    );
                    return;
                  }

                  // 업로드 요청
                  final success = await diaryViewModel.uploadDiary(
                    title: _titleController.text,
                    content: _contentController.text,
                    moodIndex: _selectedMoodIndex,
                    date: widget.selectedDate,
                  );

                  if (success && mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('일기가 등록되었습니다!')),
                    );
                    // 캘린더 갱신
                    diaryViewModel.fetchMonthlyDiaries(
                        widget.selectedDate.year, widget.selectedDate.month);
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('등록 실패! 다시 시도해주세요.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFCDD2), // 디자인의 핑크색
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: diaryViewModel.isUploading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text(
                  '일기 저장',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}