import 'package:shared_preferences/shared_preferences.dart';

class mapCenterManager {
  // 싱글톤 인스턴스
  static final mapCenterManager _instance = mapCenterManager._internal();

  // 내부 생성자
  mapCenterManager._internal();

  // 팩토리 생성자
  factory mapCenterManager() => _instance;

  static const double _defaultmapCenterlatitude = 37.3608681;
  static const double _defaultmapCenterlongitude = 126.9306506;
  static const int _defaultLevel = 4;  // 기본 레벨 값

  // SharedPreferences 인스턴스
  SharedPreferences? _prefs;

  double _mapCenterlatitude = _defaultmapCenterlatitude;
  double _mapCenterlongitude = _defaultmapCenterlongitude;
  int _level = _defaultLevel;  // 기본 레벨 값

  // 초기화 (SharedPreferences 로드 및 값 불러오기)
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _mapCenterlatitude = _prefs?.getDouble('latitude') ?? _defaultmapCenterlatitude;
    _mapCenterlongitude = _prefs?.getDouble('longitude') ?? _defaultmapCenterlongitude;
    _level = _prefs?.getInt('level') ?? _defaultLevel;  // 레벨 불러오기
  }

  // 현재 위치 Getter
  double get mapCenterlatitude => _mapCenterlatitude;
  double get mapCenterlongitude => _mapCenterlongitude;

  // 레벨 Getter
  int get level => _level;

  // 위도 값 설정 및 영구 저장
  Future<void> setMapCenterLatitude(double value) async {
    _mapCenterlatitude = value;
    if (_prefs != null) {
      await _prefs!.setDouble('latitude', value); // 값 저장
    }
  }

  // 경도 값 설정 및 영구 저장
  Future<void> setMapCenterLongitude(double value) async {
    _mapCenterlongitude = value;
    if (_prefs != null) {
      await _prefs!.setDouble('longitude', value); // 값 저장
    }
  }

  // 레벨 값 설정 및 영구 저장
  Future<void> setLevel(int value) async {
    _level = value;
    if (_prefs != null) {
      await _prefs!.setInt('level', value); // 레벨 값 저장
    }
  }
}
