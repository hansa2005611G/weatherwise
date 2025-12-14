import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../providers/weather_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/favorites_provider.dart';
import 'widgets/weather_app_bar.dart';
import 'widgets/weather_header.dart';
import 'widgets/weather_details_grid.dart';
import 'widgets/hourly_forecast_section.dart';
import 'widgets/daily_forecast_section. dart';
import 'widgets/weather_background.dart';
import '../../../core/utils/weather_icon_mapper.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial weather data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final weatherNotifier = ref.read(weatherProvider. notifier);
    
    // Try to load last location or use default
    final lastLocation = ref.read(localStorageServiceProvider).getLastLocation();
    
    if (lastLocation != null) {
      await weatherNotifier.fetchWeatherByCity(lastLocation);
      await weatherNotifier.fetchForecast(lastLocation);
    } else {
      // Load default city
      await weatherNotifier.fetchWeatherByCity('London');
      await weatherNotifier.fetchForecast('London');
    }
  }

  Future<void> _refreshWeather() async {
    await ref.read(weatherProvider.notifier).refreshWeather();
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    final weather = weatherState.weather;
    final forecast = weatherState.forecast;

    // Get background gradient based on weather condition
    final gradient = weather != null
        ? WeatherIconMapper.getWeatherGradient(weather.weatherCondition)
        : [const Color(0xFF4A90E2), const Color(0xFF87CEEB)];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: WeatherAppBar(
        cityName: weather?.cityName ?? 'Loading...',
        onSearchTap: () => _navigateToSearch(context),
        onFavoriteTap: () => _navigateToFavorites(context),
        onMenuTap: () => _showMenuBottomSheet(context),
      ),
      body: Stack(
        children: [
          // Animated background
          WeatherBackground(
            gradient: gradient,
            condition: weather?.weatherCondition ??  'Clear',
          ),

          // Main content
          SafeArea(
            child: weatherState.isLoading && weather == null
                ? _buildLoadingState()
                : weatherState.error != null && weather == null
                    ? _buildErrorState(weatherState.error!)
                    :  _buildWeatherContent(weather!, forecast),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading weather data...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child:  Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white. withOpacity(0.9),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton. icon(
              onPressed: _loadInitialData,
              icon:  const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4A90E2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent(
    weather,
    forecast,
  ) {
    return RefreshIndicator(
      onRefresh: _refreshWeather,
      color: const Color(0xFF4A90E2),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // Header section with temperature
          SliverToBoxAdapter(
            child: FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: WeatherHeader(weather: weather),
            ),
          ),

          // Weather details grid
          SliverToBoxAdapter(
            child: FadeInUp(
              duration:  const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 100),
              child:  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: WeatherDetailsGrid(weather: weather),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Hourly forecast section
          if (forecast != null)
            SliverToBoxAdapter(
              child: FadeInUp(
                duration: const Duration(milliseconds: 500),
                delay: const Duration(milliseconds: 200),
                child: HourlyForecastSection(forecast: forecast),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Daily forecast section
          if (forecast != null)
            SliverToBoxAdapter(
              child: FadeInUp(
                duration:  const Duration(milliseconds: 500),
                delay: const Duration(milliseconds: 300),
                child: DailyForecastSection(forecast: forecast),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  void _navigateToSearch(BuildContext context) {
    Navigator.pushNamed(context, '/search');
  }

  void _navigateToFavorites(BuildContext context) {
    Navigator.pushNamed(context, '/favorites');
  }

  void _showMenuBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MenuBottomSheet(),
    );
  }
}

// Menu Bottom Sheet Widget
class _MenuBottomSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('Favorite Cities'),
            onTap:  () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Weather Alerts'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/alerts');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator. pop(context);
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'WeatherWise',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons. cloud, size: 48),
      children: [
        const Text(
          'Your smart weather companion.  Get accurate weather forecasts and stay prepared.',
        ),
      ],
    );
  }
}