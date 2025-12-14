import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/local/local_storage_service.dart';
import 'weather_provider.dart';

// Settings state
class SettingsState {
  final bool isCelsius;
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String windSpeedUnit; // 'km/h' or 'mph'
  final int refreshInterval; // in minutes
  final String language;

  SettingsState({
    this.isCelsius = true,
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.windSpeedUnit = 'km/h',
    this. refreshInterval = 30,
    this.language = 'en',
  });

  SettingsState copyWith({
    bool? isCelsius,
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? windSpeedUnit,
    int? refreshInterval,
    String? language,
  }) {
    return SettingsState(
      isCelsius: isCelsius ?? this. isCelsius,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit,
      refreshInterval:  refreshInterval ?? this.refreshInterval,
      language: language ?? this. language,
    );
  }
}

// Settings notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  final LocalStorageService _storageService;

  SettingsNotifier(this._storageService) : super(SettingsState()) {
    _loadSettings();
  }

  // Load all settings from storage
  void _loadSettings() {
    final isCelsius = _storageService.getTemperatureUnit();
    final isDarkMode = _storageService.getThemeMode();
    final notificationsEnabled = _storageService.getNotificationsEnabled();
    final windSpeedUnit = _storageService. getWindSpeedUnit();
    final refreshInterval = _storageService.getRefreshInterval();
    final language = _storageService. getLanguage();

    state = SettingsState(
      isCelsius: isCelsius,
      isDarkMode: isDarkMode,
      notificationsEnabled: notificationsEnabled,
      windSpeedUnit: windSpeedUnit,
      refreshInterval:  refreshInterval,
      language: language,
    );
  }

  // Toggle temperature unit
  Future<void> toggleTemperatureUnit() async {
    final newValue = !state.isCelsius;
    await _storageService.setTemperatureUnit(newValue);
    state = state.copyWith(isCelsius: newValue);
  }

  // Set specific temperature unit
  Future<void> setTemperatureUnit(bool isCelsius) async {
    await _storageService.setTemperatureUnit(isCelsius);
    state = state.copyWith(isCelsius: isCelsius);
  }

  // Toggle theme mode
  Future<void> toggleThemeMode() async {
    final newValue = !state.isDarkMode;
    await _storageService.setThemeMode(newValue);
    state = state.copyWith(isDarkMode: newValue);
  }

  // Toggle notifications
  Future<void> toggleNotifications() async {
    final newValue = !state.notificationsEnabled;
    await _storageService.setNotificationsEnabled(newValue);
    state = state.copyWith(notificationsEnabled: newValue);
  }

  // Set wind speed unit
  Future<void> setWindSpeedUnit(String unit) async {
    await _storageService. setWindSpeedUnit(unit);
    state = state.copyWith(windSpeedUnit: unit);
  }

  // Set refresh interval
  Future<void> setRefreshInterval(int minutes) async {
    await _storageService.setRefreshInterval(minutes);
    state = state.copyWith(refreshInterval: minutes);
  }

  // Set language
  Future<void> setLanguage(String language) async {
    await _storageService.setLanguage(language);
    state = state.copyWith(language: language);
  }

  // Clear all cache
  Future<void> clearCache() async {
    await _storageService.clearWeatherCache();
  }

  // Reset all settings to default
  Future<void> resetSettings() async {
    await _storageService.setTemperatureUnit(true);
    await _storageService.setThemeMode(false);
    await _storageService.setNotificationsEnabled(true);
    await _storageService.setWindSpeedUnit('km/h');
    await _storageService.setRefreshInterval(30);
    await _storageService.setLanguage('en');

    state = SettingsState();
  }
}

// Settings provider
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    final storageService = ref.watch(localStorageServiceProvider);
    return SettingsNotifier(storageService);
  },
);