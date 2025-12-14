import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/data_sources/local/local_storage_service.dart';
import '../../data/models/alert_model.dart';
import 'weather_provider.dart';

// Alerts state
class AlertsState {
  final List<WeatherAlert> alerts;
  final List<AlertNotification> notifications;
  final bool isLoading;
  final String? error;

  AlertsState({
    this.alerts = const [],
    this.notifications = const [],
    this.isLoading = false,
    this.error,
  });

  AlertsState copyWith({
    List<WeatherAlert>? alerts,
    List<AlertNotification>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return AlertsState(
      alerts:  alerts ?? this.alerts,
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  int get activeAlertsCount => alerts.where((a) => a.isEnabled).length;
  int get unreadNotificationsCount =>
      notifications. where((n) => !n.isRead).length;
}

// Alerts notifier
class AlertsNotifier extends StateNotifier<AlertsState> {
  final LocalStorageService _storageService;
  final Uuid _uuid = const Uuid();

  AlertsNotifier(this._storageService) : super(AlertsState()) {
    _loadAlerts();
  }

  // Load alerts and notifications from storage
  Future<void> _loadAlerts() async {
    state = state.copyWith(isLoading: true);

    try {
      final alerts = _storageService.getAlerts();
      final notifications = _storageService.getAlertNotifications();

      state = state.copyWith(
        alerts: alerts,
        notifications:  notifications,
        isLoading:  false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load alerts',
      );
    }
  }

  // Create new alert
  Future<void> createAlert({
    required String cityName,
    required AlertType type,
    required AlertCondition condition,
    required double threshold,
  }) async {
    final alert = WeatherAlert(
      id: _uuid.v4(),
      cityName: cityName,
      type: type,
      condition: condition,
      threshold:  threshold,
      createdAt: DateTime.now(),
    );

    final updatedAlerts = [...state.alerts, alert];
    await _storageService.saveAlerts(updatedAlerts);

    state = state.copyWith(
      alerts: updatedAlerts,
      error: null,
    );
  }

  // Update alert
  Future<void> updateAlert(WeatherAlert alert) async {
    final updatedAlerts = state.alerts.map((a) {
      return a.id == alert.id ?  alert : a;
    }).toList();

    await _storageService.saveAlerts(updatedAlerts);

    state = state.copyWith(
      alerts: updatedAlerts,
      error: null,
    );
  }

  // Toggle alert enabled/disabled
  Future<void> toggleAlert(String alertId) async {
    final updatedAlerts = state.alerts.map((alert) {
      if (alert.id == alertId) {
        return alert.copyWith(isEnabled: ! alert.isEnabled);
      }
      return alert;
    }).toList();

    await _storageService.saveAlerts(updatedAlerts);

    state = state.copyWith(alerts: updatedAlerts);
  }

  // Delete alert
  Future<void> deleteAlert(String alertId) async {
    final updatedAlerts = state.alerts.where((a) => a.id != alertId).toList();

    await _storageService.saveAlerts(updatedAlerts);

    state = state.copyWith(
      alerts: updatedAlerts,
      error: null,
    );
  }

  // Add notification (triggered alert)
  Future<void> addNotification({
    required String alertId,
    required String cityName,
    required String message,
  }) async {
    final notification = AlertNotification(
      id:  _uuid.v4(),
      alertId: alertId,
      cityName: cityName,
      message: message,
      triggeredAt: DateTime.now(),
    );

    final updatedNotifications = [notification, ...state.notifications];
    await _storageService.saveAlertNotifications(updatedNotifications);

    state = state.copyWith(notifications: updatedNotifications);
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    final updatedNotifications = state.notifications.map((n) {
      if (n.id == notificationId) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    await _storageService.saveAlertNotifications(updatedNotifications);

    state = state.copyWith(notifications: updatedNotifications);
  }

  // Mark all notifications as read
  Future<void> markAllNotificationsAsRead() async {
    final updatedNotifications = state.notifications. map((n) {
      return n.copyWith(isRead: true);
    }).toList();

    await _storageService. saveAlertNotifications(updatedNotifications);

    state = state.copyWith(notifications: updatedNotifications);
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    final updatedNotifications =
        state.notifications.where((n) => n.id != notificationId).toList();

    await _storageService.saveAlertNotifications(updatedNotifications);

    state = state.copyWith(notifications: updatedNotifications);
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    await _storageService.saveAlertNotifications([]);
    state = state.copyWith(notifications: []);
  }

  // Check weather against alerts (call this when weather updates)
  Future<void> checkAlertsForWeather(
    String cityName,
    double temperature,
    double humidity,
    double windSpeed,
  ) async {
    final cityAlerts = state.alerts
        .where((alert) => alert.cityName == cityName && alert.isEnabled)
        .toList();

    for (var alert in cityAlerts) {
      bool shouldTrigger = false;
      String message = '';

      switch (alert. type) {
        case AlertType.temperature:
          if (alert.condition == AlertCondition.above) {
            shouldTrigger = temperature > alert.threshold;
            message =
                'Temperature in $cityName is ${temperature.round()}°C (above ${alert.threshold.round()}°C)';
          } else {
            shouldTrigger = temperature < alert.threshold;
            message =
                'Temperature in $cityName is ${temperature.round()}°C (below ${alert.threshold. round()}°C)';
          }
          break;

        case AlertType.humidity:
          if (alert.condition == AlertCondition.above) {
            shouldTrigger = humidity > alert.threshold;
            message =
                'Humidity in $cityName is ${humidity.round()}% (above ${alert.threshold. round()}%)';
          } else {
            shouldTrigger = humidity < alert.threshold;
            message =
                'Humidity in $cityName is ${humidity.round()}% (below ${alert.threshold.round()}%)';
          }
          break;

        case AlertType.wind:
          shouldTrigger = windSpeed > alert.threshold;
          message =
              'Wind speed in $cityName is ${windSpeed.round()} km/h (above ${alert.threshold.round()} km/h)';
          break;

        case AlertType.rain:
          // This would need forecast data
          break;
      }

      if (shouldTrigger) {
        // Check if we already have a recent notification for this alert
        final recentNotification = state.notifications. firstWhere(
          (n) =>
              n.alertId == alert.id &&
              DateTime.now().difference(n.triggeredAt).inHours < 1,
          orElse: () => AlertNotification(
            id: '',
            alertId: '',
            cityName: '',
            message: '',
            triggeredAt: DateTime.now(),
          ),
        );

        if (recentNotification.id.isEmpty) {
          await addNotification(
            alertId: alert. id,
            cityName: cityName,
            message: message,
          );
        }
      }
    }
  }
}

// Alerts provider
final alertsProvider = StateNotifierProvider<AlertsNotifier, AlertsState>(
  (ref) {
    final storageService = ref.watch(localStorageServiceProvider);
    return AlertsNotifier(storageService);
  },
);