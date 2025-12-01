import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../repositories/diary_repository.dart';

class DiaryViewModel extends ChangeNotifier {
  final DiaryRepository _repository = DiaryRepository();
  final ImagePicker _picker = ImagePicker();

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  // 1. 갤러리에서 사진 가져오기
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners(); // 화면에 사진 뜸
      }
    } catch (e) {
      print("이미지 선택 실패: $e");
    }
  }

  //2. 일기 업로드 (UI에서 이 함수를 부름)
  Future<bool> uploadDiary({
    required String title,
    required String content,
    required int moodIndex,
  }) async {
    if (title.isEmpty || content.isEmpty) return false;

    _isUploading = true;
    notifyListeners();

    String moodEnum = _convertIndexToMood(moodIndex);

    Map<String, dynamic> diaryData = {
      "title": title,
      "mood": moodEnum,
      "description": content,
    };

    try {
      // 리포지토리에게 (이미지 + 데이터) 넘기기
      return await _repository.createDiary(_selectedImage, diaryData);
    } catch (e) {
      print("업로드 중 에러: $e");
      return false;
    } finally {
      _isUploading = false;
      notifyListeners(); // 로딩 끝
    }
  }

  // 😊 헬퍼: 인덱스를 백엔드 Enum으로 바꾸기
  String _convertIndexToMood(int index) {
    // 순서는 UI의 이모지 순서와 같아야 합니다.
    const moods = ["HAPPY", "PEACE", "SAD", "ANXIETY", "EXCITED"];
    if (index >= 0 && index < moods.length) {
      return moods[index];
    }
    return "PEACE"; // 기본값
  }
}