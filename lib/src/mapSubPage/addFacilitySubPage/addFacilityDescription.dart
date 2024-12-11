import 'package:flutter/material.dart';

import 'package:facilities_info/src/mapSubPage/addFacilitySubPage/addFacilityFinalCheck.dart';

import 'package:facilities_info/SingleTone/nowAddFacility.dart';
import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';

class AddFacilityDescriptionPage extends StatefulWidget {
  @override
  _AddFacilityDescriptionPageState createState() => _AddFacilityDescriptionPageState();
}

class _AddFacilityDescriptionPageState extends State<AddFacilityDescriptionPage> {
  final fontSizeManager = FontSizeManager();
  final NowAddFacility facility = NowAddFacility();

  final TextEditingController _descriptionController = TextEditingController();
  String? _descriptionError;

  // 다음 버튼 클릭 시
  void _onNextPressed() {
    setState(() {
      _descriptionError = null;
    });

    if (_descriptionController.text.isEmpty) {
      setState(() {
        _descriptionError = "시설에 대한 설명을 입력해 주세요.";
      });
      return;
    }

    // 설명 저장
    facility.description = _descriptionController.text;

    // 다음 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFacilityFinalCheckPage()),
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

                    Text(
                      "시설에 대한\n설명을 입력해 주세요",
                      style: TextStyle(
                        color: AppColors.fontPrimary,
                        fontSize: fontSizeManager.fontSize + 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    // 설명 입력 필드
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 8,
                      maxLength: 500,
                      decoration: InputDecoration(
                        labelText: "시설 설명",
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          color: AppColors.fontTertiary,
                          fontSize: fontSizeManager.fontSize,
                        ),
                        hintText: "시설의 주요 특징과 설명을 입력해 주세요.",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: fontSizeManager.fontSize - 1,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.lineColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.mainColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorText: _descriptionError,
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
