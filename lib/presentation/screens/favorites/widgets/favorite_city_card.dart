import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/weather_model.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import '../../../../core/utils/temperature_converter.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/favorites_provider.dart';

class FavoriteCityCard extends ConsumerWidget {
  final FavoriteCityData cityData;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const FavoriteCityCard({
    super.key,
    required this.cityData,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: _getGradient(),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:  Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Menu button
            Positioned(
              top: 8,
              right:  8,
              child: PopupMenuButton(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:  Colors.white. withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value:  'edit',
                    child: const Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: const Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: cityData.isLoading
                  ? _buildLoadingState()
                  : cityData.error != null
                      ? _buildErrorState()
                      : _buildWeatherContent(settings. isCelsius),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getGradient() {
    if (cityData.weather != null) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment. bottomRight,
        colors: WeatherIconMapper.getWeatherGradient(
          cityData.weather!.weatherCondition,
        ),
      );
    }

    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildErrorState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 40,
        ),
        const SizedBox(height: 8),
        Text(
          cityData.cityName,
          style: const TextStyle(
            color: Colors. white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        const Text(
          'Failed to load',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWeatherContent(bool isCelsius) {
    final weather = cityData.weather! ;
    final temperature = TemperatureConverter.getTemperatureInUnit(
      weather.main.temperature,
      isCelsius,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        
        // Weather icon
        Center(
          child: Text(
            WeatherIconMapper.getWeatherEmoji(weather.weatherIcon),
            style: const TextStyle(fontSize: 60),
          ),
        ),

        const Spacer(),

        // City name
        Text(
          cityData.cityName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Temperature
        Text(
          TemperatureConverter.formatTemperature(temperature, isCelsius),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        // Weather description
        Text(
          weather.weatherDescription,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 8),

        // High/Low temperatures
        Row(
          children: [
            const Icon(
              Icons.arrow_upward,
              color: Colors. white70,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              '${TemperatureConverter.getTemperatureInUnit(weather. main.tempMax, isCelsius).round()}°',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_downward,
              color: Colors.white70,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              '${TemperatureConverter. getTemperatureInUnit(weather.main.tempMin, isCelsius).round()}°',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}