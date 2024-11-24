import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map/map_Info.dart'; //마커 정보 파일
import 'map/address_to_LatLng.dart'; //주소를 좌표로 변환
import 'map/geolocation.dart'; //현재 위치 받아오기
import 'map/makerInfo.dart'; //마커 누르면 정보 보여주는 화면
import 'map/userCreate.dart'; //추가하기 받아오기
import 'map/Locations.dart'; //주위 정보 받아오기
import '/SingleTone/map_center.dart';//화면 이동해도 화면 남아있게 하기위해 사용하는 싱글톤


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MapScreen> with WidgetsBindingObserver{
  late KakaoMapController mapController;
  Set<Marker> markers = {}; // Marker variable
  String? latitude;
  String? longitude;
  bool isTracking = false;
  int level = 4;
  bool isRunning = false;
  final mapcentermanager = mapCenterManager();

  //마커 띄울때 사용하는 함수
  void updateMarker(LatLng position) {
    setState(() {
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

  void SingleToneclear() async{
    await mapCenterManager().initialize();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // AppLifecycleState 감지 활성화
    mapCenterManager().initialize(); // 싱글톤 초기화

    _restoreLastPosition(); // 마지막 위치 복원
  }

  Future<void> _restoreLastPosition() async {
    final prefs = await SharedPreferences.getInstance();

    // SharedPreferences에서 저장된 위치 불러오기
    double latitude = prefs.getDouble('last_latitude') ?? mapcentermanager.mapCenterlatitude;
    double longitude = prefs.getDouble('last_longitude') ?? mapcentermanager.mapCenterlongitude;

    // 지도 중심 위치 복원
    LatLng lastPosition = LatLng(latitude, longitude);
    mapController.setCenter(lastPosition);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // 현재 지도 중심 좌표 가져오기
      LatLng center = await mapController.getCenter();

      // SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('last_latitude', center.latitude);
      await prefs.setDouble('last_longitude', center.longitude);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Observer 해제
    super.dispose();
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
                      for (var positions in positions_list) {
                        List<Location> locations = await locationFromAddress(positions['address']);
                        LatLng newPosition = LatLng(locations[0].latitude, locations[0].longitude);
                        updateMarker(newPosition);
                      }
                    },
                  onZoomChangeCallback: (maplevel, context){
                    level = maplevel;
                  },
                  clusterer: Clusterer(
                    markers: markers.toList(),
                    minLevel: 10,
                    averageCenter: true
                  ),
                  zoomControl: false,
                  markers: markers.toList(),
                  center: LatLng(mapcentermanager.mapCenterlatitude, mapcentermanager.mapCenterlongitude),
                  onMarkerTap: (String markerId, LatLng position, int index1) async{

                    final Map<String, dynamic> foundPosition = findAddressInList(position.latitude, position.longitude, positions_list) as Map<String, dynamic>;
                    mapController.setCenter(position);
                    level = 4;
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true, // 전체 화면 확장 가능
                      builder: (BuildContext context) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.5, // 초기 크기: 화면의 절반
                          minChildSize: 0.3, // 최소 크기
                          maxChildSize: 0.9, // 최대 크기
                          builder: (BuildContext context,
                              ScrollController scrollController) {
                            return DraggableSheet(
                              scrollController: scrollController,
                              title: foundPosition['title'],
                              address: foundPosition['address'],
                              imageUrl: foundPosition['imageUrl'],
                              description: foundPosition['description'],
                              rating: foundPosition['rating'],
                            );
                          },
                        );
                      },
                    );
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
                            startTracking();
                            updateMarker(LatLng(mapcentermanager.mapCenterlatitude, mapcentermanager.mapCenterlongitude));// 추적 시작
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
                left: 20,
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
                                  return BottomSheetContent_find();
                                },
                              );
                            });
                          }
                          else {
                            setState(() {
                              isRunning = true;
                            });

                            while (isRunning) {
                              await Future.delayed(Duration(milliseconds: 10));
                              LatLng center = await mapController.getCenter();
                              mapcentermanager.setMapCenterLongitude(center.longitude);
                              mapcentermanager.setMapCenterLatitude(center.latitude);
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
                          LatLng center = await mapController.getCenter();
                          PositionListScreen(positions: positions_list, center: center);
                        },
                        label: const Text('정보보기', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
          ]
        ),
      ),
    );
  }
}
