import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather.dart';
import 'package:weatherapp/pages/search_page.dart';
import 'package:weatherapp/services/weather_service.dart';
import 'package:weatherapp/widgets/weather_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();
  Weather? _currentWeather;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _fetchWeather(String cityName) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _currentWeather = weather;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No se pudo obtener el clima: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final cityName = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
              if (cityName != null) {
                _fetchWeather(cityName);
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _currentWeather == null
                  ? const Center(child: Text('Busca una ciudad para ver el clima'))
                  : WeatherCard(weather: _currentWeather!),
    );
  }
}