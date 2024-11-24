import 'package:flutter/material.dart';

//사용자가 정보를 작성하는 칸
class BottomSheetContent_find extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: '해당 위치 이름을 작성해 주세요',
              border: OutlineInputBorder(),
            ),
          ),

          SizedBox(height: 16),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              labelText: '내용을 적어주세요',
              border: OutlineInputBorder(),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: Text('제출하기'),
                onPressed: (){
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
