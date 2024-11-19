import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // 싱글톤 인스턴스
  static final AuthService _instance = AuthService._internal();

  // SecureStorage 객체
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // 싱글톤 생성자
  AuthService._internal();

  // 싱글톤 객체 접근
  factory AuthService() {
    return _instance;
  }

  // 로그인 상태 확인 (accessToken 및 refreshToken 유효성 검사 포함)
  Future<bool> isLoggedIn() async {
    final accessToken = await _secureStorage.read(key: 'access_token');
    final refreshToken = await _secureStorage.read(key: 'refresh_token');

    // Access Token 검사
    if (accessToken == null || _isTokenExpired(accessToken)) {        // Access Token이 없거나 만료된 경우
      if (refreshToken == null || _isTokenExpired(refreshToken)) {    // Refresh Token도 없거나 만료된 경우
        return false; // 로그아웃 상태
      }
      return true; // Refresh Token이 유효하면 로그인 상태 유지
    }

    return true; // Access Token이 유효한 경우
  }

  // 토큰 만료 여부 확인
  bool _isTokenExpired(String token) {
    try {
      // JWT 구조를 사용하여 만료 시간 확인
      final parts = token.split('.');
      if (parts.length < 3) return true;

      final payload = parts[1];
      final decoded = utf8.decode(base64Url.decode(base64Url.normalize(payload)));
      final expiration = DateTime.fromMillisecondsSinceEpoch(
        jsonDecode(decoded)['exp'] * 1000,
      );
      return DateTime.now().isAfter(expiration);
    } catch (_) {
      return true; // 유효하지 않은 토큰은 만료된 것으로 간주
    }
  }

  // 로그인 처리 (Access Token과 Refresh Token 저장)
  Future<void> login(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: 'access_token', value: accessToken);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  // 로그아웃 처리
  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }

  // Access Token 가져오기
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  // Refresh Token 가져오기
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  // Token 갱신
  Future<void> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    // 서버에 새 Access Token 요청 (예제 API 호출)
    final newAccessToken = await _fetchNewAccessToken(refreshToken);

    if (newAccessToken != null) {
      await _secureStorage.write(key: 'access_token', value: newAccessToken);
    } else {
      // 갱신 실패 시 로그아웃 처리
      await logout();
    }
  }

  // TODO: 서버에 새 Access Token 요청 (예제용)
  Future<String?> _fetchNewAccessToken(String refreshToken) async {
    // HTTP 요청을 통해 새 Access Token 가져오기
    // 아래는 예제입니다. 실제 API 요청 코드를 추가하세요.
    try {
      // 예제 API 응답 시 새 Access Token 반환
      final newAccessToken = "new_dummy_access_token"; // 실제 서버 응답 값
      return newAccessToken;
    } catch (e) {
      return null;
    }
  }
}
