import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}

abstract class JsonStorageProvider<T extends JsonSerializable> with ChangeNotifier {
  List<T> _items = [];
  final String storageKey;
  final T Function(Map<String, dynamic> json) fromJson;

  JsonStorageProvider({
    required this.storageKey,
    required this.fromJson,
  }) {
    _loadItems();
  }

  List<T> get items => _items;

  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _items.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(storageKey, encodedData);
    notifyListeners();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsString = prefs.getString(storageKey);

    if (itemsString != null) {
      final List<dynamic> decodedData = jsonDecode(itemsString);
      _items = decodedData.map((json) => fromJson(json as Map<String, dynamic>)).toList();
      notifyListeners();
    }
  }
}