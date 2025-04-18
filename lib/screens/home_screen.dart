import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentCity = 'Barcelona'; // Ciudad por defecto

  void _updateCity(String newCity) {
    setState(() {
      _currentCity = newCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Actual'),
      ),
      body: Column(
        children: [
          CustomSearchBar(onSearch: _updateCity), // Renamed from SearchBar to CustomSearchBar
          Expanded(
            child: Center(
              child: WeatherCard(city: _currentCity),
            ),
          ),
        ],
      ),
    );
  }
}