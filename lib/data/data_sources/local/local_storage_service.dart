import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherwise/data/models/alert_model.dart';
import 'dart:convert';
import '../../../core/constants/app_constants.dart';

class LocalStorageService {
  late final SharedPreferences _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
// Alerts
Future<bool> saveAlerts(List<WeatherAlert> alerts) async {
  final jsonList = alerts.map((alert) => alert.toJson()).toList();
  final jsonString = json.encode(jsonList);
  return await _prefs.setString('weather_alerts', jsonString);
}

List<WeatherAlert> getAlerts() {
  final jsonString = _prefs.getString('weather_alerts');
  if (jsonString == null) return [];

  try {
    final jsonList = json.decode(jsonString) as List;
    return jsonList.map((json) => WeatherAlert.fromJson(json)).toList();
  } catch (e) {
    return [];
  }
}

// Alert Notifications
Future<bool> saveAlertNotifications(List<AlertNotification> notifications) async {
  final jsonList = notifications.map((n) => n.toJson()).toList();
  final jsonString = json.encode(jsonList);
  return await _prefs.setString('alert_notifications', jsonString);
}

List<AlertNotification> getAlertNotifications() {
  final jsonString = _prefs. getString('alert_notifications');
  if (jsonString == null) return [];

  try {
    final jsonList = json.decode(jsonString) as List;
    return jsonList.map((json) => AlertNotification.fromJson(json)).toList();
  } catch (e) {
    return [];
  }
}

  // Favorite Cities
  Future<bool> saveFavoriteCities(List<String> cities) async {
    return await _prefs.setStringList(AppConstants.keyFavoriteCities, cities);
  }

  List<String> getFavoriteCities() {
    return _prefs.getStringList(AppConstants. keyFavoriteCities) ?? [];
  }

  Future<bool> addFavoriteCity(String city) async {
    final cities = getFavoriteCities();
    if (! cities.contains(city)) {
      cities.add(city);
      return await saveFavoriteCities(cities);
    }
    return false;
  }

  Future<bool> removeFavoriteCity(String city) async {
    final cities = getFavoriteCities();
    cities.remove(city);
    return await saveFavoriteCities(cities);
  }
  
  // Recent Searches
  Future<bool> saveRecentSearches(List<String> searches) async {
    return await _prefs.setStringList('recent_searches', searches);
  }

  List<String> getRecentSearches() {
  return _prefs.getStringList('recent_searches') ?? [];
  }
  

  // Temperature Unit
  Future<bool> setTemperatureUnit(bool isCelsius) async {
    return await _prefs.setBool(AppConstants.keyTemperatureUnit, isCelsius);
  }

  bool getTemperatureUnit() {
    return _prefs.getBool(AppConstants. keyTemperatureUnit) ?? true;
  }

  // Theme Mode
  Future<bool> setThemeMode(bool isDark) async {
    return await _prefs.setBool(AppConstants.keyThemeMode, isDark);
  }

  bool getThemeMode() {
    return _prefs.getBool(AppConstants.keyThemeMode) ?? false;
  }
  // Add these methods to the LocalStorageService class

// Wind Speed Unit
Future<bool> setWindSpeedUnit(String unit) async {
  return await _prefs.setString('wind_speed_unit', unit);
}

String getWindSpeedUnit() {
  return _prefs.getString('wind_speed_unit') ?? 'km/h';
}

// Refresh Interval
Future<bool> setRefreshInterval(int minutes) async {
  return await _prefs.setInt('refresh_interval', minutes);
}

int getRefreshInterval() {
  return _prefs.getInt('refresh_interval') ?? 30;
}

// Language
Future<bool> setLanguage(String language) async {
  return await _prefs.setString('language', language);
}

String getLanguage() {
  return _prefs.getString('language') ?? 'en';
}

// Clear weather cache
Future<bool> clearWeatherCache() async {
  final keys = _prefs.getKeys();
  final cacheKeys = keys.where((key) => key.startsWith(AppConstants.keyCachedWeather));
  
  for (var key in cacheKeys) {
    await _prefs.remove(key);
  }
  
  return true;
}

  // Notifications
  Future<bool> setNotificationsEnabled(bool enabled) async {
    return await _prefs.setBool(AppConstants.keyNotificationsEnabled, enabled);
  }

  bool getNotificationsEnabled() {
    return _prefs.getBool(AppConstants.keyNotificationsEnabled) ?? true;
  }

  // Last Location
  Future<bool> saveLastLocation(String cityName) async {
    return await _prefs.setString(AppConstants.keyLastLocation, cityName);
  }

  String?  getLastLocation() {
    return _prefs.getString(AppConstants.keyLastLocation);
  }

  // Cache weather data
  Future<bool> cacheWeatherData(String cityName, Map<String, dynamic> data) async {
    final cacheKey = '${AppConstants.keyCachedWeather}_$cityName';
    final cacheData = {
      'data': data,
      'timestamp': DateTime. now().millisecondsSinceEpoch,
    };
    return await _prefs.setString(cacheKey, json.encode(cacheData));
  }

  Map<String, dynamic>? getCachedWeatherData(String cityName) {
    final cacheKey = '${AppConstants.keyCachedWeather}_$cityName';
    final cachedString = _prefs.getString(cacheKey);
    
    if (cachedString == null) return null;

    final cacheData = json. decode(cachedString);
    final timestamp = cacheData['timestamp'] as int;
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    
    // Check if cache is still valid
    if (DateTime.now().difference(cacheTime) < AppConstants.cacheExpiration) {
      return cacheData['data'] as Map<String, dynamic>;
    }
    
    return null;
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}