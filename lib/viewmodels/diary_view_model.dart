import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voda_front/common/constants.dart';
import 'package:voda_front/models/diary_model.dart';
import 'package:voda_front/repositories/diary_repository.dart';

class DiaryViewModel extends ChangeNotifier {
  final DiaryRepository _repository = DiaryRepository();

  File? _selectedImage;
  bool _isUploading = false;

  File? get selectedImage => _selectedImage;
  bool get isUploading => _isUploading;

  // 이미지 선택 함수
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }

  // 일기 업로드 요청
  Future<bool> uploadDiary({
    required String title,
    required String content,
    required int moodIndex,
    required DateTime date, // 작성 날짜 받기
  }) async {
    _isUploading = true;
    notifyListeners();

    // 서버 전송용 데이터 가공
    Map<String, dynamic> diaryData = {
      "title": title,
      "content": content,
      "mood": _convertIndexToMoodString(moodIndex),
      "date": date.toIso8601String().split('T')[0], // "2025-12-02" 형식
    };

    // 리포지토리 호출
    bool success = await _repository.createDiary(_selectedImage, diaryData);

    _isUploading = false;

    // 성공 시 이미지 비우기
    if (success) {
      clearImage();
    }

    notifyListeners();
    return success;
  }


  // 2. 달력 조회 (Fetch) 관련 상태

  Map<DateTime, List<Diary>> _diaryMap = {};

  Map<DateTime, List<Diary>> get diaryMap => _diaryMap;

  // 월별 조회 함수
  Future<void> fetchMonthlyDiaries(int year, int month) async {
    try {
      List<Diary> fetchedList = await _repository.getMonthlyDiaries(year, month);

      for (var diary in fetchedList) {
        // UTC 날짜 키 생성 (시분초 제거)
        final dateKey = DateTime.utc(diary.date.year, diary.date.month, diary.date.day);

        if (_diaryMap[dateKey] == null) {
          _diaryMap[dateKey] = [diary];
        } else {
          // 중복 방지 (기존 거 지우고 새거 넣기)
          _diaryMap[dateKey]!.removeWhere((element) => element.id == diary.id);
          _diaryMap[dateKey]!.add(diary);
        }
      }
      notifyListeners();
    } catch (e) {
      print("일기 불러오기 실패: $e");
    }
  }

  String _convertIndexToMoodString(int index) {
    if(index >= 0 && index < AppConstants.moods.length) {
      return AppConstants.moods[index]['code'];
    }
    return 'HAPPY';
  }
}
