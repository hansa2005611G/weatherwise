import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/weather_model.dart';
import '../../../../core/utils/date_formatter.dart';

class WeatherDetailsGrid extends ConsumerWidget {
  final WeatherModel weather;

  const WeatherDetailsGrid({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    icon: Icons.water_drop,
                    label:  'Humidity',
                    value: '${weather.main.humidity}%',
                    iconColor: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    icon: Icons.air,
                    label: 'Wind',
                    value: '${weather.wind.speed. toStringAsFixed(1)} km/h',
                    iconColor: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height:  20),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    icon: Icons. visibility,
                    label: 'Visibility',
                    value:  '10 km',
                    iconColor: Colors.purple,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    icon:  Icons.compress,
                    label: 'Pressure',
                    value:  '${weather.main.pressure} hPa',
                    iconColor: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    icon: Icons.wb_sunny,
                    label:  'Sunrise',
                    value: DateFormatter.formatTime(weather.sys.sunriseTime),
                    iconColor: Colors.amber,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    icon: Icons.nights_stay,
                    label:  'Sunset',
                    value: DateFormatter.formatTime(weather.sys.sunsetTime),
                    iconColor: Colors. indigo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size:  28,
          ),
        ),
        const SizedBox(height:  8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight. bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style:  TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}