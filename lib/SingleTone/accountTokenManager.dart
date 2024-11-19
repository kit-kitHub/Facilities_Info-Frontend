import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  // 싱글톤 인스턴스
  static final TokenManager _instance = TokenManager._internal();

  // 내부 생성자
  TokenManager._internal();

  // 팩토리 생성자
  factory TokenManager() {
    return _instance;
  }

  // FlutterSecureStorage 인스턴스
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // SecureStorage 키
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // AccessToken 저장
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  // RefreshToken 저장
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  // AccessToken 읽기
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  // RefreshToken 읽기
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  // AccessToken 삭제
  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
  }

  // RefreshToken 삭제
  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  // 모든 토큰 삭제 (로그아웃 시 사용)
  Future<void> deleteAllTokens() async {
    await deleteAccessToken();
    await deleteRefreshToken();
  }

  // AccessToken과 RefreshToken이 저장되어 있는지 확인
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return (accessToken != null && accessToken.isNotEmpty) &&
        (refreshToken != null && refreshToken.isNotEmpty);
  }
}
