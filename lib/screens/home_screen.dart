import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/weather_map_screen.dart';
import '../providers/weather_provider.dart';
import '../providers/theme_provider.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';
import '../screens/weather_detail_screen.dart';
import '../models/weather_model.dart';
import '../providers/favorites_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> cities = ['Madrid', 'Londres', 'Lima', 'Buenos Aires', 'Paris', 'Berlin'];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  Weather? _searchedWeather;

  @override
  void initState() {
    super.initState();
    _loadInitialWeather();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialWeather() async {
    try {
      print('Loading weather for Lleida...');
      await Provider.of<WeatherProvider>(context, listen: false).loadWeather('Lleida');
      print('Weather loaded successfully');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading initial weather: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load weather data';
      });
    }
  }

  Future<void> _searchCity() async {
    final String city = _searchController.text.trim();
    if (city.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final weather = await WeatherService().fetchWeather(city);
      setState(() {
        _searchedWeather = weather;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ciudad no encontrada';
        _searchedWeather = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final weather = provider.weather;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/weather_loading.gif', width: 100),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Weather App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.deepPurple.shade700, // Color más oscuro para modo claro
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WeatherMapScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Buscador mejorado
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar ciudad...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    onSubmitted: (_) => _searchCity(),
                  ),
                ),

                // Resultados de búsqueda
                if (_searchController.text.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Resultado de búsqueda'),
                  const SizedBox(height: 16),
                  if (_searchedWeather != null)
                    _buildAnimatedWeatherCard(_searchedWeather!)
                  else if (_errorMessage != null)
                    _buildErrorMessage(_errorMessage!),
                ],

                // Sección de favoritos
                if (favoritesProvider.favorites.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Ciudades Favoritas'),
                  const SizedBox(height: 16),
                  _buildFavoritesList(favoritesProvider.favorites),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),
                ],

                // Ciudad principal (Lleida)
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Tu Ciudad'),
                const SizedBox(height: 16),
                _buildMainCityCard(weather),

                // Otras ciudades
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Otras Ciudades'),
                const SizedBox(height: 16),
                _buildCitiesList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget _buildAnimatedWeatherCard(Weather weather) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _buildWeatherCard(weather),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(color: Colors.red.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(Set<String> favorites) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final city = favorites.elementAt(index);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FutureBuilder<Weather>(
            future: WeatherService().fetchWeather(city),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              }
              if (snapshot.hasData) {
                return _buildAnimatedWeatherCard(snapshot.data!);
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  Widget _buildMainCityCard(Weather? weather) {
    return Hero(
      tag: 'lleida-card',
      child: _buildWeatherCard(weather ?? Weather(
        city: 'Lleida',
        country: '',
        description: '',
        temp: 0,
        wind: 0,
        pressure: 0,
        humidity: 0,
        hourly: [],
        daily: [],
      )),
    );
  }

  Widget _buildCitiesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FutureBuilder<Weather>(
            future: WeatherService().fetchWeather(city),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              }
              if (snapshot.hasData) {
                return _buildAnimatedWeatherCard(snapshot.data!);
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  Widget _buildWeatherCard(Weather weather) {
    return WeatherCard(weather: weather);
  }
}