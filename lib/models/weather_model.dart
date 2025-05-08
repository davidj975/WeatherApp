class Weather {
  final String city;
  final String country;
  final String description;
  final double temp;
  final double wind;
  final double pressure;
  final List<HourlyForecast> hourly;
  final List<DailyForecast>? daily;
  final double? pop; // Probability of precipitation (0-100)
  final double humidity;

  Weather({
    required this.city,
    required this.country,
    required this.description,
    required this.temp,
    required this.wind,
    required this.pressure,
    required this.hourly,
    this.daily,
    this.pop,
    required this.humidity,
  });
}

class HourlyForecast {
  final String time;
  final double temp;
  final String icon;

  HourlyForecast({
    required this.time,
    required this.temp,
    required this.icon,
  });
}

class DailyForecast {
  final String date;
  final double temp;
  final String description;
  final String icon;

  DailyForecast({
    required this.date,
    required this.temp,
    required this.description,
    required this.icon,
  });
}