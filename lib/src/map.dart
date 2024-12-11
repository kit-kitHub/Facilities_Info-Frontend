import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:facilities_info/src/search.dart';
import 'package:facilities_info/src/mapSubPage/addFacility.dart';

import 'package:facilities_info/Controller/geo_coordinates_service.dart';

import 'map/makerInfo.dart'; //마커 누르면 정보 보여주는 화면
import 'map/Locations.dart'; //주위 정보 받아오기

import 'package:facilities_info/SingleTone/map_center.dart';//화면 이동해도 화면 남아있게 하기위해 사용하는 싱글톤


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MapScreen> with WidgetsBindingObserver{
  late KakaoMapController mapController;
  StreamSubscription<Position>? positionStream;
  Set<Marker> markers = {}; // Marker variable
  String? latitude;
  String? longitude;
  bool isTracking = false;
  bool isRunning = false;
  int currentLevel = mapCenterManager().level;
  final mapcentermanager = mapCenterManager();

  //마커 띄울때 사용하는 함수
  void updateMarker_Map_Info(LatLng position) {
    setState(() {
      markers.add(
        Marker(
          markerId: UniqueKey().toString(),
          latLng: position,
        ),
      );
    });
  }

  void updateMarker_Camera_Center_Move(LatLng position) {
    setState(() {
      markers.add(
        Marker(
          markerId: UniqueKey().toString(),
          latLng: position,
        ),
      );
      mapcentermanager.setMapCenterLongitude(position.longitude);
      mapcentermanager.setMapCenterLatitude(position.latitude);
    });
  }

  //마커가 찍혀도 화면이 움직이지 않게 하기위한 함수
  void updateMarker_Use_Add(LatLng position) {
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
    _restoreCurrentLevel(); // 마지막 레벨 복원
  }

  Future<void> _saveCurrentLevel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('map_level', currentLevel);
  }

  Future<void> _restoreCurrentLevel() async {
    final prefs = await SharedPreferences.getInstance();
    currentLevel = prefs.getInt('map_level') ?? mapCenterManager().level;
    mapController.setLevel(currentLevel); // 복원된 레벨 적용
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

      await _saveCurrentLevel(); // 레벨 저장
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Observer 해제
    super.dispose();
  }

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
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      mapcentermanager.setMapCenterLongitude(position.longitude);
      mapcentermanager.setMapCenterLatitude(position.latitude);
      mapController.setCenter(LatLng(mapcentermanager.mapCenterlatitude, mapcentermanager.mapCenterlongitude));
    });
  }

// 위치 추적을 중지하는 함수
  void stopTracking() {
    positionStream?.cancel();  // 위치 추적 취소
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
                    List<GeoCoordinates> positionsList = await fetchGeoCoordinates(36.1465, 128.3935, 10);
                    controller.setLevel(mapcentermanager.level);
                    for (var position in positionsList) {
                      LatLng newPosition = LatLng(position.latitude, position.longitude);
                      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
                      updateMarker_Map_Info(newPosition);
                      }
                    },
                    markers: markers.toList(),
                  onZoomChangeCallback: (maplevel, context){
                    //zoomlevel저장
                    currentLevel = maplevel;
                    mapcentermanager.setLevel(maplevel);
                  },
                  clusterer: Clusterer(
                    markers: markers.toList(),
                    minLevel: 10,
                    averageCenter: true,
                  ),
                  zoomControl: false,
                  onCameraIdle: (LatLng postions, int maplevel){
                    mapcentermanager.setMapCenterLongitude(postions.longitude);
                    mapcentermanager.setMapCenterLatitude(postions.latitude);
                    //현재 level정보 저장
                    currentLevel = maplevel;
                    mapcentermanager.setLevel(maplevel);
                  },
                  center: LatLng(mapcentermanager.mapCenterlatitude, mapcentermanager.mapCenterlongitude),
                    onMarkerTap: (String markerId, LatLng position, int index1) async {
                      // 위치 정보 가져오기
                      List<GeoCoordinates> positionsList = await fetchGeoCoordinates(mapcentermanager.mapCenterlatitude, mapcentermanager.mapCenterlongitude, 10000.0);

                      // 해당 마커의 위치 찾기
                      final int index = positionsList.indexWhere((positions) {
                        // 소수점 4자리까지 반올림하여 비교
                        double lat1 = (positions.latitude * pow(10  , 4)).roundToDouble() / pow(10, 4);
                        double lon1 = (positions.longitude * pow(10, 4)).roundToDouble() / pow(10, 4);
                        double lat2 = (position.latitude * pow(10, 4)).roundToDouble() / pow(10, 4);
                        double lon2 = (position.longitude * pow(10, 4)).roundToDouble() / pow(10, 4);

                        return lat1 == lat2 && lon1 == lon2;
                      });
                      if (index == -1) return; // 위치를 찾지 못한 경우 처리

                      final GeoCoordinates foundPosition = positionsList[index];

                      // 화면 갱신 후 모달 표시 (지연을 추가)
                      mapController.setCenter(position);

                      //화면 확대 해서 보여주기
                      mapController.setLevel(1);

                      // 화면이 갱신될 시간을 주기 위해 잠시 딜레이
                      await Future.delayed(Duration(milliseconds: 300));

                      // 모달 바텀 시트 표시
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true, // 전체 화면 확장 가능
                        builder: (BuildContext context) {
                          return DraggableScrollableSheet(
                            initialChildSize: 0.5, // 초기 크기: 화면의 절반
                            minChildSize: 0.3, // 최소 크기
                            maxChildSize: 0.9, // 최대 크기
                            builder: (BuildContext context, ScrollController scrollController) {
                              return DraggableSheet(
                                scrollController: scrollController,
                                title: foundPosition.facility.name,
                                address: foundPosition.facility.address,
                                imageUrl: foundPosition.facility.imageUrl,
                                description: foundPosition.facility.address,
                                rating: foundPosition.facility.rating.toInt(),
                                facilityId: foundPosition.facility.id,
                              );
                            },
                          );
                        },
                      );
                    }
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
                          isTracking = !isTracking; // 상태를 먼저 토글
                        });

                        // 상태에 맞춰 추적 시작 또는 중지
                        if (isTracking) {
                          startTracking(); // 추적 시작
                        } else {
                          stopTracking();  // 추적 중지
                        }
                      },
                      child: Icon(
                        Icons.my_location,
                        color: isTracking ? Colors.blue : Colors.black87, // 상태에 따라 색상 변경
                      ),
                    ),
                    const SizedBox(height: 20),
                    FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        setState(() {
                          currentLevel = currentLevel - 1;
                        });
                        mapController.setLevel(currentLevel);
                        _saveCurrentLevel(); // 변경된 레벨 저장
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
                        setState(() {
                        currentLevel = currentLevel + 1;
                        });

                        mapController.setLevel(currentLevel);
                        _saveCurrentLevel(); // 변경된 레벨 저장
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddFacilityPage(),
                            ),
                          );
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
                          List<GeoCoordinates> positionsList = await fetchGeoCoordinates(36.1466, 128.3944, 10);
                          positionsList.sort((a, b) {
                            final double distanceA = LocationUtils.calculateDistance(
                              center.latitude,
                              center.longitude,
                              a.latitude,
                              a.longitude,
                            );
                            final double distanceB = LocationUtils.calculateDistance(
                              center.latitude,
                              center.longitude,
                              b.latitude,
                              b.longitude,
                            );
                            return distanceA.compareTo(distanceB); // 거리 기준 오름차순 정렬
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
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