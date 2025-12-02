import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../common/app_colors.dart';
import '../../models/diary_model.dart';

class HomeCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final List<Diary> Function(DateTime) eventLoader;

  const HomeCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.eventLoader,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      eventLoader: eventLoader,
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
        todayTextStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        todayDecoration: BoxDecoration(color: Colors.transparent),
        selectedDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
        selectedTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        markerDecoration: BoxDecoration(color: AppColors.secondaryPink, shape: BoxShape.circle),
        markerSize: 5,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextFormatter: (date, locale) => DateFormat('yyyy.MM', locale).format(date),
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textBlack),
      ),
    );
  }
}