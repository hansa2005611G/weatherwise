import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/weather_model.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import '../../../../core/utils/temperature_converter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../providers/settings_provider.dart';

class WeatherHeader extends ConsumerWidget {
  final WeatherModel weather;

  const WeatherHeader({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final temperature = TemperatureConverter.getTemperatureInUnit(
      weather.main.temperature,
      settings.isCelsius,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          // Weather icon emoji
          Text(
            WeatherIconMapper. getWeatherEmoji(weather.weatherIcon),
            style: const TextStyle(fontSize: 120),
          ),

          const SizedBox(height: 16),

          // Temperature
          Text(
            TemperatureConverter.formatTemperature(
              temperature,
              settings.isCelsius,
            ),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),

          const SizedBox(height: 8),

          // Weather description
          Text(
            weather. weatherDescription. toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height:  16),

          // Feels like temperature
          Text(
            'Feels like ${TemperatureConverter.formatTemperature(
              TemperatureConverter.getTemperatureInUnit(
                weather. main.feelsLike,
                settings.isCelsius,
              ),
              settings.isCelsius,
            )}',
            style: TextStyle(
              fontSize: 16,
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.9),
            ),
          ),

          const SizedBox(height: 8),

          // Current date
          Text(
            DateFormatter. formatFullDate(weather.dateTime),
            style: TextStyle(
              fontSize: 14,
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.8),
            ),
          ),

          const SizedBox(height: 24),

          // High/Low temperatures
          Row(
            mainAxisAlignment: MainAxisAlignment. center,
            children: [
              _buildTempChip(
                icon: Icons.arrow_upward,
                label: 'High',
                temperature: TemperatureConverter.formatTemperature(
                  TemperatureConverter.getTemperatureInUnit(
                    weather.main.tempMax,
                    settings.isCelsius,
                  ),
                  settings.isCelsius,
                ),
              ),
              const SizedBox(width: 16),
              _buildTempChip(
                icon: Icons. arrow_downward,
                label: 'Low',
                temperature: TemperatureConverter.formatTemperature(
                  TemperatureConverter.getTemperatureInUnit(
                    weather.main.tempMin,
                    settings.isCelsius,
                  ),
                  settings.isCelsius,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTempChip({
    required IconData icon,
    required String label,
    required String temperature,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            '$label: $temperature',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}