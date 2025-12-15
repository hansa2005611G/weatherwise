import 'package:flutter/material.dart';
import '../../../../data/models/forecast_model.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import '../../../../core/utils/temperature_converter.dart';
import '../../../../core/utils/date_formatter.dart';

class DailySummaryCard extends StatelessWidget {
  final DateTime date;
  final List<ForecastItemModel> forecasts;
  final bool isCelsius;

  const DailySummaryCard({
    super.key,
    required this.date,
    required this.forecasts,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate daily summary
    final temps = forecasts.map((f) => f.main.temperature).toList();
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final minTemp = temps.reduce((a, b) => a < b ? a : b);

    final maxTempConverted = TemperatureConverter. getTemperatureInUnit(
      maxTemp,
      isCelsius,
    );
    final minTempConverted = TemperatureConverter.getTemperatureInUnit(
      minTemp,
      isCelsius,
    );

    // Get most common weather condition
    final midDayForecast = forecasts[forecasts.length ~/ 2];
    
    final isToday = DateFormatter.isToday(date);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius. circular(16),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.all(16),
        leading: Text(
          WeatherIconMapper.getWeatherEmoji(midDayForecast.weatherIcon),
          style: const TextStyle(fontSize: 40),
        ),
        title: Text(
          isToday ? 'Today' :  DateFormatter.formatFullDate(date),
          style: TextStyle(
            fontSize: 16,
            fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        subtitle: Text(
          midDayForecast.weatherCondition,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${maxTempConverted.round()}°',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${minTempConverted.round()}°',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        children: [
          // Hourly breakdown
          SizedBox(
            height: 120,
            child: ListView. builder(
              scrollDirection:  Axis.horizontal,
              itemCount: forecasts.length,
              itemBuilder: (context, index) {
                final forecast = forecasts[index];
                final temp = TemperatureConverter.getTemperatureInUnit(
                  forecast.main.temperature,
                  isCelsius,
                );

                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Theme.of(context).primaryColor. withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        DateFormatter.formatHourShort(forecast.dateTime),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        WeatherIconMapper.getWeatherEmoji(forecast.weatherIcon),
                        style: const TextStyle(fontSize: 28),
                      ),
                      Text(
                        '${temp.round()}°',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Summary metrics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryMetric(
                icon: Icons.water_drop,
                label: 'Avg Humidity',
                value: '${_calculateAverage(forecasts. map((f) => f.main.humidity. toDouble()).toList()).round()}%',
                color:  Colors.blue,
              ),
              _buildSummaryMetric(
                icon: Icons.air,
                label: 'Avg Wind',
                value: '${_calculateAverage(forecasts.map((f) => f.wind.speed).toList()).toStringAsFixed(1)} km/h',
                color: Colors. teal,
              ),
              _buildSummaryMetric(
                icon: Icons.umbrella,
                label: 'Rain Chance',
                value: '${(_calculateAverage(forecasts.map((f) => f.precipitationProbability).toList()) * 100).round()}%',
                color: Colors.indigo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric({
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
            fontSize:  11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  double _calculateAverage(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }
}