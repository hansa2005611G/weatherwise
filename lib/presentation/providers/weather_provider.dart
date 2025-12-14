import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/remote/weather_api_service.dart';
import '../../data/data_sources/local/local_storage_service.dart';
import '../../core/network/api_client.dart';
import '../../data/models/weather_model.dart';
import '../../data/models/forecast_model.dart';

// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Provider for WeatherApiService
final weatherApiServiceProvider = Provider<WeatherApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WeatherApiService(apiClient);
});

// Provider for LocalStorageService
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

// State class for weather
class WeatherState {
  final WeatherModel? weather;
  final ForecastModel? forecast;
  final bool isLoading;
  final String?  error;
  final String? currentCity;

  WeatherState({
    this.weather,
    this.forecast,
    this. isLoading = false,
    this.error,
    this. currentCity,
  });

  WeatherState copyWith({
    WeatherModel? weather,
    ForecastModel? forecast,
    bool? isLoading,
    String? error,
    String?  currentCity,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      forecast: forecast ?? this. forecast,
      isLoading:  isLoading ?? this.isLoading,
      error: error,
      currentCity: currentCity ??  this.currentCity,
    );
  }
}

// Weather StateNotifier
class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  WeatherNotifier(this._apiService, this._storageService)
      : super(WeatherState());

  /// Fetch weather by city name
  Future<void> fetchWeatherByCity(String cityName) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Check cache first
      final cachedData = _storageService.getCachedWeatherData(cityName);
      if (cachedData != null) {
        final weather = WeatherModel.fromJson(cachedData);
        state = state. copyWith(
          weather: weather,
          currentCity: cityName,
          isLoading: false,
        );
        // Fetch in background
        _fetchAndUpdateWeather(cityName);
        return;
      }

      // Fetch from API
      await _fetchAndUpdateWeather(cityName);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> _fetchAndUpdateWeather(String cityName) async {
    final weather = await _apiService.getCurrentWeatherByCity(cityName);
    
    // Cache the weather data
    await _storageService.cacheWeatherData(cityName, weather. toJson());
    
    // Save as last location
    await _storageService.saveLastLocation(cityName);

    state = state.copyWith(
      weather: weather,
      currentCity: cityName,
      isLoading: false,
      error: null,
    );
  }

  /// Fetch weather by coordinates
  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final weather = await _apiService.getCurrentWeatherByCoordinates(
        latitude: lat,
        longitude: lon,
      );

      state = state.copyWith(
        weather: weather,
        currentCity: weather.cityName,
        isLoading:  false,
      );

      // Save location
      await _storageService. saveLastLocation(weather.cityName);
    } catch (e) {
      state = state.copyWith(
        isLoading:  false,
        error: e. toString(),
      );
    }
  }

  /// Fetch forecast
  Future<void> fetchForecast(String cityName) async {
    try {
      final forecast = await _apiService.getForecastByCity(cityName);
      state = state.copyWith(forecast: forecast);
    } catch (e) {
      // Handle error silently for forecast
      state = state.copyWith(error: 'Failed to load forecast');
    }
  }

  /// Refresh weather data
  Future<void> refreshWeather() async {
    if (state.currentCity != null) {
      await fetchWeatherByCity(state.currentCity!);
      await fetchForecast(state.currentCity!);
    }
  }
}

// Weather Provider
final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>(
  (ref) {
    final apiService = ref.watch(weatherApiServiceProvider);
    final storageService = ref.watch(localStorageServiceProvider);
    return WeatherNotifier(apiService, storageService);
  },
);