import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geolocator/geolocator.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MapScreen> {
  late KakaoMapController mapController;
  Set<Marker> markers = {}; // Marker variable
  String? latitude;
  String? longitude;
  bool isTracking = false;  // 추적 상태를 나타내는 변수
  StreamSubscription<Position>? positionStream;

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
        distanceFilter: 5, // 최소 이동 거리 (5미터)
      ),
    ).listen((Position position) {
      LatLng currentPosition = LatLng(position.latitude, position.longitude);

      // 지도 중심과 마커를 업데이트
      updateMarker(currentPosition, '현재 위치');
    });
  }

  // 위치 추적을 중지하는 함수
  void stopTracking() {
    positionStream?.cancel();  // 위치 추적 취소
  }

  //마커 띄울때 사용하는 함수
  void updateMarker(LatLng position, String infoText) {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: UniqueKey().toString(),
          latLng: position,
          infoWindowContent: infoText,    //위에 infoText로 넘어온 것들 마커 위에 표시해준다
          infoWindowFirstShow: false,
          infoWindowRemovable: true,
        ),
      );
    });
    mapController.setCenter(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: KakaoMap(
              onMapCreated: (controller) async {
                mapController = controller;
                LatLng initialPosition = LatLng(37.3608681, 126.9306506);
                updateMarker(initialPosition, 'Test');
              },
              markers: markers.toList(),
              center: LatLng(37.3608681, 126.9306506),
              onMarkerTap: (String markerId, LatLng position, int index) async{
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 20),

                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (isTracking) {
                        stopTracking();  // 이미 추적 중이면 멈추기
                      } else {
                        startTracking();  // 추적 시작
                      }
                      isTracking = !isTracking;  // 추적 상태 토글
                    });
                  },
                  child: Icon(
                    isTracking ? Icons.my_location_rounded : Icons.my_location,  // 상태에 따라 아이콘 변경
                  ),
                ),

                SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      markers.clear();
                    });
                  },
                  child: Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
