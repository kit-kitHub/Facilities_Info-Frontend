import 'package:flutter/material.dart';

import 'AddLocationFacType.dart';
import '../../SingleTone/font.dart';

class AddDetailedLocationScreen extends StatelessWidget {
  final TextEditingController _descriptionController = TextEditingController();
  final fontSizeManager = FontSizeManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '추가하기',
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSizeManager.fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              '시설물의 상세 위치를\n입력해 주세요',
              style: TextStyle(
                fontSize: fontSizeManager.fontSize + 4,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: '상세 위치',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: fontSizeManager.fontSize,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 8),
            Text(
              '(예 : 2층 복도)',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: fontSizeManager.fontSize - 2,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  String detail_text = _descriptionController.text.trim();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectFacilityTypeScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2AAE66)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '다음',
                  style: TextStyle(
                    color: const Color(0xFF2AAE66),
                    fontSize: fontSizeManager.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}