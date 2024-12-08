import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:facilities_info/SingleTone/tokenManager.dart';

import 'package:facilities_info/tools/jwt_decoder.dart';


class TokenController {
  final String apiBaseUrl = "http://3.34.105.70:8080/api/auth"; // TODO : API 경로 맞게 설정
  final TokenManager tokenManager = TokenManager();

  /// 토큰 갱신 메서드
  Future<bool> refreshAccessToken() async {
    try {
      String? refreshToken = await tokenManager.refreshToken;

      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse("$apiBaseUrl/token/refresh"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        String newAccessToken = responseData['accessToken'];
        String newRefreshToken = responseData['refreshToken'] ?? refreshToken;

        await tokenManager.setAccessToken(newAccessToken);
        await tokenManager.setRefreshToken(newRefreshToken);

        return true;
      } else {
        await tokenManager.clearTokens();
        return false;
      }
    } catch (e) {
      print("토큰 갱신 오류: $e");
      return false;
    }
  }

  /// AccessToken 유효성 검사 및 자동 갱신 메서드
  Future<bool> ensureAuthenticated() async {
    String? accessToken = await tokenManager.accessToken;

    if (accessToken == null || JwtDecoder.isTokenExpired(accessToken)) {
      return await refreshAccessToken();
    }
    return true;
  }
}
