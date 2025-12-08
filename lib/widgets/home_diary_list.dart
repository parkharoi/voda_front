import 'package:flutter/material.dart';
import '../../common/app_colors.dart';
import '../../models/diary_model.dart';
import '../../screens/diary_write_screen.dart';

class HomeDiaryList extends StatelessWidget {
  final DateTime selectedDate;
  final List<Diary> diaries;

  const HomeDiaryList({super.key, required this.selectedDate, required this.diaries});

  @override
  Widget build(BuildContext context) {
    if (diaries.isEmpty) {
      return _buildEmptyView(context);
    }
    return ListView.separated(
      itemCount: diaries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final diary = diaries[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: Row(
            children: [
              Text(diary.moodCode, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(diary.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      diary.description ?? "",
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

  Widget _buildEmptyView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.edit_note_rounded, size: 60, color: AppColors.textGray),
        const SizedBox(height: 16),
        const Text("작성된 일기가 없어요.", style: TextStyle(fontSize: 16, color: AppColors.textGray)),
        const SizedBox(height: 24),
        SizedBox(
          width: 200, height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DiaryWriteScreen(selectedDate: selectedDate))),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            child: const Text("오늘의 일기 쓰기", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}