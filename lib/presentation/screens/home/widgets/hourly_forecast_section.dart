import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/forecast_model.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import '../../../../core/utils/temperature_converter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../providers/settings_provider.dart';

class HourlyForecastSection extends ConsumerWidget {
  final ForecastModel forecast;

  const HourlyForecastSection({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    
    // Get next 24 hours (8 items, every 3 hours)
    final hourlyForecasts = forecast.forecasts.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Hourly Forecast',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to detailed forecast
                },
                child: const Text(
                  'See More',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis. horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: hourlyForecasts.length,
            itemBuilder: (context, index) {
              final item = hourlyForecasts[index];
              final isNow = index == 0;

              return _buildHourlyItem(
                context:  context,
                item: item,
                isNow: isNow,
                isCelsius: settings.isCelsius,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyItem({
    required BuildContext context,
    required ForecastItemModel item,
    required bool isNow,
    required bool isCelsius,
  }) {
    final temperature = TemperatureConverter.getTemperatureInUnit(
      item.main.temperature,
      isCelsius,
    );

    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isNow
            // ignore: deprecated_member_use
            ? Colors.white.withOpacity(0.3)
            // ignore: deprecated_member_use
            : Colors.white. withOpacity(0.2),
        borderRadius: BorderRadius. circular(16),
        border: isNow
            ? Border.all(color: Colors.white, width: 2)
            : null,
      ),
      child: Column(
        mainAxisAlignment:  MainAxisAlignment.spaceAround,
        children: [
          Text(
            isNow ? 'Now' :  DateFormatter.formatHourShort(item.dateTime),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            WeatherIconMapper.getWeatherEmoji(item.weatherIcon),
            style: const TextStyle(fontSize: 32),
          ),
          Text(
            '${temperature.round()}°',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}