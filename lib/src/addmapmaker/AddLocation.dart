import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/SingleTone/fontSizeManager.dart';
import '../../SingleTone/map_center.dart';
import 'AddLocationimg.dart';

class AddLocationScreen extends StatefulWidget {
  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  late KakaoMapController mapController;
  final mapcentermanager = mapCenterManager();
  LatLng? currentCenter; // 현재 지도 중심 좌표 저장
  Set<Marker> centerMarker = {};// 중심 마커
  final fontSizeManager = FontSizeManager();

  @override
  void initState() {
    super.initState();
    // 초기 중심 좌표 설정
    currentCenter = LatLng(mapcentermanager.mapCenterlatitude, mapcentermanager.mapCenterlongitude);
    centerMarker.add(
      Marker(
        markerId: 'center_marker',
        latLng: currentCenter!,
      )
    );
  }


  Future<void> _saveData(String lat, String lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lat', lat);
    await prefs.setString('lat', lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추가하기'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: fontSizeManager.fontSize + 2),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              '지도를 움직여\n추가할 시설의 위치를 설정해 주세요',
              style: TextStyle(fontSize: fontSizeManager.fontSize, color: Colors.black),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: KakaoMap(
                    onMapCreated: (controller) async {
                      mapController = controller;
                      mapController.setLevel(mapcentermanager.level);

                    },
                    markers: centerMarker.toList(),
                    onCameraIdle: (LatLng position, int level) async {
                      centerMarker.clear();
                      setState(() {
                        currentCenter = position; // 현재 중심 좌표 업데이트
                        centerMarker.add(
                            Marker(
                              markerId: 'center_marker',
                              latLng: currentCenter!,
                            )
                        );
                      });
                    },
                    center: LatLng(mapcentermanager.mapCenterlatitude, mapcentermanager.mapCenterlongitude),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width:  MediaQuery.of(context).size.width * 0.9, // 버튼이 부모의 모든 가로 영역을 차지하도록 설정
            child: OutlinedButton(
              onPressed: () {
                _saveData(currentCenter!.latitude.toString(), currentCenter!.longitude.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFacilityScreen(),
                  ),
                );
              },
              child: Text(
                '다음',
                style: TextStyle(color: Colors.green, fontSize: fontSizeManager.fontSize),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        SizedBox(height: 10, width: 10),
        ],
      ),
    );
  }
}