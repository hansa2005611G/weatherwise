// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
      coordinates: json['coord'] == null
          ? null
          : CoordinatesModel.fromJson(json['coord'] as Map<String, dynamic>),
      conditions: (json['weather'] as List<dynamic>)
          .map((e) => WeatherConditionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      main: MainWeatherModel.fromJson(json['main'] as Map<String, dynamic>),
      wind: WindModel.fromJson(json['wind'] as Map<String, dynamic>),
      clouds: CloudsModel.fromJson(json['clouds'] as Map<String, dynamic>),
      sys: SysModel.fromJson(json['sys'] as Map<String, dynamic>),
      cityName: json['name'] as String,
      timestamp: (json['dt'] as num).toInt(),
    );

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'coord': instance.coordinates,
      'weather': instance.conditions,
      'main': instance.main,
      'wind': instance.wind,
      'clouds': instance.clouds,
      'sys': instance.sys,
      'name': instance.cityName,
      'dt': instance.timestamp,
    };

CoordinatesModel _$CoordinatesModelFromJson(Map<String, dynamic> json) =>
    CoordinatesModel(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordinatesModelToJson(CoordinatesModel instance) =>
    <String, dynamic>{
      'lat': instance.latitude,
      'lon': instance.longitude,
    };

WeatherConditionModel _$WeatherConditionModelFromJson(
        Map<String, dynamic> json) =>
    WeatherConditionModel(
      id: (json['id'] as num).toInt(),
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$WeatherConditionModelToJson(
        WeatherConditionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };

MainWeatherModel _$MainWeatherModelFromJson(Map<String, dynamic> json) =>
    MainWeatherModel(
      temperature: (json['temp'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      tempMin: (json['temp_min'] as num).toDouble(),
      tempMax: (json['temp_max'] as num).toDouble(),
      pressure: (json['pressure'] as num).toInt(),
      humidity: (json['humidity'] as num).toInt(),
    );

Map<String, dynamic> _$MainWeatherModelToJson(MainWeatherModel instance) =>
    <String, dynamic>{
      'temp': instance.temperature,
      'feels_like': instance.feelsLike,
      'temp_min': instance.tempMin,
      'temp_max': instance.tempMax,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
    };

WindModel _$WindModelFromJson(Map<String, dynamic> json) => WindModel(
      speed: (json['speed'] as num).toDouble(),
      degree: (json['deg'] as num).toInt(),
    );

Map<String, dynamic> _$WindModelToJson(WindModel instance) => <String, dynamic>{
      'speed': instance.speed,
      'deg': instance.degree,
    };

CloudsModel _$CloudsModelFromJson(Map<String, dynamic> json) => CloudsModel(
      cloudiness: (json['all'] as num).toInt(),
    );

Map<String, dynamic> _$CloudsModelToJson(CloudsModel instance) =>
    <String, dynamic>{
      'all': instance.cloudiness,
    };

SysModel _$SysModelFromJson(Map<String, dynamic> json) => SysModel(
      country: json['country'] as String?,
      sunrise: (json['sunrise'] as num).toInt(),
      sunset: (json['sunset'] as num).toInt(),
    );

Map<String, dynamic> _$SysModelToJson(SysModel instance) => <String, dynamic>{
      'country': instance.country,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
    };
