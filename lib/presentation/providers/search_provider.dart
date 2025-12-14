import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/remote/weather_api_service.dart';
import '../../data/data_sources/local/local_storage_service.dart';
import 'weather_provider.dart';

// Search state
class SearchState {
  final List<CitySearchResult> results;
  final List<String> recentSearches;
  final bool isLoading;
  final String?  error;
  final String query;

  SearchState({
    this.results = const [],
    this.recentSearches = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
  });

  SearchState copyWith({
    List<CitySearchResult>? results,
    List<String>? recentSearches,
    bool? isLoading,
    String? error,
    String? query,
  }) {
    return SearchState(
      results: results ?? this.results,
      recentSearches:  recentSearches ?? this.recentSearches,
      isLoading: isLoading ?? this. isLoading,
      error:  error,
      query: query ?? this. query,
    );
  }
}

// City search result model
class CitySearchResult {
  final String name;
  final String country;
  final String?  state;
  final double latitude;
  final double longitude;

  CitySearchResult({
    required this.name,
    required this.country,
    this. state,
    required this.latitude,
    required this.longitude,
  });

  factory CitySearchResult.fromJson(Map<String, dynamic> json) {
    return CitySearchResult(
      name: json['name'] as String,
      country: json['country'] as String,
      state: json['state'] as String?,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
    );
  }

  String get displayName {
    if (state != null) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }
}

// Search notifier
class SearchNotifier extends StateNotifier<SearchState> {
  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  SearchNotifier(this._apiService, this._storageService)
      : super(SearchState()) {
    _loadRecentSearches();
  }

  // Load recent searches from local storage
  void _loadRecentSearches() {
    final recent = _storageService.getRecentSearches();
    state = state.copyWith(recentSearches: recent);
  }

  // Search cities
  Future<void> searchCities(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(
        results: [],
        query: '',
        error: null,
      );
      return;
    }

    state = state. copyWith(
      isLoading: true,
      error: null,
      query: query,
    );

    try {
      final response = await _apiService.searchCities(query);
      
      final results = response
          .map((json) => CitySearchResult.fromJson(json))
          .toList();

      state = state.copyWith(
        results: results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to search cities: ${e.toString()}',
        results: [],
      );
    }
  }

  // Clear search
  void clearSearch() {
    state = state.copyWith(
      results: [],
      query:  '',
      error: null,
    );
  }

  // Add to recent searches
  Future<void> addToRecentSearches(String cityName) async {
    final recent = List<String>.from(state.recentSearches);
    
    // Remove if already exists
    recent.remove(cityName);
    
    // Add to beginning
    recent.insert(0, cityName);
    
    // Keep only last 10
    if (recent.length > 10) {
      recent.removeRange(10, recent.length);
    }

    await _storageService.saveRecentSearches(recent);
    state = state.copyWith(recentSearches: recent);
  }

  // Remove from recent searches
  Future<void> removeFromRecentSearches(String cityName) async {
    final recent = state.recentSearches. where((city) => city != cityName).toList();
    await _storageService.saveRecentSearches(recent);
    state = state.copyWith(recentSearches: recent);
  }

  // Clear all recent searches
  Future<void> clearRecentSearches() async {
    await _storageService.saveRecentSearches([]);
    state = state.copyWith(recentSearches: []);
  }
}

// Search provider
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>(
  (ref) {
    final apiService = ref.watch(weatherApiServiceProvider);
    final storageService = ref.watch(localStorageServiceProvider);
    return SearchNotifier(apiService, storageService);
  },
);