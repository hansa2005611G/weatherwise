import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeather {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  Future<Weather> byCity(String cityName) async {
    return await repository.getCurrentWeatherByCity(cityName);
  }

  Future<Weather> byCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    return await repository.getCurrentWeatherByCoordinates(
      latitude: latitude,
      longitude: longitude,
    );
  }
}