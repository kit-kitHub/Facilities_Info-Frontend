import 'package:flutter/material.dart';

import 'package:facilities_info/src/mapSubPage/addFacilitySubPage/addFacilityLocationDetail.dart';

import 'package:facilities_info/SingleTone/nowAddFacility.dart';
import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/Controller/facilitiesController.dart';
import 'package:facilities_info/models/facility.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';

class AddFacilityLocationPage extends StatefulWidget {
  @override
  _AddFacilityLocationPageState createState() =>
      _AddFacilityLocationPageState();
}

class _AddFacilityLocationPageState extends State<AddFacilityLocationPage> {
  final fontSizeManager = FontSizeManager();
  final NowAddFacility facility = NowAddFacility();

  final TextEditingController _locationController = TextEditingController();
  String? _locationError;

  List<Facility> _searchResults = [];
  int? _selectedIndex;
  bool _isNewLocation = false;

  // 장소 검색 로직
  void _onLocationChanged(String value) async {
    setState(() {
      _selectedIndex = null;
      _isNewLocation = false;
    });

    if (value.isNotEmpty) {
      try {
        final results = await FacilitiesController.searchFacilities(name: value);
        setState(() {
          _searchResults = results;
        });
      } catch (e) {
        print("시설 검색 오류: $e");
      }
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  // 다음 버튼 동작
  void _onNextPressed() {
    setState(() {
      _locationError = null;
    });

    if (_isNewLocation || _selectedIndex == null) {
      facility.newLocation = true;
      facility.locationName = _locationController.text.trim();
      facility.locationId = null; // 새로운 장소는 ID가 없음
    } else {
      facility.newLocation = false;
      facility.locationName = _searchResults[_selectedIndex!].name;
      facility.locationId = _searchResults[_selectedIndex!].id; // ID 저장
    }

    if (facility.locationName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("장소를 선택하거나 새 장소를 추가해 주세요.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFacilityLocationDetailPage()),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),

                Text(
                  "시설이 위치한\n장소의 이름을 입력해 주세요",
                  style: TextStyle(
                    color: AppColors.fontPrimary,
                    fontSize: fontSizeManager.fontSize + 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                TextField(
                  controller: _locationController,
                  onChanged: _onLocationChanged,
                  decoration: InputDecoration(
                    labelText: "장소 이름",
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
                    errorText: _locationError,
                    errorStyle: TextStyle(
                      color: AppColors.errorColor,
                      fontSize: fontSizeManager.fontSize - 2,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                if (_searchResults.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final facility = _searchResults[index];
                      final isSelected = _selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                            _isNewLocation = false;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.mainColor
                                  : AppColors.lineColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                facility.name,
                                style: TextStyle(
                                  fontSize: fontSizeManager.fontSize,
                                  color: Colors.black,
                                ),
                              ),
                              if (facility.address != null)
                                Text(
                                  facility.address!,
                                  style: TextStyle(
                                    fontSize: fontSizeManager.fontSize - 2,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                SizedBox(height: 20),

                // 새로운 장소 추가 버튼
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isNewLocation = true;
                      _selectedIndex = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isNewLocation
                            ? AppColors.mainColor
                            : AppColors.lineColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "새로운 장소 추가",
                        style: TextStyle(
                          color: AppColors.fontPrimary,
                          fontSize: fontSizeManager.fontSize,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 120), // 여유 공간
              ],
            ),
          ),

          // 하단 고정 버튼
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FI_MainButton(
                text: "다음",
                onPressed: _onNextPressed,
                backgroundColor: Colors.white,
                borderColor: AppColors.mainColor,
                textColor: AppColors.mainColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
