import 'package:voda_front/common/constants.dart';

class Diary {
  final int? id;
  final DateTime date;
  final String moodEmoji;
  final String title;
  final String? content;

  Diary({
    this.id, //선택사항
    required this.date,
    required this.moodEmoji,
    required this.title,
    this.content,
  });

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
        id: json['diaryId'],
        title: json['title'],
        date: DateTime.parse(json['writtenDate']),
        moodEmoji: _convertMoodToEmoji(json['mood']),
    );
  }

  static String _convertMoodToEmoji(String? mood) {
    int index = 0;

    switch (mood) {
      case 'HAPPY':
        index = 0; // 🥰
        break;
      case 'PEACE':
        index = 1; // 😌
        break;
      case 'SAD':
        index = 2; // 😢
        break;
      case 'ANXIETY':
        index = 3; // 😨
        break;
      case 'EXCITED':
        index = 4; // 🥳
        break;
      default:
        index = 0; // 모르는 값이 오면 기본값
    }

    return (index <AppConstants.moodEmojis.length)
      ? AppConstants.moodEmojis[index]
      : AppConstants.moodEmojis[0];
  }
}