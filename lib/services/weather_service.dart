import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class WeatherService {
  static const apiKey = '58dca0bf8bae77429f91a01e89d9f23a';
  static const baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const iconBaseUrl = 'https://openweathermap.org/img/wn';

  static const Map<String, String> _weatherTranslations = {
    'clear sky': 'Cielo despejado',
    'few clouds': 'Algunas nubes',
    'scattered clouds': 'Nubes dispersas',
    'broken clouds': 'Nuboso',
    'shower rain': 'Lluvia fuerte',
    'rain': 'Lluvia',
    'light rain': 'Lluvia ligera',
    'moderate rain': 'Lluvia moderada',
    'heavy rain': 'Lluvia intensa',
    'thunderstorm': 'Tormenta',
    'snow': 'Nieve',
    'mist': 'Neblina',
    'overcast clouds': 'Muy nuboso',
    'light intensity shower rain': 'Lluvia ligera',
    'heavy intensity rain': 'Lluvia intensa',
    'light intensity drizzle': 'Llovizna ligera',
    'drizzle': 'Llovizna',
    'heavy intensity drizzle': 'Llovizna intensa',
    'light intensity drizzle rain': 'Lluvia con llovizna ligera',
    'drizzle rain': 'Lluvia con llovizna',
    'heavy intensity drizzle rain': 'Lluvia con llovizna intensa',
  };

  static Future<void> initialize() async {
    await initializeDateFormatting('es_ES', null);
  }

  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse('$baseUrl/forecast?q=$city&appid=$apiKey&units=metric');
    try {
      print('Fetching weather for $city from $url');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['list'] == null || data['city'] == null) {
          throw Exception('Invalid API response');
        }
        final list = data['list'] as List;

        // Hourly forecast (next 8 intervals, ~24 hours)
        List<HourlyForecast> hourly = list.take(8).map((e) {
          final time = DateFormat('HH:00').format(DateTime.parse(e['dt_txt']));
          final iconCode = e['weather'][0]['icon'];
          final String iconUrl = '$iconBaseUrl/$iconCode@2x.png';
          return HourlyForecast(
            time: time,
            temp: e['main']['temp'].toDouble(),
            icon: iconUrl,
          );
        }).toList();

        // Daily forecast (next 3 days)
        List<DailyForecast> daily = [];
        final now = DateTime.now();
        final seenDays = <String>{};

        for (var item in list) {
          final dateTime = DateTime.parse(item['dt_txt']);
          final dayKey = DateFormat('yyyy-MM-dd').format(dateTime);
          if (dateTime.isAfter(now) &&
              seenDays.length < 3 &&
              !seenDays.contains(dayKey)) {
            // Collect all entries for this day
            final dayEntries = list.where((e) {
              return DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(e['dt_txt'])) ==
                  dayKey;
            }).toList();

            if (dayEntries.isNotEmpty) {
              // Calculate average temperature
              final avgTemp = dayEntries
                      .map((e) => e['main']['temp'].toDouble())
                      .reduce((a, b) => a + b) /
                  dayEntries.length;

              // Pick the most frequent weather icon/description (midday entry for simplicity)
              final middayEntry = dayEntries.firstWhere(
                (e) {
                  final hour = DateTime.parse(e['dt_txt']).hour;
                  return hour >= 12 && hour <= 15;
                },
                orElse: () => dayEntries[dayEntries.length ~/ 2],
              );

              daily.add(DailyForecast(
                date: DateFormat('EEE, MMM d').format(dateTime),
                temp: avgTemp,
                description: _weatherTranslations[middayEntry['weather'][0]['description']] ?? 
                            middayEntry['weather'][0]['description'],
                icon: '$iconBaseUrl/${middayEntry['weather'][0]['icon']}@2x.png',
              ));
              seenDays.add(dayKey);
            }
          }
        }

        final weather = Weather(
          city: data['city']['name'],
          country: data['city']['country'],
          description: _weatherTranslations[list[0]['weather'][0]['description']] ?? 
                      list[0]['weather'][0]['description'],
          temp: list[0]['main']['temp'].toDouble(),
          wind: list[0]['wind']['speed'].toDouble(),
          pressure: list[0]['main']['pressure'].toDouble(),
          hourly: hourly,
          daily: daily.isNotEmpty ? daily : null,
          humidity: list[0]['main']['humidity'].toDouble(),
        );
        print('Weather fetched for ${weather.city}: ${daily.length} daily forecasts');
        return weather;
      } else {
        throw Exception('Failed to load weather for $city: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weather for $city: $e');
      rethrow;
    }
  }
}