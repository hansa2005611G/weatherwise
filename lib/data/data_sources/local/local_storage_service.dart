import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/constants/app_constants.dart';

class LocalStorageService {
  late final SharedPreferences _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
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