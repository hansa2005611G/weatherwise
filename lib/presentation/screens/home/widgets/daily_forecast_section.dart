import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/forecast_model.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import '../../../../core/utils/temperature_converter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../providers/settings_provider.dart';

class DailyForecastSection extends ConsumerWidget {
  final ForecastModel forecast;

  const DailyForecastSection({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    
    // Group forecasts by day and get daily summary
    final dailyForecasts = _groupForecastsByDay(forecast.forecasts);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                '7-Day Forecast',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height:  12),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: dailyForecasts.map((day) {
                return _buildDailyItem(
                  context: context,
                  day:  day,
                  isCelsius: settings.isCelsius,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<DailyForecast> _groupForecastsByDay(List<ForecastItemModel> forecasts) {
    final Map<String, List<ForecastItemModel>> grouped = {};

    for (var forecast in forecasts) {
      final dateKey = '${forecast.dateTime.year}-${forecast.dateTime.month}-${forecast.dateTime.day}';
      
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(forecast);
    }

    final dailyForecasts = <DailyForecast>[];
    
    grouped.forEach((key, items) {
      if (dailyForecasts.length < 5) {
        final temps = items.map((e) => e.main.temperature).toList();
        final maxTemp = temps.reduce((a, b) => a > b ? a : b);
        final minTemp = temps.reduce((a, b) => a < b ? a : b);
        
        dailyForecasts.add(DailyForecast(
          date: items. first.dateTime,
          maxTemp: maxTemp,
          minTemp: minTemp,
          icon: items[items.length ~/ 2].weatherIcon,
          condition: items[items.length ~/ 2]. weatherCondition,
        ));
      }
    });

    return dailyForecasts;
  }

  Widget _buildDailyItem({
    required BuildContext context,
    required DailyForecast day,
    required bool isCelsius,
  }) {
    final isToday = DateFormatter.isToday(day.date);
    
    final maxTemp = TemperatureConverter. getTemperatureInUnit(
      day.maxTemp,
      isCelsius,
    );
    
    final minTemp = TemperatureConverter.getTemperatureInUnit(
      day.minTemp,
      isCelsius,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          // Day name
          SizedBox(
            width: 80,
            child: Text(
              isToday ? 'Today' :  DateFormatter.formatDayShort(day.date),
              style: TextStyle(
                fontSize: 16,
                fontWeight: isToday ? FontWeight.bold :  FontWeight.w500,
                color: const Color(0xFF333333),
              ),
            ),
          ),

          // Weather icon
          Text(
            WeatherIconMapper. getWeatherEmoji(day. icon),
            style: const TextStyle(fontSize: 32),
          ),

          const SizedBox(width: 12),

          // Condition
          Expanded(
            child: Text(
              day.condition,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
              ),
            ),
          ),

          // Temperature range
          Row(
            children: [
              Text(
                '${minTemp.round()}°',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF757575),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade300,
                      Colors.orange.shade300,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${maxTemp.round()}°',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Helper class for daily forecast data
class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String icon;
  final String condition;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.icon,
    required this.condition,
  });
}