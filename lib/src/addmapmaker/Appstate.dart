import 'dart:io';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  void setSelectedImage(File? image) {
    _selectedImage = image;
    notifyListeners(); // 상태 변경 알림
  }
}