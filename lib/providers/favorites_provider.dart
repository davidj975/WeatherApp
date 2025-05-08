import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  Set<String> _favorites = {};
  static const String _key = 'favorite_cities';

  Set<String> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = Set<String>.from(prefs.getStringList(_key) ?? []);
    notifyListeners();
  }

  Future<void> toggleFavorite(String city) async {
    if (_favorites.contains(city)) {
      _favorites.remove(city);
    } else {
      _favorites.add(city);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _favorites.toList());
    notifyListeners();
  }

  bool isFavorite(String city) => _favorites.contains(city);
}