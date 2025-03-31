import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String city;

  const WeatherCard({required this.city});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(city, style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Icon(Icons.wb_sunny, size: 50, color: Colors.amber),
            SizedBox(height: 10),
            Text('25°C', style: TextStyle(fontSize: 32)),
            Text('Soleado', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}