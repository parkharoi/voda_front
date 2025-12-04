import 'package:voda_front/common/constants.dart';

class Diary {
  final int? id;
  final DateTime date;
  final String title;
  final String? description;
  final String moodCode;
  final String moodLabel;
  final String? imgUrl;
  final String? diaryType;


  Diary({
    this.id,
    required this.date,
    required this.title,
    this.description, //할지 말지 고민중
    required this.moodCode,
    required this.moodLabel,
    this.imgUrl,
    this.diaryType,
  });

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
        id: json['diaryId'],
        title: json['title'] ?? '',
        description : json['description'] ?? '',
        date: DateTime.parse(json['writtenDate']),
        moodCode: json['mood'] ?? 'HAPPY',
        moodLabel: json['moodLabel'] ?? '행복해요',
        imgUrl: json['imgUrl'],
        diaryType: json['diaryType'],
    );
  }

}