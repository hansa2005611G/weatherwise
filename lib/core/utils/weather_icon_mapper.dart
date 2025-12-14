import 'package:flutter/material.dart';

class WeatherIconMapper {
  WeatherIconMapper._();

  /// Map OpenWeatherMap icon codes to emoji icons
  static String getWeatherEmoji(String iconCode) {
    switch (iconCode) {
      case '01d':
        return '☀️';
      case '01n':
        return '🌙';
      case '02d':
      case '02n':
        return '⛅';
      case '03d':
      case '03n':
        return '☁️';
      case '04d':
      case '04n':
        return '🌥️';
      case '09d':
      case '09n': 
        return '🌧️';
      case '10d': 
      case '10n': 
        return '🌦️';
      case '11d':
      case '11n':
        return '⛈️';
      case '13d':
      case '13n':
        return '🌨️';
      case '50d':
      case '50n': 
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  /// Get weather condition colors
  static Color getWeatherColor(String condition) {
    switch (condition. toLowerCase()) {
      case 'clear':
        return const Color(0xFFFDB813);
      case 'clouds':
        return const Color(0xFF9E9E9E);
      case 'rain':
      case 'drizzle': 
        return const Color(0xFF5C9EAD);
      case 'thunderstorm':
        return const Color(0xFF4A5568);
      case 'snow':
        return const Color(0xFFE8F4F8);
      case 'mist':
      case 'fog':
        return const Color(0xFFBDBDBD);
      default:
        return const Color(0xFF4A90E2);
    }
  }

  /// Get gradient colors based on weather
  static List<Color> getWeatherGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return [const Color(0xFFFDB813), const Color(0xFFFFD54F)];
      case 'clouds':
        return [const Color(0xFF9E9E9E), const Color(0xFFBDBDBD)];
      case 'rain':
      case 'drizzle':
        return [const Color(0xFF5C9EAD), const Color(0xFF89CFF0)];
      case 'thunderstorm':
        return [const Color(0xFF4A5568), const Color(0xFF718096)];
      default:
        return [const Color(0xFF4A90E2), const Color(0xFF87CEEB)];
    }
  }
}