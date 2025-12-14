import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/repositories/weather_repository.dart';
import '../data_sources/remote/weather_api_service.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService apiService;

  WeatherRepositoryImpl(this.apiService);

  @override
  Future<Weather> getCurrentWeatherByCity(String cityName) async {
    try {
      final weatherModel = await apiService.getCurrentWeatherByCity(cityName);
      return _weatherModelToEntity(weatherModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Weather> getCurrentWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final weatherModel = await apiService.getCurrentWeatherByCoordinates(
        latitude: latitude,
        longitude: longitude,
      );
      return _weatherModelToEntity(weatherModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Forecast> getForecastByCity(String cityName) async {
    try {
      final forecastModel = await apiService.getForecastByCity(cityName);
      return _forecastModelToEntity(forecastModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Forecast> getForecastByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final forecastModel = await apiService.getForecastByCoordinates(
        latitude: latitude,
        longitude: longitude,
      );
      return _forecastModelToEntity(forecastModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    try {
      return await apiService.searchCities(query);
    } catch (e) {
      rethrow;
    }
  }

  // Private helper methods to convert models to entities

  Weather _weatherModelToEntity(WeatherModel model) {
    return Weather(
      cityName: model.cityName,
      temperature: model.main.temperature,
      feelsLike:  model.main.feelsLike,
      tempMin: model. main.tempMin,
      tempMax: model.main.tempMax,
      humidity: model.main.humidity,
      pressure: model.main.pressure,
      windSpeed: model.wind.speed,
      windDegree: model.wind.degree,
      weatherCondition: model.weatherCondition,
      weatherDescription:  model.weatherDescription,
      weatherIcon: model.weatherIcon,
      cloudiness: model.clouds.cloudiness,
      dateTime: model.dateTime,
      sunrise: model. sys.sunriseTime,
      sunset:  model.sys.sunsetTime,
      country: model.sys. country ??  'Unknown',
    );
  }

  Forecast _forecastModelToEntity(ForecastModel model) {
    final items = model.forecasts.map((forecastItem) {
      return ForecastItem(
        dateTime: forecastItem.dateTime,
        temperature: forecastItem.main. temperature,
        feelsLike:  forecastItem.main.feelsLike,
        tempMin:  forecastItem.main.tempMin,
        tempMax: forecastItem.main.tempMax,
        humidity: forecastItem.main.humidity,
        pressure: forecastItem.main.pressure,
        windSpeed: forecastItem. wind.speed,
        weatherCondition: forecastItem.weatherCondition,
        weatherDescription:  forecastItem.conditions. first.description,
        weatherIcon: forecastItem.weatherIcon,
        precipitationProbability: forecastItem.precipitationProbability,
      );
    }).toList();

    return Forecast(
      cityName: model.city.name,
      country: model.city.country,
      items: items,
    );
  }
}