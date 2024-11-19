import 'package:shared_preferences/shared_preferences.dart';

class mapCenterManager {
  // 싱글톤 인스턴스
  static final mapCenterManager _instance = mapCenterManager._internal();

  // 내부 생성자
  mapCenterManager._internal();

  // 팩토리 생성자
  factory mapCenterManager() => _instance;

  // 폰트 크기 기본값
  static const double _defaultmapCenterlatitude = 37.3608681;
  static const double _defaultmapCenterlongitude = 126.9306506;

  // SharedPreferences 인스턴스
  SharedPreferences? _prefs;

  // 폰트 크기 상태 변수
  double _mapCenterlatitude = _defaultmapCenterlatitude;
  double _mapCenterlongitude = _defaultmapCenterlongitude;

  // 초기화 (SharedPreferences 로드 및 폰트 크기 불러오기)
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _mapCenterlatitude = _prefs?.getDouble('latitude') ?? _defaultmapCenterlatitude;
    _mapCenterlongitude = _prefs?.getDouble('longitude') ?? _defaultmapCenterlongitude;
  }

  // 현재 위치 Getter
  double get mapCenterlatitude => _mapCenterlatitude;
  double get mapCenterlongitude => _mapCenterlongitude;

  // 현재 위치 Setter (저장 포함)
  set mapCenterlatitude(double value) {
    _mapCenterlatitude = value;
    _prefs?.setDouble('latitude', value);
  }

  set mapCenterlongitude(double value) {
    _mapCenterlongitude = value;
    _prefs?.setDouble('longitude', value);
  }

}
