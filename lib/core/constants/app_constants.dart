class AppConstants {
  static const double defaultSpeed = 1.0;
  static const List<double> speedOptions = [
    0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 3.0,
  ];
  static const int defaultTransitionMs = 300;
  static const int tenseTransitionMs = 150;
  static const int sceneTransitionMs = 600;
  static const int prefetchWindow = 2;
  static const int autoSaveInterval = 30;
  static const int maxUnknownCharacters = 20;
  static const int chapterTextPreviewChars = 2000;
  static const int txtChunkSize = 5000;
}
