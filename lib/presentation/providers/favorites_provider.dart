import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/local/local_storage_service.dart';
import 'weather_provider.dart';

// Favorites state
class FavoritesState {
  final List<String> cities;
  final bool isLoading;
  final String? error;

  FavoritesState({
    this.cities = const [],
    this.isLoading = false,
    this.error,
  });

  FavoritesState copyWith({
    List<String>? cities,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      cities: cities ?? this.cities,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Favorites notifier
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final LocalStorageService _storageService;

  FavoritesNotifier(this._storageService) : super(FavoritesState()) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final cities = _storageService.getFavoriteCities();
    state = state.copyWith(cities: cities);
  }

  Future<void> addCity(String cityName) async {
    if (state.cities.contains(cityName)) {
      state = state.copyWith(error: 'City already in favorites');
      return;
    }

    final success = await _storageService.addFavoriteCity(cityName);
    if (success) {
      state = state.copyWith(
        cities: [...state.cities, cityName],
        error: null,
      );
    } else {
      state = state. copyWith(error: 'Failed to add city');
    }
  }

  Future<void> removeCity(String cityName) async {
    final success = await _storageService. removeFavoriteCity(cityName);
    if (success) {
      state = state.copyWith(
        cities: state.cities.where((city) => city != cityName).toList(),
        error: null,
      );
    } else {
      state = state.copyWith(error: 'Failed to remove city');
    }
  }

  Future<void> reorderCities(int oldIndex, int newIndex) async {
    final cities = List<String>.from(state.cities);
    
    if (newIndex > oldIndex) {
      newIndex--;
    }
    
    final city = cities. removeAt(oldIndex);
    cities.insert(newIndex, city);

    await _storageService.saveFavoriteCities(cities);
    state = state.copyWith(cities: cities);
  }

  bool isFavorite(String cityName) {
    return state.cities. contains(cityName);
  }
}

// Favorites provider
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>(
  (ref) {
    final storageService = ref.watch(localStorageServiceProvider);
    return FavoritesNotifier(storageService);
  },
);