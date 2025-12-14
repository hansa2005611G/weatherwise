class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  
  // Your API Key
  static const String apiKey = '373229ee8ef1966e4011e95a0e4680c0';

  // Endpoints
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  static const String oneCall = '/onecall';
  
  // Geocoding
  static const String geoBaseUrl = 'https://api.openweathermap.org/geo/1.0';
  static const String directGeocoding = '/direct';
  static const String reverseGeocoding = '/reverse';

  // Units
  static const String metricUnits = 'metric';
  static const String imperialUnits = 'imperial';

  // Limits
  static const int searchLimit = 5;
  static const int forecastDays = 7;
}