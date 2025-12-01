import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voda_front/viewmodels/diary_view_model.dart';
import '../common/app_colors.dart';
import '../common/constants.dart';

class DiaryWriteScreen extends StatefulWidget {
  final DateTime selectedDate;

  const DiaryWriteScreen({super.key, required this.selectedDate});

  @override
  State<DiaryWriteScreen> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends State<DiaryWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _selectedMoodIndex = 0; // 기본 기분: 첫 번째

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diaryViewModel = Provider.of<DiaryViewModel>(context);

    final formattedDate = DateFormat('yyyy.MM.dd EEEE', 'ko_KR').format(widget.selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("일기 작성하기", style: TextStyle(color: AppColors.textBlack, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Text(formattedDate, style: const TextStyle(color: AppColors.textGray, fontSize: 14)),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 기분 선택
            const Text("오늘의 기분은 어떠신가요?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textBlack)),
            const SizedBox(height: 20),
            _buildMoodSelector(),

            const SizedBox(height: 30),

            // 2. 이미지 추가 영역
            GestureDetector(
              onTap: () => diaryViewModel.pickImage(), //갤러리 열기
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                // 이미지가 있으면 보여주고, 없으면 아이콘 보여줌
                child: diaryViewModel.selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    diaryViewModel.selectedImage!,
                    fit: BoxFit.cover,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppColors.textGray),
                    SizedBox(height: 8),
                    Text("사진을 추가해 보세요", style: TextStyle(color: AppColors.textGray)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 3. 제목 입력
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textBlack),
              decoration: const InputDecoration(
                hintText: "제목을 입력하세요",
                hintStyle: TextStyle(color: AppColors.textGray),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const Divider(height: 30, thickness: 1, color: Colors.grey),

            // 4. 내용 입력
            TextField(
              controller: _contentController,
              maxLines: null, // 무제한 줄바꿈
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontSize: 16, color: AppColors.textBlack, height: 1.5),
              decoration: const InputDecoration(
                hintText: "오늘의 이야기를 들려주세요",
                hintStyle: TextStyle(color: AppColors.textGray),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 100), // 키보드 올라올 때 여유 공간
          ],
        ),
      ),

      // 5. 하단 버튼
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () { /* 임시저장 로직 */ },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: AppColors.textGray),
                  ),
                  child: const Text("임시 저장", style: TextStyle(color: AppColors.textGray)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  // 로딩 중이면 버튼 비활성화
                  onPressed: diaryViewModel.isUploading
                      ? null
                      : () async {
                    // 작성 완료 클릭!
                    final success = await diaryViewModel.uploadDiary(
                      title: _titleController.text,
                      content: _contentController.text,
                      moodIndex: _selectedMoodIndex,
                    );

                    if (success && mounted) {
                      Navigator.pop(context); // 성공하면 닫기
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('일기가 등록되었습니다!')),
                      );
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('등록 실패! 다시 시도해주세요.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: diaryViewModel.isUploading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("작성 완료", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 기분 선택 위젯
  Widget _buildMoodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(AppConstants.moodEmojis.length, (index) {
        final isSelected = _selectedMoodIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedMoodIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(AppConstants.moodEmojis[index], style: const TextStyle(fontSize: 30)),
          ),
        );
      }),
    );
  }
}