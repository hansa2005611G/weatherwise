import 'package:json_annotation/json_annotation.dart';

part 'alert_model.g.dart';

@JsonSerializable()
class WeatherAlert {
  final String id;
  final String cityName;
  final AlertType type;
  final AlertCondition condition;
  final double threshold;
  final bool isEnabled;
  final DateTime createdAt;

  WeatherAlert({
    required this.id,
    required this.cityName,
    required this.type,
    required this. condition,
    required this.threshold,
    this.isEnabled = true,
    required this.createdAt,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) =>
      _$WeatherAlertFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherAlertToJson(this);

  WeatherAlert copyWith({
    String? id,
    String? cityName,
    AlertType? type,
    AlertCondition? condition,
    double? threshold,
    bool? isEnabled,
    DateTime? createdAt,
  }) {
    return WeatherAlert(
      id: id ?? this.id,
      cityName: cityName ?? this.cityName,
      type: type ?? this. type,
      condition: condition ??  this.condition,
      threshold: threshold ?? this.threshold,
      isEnabled: isEnabled ?? this. isEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get description {
    switch (type) {
      case AlertType.temperature:
        return 'Temperature ${condition == AlertCondition.above ? '>' : '<'} ${threshold. round()}°';
      case AlertType.rain:
        return 'Rain probability > ${threshold.round()}%';
      case AlertType.wind:
        return 'Wind speed > ${threshold.round()} km/h';
      case AlertType.humidity:
        return 'Humidity ${condition == AlertCondition.above ?  '>' : '<'} ${threshold.round()}%';
    }
  }

  String get icon {
    switch (type) {
      case AlertType.temperature:
        return '🌡️';
      case AlertType.rain:
        return '🌧️';
      case AlertType.wind:
        return '💨';
      case AlertType. humidity:
        return '💧';
    }
  }
}

enum AlertType {
  temperature,
  rain,
  wind,
  humidity,
}

enum AlertCondition {
  above,
  below,
}

// Alert notification history
@JsonSerializable()
class AlertNotification {
  final String id;
  final String alertId;
  final String cityName;
  final String message;
  final DateTime triggeredAt;
  final bool isRead;

  AlertNotification({
    required this.id,
    required this.alertId,
    required this.cityName,
    required this.message,
    required this.triggeredAt,
    this.isRead = false,
  });

  factory AlertNotification. fromJson(Map<String, dynamic> json) =>
      _$AlertNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$AlertNotificationToJson(this);

  AlertNotification copyWith({
    String? id,
    String?  alertId,
    String? cityName,
    String? message,
    DateTime? triggeredAt,
    bool? isRead,
  }) {
    return AlertNotification(
      id: id ??  this.id,
      alertId: alertId ?? this.alertId,
      cityName: cityName ?? this.cityName,
      message: message ?? this.message,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      isRead: isRead ??  this.isRead,
    );
  }
}