import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import '/SingleTone/map_center.dart';//화면 이동해도 화면 남아있게 하기위해 사용하는 싱글톤



StreamSubscription<Position>? positionStream;
final mapcentermanager = mapCenterManager();

//현재 위치를 움직이면 마커가 따라오게 해주는 함수
void startTracking() async {

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1, // 최소 이동 거리 (5미터)
    ),
  ).listen((Position position) {
    LatLng currentPosition = LatLng(position.latitude, position.longitude);
    mapcentermanager.setMapCenterLongitude(position.longitude);
    mapcentermanager.setMapCenterLatitude(position.latitude);
  });
}

// 위치 추적을 중지하는 함수
void stopTracking() {
  positionStream?.cancel();  // 위치 추적 취소
}
