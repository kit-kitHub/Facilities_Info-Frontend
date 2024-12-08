import 'dart:convert';

class JwtDecoder {
  // 토큰 만료 여부 확인
  static bool isTokenExpired(String token) {
    try {
      final payload = _decodePayload(token);
      final exp = payload['exp'];
      if (exp == null) return true;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true; // 오류 발생 시 만료로 간주
    }
  }

  // 토큰 만료 날짜 반환
  static DateTime getExpiryDate(String token) {
    final payload = _decodePayload(token);
    final exp = payload['exp'];
    if (exp == null) throw Exception("만료 시간이 없습니다.");

    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }

  // JWT 페이로드 디코딩
  static Map<String, dynamic> _decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception("잘못된 JWT 형식입니다.");

    final payload = parts[1];
    final decoded = utf8.decode(base64Url.decode(base64Url.normalize(payload)));
    return json.decode(decoded);
  }
}