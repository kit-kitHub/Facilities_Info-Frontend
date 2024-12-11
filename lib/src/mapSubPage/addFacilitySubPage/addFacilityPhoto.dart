import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'package:facilities_info/src/mapSubPage/addFacilitySubPage/addFacilityLocation.dart';

import 'package:facilities_info/SingleTone/nowAddFacility.dart';
import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/styles/color.dart';

import 'package:facilities_info/widgets/fi_mainButton.dart';

class AddFacilityPhotoPage extends StatefulWidget {
  @override
  _AddFacilityPhotoPageState createState() => _AddFacilityPhotoPageState();
}

class _AddFacilityPhotoPageState extends State<AddFacilityPhotoPage> {
  final fontSizeManager = FontSizeManager(); // 폰트 크기 관리자
  NowAddFacility facility = NowAddFacility(); // 시설 정보 저장 객체

  XFile? _selectedImage;
  double? _imageAspectRatio; // 이미지 비율 저장

  // 이미지 선택 함수
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(source: source);
      if (image != null) {
        final file = File(image.path);
        final imageBytes = await file.readAsBytes();
        final decodedImage = img.decodeImage(imageBytes);

        if (decodedImage != null) {
          setState(() {
            _selectedImage = image;
            _imageAspectRatio = decodedImage.width / decodedImage.height;
            facility.imagePath = image.path; // 이미지 경로 저장
          });
        }
      }
    } catch (e) {
      print("이미지 선택 오류: $e");
    }
  }

  void _onNextPressed() {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("사진을 업로드해 주세요.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFacilityLocationPage()),
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
                      "시설의 사진을\n업로드해 주세요",
                      style: TextStyle(
                        color: AppColors.fontPrimary,
                        fontSize: fontSizeManager.fontSize + 2, // 기본 크기 + 2
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    // 이미지 업로드 컨테이너
                    GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.lineColor,
                            width: 1,
                          ),
                        ),
                        child: _selectedImage == null
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_camera, size: 50, color: Colors.grey
                                .shade600),
                            SizedBox(height: 10),
                            Text(
                              "사진 업로드",
                              style: TextStyle(
                                fontSize: fontSizeManager.fontSize,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        )
                            : AspectRatio(
                          aspectRatio: _imageAspectRatio ?? 16 / 9, // 이미지 비율 적용
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(_selectedImage!.path),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    // 카메라로 촬영 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
                      children: [
                        TextButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: Icon(Icons.camera_alt, color: AppColors.mainColor),
                          label: Text(
                            "카메라로 촬영",
                            style: TextStyle(
                              color: AppColors.mainColor,
                              fontSize: fontSizeManager.fontSize,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

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
