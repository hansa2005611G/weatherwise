import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/local/local_storage_service.dart';
import 'weather_provider.dart';

// Settings state
class SettingsState {
  final bool isCelsius;
  final bool isDarkMode;
  final bool notificationsEnabled;

  SettingsState({
    this.isCelsius = true,
    this.isDarkMode = false,
    this.notificationsEnabled = true,
  });

  SettingsState copyWith({
    bool? isCelsius,
    bool? isDarkMode,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      isCelsius: isCelsius ?? this.isCelsius,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

// Settings notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  final LocalStorageService _storageService;

  SettingsNotifier(this._storageService) : super(SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final isCelsius = _storageService.getTemperatureUnit();
    final isDarkMode = _storageService.getThemeMode();
    final notificationsEnabled = _storageService.getNotificationsEnabled();

    state = SettingsState(
      isCelsius: isCelsius,
      isDarkMode: isDarkMode,
      notificationsEnabled: notificationsEnabled,
    );
  }

  Future<void> toggleTemperatureUnit() async {
    final newValue = !state.isCelsius;
    await _storageService.setTemperatureUnit(newValue);
    state = state.copyWith(isCelsius: newValue);
  }

  Future<void> toggleThemeMode() async {
    final newValue = !state. isDarkMode;
    await _storageService.setThemeMode(newValue);
    state = state.copyWith(isDarkMode: newValue);
  }

  Future<void> toggleNotifications() async {
    final newValue = !state.notificationsEnabled;
    await _storageService.setNotificationsEnabled(newValue);
    state = state. copyWith(notificationsEnabled:  newValue);
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