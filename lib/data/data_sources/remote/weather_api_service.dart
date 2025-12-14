import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/weather_model.dart';
import '../../models/forecast_model.dart';

class WeatherApiService {
  final ApiClient _apiClient;

  WeatherApiService(this._apiClient);

  /// Get current weather by city name
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.currentWeather,
        queryParameters: {'q': cityName},
      );

      return WeatherModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get current weather by coordinates
  Future<WeatherModel> getCurrentWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants. currentWeather,
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
        },
      );

      return WeatherModel.fromJson(response. data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get 5-day forecast by city name
  Future<ForecastModel> getForecastByCity(String cityName) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.forecast,
        queryParameters: {'q':  cityName},
      );

      return ForecastModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get 5-day forecast by coordinates
  Future<ForecastModel> getForecastByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.forecast,
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
        },
      );

      return ForecastModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Search cities by name (Geocoding API)
  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.geoBaseUrl}${ApiConstants.directGeocoding}',
        queryParameters: {
          'q': query,
          'limit': ApiConstants.searchLimit,
        },
      );

      return List<Map<String, dynamic>>. from(response.data);
    } catch (e) {
      rethrow;
    }
  }
}