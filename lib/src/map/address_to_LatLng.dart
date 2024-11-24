import 'package:geocoding/geocoding.dart';

Future<List<Map<String, dynamic>>> findAddressInList(
    double latitude, double longitude, List<Map<String, dynamic>> positionsList) async {

  try {
    // 좌표를 주소로 변환
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    // 첫 번째 주소만 사용 (대부분의 경우 첫 번째 주소가 가장 정확함)
    String address = placemarks.first.name ?? '';

    // 주소가 리스트에 존재하는지 확인
    List<Map<String, dynamic>> foundPositions = positionsList.where((position) {
      return position['address'] == address;
    }).toList();

    return foundPositions;

  } catch (e) {
    // 에러 발생 시 빈 리스트 반환
    print("Error: $e");
    return [];
  }
}
