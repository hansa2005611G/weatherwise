class TemperatureConverter {
  TemperatureConverter._();

  /// Convert Celsius to Fahrenheit
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  /// Convert Fahrenheit to Celsius
  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  /// Format temperature with unit symbol
  static String formatTemperature(double temperature, bool isCelsius) {
    final roundedTemp = temperature.round();
    return isCelsius ? '$roundedTemp°C' : '$roundedTemp°F';
  }

  /// Get temperature with appropriate unit
  static double getTemperatureInUnit(double celsius, bool isCelsius) {
    return isCelsius ? celsius : celsiusToFahrenheit(celsius);
  }
}