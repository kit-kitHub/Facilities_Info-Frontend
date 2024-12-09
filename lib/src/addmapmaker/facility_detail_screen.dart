import 'package:flutter/material.dart';
import 'facility.dart';
import 'detailed_location.dart';
import 'facility_controller.dart';
import 'detailed_location_screen.dart';
import 'detailed_location_detail_screen.dart';

class FacilityDetailScreen extends StatefulWidget {
  final Facility facility;

  FacilityDetailScreen({required this.facility});

  @override
  _FacilityDetailScreenState createState() => _FacilityDetailScreenState();
}

class _FacilityDetailScreenState extends State<FacilityDetailScreen> {
  final ApiService apiService = ApiService();

  void _addDetailedLocation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedLocationScreen(facilityId: widget.facility.id),
      ),
    );
  }

  void _deleteDetailedLocation(int detailedLocationId) async {
    try {
      await apiService.deleteDetailedLocation(detailedLocationId);
      setState(() {
        widget.facility.detailedLocations.removeWhere((dl) => dl.id == detailedLocationId);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Detailed location deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete detailed location')));
    }
  }

  void _viewDetailedLocation(DetailedLocation detailedLocation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedLocationDetailScreen(detailedLocation: detailedLocation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.facility.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.facility.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Address: ${widget.facility.address}'),
            SizedBox(height: 10),
            Text('Description: ${widget.facility.description}'),
            SizedBox(height: 10),
            Text('Rating: ${widget.facility.rating}'),
            SizedBox(height: 10),
            Text('Type: ${widget.facility.type.name}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addDetailedLocation(context),
              child: Text('Add Detailed Location'),
            ),
            SizedBox(height: 20),
            Text(
              'Detailed Locations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.facility.detailedLocations.length,
                itemBuilder: (context, index) {
                  DetailedLocation detailedLocation = widget.facility.detailedLocations[index];
                  return ListTile(
                    title: Text(detailedLocation.location),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rating: ${detailedLocation.rating}'),
                        Text('Latitude: ${detailedLocation.latitude}'),
                        Text('Longitude: ${detailedLocation.longitude}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteDetailedLocation(detailedLocation.id),
                    ),
                    onTap: () => _viewDetailedLocation(detailedLocation),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
