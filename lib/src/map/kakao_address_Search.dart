import 'package:geocoding/geocoding.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

Future<LatLng> getCoordinatesFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    return LatLng(locations[0].latitude, locations[0].longitude);
  } catch (e) {
    print('주소 변환 오류: $e');
    throw Exception('Unable to fetch coordinates');
  }
}