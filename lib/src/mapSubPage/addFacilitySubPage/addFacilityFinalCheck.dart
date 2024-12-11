import 'dart:io';
import 'package:flutter/material.dart';

import 'package:facilities_info/Controller/facilitiesController.dart';

import 'package:facilities_info/SingleTone/nowAddFacility.dart';
import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/models/facility.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';

class AddFacilityFinalCheckPage extends StatefulWidget {
  @override
  _AddFacilityFinalCheckPageState createState() =>
      _AddFacilityFinalCheckPageState();
}

class _AddFacilityFinalCheckPageState
    extends State<AddFacilityFinalCheckPage> {
  final fontSizeManager = FontSizeManager();
  final NowAddFacility facility = NowAddFacility();

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSizeManager.fontSize,
              color: AppColors.fontPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(
                color: AppColors.lineColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value.isNotEmpty ? value : "입력되지 않음",
              style: TextStyle(
                fontSize: fontSizeManager.fontSize,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirmPressed() async {
    try {
      // newLocation 인지 확인
      if (facility.newLocation == true) {
        final facilityData = {
          'name': facility.locationName,
          // 'address': facility.address,
          'latitude': facility.latitude,
          'longitude': facility.longitude,
        };

        await FacilitiesController.createFacility(facilityData, [File(facility.imagePath!)]);

        facility.newLocation = false;
      }

      if (facility.locationId == null) {
        // 방금 생성한 Facility의 id 획득
        final List<Facility> facilities = await FacilitiesController.searchFacilities(
          name: facility.locationName,
        );

        if (facilities.isNotEmpty) {
          facility.locationId = facilities.first.id;
        } else {
          throw Exception("시설 ID를 가져오는 데 실패했습니다.");
        }
      }

      // detailedLocation 등록
      final detatiledData = {
        'location': facility.locationDetail,
        'rating': facility.rating,
        'latitude': facility.latitude,
        'longitude': facility.longitude,
        'facilityId': facility.locationId,
      };

      await FacilitiesController.createDetailedLocation(detatiledData, [File(facility.imagePath!)]);
    } catch (e) {
      print("시설 추가 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('시설 추가에 실패했습니다.\n다시 시도해 주세요'))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.fontSecondary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 80),

                    Text(
                      "입력한 내용을 확인해 주세요",
                      style: TextStyle(
                        color: AppColors.fontPrimary,
                        fontSize: fontSizeManager.fontSize + 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    _buildReadOnlyField("장소 이름", facility.locationName ?? ""),
                    _buildReadOnlyField("상세 위치", facility.locationDetail ?? ""),
                    _buildReadOnlyField("시설 종류", facility.facilityType ?? ""),
                    _buildReadOnlyField("편의성 평가", facility.rating ?? ""),
                    _buildReadOnlyField("설명", facility.description ?? ""),

                    SizedBox(height: 30),

                    Spacer(),

                    FI_MainButton(
                      text: "확인",
                      onPressed: _onConfirmPressed,
                      backgroundColor: AppColors.mainColor,
                      textColor: Colors.white,
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
