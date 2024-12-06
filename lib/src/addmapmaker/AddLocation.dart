import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추가하기'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              '지도를 움직여\n추가할 시설의 위치를 설정해 주세요',
              style: TextStyle(fontSize: 16, color: Colors.black),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFacilityScreen(),
                  ),
                );
              },
              child: Text(
                '다음',
                style: TextStyle(color: Colors.green),
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