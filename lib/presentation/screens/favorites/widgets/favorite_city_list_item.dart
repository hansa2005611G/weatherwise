import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import '../../../../core/utils/temperature_converter.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/favorites_provider.dart';

class FavoriteCityListItem extends ConsumerWidget {
  final FavoriteCityData cityData;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const FavoriteCityListItem({
    super.key,
    required this.cityData,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Drag handle
              const Icon(
                Icons.drag_handle,
                color: Colors.grey,
              ),

              const SizedBox(width:  12),

              // Weather icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getWeatherColor().withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  cityData.weather != null
                      ? WeatherIconMapper.getWeatherEmoji(
                          cityData.weather!. weatherIcon,
                        )
                      : '❓',
                  style: const TextStyle(fontSize: 32),
                ),
              ),

              const SizedBox(width:  16),

              // City info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cityData.cityName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (cityData.isLoading)
                      const Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      )
                    else if (cityData.error != null)
                      const Text(
                        'Failed to load',
                        style:  TextStyle(
                          fontSize:  14,
                          color:  Colors.red,
                        ),
                      )
                    else if (cityData.weather != null)
                      Text(
                        cityData.weather!.weatherDescription,
                        style: const TextStyle(
                          fontSize:  14,
                          color:  Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),

              // Temperature
              if (cityData.weather != null && ! cityData.isLoading)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      TemperatureConverter.formatTemperature(
                        TemperatureConverter.getTemperatureInUnit(
                          cityData.weather!.main.temperature,
                          settings.isCelsius,
                        ),
                        settings.isCelsius,
                      ),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'H: ${TemperatureConverter. getTemperatureInUnit(cityData.weather!.main.tempMax, settings.isCelsius).round()}°',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors. grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'L: ${TemperatureConverter.getTemperatureInUnit(cityData.weather!. main.tempMin, settings.isCelsius).round()}°',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors. grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              const SizedBox(width: 8),

              // Menu button
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
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
                        Icon(Icons.delete, size: 20, color:  Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors. red)),
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
            ],
          ),
        ),
      ),
    );
  }

  Color _getWeatherColor() {
    if (cityData.weather != null) {
      return WeatherIconMapper.getWeatherColor(
        cityData.weather!.weatherCondition,
      );
    }
    return const Color(0xFF4A90E2);
  }
}