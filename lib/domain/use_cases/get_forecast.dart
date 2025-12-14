import '../entities/forecast.dart';
import '../repositories/weather_repository.dart';

class GetForecast {
  final WeatherRepository repository;

  GetForecast(this.repository);

  Future<Forecast> byCity(String cityName) async {
    return await repository.getForecastByCity(cityName);
  }

  Future<Forecast> byCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    return await repository.getForecastByCoordinates(
      latitude:  latitude,
      longitude: longitude,
    );
  }
}