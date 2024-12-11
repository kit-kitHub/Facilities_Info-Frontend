import 'package:flutter/material.dart';

import 'package:facilities_info/src/mapSubPage/addFacilitySubPage/addFacilityType.dart';

import 'package:facilities_info/SingleTone/nowAddFacility.dart';
import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';

class AddFacilityLocationDetailPage extends StatefulWidget {
  @override
  _AddFacilityLocationDetailPageState createState() =>
      _AddFacilityLocationDetailPageState();
}

class _AddFacilityLocationDetailPageState
    extends State<AddFacilityLocationDetailPage> {
  final fontSizeManager = FontSizeManager(); // 폰트 크기 관리자
  final NowAddFacility facility = NowAddFacility(); // 시설 정보 저장 객체

  final TextEditingController _locationDetailController =
  TextEditingController(); // 상세 위치 입력 컨트롤러

  String? _locationDetailError; // 오류 메시지

  // 다음 버튼 클릭 시
  void _onNextPressed() {
    setState(() {
      _locationDetailError = null; // 오류 초기화
    });

    if (_locationDetailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("상세 위치를 입력해 주세요."))
      );
      return;
    }

    // 상세 위치 값 저장
    facility.locationDetail = _locationDetailController.text.trim();

    // 다음 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFacilityTypePage()),
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

                    // 설명 텍스트
                    Text(
                      "시설이 위치한\n상세 위치를 입력해 주세요",
                      style: TextStyle(
                        color: AppColors.fontPrimary,
                        fontSize: fontSizeManager.fontSize + 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    // 상세 위치 입력 필드
                    TextField(
                      controller: _locationDetailController,
                      decoration: InputDecoration(
                        labelText: "상세 위치",
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
                        errorText: _locationDetailError,
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
            ),
          );
        },
      ),
    );
  }
}
