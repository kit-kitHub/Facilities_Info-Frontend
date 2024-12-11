import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'package:facilities_info/src/mapSubPage/addFacilitySubPage/addFacilityPhoto.dart';

import 'package:facilities_info/SingleTone/nowAddFacility.dart';
import 'package:facilities_info/SingleTone/map_center.dart';

import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';


class AddFacilityPage extends StatefulWidget {
  @override
  _AddFacilityPageState createState() => _AddFacilityPageState();
}

class _AddFacilityPageState extends State<AddFacilityPage> {
  final fontSizeManager = FontSizeManager(); // FontSizeManager 로드

  NowAddFacility facility = NowAddFacility(); // 현재 추가중인 시설 정보 저장

  // 지도 표시 관련
  late KakaoMapController mapController;
  final mapcentermanager = mapCenterManager();
  LatLng? currentCenter;
  Set<Marker> centerMarker = {};


  void _onNextPressed() {
    // longitude 및 latitude 저장
    if (currentCenter != null) {
      facility.latitude = currentCenter!.latitude;
      facility.longitude = currentCenter!.longitude;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("시설의 위치를 설정해 주세요.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFacilityPhotoPage()),
    );
  }

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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.fontSecondary), // Font Secondary Color 적용
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),

            // 설명 텍스트
            Text(
              "지도를 움직여\n추가할 시설의 위치를 설정해 주세요",
              style: TextStyle(
                color: AppColors.fontPrimary, // Font Primary Color 적용
                fontSize: fontSizeManager.fontSize + 2, // 기본 크기 + 2
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            // 지도
            Expanded(
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

            SizedBox(height: 150),

            // Spacer(),

            // 다음 버튼
            FI_MainButton(
              text: "다음",
              onPressed: _onNextPressed,
              backgroundColor: Colors.white, // 버튼 배경 투명
              borderColor: AppColors.mainColor, // 테두리 색상
              textColor: AppColors.mainColor, // 텍스트 색상
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
