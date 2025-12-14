import 'package:flutter/material.dart';
import '../../../../data/models/forecast_model.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import '../../../../core/utils/temperature_converter.dart';
import '../../../../core/utils/date_formatter.dart';

class HourlyDetailCard extends StatelessWidget {
  final ForecastItemModel forecast;
  final bool isCelsius;

  const HourlyDetailCard({
    super.key,
    required this.forecast,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    final temperature = TemperatureConverter.getTemperatureInUnit(
      forecast.main.temperature,
      isCelsius,
    );

    final isNow = DateTime.now().difference(forecast.dateTime).inHours. abs() < 2;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isNow ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isNow
            ?  BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              )
            : BorderSide.none,
      ),
      child:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Time and icon
            Row(
              children:  [
                // Time
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      Text(
                        isNow ? 'Now' :  DateFormatter.formatTime(forecast.dateTime),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isNow ? FontWeight.bold :  FontWeight.w600,
                          color: isNow ? Theme.of(context).primaryColor : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormatter.formatFullDate(forecast.dateTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors. grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Weather icon
                Text(
                  WeatherIconMapper.getWeatherEmoji(forecast.weatherIcon),
                  style: const TextStyle(fontSize: 48),
                ),

                const SizedBox(width: 16),

                // Temperature
                Column(
                  crossAxisAlignment:  CrossAxisAlignment.end,
                  children: [
                    Text(
                      TemperatureConverter.formatTemperature(
                        temperature,
                        isCelsius,
                      ),
                      style: const TextStyle(
                        fontSize:  32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      forecast.weatherCondition,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors. grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height:  12),

            // Weather metrics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric(
                  icon: Icons. water_drop,
                  label:  'Humidity',
                  value: '${forecast.main.humidity}%',
                  color: Colors. blue,
                ),
                _buildMetric(
                  icon: Icons.air,
                  label: 'Wind',
                  value: '${forecast.wind.speed. toStringAsFixed(1)} km/h',
                  color:  Colors.teal,
                ),
                _buildMetric(
                  icon: Icons.umbrella,
                  label: 'Rain',
                  value: '${(forecast.precipitationProbability * 100).round()}%',
                  color:  Colors.indigo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}