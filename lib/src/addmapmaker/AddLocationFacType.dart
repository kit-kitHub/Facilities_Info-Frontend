import 'package:flutter/material.dart';

import 'AddLocationstar.dart';

class SelectFacilityTypeScreen extends StatefulWidget {
  const SelectFacilityTypeScreen({super.key});

  @override
  State<SelectFacilityTypeScreen> createState() => _SelectFacilityTypeScreenState();
}

class _SelectFacilityTypeScreenState extends State<SelectFacilityTypeScreen> {
  String? selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '추가하기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
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
            const Text(
              '시설물의 종류를\n선택해 주세요',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: InputDecoration(
                hintText: '시설물 종류',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: const [
                DropdownMenuItem(
                  value: 'type1',
                  child: Text('시설물 종류 1'),
                ),
                DropdownMenuItem(
                  value: 'type2',
                  child: Text('시설물 종류 2'),
                ),
                DropdownMenuItem(
                  value: 'type3',
                  child: Text('시설물 종류 3'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RateFacilityScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2AAE66)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(
                    color: Color(0xFF2AAE66),
                    fontSize: 16,
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