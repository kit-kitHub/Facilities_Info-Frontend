import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_controller.dart';

class FacilityEditScreen extends StatefulWidget {
  @override
  _FacilityEditScreenState createState() => _FacilityEditScreenState();
}

class _FacilityEditScreenState extends State<FacilityEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _updateFacility(int facilityId) async {
    final response = await ApiController.updateFacilityWithImages(
      facilityId,
      _nameController.text,
      _addressController.text,
      _descriptionController.text,
      _images,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Facility updated successfully')));
      Navigator.pop(context); // 이전 화면으로 이동
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update facility')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final int facilityId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Facility'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 16),
            _images.isEmpty
                ? Text('No images selected.')
                : Wrap(
              children: _images.map((image) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(image, width: 100, height: 100, fit: BoxFit.cover),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _updateFacility(facilityId),
              child: Text('Update Facility'),
            ),
          ],
        ),
      ),
    );
  }
}
