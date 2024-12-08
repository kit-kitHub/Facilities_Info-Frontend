import 'package:flutter/material.dart';

import 'package:facilities_info/SingleTone/fontSizeManager.dart';


class FI_MainButton extends StatelessWidget {
  final fontSizeManager = FontSizeManager();  // FontSizeManager 로드
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  FI_MainButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: borderColor != null
            ? BorderSide(color: borderColor!) // 테두리 색상
            : null,
        minimumSize: Size(double.infinity, 50), // 버튼 크기
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // 둥근 모서리
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSizeManager.fontSize + 2,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
