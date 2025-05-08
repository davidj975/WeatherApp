import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../screens/weather_detail_screen.dart';

class CityCard extends StatelessWidget {
  final Weather weather;

  const CityCard({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherDetailScreen(weather: weather),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade300,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Image.network(
              'https:${weather.hourly.first.icon}',
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.cloud, size: 50, color: Colors.white70),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.country,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    weather.city,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    weather.description,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Text(
              '${weather.temp.toStringAsFixed(0)}°C',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
