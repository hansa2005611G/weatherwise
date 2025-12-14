// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherAlert _$WeatherAlertFromJson(Map<String, dynamic> json) => WeatherAlert(
      id: json['id'] as String,
      cityName: json['cityName'] as String,
      type: $enumDecode(_$AlertTypeEnumMap, json['type']),
      condition: $enumDecode(_$AlertConditionEnumMap, json['condition']),
      threshold: (json['threshold'] as num).toDouble(),
      isEnabled: json['isEnabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$WeatherAlertToJson(WeatherAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cityName': instance.cityName,
      'type': _$AlertTypeEnumMap[instance.type]!,
      'condition': _$AlertConditionEnumMap[instance.condition]!,
      'threshold': instance.threshold,
      'isEnabled': instance.isEnabled,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$AlertTypeEnumMap = {
  AlertType.temperature: 'temperature',
  AlertType.rain: 'rain',
  AlertType.wind: 'wind',
  AlertType.humidity: 'humidity',
};

const _$AlertConditionEnumMap = {
  AlertCondition.above: 'above',
  AlertCondition.below: 'below',
};

AlertNotification _$AlertNotificationFromJson(Map<String, dynamic> json) =>
    AlertNotification(
      id: json['id'] as String,
      alertId: json['alertId'] as String,
      cityName: json['cityName'] as String,
      message: json['message'] as String,
      triggeredAt: DateTime.parse(json['triggeredAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$AlertNotificationToJson(AlertNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alertId': instance.alertId,
      'cityName': instance.cityName,
      'message': instance.message,
      'triggeredAt': instance.triggeredAt.toIso8601String(),
      'isRead': instance.isRead,
    };
