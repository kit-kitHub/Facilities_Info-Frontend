import 'package:flutter/material.dart';

import 'package:facilities_info/src/mapSubPage/addFacilitySubPage/addFacilityRating.dart';

import 'package:facilities_info/SingleTone/nowAddFacility.dart';
import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';

class AddFacilityTypePage extends StatefulWidget {
  @override
  _AddFacilityTypePageState createState() => _AddFacilityTypePageState();
}

class _AddFacilityTypePageState extends State<AddFacilityTypePage> {
  final fontSizeManager = FontSizeManager();
  final NowAddFacility facility = NowAddFacility();

  final List<String> facilityTypes = [
    "경사로",
    "엘리베이터",
    "장애인 화장실",
    "장애인 주차장",
    "의료시설",
    "복지시설"
  ];

  String? _selectedFacilityType;
  String? _selectionError;

  // 다음 버튼 클릭 시
  void _onNextPressed() {
    setState(() {
      _selectionError = null;
    });

    if (_selectedFacilityType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("시설 종류를 선택해 주세요."))
      );
      return;
    }

    // 시설 종류 저장
    facility.facilityType = _selectedFacilityType!;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFacilityRatingPage()),
    );
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),

            Text(
              "시설의 종류를\n선택해 주세요",
              style: TextStyle(
                color: AppColors.fontPrimary,
                fontSize: fontSizeManager.fontSize + 2,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            // 시설 종류 선택 필드
            DropdownButtonFormField<String>(
              value: _selectedFacilityType,
              hint: Text(
                "시설 종류 선택",
                style: TextStyle(
                  fontSize: fontSizeManager.fontSize,
                  color: AppColors.fontTertiary,
                ),
              ),
              items: facilityTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: fontSizeManager.fontSize,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFacilityType = value;
                });
              },
              decoration: InputDecoration(
                labelText: "시설 종류",
                labelStyle: TextStyle(
                  color: AppColors.fontTertiary,
                  fontSize: fontSizeManager.fontSize,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lineColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainColor),
                ),
                errorText: _selectionError,
                errorStyle: TextStyle(
                  color: AppColors.errorColor,
                  fontSize: fontSizeManager.fontSize - 2,
                ),
              ),
            ),

            SizedBox(height: 30),

            Spacer(),

            // 다음 버튼
            FI_MainButton(
              text: "다음",
              onPressed: _onNextPressed,
              backgroundColor: Colors.white,
              borderColor: AppColors.mainColor,
              textColor: AppColors.mainColor,
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
