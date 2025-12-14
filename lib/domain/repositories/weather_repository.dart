import '../entities/weather.dart';
import '../entities/forecast.dart';

abstract class WeatherRepository {
  /// Get current weather by city name
  Future<Weather> getCurrentWeatherByCity(String cityName);

  /// Get current weather by coordinates
  Future<Weather> getCurrentWeatherByCoordinates({
    required double latitude,
    required double longitude,
  });

  /// Get forecast by city name
  Future<Forecast> getForecastByCity(String cityName);

  /// Get forecast by coordinates
  Future<Forecast> getForecastByCoordinates({
    required double latitude,
    required double longitude,
  });

  /// Search cities
  Future<List<Map<String, dynamic>>> searchCities(String query);
}