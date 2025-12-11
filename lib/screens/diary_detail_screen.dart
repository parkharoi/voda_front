import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voda_front/common/app_colors.dart';
import 'package:voda_front/common/constants.dart';
import 'package:voda_front/models/diary_model.dart';

class DiaryDetailScreen extends StatelessWidget {
  final Diary diary;

  const DiaryDetailScreen({super.key, required this.diary});

  @override
  Widget build(BuildContext context) {
    // 날짜 포맷팅
    final dateStr = DateFormat('M월 d일 EEEE', 'ko_KR').format(diary.date);
    final yearStr = DateFormat('yyyy년', 'ko_KR').format(diary.date);

    // 기분 데이터 가져오기
    final moodData = AppConstants.getMoodData(diary.moodCode);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('뒤로', style: TextStyle(color: AppColors.textBlack, fontSize: 16)),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // 1. 헤더 (날짜, 년도, 기분 아이콘)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      yearStr,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
                // AppConstants의 아이콘과 색상 사용
                Icon(
                  moodData['icon'],
                  color: moodData['color'],
                  size: 46,
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 2. 제목
            Text(
              diary.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 24),

            // 3. 이미지 (모델에 imageUrl이 있다고 가정시 사용)
            if (diary.imgUrl != null && diary.imgUrl!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  diary.imgUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // 4. 본문 내용
            Text(
              diary.description ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textBlack,
                height: 1.8, // 줄 간격 늘림
              ),
            ),

            const SizedBox(height: 40),

            // 5. AI 작성 배너 (모델에 isAiGenerated 같은 필드가 필요)
            // if (diary.isAiGenerated ?? false) ...[
            //   Container(
            //     padding: const EdgeInsets.all(16),
            //     decoration: BoxDecoration(
            //       color: const Color(0xFFF8F9FA),
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: Row(
            //       children: const [
            //         Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
            //         SizedBox(width: 8),
            //         Expanded(
            //           child: Text(
            //             '이 일기는 대화를 기반으로 AI가 작성했습니다',
            //             style: TextStyle(fontSize: 14, color: AppColors.textGray),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            //   const SizedBox(height: 40),
            // ],
          ],
        ),
      ),
    );
  }
}