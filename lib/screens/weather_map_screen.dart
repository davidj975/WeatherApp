import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/weather_service.dart';

class WeatherMapScreen extends StatelessWidget {
  const WeatherMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radar Meteorológico'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(41.6183, 0.6223), 
          zoom: 6.0,
          maxZoom: 18.0,
          minZoom: 3.0,
        ),
        children: [
          // Capa base del mapa
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          // Capa de precipitaciones
          TileLayer(
            urlTemplate: 'https://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}.png?appid=${WeatherService.apiKey}',
            tileBuilder: (context, child, tile) {
              return Opacity(
                opacity: 0.9,
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }
}