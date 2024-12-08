import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecentSearch {
  static final RecentSearch _instance = RecentSearch._internal();
  RecentSearch._internal();
  factory RecentSearch() => _instance;

  SharedPreferences? _prefs;
  List<Map<String, String>> _recentSearches = [];

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    String? recentSearchesString = _prefs?.getString('recentSearches');
    if (recentSearchesString != null) {
      List<dynamic> jsonList = json.decode(recentSearchesString);
      _recentSearches = jsonList.map((item) => Map<String, String>.from(item)).toList();
    }
  }

  List<Map<String, String>> get recentSearches => _recentSearches;

  Future<void> addRecentSearch(String name) async {
    _recentSearches.removeWhere((item) => item['name'] == name); // 중복 제거
    _recentSearches.insert(0, {'name': name});
    if (_recentSearches.length > 10) {
      _recentSearches.removeLast(); // 최대 10개 제한
    }
    await _saveRecentSearches();
  }

  Future<void> removeRecentSearch(int index) async {
    _recentSearches.removeAt(index);
    await _saveRecentSearches();
  }

  Future<void> _saveRecentSearches() async {
    String jsonString = json.encode(_recentSearches);
    await _prefs?.setString('recentSearches', jsonString);
  }
}
