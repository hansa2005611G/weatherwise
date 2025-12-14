class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'WeatherWise';
  static const String appVersion = '1.0.0';
  
  // Local Storage Keys
  static const String keyFavoriteCities = 'favorite_cities';
  static const String keyThemeMode = 'theme_mode';
  static const String keyTemperatureUnit = 'temperature_unit';
  static const String keyWindSpeedUnit = 'wind_speed_unit';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyLastLocation = 'last_location';
  static const String keyCachedWeather = 'cached_weather';

  // Default Values
  static const String defaultCity = 'London';
  static const double defaultLatitude = 51.5074;
  static const double defaultLongitude = -0.1278;

  // Refresh Intervals
  static const Duration weatherRefreshInterval = Duration(minutes: 30);
  static const Duration cacheExpiration = Duration(hours: 1);

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);
}