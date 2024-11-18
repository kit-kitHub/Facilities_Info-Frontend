import 'package:shared_preferences/shared_preferences.dart';

class FontSizeManager {
  // 싱글톤 인스턴스
  static final FontSizeManager _instance = FontSizeManager._internal();

  // 내부 생성자
  FontSizeManager._internal();

  // 팩토리 생성자
  factory FontSizeManager() => _instance;

  // 폰트 크기 기본값
  static const double _defaultFontSize = 16.0;

  // SharedPreferences 인스턴스
  SharedPreferences? _prefs;

  // 폰트 크기 상태 변수
  double _fontSize = _defaultFontSize;

  // 초기화 (SharedPreferences 로드 및 폰트 크기 불러오기)
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _fontSize = _prefs?.getDouble('fontSize') ?? _defaultFontSize;
  }

  // 폰트 크기 Getter
  double get fontSize => _fontSize;

  // 폰트 크기 Setter (저장 포함)
  set fontSize(double value) {
    _fontSize = value;
    _prefs?.setDouble('fontSize', value);
  }

  void decreaseFontSize() {
    if (fontSize > 10) { fontSize -= 2; }
  }

  void increaseFontSize() {
    if (fontSize < 40) { fontSize += 2; }
  }
}
