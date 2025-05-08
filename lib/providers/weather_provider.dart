import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  String? _error;

  Weather? get weather => _weather;
  String? get error => _error;

  Future<void> loadWeather(String city) async {
    try {
      _error = null;
      _weather = await WeatherService().fetchWeather(city);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load weather: $e';
      _weather = null;
      notifyListeners();
    }
  }
}