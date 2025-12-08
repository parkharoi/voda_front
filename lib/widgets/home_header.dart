import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final DateTime selectedDay;
  final VoidCallback onLogout;

  const HomeHeader({super.key, required this.selectedDay, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final String selectedDateText = DateFormat('M월 d일 EEEE', 'ko_KR').format(selectedDay);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("나의 일기", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textBlack)),
            const SizedBox(height: 4),
            Text(selectedDateText, style: const TextStyle(fontSize: 14, color: AppColors.textGray, fontWeight: FontWeight.w500)),
          ],
        ),
        GestureDetector(
          onTap: onLogout,
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
            child: const Icon(Icons.person, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}