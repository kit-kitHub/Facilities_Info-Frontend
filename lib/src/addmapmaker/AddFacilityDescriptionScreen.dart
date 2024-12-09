import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '/main.dart';
import '/SingleTone/fontSizeManager.dart';
import 'Appstate.dart';
import 'facility.dart';
import 'facility_controller.dart';


class AddFacilityDescriptionScreen extends StatefulWidget {
  const AddFacilityDescriptionScreen({super.key});

  @override
  State<AddFacilityDescriptionScreen> createState() => _AddFacilityDescriptionScreenState();
}

class _AddFacilityDescriptionScreenState extends State<AddFacilityDescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  late Future<List<Facility>> futureFacilities;
  final TextEditingController _descriptionController = TextEditingController();
  final fontSizeManager = FontSizeManager();

  Future<void> _saveData(String FacDetailadd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('facdescrition', FacDetailadd);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _createFacility() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      final facilityData = {
        'name': prefs.getString('facName'),
        'address': prefs.getString('facaddress'),
        'description': prefs.getString('facdescrition'),
        'type': prefs.getString('facType'),
        'latitude': prefs.getString('lat'),
        'longitude': prefs.getString('lng'),
      };


      File? image = Provider.of<AppState>(context).selectedImage;

      try {
        await apiService.createFacility(facilityData, image as List<File>);
        setState(() {
          futureFacilities = apiService.searchFacilities();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Facility created successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create facility')));
      }
    }
  }

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
              '시설물에 대한\n설명을 적어주세요',
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
                hintText: '설명',
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
              maxLines: 5,
              minLines: 1,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Handle completion with description
                  final description = _descriptionController.text;
                  _saveData(description);
                  _createFacility;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2AAE66),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '완료',
                  style: TextStyle(
                    color: Colors.white,
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