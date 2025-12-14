import 'package:json_annotation/json_annotation.dart';
import 'weather_model.dart';

part 'forecast_model.g.dart';

@JsonSerializable()
class ForecastModel {
  @JsonKey(name: 'list')
  final List<ForecastItemModel> forecasts;
  
  @JsonKey(name: 'city')
  final CityModel city;

  ForecastModel({
    required this. forecasts,
    required this. city,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastModelToJson(this);
}

@JsonSerializable()
class ForecastItemModel {
  @JsonKey(name: 'dt')
  final int timestamp;
  
  @JsonKey(name: 'main')
  final MainWeatherModel main;
  
  @JsonKey(name: 'weather')
  final List<WeatherConditionModel> conditions;
  
  @JsonKey(name: 'wind')
  final WindModel wind;
  
  @JsonKey(name: 'clouds')
  final CloudsModel clouds;
  
  @JsonKey(name: 'pop')
  final double precipitationProbability;

  ForecastItemModel({
    required this.timestamp,
    required this.main,
    required this.conditions,
    required this.wind,
    required this. clouds,
    required this.precipitationProbability,
  });

  factory ForecastItemModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastItemModelToJson(this);

  DateTime get dateTime => 
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  String get weatherIcon => conditions.isNotEmpty 
      ? conditions.first.icon 
      : '01d';
  
  String get weatherCondition => conditions.isNotEmpty 
      ? conditions.first.main 
      : 'Unknown';
}

@JsonSerializable()
class CityModel {
  @JsonKey(name: 'id')
  final int id;
  
  @JsonKey(name:  'name')
  final String name;
  
  @JsonKey(name: 'coord')
  final CoordinatesModel coordinates;
  
  @JsonKey(name: 'country')
  final String country;

  CityModel({
    required this.id,
    required this.name,
    required this. coordinates,
    required this.country,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}