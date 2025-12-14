import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel {
  @JsonKey(name:  'coord')
  final CoordinatesModel?  coordinates;
  
  @JsonKey(name: 'weather')
  final List<WeatherConditionModel> conditions;
  
  @JsonKey(name: 'main')
  final MainWeatherModel main;
  
  @JsonKey(name: 'wind')
  final WindModel wind;
  
  @JsonKey(name: 'clouds')
  final CloudsModel clouds;
  
  @JsonKey(name: 'sys')
  final SysModel sys;
  
  @JsonKey(name: 'name')
  final String cityName;
  
  @JsonKey(name: 'dt')
  final int timestamp;

  WeatherModel({
    this.coordinates,
    required this.conditions,
    required this.main,
    required this.wind,
    required this.clouds,
    required this.sys,
    required this.cityName,
    required this.timestamp,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  // Helper getters
  String get weatherCondition => conditions.isNotEmpty 
      ? conditions. first.main 
      : 'Unknown';
  
  String get weatherDescription => conditions.isNotEmpty 
      ? conditions.first.description 
      : 'No description';
  
  String get weatherIcon => conditions.isNotEmpty 
      ? conditions.first.icon 
      : '01d';

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}

@JsonSerializable()
class CoordinatesModel {
  @JsonKey(name: 'lat')
  final double latitude;
  
  @JsonKey(name: 'lon')
  final double longitude;

  CoordinatesModel({
    required this.latitude,
    required this.longitude,
  });

  factory CoordinatesModel. fromJson(Map<String, dynamic> json) =>
      _$CoordinatesModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinatesModelToJson(this);
}

@JsonSerializable()
class WeatherConditionModel {
  @JsonKey(name: 'id')
  final int id;
  
  @JsonKey(name: 'main')
  final String main;
  
  @JsonKey(name:  'description')
  final String description;
  
  @JsonKey(name: 'icon')
  final String icon;

  WeatherConditionModel({
    required this.id,
    required this.main,
    required this.description,
    required this. icon,
  });

  factory WeatherConditionModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherConditionModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherConditionModelToJson(this);
}

@JsonSerializable()
class MainWeatherModel {
  @JsonKey(name:  'temp')
  final double temperature;
  
  @JsonKey(name: 'feels_like')
  final double feelsLike;
  
  @JsonKey(name: 'temp_min')
  final double tempMin;
  
  @JsonKey(name: 'temp_max')
  final double tempMax;
  
  @JsonKey(name: 'pressure')
  final int pressure;
  
  @JsonKey(name: 'humidity')
  final int humidity;

  MainWeatherModel({
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory MainWeatherModel. fromJson(Map<String, dynamic> json) =>
      _$MainWeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$MainWeatherModelToJson(this);
}

@JsonSerializable()
class WindModel {
  @JsonKey(name: 'speed')
  final double speed;
  
  @JsonKey(name: 'deg')
  final int degree;

  WindModel({
    required this.speed,
    required this.degree,
  });

  factory WindModel.fromJson(Map<String, dynamic> json) =>
      _$WindModelFromJson(json);

  Map<String, dynamic> toJson() => _$WindModelToJson(this);
}

@JsonSerializable()
class CloudsModel {
  @JsonKey(name:  'all')
  final int cloudiness;

  CloudsModel({required this.cloudiness});

  factory CloudsModel.fromJson(Map<String, dynamic> json) =>
      _$CloudsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CloudsModelToJson(this);
}

@JsonSerializable()
class SysModel {
  @JsonKey(name: 'country')
  final String? country;
  
  @JsonKey(name: 'sunrise')
  final int sunrise;
  
  @JsonKey(name:  'sunset')
  final int sunset;

  SysModel({
    this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory SysModel.fromJson(Map<String, dynamic> json) =>
      _$SysModelFromJson(json);

  Map<String, dynamic> toJson() => _$SysModelToJson(this);

  DateTime get sunriseTime => 
      DateTime.fromMillisecondsSinceEpoch(sunrise * 1000);
  
  DateTime get sunsetTime => 
      DateTime.fromMillisecondsSinceEpoch(sunset * 1000);
}