// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastModel _$ForecastModelFromJson(Map<String, dynamic> json) =>
    ForecastModel(
      forecasts: (json['list'] as List<dynamic>)
          .map((e) => ForecastItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      city: CityModel.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForecastModelToJson(ForecastModel instance) =>
    <String, dynamic>{
      'list': instance.forecasts,
      'city': instance.city,
    };

ForecastItemModel _$ForecastItemModelFromJson(Map<String, dynamic> json) =>
    ForecastItemModel(
      timestamp: (json['dt'] as num).toInt(),
      main: MainWeatherModel.fromJson(json['main'] as Map<String, dynamic>),
      conditions: (json['weather'] as List<dynamic>)
          .map((e) => WeatherConditionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      wind: WindModel.fromJson(json['wind'] as Map<String, dynamic>),
      clouds: CloudsModel.fromJson(json['clouds'] as Map<String, dynamic>),
      precipitationProbability: (json['pop'] as num).toDouble(),
    );

Map<String, dynamic> _$ForecastItemModelToJson(ForecastItemModel instance) =>
    <String, dynamic>{
      'dt': instance.timestamp,
      'main': instance.main,
      'weather': instance.conditions,
      'wind': instance.wind,
      'clouds': instance.clouds,
      'pop': instance.precipitationProbability,
    };

CityModel _$CityModelFromJson(Map<String, dynamic> json) => CityModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      coordinates:
          CoordinatesModel.fromJson(json['coord'] as Map<String, dynamic>),
      country: json['country'] as String,
    );

Map<String, dynamic> _$CityModelToJson(CityModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'coord': instance.coordinates,
      'country': instance.country,
    };
