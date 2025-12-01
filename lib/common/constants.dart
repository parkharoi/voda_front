class AppConstants {
  AppConstants._();

  static const String accessTokenKey = 'ACCESS_TOKEN';
  static const String refreshTokenKey = 'REFRESH_TOKEN';

  static const int apiTimeout = 10000;
  static const List<String> moodEmojis = [
    "🥰", // HAPPY (행복)
    "😌", // PEACE (평온)
    "😢", // SAD (슬픔)
    "😨", // ANXIETY (불안) - 바뀜!
    "🥳", // EXCITED (신남)
  ];
}