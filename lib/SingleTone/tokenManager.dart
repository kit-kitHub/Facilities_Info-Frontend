import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/tools/jwt_decoder.dart';

class TokenManager {
  // Singleton 인스턴스 생성
  static final TokenManager _instance = TokenManager._internal();

  final _storage = const FlutterSecureStorage();

  // 내부 생성자
  TokenManager._internal();

  // Singleton 인스턴스 반환
  factory TokenManager() {
    return _instance;
  }

  // AccessToken 설정 및 저장
  Future<void> setAccessToken(String token) async {
    await _storage.write(key: 'accessToken', value: token);
  }

  // AccessToken 가져오기
  Future<String?> get accessToken async {
    return await _storage.read(key: 'accessToken');
  }

  // RefreshToken 설정 및 저장
  Future<void> setRefreshToken(String token) async {
    await _storage.write(key: 'refreshToken', value: token);
  }

  // RefreshToken 가져오기
  Future<String?> get refreshToken async {
    return await _storage.read(key: 'refreshToken');
  }

  // 토큰 초기화
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  // AccessToken 만료 여부 검사
  Future<bool> isAccessTokenExpired() async {
    String? token = await accessToken;
    if (token == null) return true;
    return JwtDecoder.isTokenExpired(token);
  }
}
