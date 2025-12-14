import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDegree;
  final String weatherCondition;
  final String weatherDescription;
  final String weatherIcon;
  final int cloudiness;
  final DateTime dateTime;
  final DateTime sunrise;
  final DateTime sunset;
  final String country;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this. tempMin,
    required this. tempMax,
    required this. humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDegree,
    required this. weatherCondition,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.cloudiness,
    required this.dateTime,
    required this.sunrise,
    required this. sunset,
    required this.country,
  });

  @override
  List<Object?> get props => [
        cityName,
        temperature,
        feelsLike,
        tempMin,
        tempMax,
        humidity,
        pressure,
        windSpeed,
        windDegree,
        weatherCondition,
        weatherDescription,
        weatherIcon,
        cloudiness,
        dateTime,
        sunrise,
        sunset,
        country,
      ];
}