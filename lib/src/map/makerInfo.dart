import 'package:flutter/material.dart';
import '../addmapmaker/facility.dart';
import '../addmapmaker/facility_controller.dart';
import '/SingleTone/fontSizeManager.dart';
import 'detailaddress.dart';

class DraggableSheet extends StatefulWidget {
  final ScrollController scrollController;
  final String title;
  final String address;
  final String imageUrl;
  final String description;
  final int rating;
  final int facilityId;

  DraggableSheet({
    required this.scrollController,
    required this.title,
    required this.address,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.facilityId,
  });

  @override
  _DraggableSheetState createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  final fontSizeManager = FontSizeManager();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.25, // 시작 크기 (화면의 4분의 1)
      minChildSize: 0.25, // 최소 크기
      maxChildSize: 0.5, // 최대 크기 (원한다면 변경 가능)
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              GestureDetector(
                onTap: () async {
                  Facility fac = await ApiService().getFacilityById(widget.facilityId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FacilityDetailScreen(facility: fac),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: fontSizeManager.fontSize + 4,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.address,
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: fontSizeManager.fontSize),
                      ),
                      SizedBox(height: 16),
                      Text(
                        widget.description,
                        style: TextStyle(fontSize: fontSizeManager.fontSize),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
