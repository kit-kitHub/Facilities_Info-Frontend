import 'package:flutter/material.dart';

import '/SingleTone/font.dart';
import '/SingleTone/Recent_Search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final fontSizeManager = FontSizeManager();
  late TabController _tabController;
  List<Map<String, dynamic>> menuItems = [];
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Define menu items with categories
    menuItems = [
      {'icon': Icons.favorite, 'text': '양포동 영상복지센터', 'category': '복지센터', 'url': 'fsdfsd'},
      {'icon': Icons.add, 'text': '서울필의원', 'category': '의료시설', 'url': 'fsdfsd'},
      {'icon': Icons.favorite, 'text': '신동읍 영상복지센터', 'category': '복지센터', 'url': 'fsdfsd'},
      {'icon': Icons.favorite, 'text': '구미시 장애인 종합 복지관', 'category': '복지센터', 'url': 'fsdfsd'},
    ];

    // Initialize to show all items (for the "전체" tab)
    filteredItems = menuItems;

    // Add listener to tab changes
    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 0) {
          // 전체 (All items)
          filteredItems = menuItems;
        } else if (_tabController.index == 1) {
          // 주차장
          filteredItems = menuItems.where((item) => item['category'] == '주차장').toList();
        } else if (_tabController.index == 2) {
          // 복지센터
          filteredItems = menuItems.where((item) => item['category'] == '복지센터').toList();
        } else if (_tabController.index == 3) {
          // 의료시설
          filteredItems = menuItems.where((item) => item['category'] == '의료시설').toList();
        } else if (_tabController.index == 4) {
          // 화장실
          filteredItems = menuItems.where((item) => item['category'] == '화장실').toList();
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.circle, color: Colors.white),
        title: GestureDetector(
          onTap: () {
            // Navigate to RecentSearchScreen when tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecentSearchScreen()),
            );
          },
          child: AbsorbPointer(
            child: TextField(
              decoration: InputDecoration(
                hintText: '검색 내용 작성칸',
                hintStyle: TextStyle(fontSize: fontSizeManager.fontSize),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              enabled: false, // Disables editing in the TextField
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () {
              // Handle microphone action
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          labelStyle: TextStyle(
            fontSize: fontSizeManager.fontSize,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelColor: Colors.black,
          unselectedLabelStyle: TextStyle(
            fontSize: fontSizeManager.fontSize,
          ),
          indicatorColor: Colors.blue,
          tabs: [
            Tab(text: '전체'),
            Tab(text: '주차장'),
            Tab(text: '복지센터'),
            Tab(text: '의료시설'),
            Tab(text: '화장실'),
          ],
        ),
      ),
      body: ListView(
        children: filteredItems.map((item) {
          return MenuButton(
            icon: item['icon'],
            text: item['text'],
            onPressurl: item['url'],
            fontSizeManager: fontSizeManager,// Placeholder URL
          );
        }).toList(),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final String onPressurl;
  final fontSizeManager;
  const MenuButton({Key? key, required this.icon, required this.text, required this.onPressurl, required this.fontSizeManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextButton(
        onPressed: () {
          // Navigate or perform action based on onPressurl
        },
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black54),
            SizedBox(width: 12),
            Text(text, style: TextStyle(color: Colors.black87, fontSize: fontSizeManager.fontSize)),
          ],
        ),
      ),
    );
  }
}

class RecentSearch {
  static final RecentSearch _instance = RecentSearch._internal();

  factory RecentSearch() => _instance;

  RecentSearch._internal();

  final List<Map<String, String>> _recentSearches = [];

  List<Map<String, String>> get recentSearches => _recentSearches;

  void addRecentSearch(String name, String description) {
    _recentSearches.insert(0, {'name': name, 'description': description});
  }

  void removeRecentSearch(int index) {
    if (index >= 0 && index < _recentSearches.length) {
      _recentSearches.removeAt(index);
    }
  }

  Map<String, String>? getRecentSearchByIndex(int index) {
    if (index >= 0 && index < _recentSearches.length) {
      return _recentSearches[index];
    }
    return null;
  }
}

class RecentSearchScreen extends StatefulWidget {
  @override
  _RecentSearchScreenState createState() => _RecentSearchScreenState();
}

class _RecentSearchScreenState extends State<RecentSearchScreen> {
  final recentSearch = RecentSearch();
  final fontSizeManager = FontSizeManager();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _textEditingController,
          textInputAction: TextInputAction.go,
          onSubmitted: (String value) {
            if (value.isNotEmpty) {
              setState(() {
                recentSearch.addRecentSearch(value, '검색 기록'); // 새로운 검색 추가
              });
              _textEditingController.clear();
            }
          },
          decoration: InputDecoration(
            hintText: '검색 내용 작성칸',
            hintStyle: TextStyle(color: Colors.grey, fontSize: fontSizeManager.fontSize),
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () {
              // 음성 검색 기능 처리
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('최근 검색',
                style: TextStyle(fontSize: fontSizeManager.fontSize + 2, fontWeight: FontWeight.bold)),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: recentSearch.recentSearches.length,
                itemBuilder: (context, index) {
                  Map<String, String>? search = recentSearch.getRecentSearchByIndex(index);
                  return Row(
                    children: [
                      Flexible(
                        flex: 13,
                        child: TextButton(
                          onPressed: () {
                            // 검색 항목 클릭 시 동작
                          },
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 16),
                              Text(
                                search?['name'] ?? '',
                                style: TextStyle(
                                    color: Colors.black87, fontSize: fontSizeManager.fontSize),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              recentSearch.removeRecentSearch(index); // 검색 항목 삭제
                            });
                          },
                        ),
                      ),
                    ],
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
