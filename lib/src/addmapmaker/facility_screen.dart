import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'facility.dart';
import 'facility_controller.dart';
import 'facility_detail_screen.dart';

class FacilityScreen extends StatefulWidget {
  @override
  _FacilityScreenState createState() => _FacilityScreenState();
}

class _FacilityScreenState extends State<FacilityScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Facility>> futureFacilities;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  FacilityType? _selectedType;
  List<File> _imageFiles = [];

  @override
  void initState() {
    super.initState();
    futureFacilities = apiService.searchFacilities();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
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

  void _createFacility() async {
    if (_formKey.currentState!.validate()) {
      final facilityData = {
        'name': _nameController.text,
        'address': _addressController.text,
        'description': _descriptionController.text,
        'type': _selectedType!.name,
        'latitude': 0.0, // 실제 위도 값으로 대체
        'longitude': 0.0, // 실제 경도 값으로 대체
      };

      try {
        await apiService.createFacility(facilityData, _imageFiles);
        setState(() {
          futureFacilities = apiService.searchFacilities();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Facility created successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create facility')));
      }
    }
  }

  void _deleteFacility(int facilityId) async {
    try {
      await apiService.deleteFacility(facilityId);
      setState(() {
        futureFacilities = apiService.searchFacilities();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Facility deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete facility')));
    }
  }

  void _viewFacilityDetail(Facility facility) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FacilityDetailScreen(facility: facility)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facilities'),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<FacilityType>(
                  decoration: InputDecoration(labelText: 'Type'),
                  value: _selectedType,
                  items: FacilityType.values.map((FacilityType type) {
                    return DropdownMenuItem<FacilityType>(
                      value: type,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (FacilityType? newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a type';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: Text('Pick Images'),
                ),
                ElevatedButton(
                  onPressed: _createFacility,
                  child: Text('Create Facility'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Facility>>(
              future: futureFacilities,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(snapshot.data![index].address),
                        onTap: () => _viewFacilityDetail(snapshot.data![index]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteFacility(snapshot.data![index].id),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
