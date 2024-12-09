import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'Appstate.dart';

import 'dart:io';

import 'AddLocationfacName.dart';
import '/SingleTone/fontSizeManager.dart';

class AddFacilityScreen extends StatefulWidget {
  @override
  _AddFacilityScreenState createState() => _AddFacilityScreenState();
}

class _AddFacilityScreenState extends State<AddFacilityScreen> {
  final fontSizeManager = FontSizeManager();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        Provider.of<AppState>(context, listen: false)
            .setSelectedImage(_selectedImage); // 이미지 설정
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '추가하기',
          style: TextStyle(color: Colors.black, fontSize: fontSizeManager.fontSize),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Text(
              '시설물의 사진을\n업로드해 주세요',
              style: TextStyle(fontSize: fontSizeManager.fontSize + 2),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: _selectedImage == null
                    ? Text(
                  '(사진 업로드 버튼)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: fontSizeManager.fontSize,
                  ),
                )
                    : Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Spacer(),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddLocationfacNameScreen(),
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
