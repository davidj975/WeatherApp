import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';

class WeatherService {
  final String apiKey = 'TU_API_KEY'; // Reemplaza con tu API key
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather(
        cityName: data['name'],
        temperature: data['main']['temp'].toDouble(),
        description: data['weather'][0]['description'],
        iconCode: data['weather'][0]['icon'],
      );
    } else {
      throw Exception('Error al obtener el clima');
    }
  }
}