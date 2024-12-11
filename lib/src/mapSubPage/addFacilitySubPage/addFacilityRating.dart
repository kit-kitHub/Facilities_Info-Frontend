import 'package:flutter/material.dart';

import 'package:facilities_info/src/mapSubPage/addFacilitySubPage/addFacilityDescription.dart';

import 'package:facilities_info/SingleTone/nowAddFacility.dart';
import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';

class AddFacilityRatingPage extends StatefulWidget {
  @override
  _AddFacilityRatingPageState createState() => _AddFacilityRatingPageState();
}

class _AddFacilityRatingPageState extends State<AddFacilityRatingPage> {
  final fontSizeManager = FontSizeManager();
  final NowAddFacility facility = NowAddFacility();

  String? _selectedRating;
  String? _ratingError;

  // 다음 버튼 클릭 시
  void _onNextPressed() {
    setState(() {
      _ratingError = null;
    });

    if (_selectedRating == null) {
      setState(() {
        _ratingError = "시설의 편의성을 평가해 주세요.";
      });
      return;
    }

    facility.rating = _selectedRating!;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFacilityDescriptionPage()),
    );
  }

  // 평가 버튼 위젯 생성
  Widget _buildRatingButton(String label, IconData icon, String rating, Color highlightColor) {
    final isSelected = _selectedRating == rating;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRating = rating;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          color: isSelected ? highlightColor : Colors.white,
          border: Border.all(
            color: isSelected ? highlightColor : AppColors.lineColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.fontPrimary,
              size: 40,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSizeManager.fontSize,
                color: isSelected ? Colors.white : AppColors.fontPrimary,
              ),
            ),
          ],
        ),
      ),
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

            // 설명 텍스트
            Text(
              "시설의 편의성을\n평가해 주세요",
              style: TextStyle(
                color: AppColors.fontPrimary,
                fontSize: fontSizeManager.fontSize + 2,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            if (_ratingError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _ratingError!,
                  style: TextStyle(
                    color: AppColors.errorColor,
                    fontSize: fontSizeManager.fontSize - 2,
                  ),
                ),
              ),

            // 평가 버튼 그룹
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRatingButton("좋아요", Icons.thumb_up, "좋아요", AppColors.mainColor),
                _buildRatingButton("아쉬워요", Icons.thumb_down, "아쉬워요", AppColors.errorColor),
              ],
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
