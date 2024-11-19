import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geolocator/geolocator.dart';

import '/SingleTone/map_center.dart';//화면 이동해도 화면 남아있게 하기위해 사용하는 싱글톤


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
  int level = 4;
  bool isRunning = false;
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
      mapcentermanager.mapCenterlatitude = position.latitude;
      mapcentermanager.mapCenterlongitude = position.longitude;
      // 지도 중심과 마커를 업데이트
      updateMarker(currentPosition);
    });
  }

  // 위치 추적을 중지하는 함수
  void stopTracking() {
    positionStream?.cancel();  // 위치 추적 취소
  }

  //마커 띄울때 사용하는 함수
  void updateMarker(LatLng position) {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: UniqueKey().toString(),
          latLng: position,
        ),
      );
      mapController.setCenter(position);
    });
  }

  //마커가 찍혀도 화면이 움직이지 않게 하기위한 함수
  void updateMarker_not_center_move(LatLng position) {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: UniqueKey().toString(),
          latLng: position,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: KakaoMap(
                  onMapCreated: (controller) async {
                    mapController = controller;
                    LatLng initialPosition = LatLng(mapcentermanager.mapCenterlatitude, mapcentermanager.mapCenterlongitude);
                    updateMarker(initialPosition);
                  },
                  markers: markers.toList(),
                  center: LatLng(mapcentermanager.mapCenterlatitude, mapcentermanager.mapCenterlongitude),
                  onMarkerTap: (String markerId, LatLng position, int index) async{
                  },
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      backgroundColor: Colors.white,
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
                        Icons.my_location,
                        color: isTracking ? Colors.blue : Colors.black87 , // 상태에 따라 색상 변경
                      ),
                    ),
                    const SizedBox(height: 20),
                    FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        level = level - 1;
                        mapController.setLevel(level);
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 20),
                    FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        level = level + 1;
                        mapController.setLevel(level);
                      },
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: FloatingActionButton.extended(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                        backgroundColor : Colors.white,
                        onPressed: () async {
                          //추가하기 버튼이 이미 한번 눌렸던 상태였다면
                          if (isRunning) {
                            setState(() {
                              isRunning = false;
                              var moveLatLon = LatLng(mapcentermanager.mapCenterlatitude - 0.00125, mapcentermanager.mapCenterlongitude);
                              mapController.panTo(moveLatLon);
                              showModalBottomSheet(
                                context: context,
                                barrierColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (context) {
                                  return BottomSheetContent();
                                },
                              );
                            });
                          } 
                          //아니면 무한반복으로 현재 화면 중간에 마커 생성
                          else {
                            setState(() {
                              isRunning = true;
                            });

                            while (isRunning) {
                              await Future.delayed(Duration(milliseconds: 10));
                              LatLng center = await mapController.getCenter();
                              mapcentermanager.mapCenterlongitude = center.longitude;
                              mapcentermanager.mapCenterlatitude = center.latitude;
                              updateMarker_not_center_move(center);
                            }
                          }
                        },
                        label: const Text('추가하기', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}

//사용자가 정보를 작성하는 칸
class BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: '해당 위치 이름을 작성해 주세요',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // 이미지 추가 로직 구현
            },
            child: Text('이미지 추가하기'),
          ),
          SizedBox(height: 16),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              labelText: '내용을 적어주세요',
              border: OutlineInputBorder(),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // 제출 로직 구현
                },
                child: Text('제출하기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
