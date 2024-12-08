import 'package:flutter/material.dart';

import 'AddFacilityDescriptionScreen.dart';
import '../../SingleTone/font.dart';

class RateFacilityScreen extends StatefulWidget {
  const RateFacilityScreen({super.key});

  @override
  State<RateFacilityScreen> createState() => _RateFacilityScreenState();
}

class _RateFacilityScreenState extends State<RateFacilityScreen> {
  double rating = 0;
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
              '시설물의 편의성을\n평가해 주세요',
              style: TextStyle(
                fontSize: fontSizeManager.fontSize + 4,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                  icon: Icon(
                    rating >= index + 1 ? Icons.star : Icons.star_border,
                    size: 40,
                    color: rating >= index + 1 ? Colors.amber : Colors.grey[300],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                );
              }),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: rating > 0
                    ? () {
                  // Navigate to next screen with rating value
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFacilityDescriptionScreen(),
                    ),
                  );
                }
                    : null,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: rating > 0 ? const Color(0xFF2AAE66) : Colors.grey[300]!,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '다음',
                  style: TextStyle(
                    color: rating > 0 ? const Color(0xFF2AAE66) : Colors.grey[400],
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