import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  // 1. 싱글톤 인스턴스 정의
  static final DeviceInfo _instance = DeviceInfo._internal();

  // 2. 내부 생성자
  DeviceInfo._internal();

  // 3. 팩토리 생성자
  factory DeviceInfo() => _instance;

  // 4. 디바이스 정보 저장 변수
  late final String _osName;
  late final String _osVersion;
  late final String _deviceModel;
  late final String _manufacturer;

  // 5. 초기화 함수
  Future<void> initialize() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      // Android 디바이스 정보 가져오기
      final androidInfo = await deviceInfo.androidInfo;
      _osName = 'Android';
      _osVersion = androidInfo.version.release ?? 'Unknown';
      _deviceModel = androidInfo.model ?? 'Unknown';
      _manufacturer = androidInfo.manufacturer ?? 'Unknown';
    } else if (Platform.isIOS) {
      // iOS 디바이스 정보 가져오기
      final iosInfo = await deviceInfo.iosInfo;
      _osName = 'iOS';
      _osVersion = iosInfo.systemVersion ?? 'Unknown';
      _deviceModel = iosInfo.utsname.machine ?? 'Unknown';
      _manufacturer = 'Apple';
    } else {
      // 기타 OS 처리
      _osName = Platform.operatingSystem;
      _osVersion = Platform.operatingSystemVersion;
      _deviceModel = 'Unknown';
      _manufacturer = 'Unknown';
    }
  }

  // 6. 정보 출력
  @override
  String toString() {
    return '''
OS: $_osName $_osVersion
Device Model: $_deviceModel
Manufacturer: $_manufacturer
''';
  }

  get osName { return _osName; }
  get osVersion { return _osVersion; }
  get deviceModel { return _deviceModel; }
  get manufacturer { return _manufacturer; }

}
