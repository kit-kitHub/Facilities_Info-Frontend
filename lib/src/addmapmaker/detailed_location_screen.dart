import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'facility_controller.dart';

class DetailedLocationScreen extends StatefulWidget {
  final int facilityId;

  DetailedLocationScreen({required this.facilityId});

  @override
  _DetailedLocationScreenState createState() => _DetailedLocationScreenState();
}

class _DetailedLocationScreenState extends State<DetailedLocationScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _ratingController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  List<File> _imageFiles = [];

  @override
  void dispose() {
    _locationController.dispose();
    _ratingController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  void _createDetailedLocation() async {
    if (_formKey.currentState!.validate()) {
      final detailedLocationData = {
        'location': _locationController.text,
        'rating': double.parse(_ratingController.text),
        'latitude': double.parse(_latitudeController.text),
        'longitude': double.parse(_longitudeController.text),
        'facilityId': widget.facilityId,
      };

      try {
        await apiService.createDetailedLocation(detailedLocationData, _imageFiles);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Detailed location created successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create detailed location')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Detailed Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ratingController,
                decoration: InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter latitude';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter longitude';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Pick Images'),
              ),
              ElevatedButton(
                onPressed: _createDetailedLocation,
                child: Text('Create Detailed Location'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
