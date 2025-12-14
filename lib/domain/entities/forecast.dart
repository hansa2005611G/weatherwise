import 'package:equatable/equatable.dart';

class Forecast extends Equatable {
  final String cityName;
  final String country;
  final List<ForecastItem> items;

  const Forecast({
    required this.cityName,
    required this.country,
    required this.items,
  });

  @override
  List<Object? > get props => [cityName, country, items];
}

class ForecastItem extends Equatable {
  final DateTime dateTime;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String weatherCondition;
  final String weatherDescription;
  final String weatherIcon;
  final double precipitationProbability;

  const ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.weatherCondition,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.precipitationProbability,
  });

  @override
  List<Object? > get props => [
        dateTime,
        temperature,
        feelsLike,
        tempMin,
        tempMax,
        humidity,
        pressure,
        windSpeed,
        weatherCondition,
        weatherDescription,
        weatherIcon,
        precipitationProbability,
      ];
}