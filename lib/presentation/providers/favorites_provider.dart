import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/local/local_storage_service.dart';
import '../../data/data_sources/remote/weather_api_service.dart';  // ✅ ADD THIS
import '../../data/models/weather_model.dart';
import 'weather_provider.dart';

// Favorite city with weather data
class FavoriteCityData {
  final String cityName;
  final WeatherModel?  weather;
  final bool isLoading;
  final String?  error;

  FavoriteCityData({
    required this. cityName,
    this.weather,
    this.isLoading = false,
    this.error,
  });

  FavoriteCityData copyWith({
    String? cityName,
    WeatherModel? weather,
    bool? isLoading,
    String? error,
  }) {
    return FavoriteCityData(
      cityName:  cityName ?? this.cityName,
      weather: weather ?? this. weather,
      isLoading:  isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Favorites state
class FavoritesState {
  final List<FavoriteCityData> cities;
  final bool isLoading;
  final String? error;
  final ViewMode viewMode;

  FavoritesState({
    this.cities = const [],
    this.isLoading = false,
    this.error,
    this.viewMode = ViewMode.grid,
  });

  FavoritesState copyWith({
    List<FavoriteCityData>? cities,
    bool?  isLoading,
    String?  error,
    ViewMode? viewMode,
  }) {
    return FavoritesState(
      cities: cities ?? this.cities,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      viewMode: viewMode ??  this.viewMode,
    );
  }
}

// View mode enum
enum ViewMode { grid, list }

// Favorites notifier
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final LocalStorageService _storageService;
  final WeatherApiService _apiService;

  FavoritesNotifier(this._storageService, this._apiService)
      : super(FavoritesState()) {
    _loadFavorites();
  }

  // Load favorites and their weather data
  Future<void> _loadFavorites() async {
    final cityNames = _storageService.getFavoriteCities();
    final cities = cityNames
        .map((name) => FavoriteCityData(cityName: name))
        .toList();

    state = state.copyWith(cities: cities);

    // Fetch weather for all cities
    await _fetchWeatherForAllCities();
  }

  // Fetch weather for all favorite cities
  Future<void> _fetchWeatherForAllCities() async {
    final updatedCities = <FavoriteCityData>[];

    for (var city in state.cities) {
      updatedCities.add(city. copyWith(isLoading: true));
    }

    state = state.copyWith(cities: updatedCities);

    // Fetch weather for each city
    for (var i = 0; i < updatedCities.length; i++) {
      try {
        final weather = await _apiService.getCurrentWeatherByCity(
          updatedCities[i].cityName,
        );

        updatedCities[i] = updatedCities[i]. copyWith(
          weather: weather,
          isLoading: false,
        );

        // Update state after each fetch for progressive loading
        state = state.copyWith(cities: List.from(updatedCities));
      } catch (e) {
        updatedCities[i] = updatedCities[i].copyWith(
          isLoading: false,
          error: e.toString(),
        );
        state = state.copyWith(cities: List.from(updatedCities));
      }
    }
  }

  // Add city to favorites
  Future<void> addCity(String cityName) async {
    // Check if already exists
    if (state.cities.any((city) => city.cityName.toLowerCase() == cityName.toLowerCase())) {
      state = state.copyWith(error: 'City already in favorites');
      return;
    }

    // Add to local storage
    final success = await _storageService.addFavoriteCity(cityName);
    
    if (success) {
      final newCity = FavoriteCityData(
        cityName: cityName,
        isLoading: true,
      );

      state = state.copyWith(
        cities: [...state.cities, newCity],
        error: null,
      );

      // Fetch weather for the new city
      try {
        final weather = await _apiService.getCurrentWeatherByCity(cityName);
        
        final updatedCities = state.cities.map((city) {
          if (city.cityName == cityName) {
            return city.copyWith(weather: weather, isLoading: false);
          }
          return city;
        }).toList();

        state = state.copyWith(cities: updatedCities);
      } catch (e) {
        final updatedCities = state.cities.map((city) {
          if (city.cityName == cityName) {
            return city. copyWith(isLoading: false, error: e.toString());
          }
          return city;
        }).toList();

        state = state.copyWith(cities: updatedCities);
      }
    } else {
      state = state.copyWith(error: 'Failed to add city');
    }
  }

  // Remove city from favorites
  Future<void> removeCity(String cityName) async {
    final success = await _storageService.removeFavoriteCity(cityName);
    
    if (success) {
      state = state.copyWith(
        cities: state.cities.where((city) => city.cityName != cityName).toList(),
        error: null,
      );
    } else {
      state = state. copyWith(error: 'Failed to remove city');
    }
  }

  // Reorder cities
  Future<void> reorderCities(int oldIndex, int newIndex) async {
    final cities = List<FavoriteCityData>.from(state.cities);
    
    if (newIndex > oldIndex) {
      newIndex--;
    }
    
    final city = cities. removeAt(oldIndex);
    cities.insert(newIndex, city);

    // Save to local storage
    final cityNames = cities.map((c) => c.cityName).toList();
    await _storageService.saveFavoriteCities(cityNames);

    state = state.copyWith(cities: cities);
  }

  // Update city nickname
  Future<void> updateCityNickname(String oldName, String newName) async {
    final cities = state.cities.map((city) {
      if (city.cityName == oldName) {
        return FavoriteCityData(
          cityName: newName,
          weather: city.weather,
          isLoading: city.isLoading,
          error: city.error,
        );
      }
      return city;
    }).toList();

    // Save to local storage
    final cityNames = cities.map((c) => c.cityName).toList();
    await _storageService.saveFavoriteCities(cityNames);

    state = state.copyWith(cities: cities);
  }

  // Toggle view mode
  void toggleViewMode() {
    state = state.copyWith(
      viewMode: state.viewMode == ViewMode.grid ?  ViewMode.list : ViewMode. grid,
    );
  }

  // Refresh weather for all cities
  Future<void> refreshWeather() async {
    await _fetchWeatherForAllCities();
  }

  // Refresh weather for specific city
  Future<void> refreshCityWeather(String cityName) async {
    final updatedCities = state.cities.map((city) {
      if (city.cityName == cityName) {
        return city.copyWith(isLoading: true, error: null);
      }
      return city;
    }).toList();

    state = state. copyWith(cities: updatedCities);

    try {
      final weather = await _apiService. getCurrentWeatherByCity(cityName);
      
      final finalCities = state.cities.map((city) {
        if (city.cityName == cityName) {
          return city.copyWith(weather: weather, isLoading: false);
        }
        return city;
      }).toList();

      state = state.copyWith(cities: finalCities);
    } catch (e) {
      final finalCities = state.cities. map((city) {
        if (city.cityName == cityName) {
          return city.copyWith(isLoading: false, error: e.toString());
        }
        return city;
      }).toList();

      state = state.copyWith(cities: finalCities);
    }
  }

  // Check if city is favorite
  bool isFavorite(String cityName) {
    return state.cities.any(
      (city) => city.cityName.toLowerCase() == cityName.toLowerCase(),
    );
  }
}

// Favorites provider
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>(
  (ref) {
    final storageService = ref.watch(localStorageServiceProvider);
    final apiService = ref.watch(weatherApiServiceProvider);
    return FavoritesNotifier(storageService, apiService);
  },
);