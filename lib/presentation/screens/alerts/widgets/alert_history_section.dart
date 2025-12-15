import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/alert_model.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../providers/alerts_provider.dart';

class AlertHistorySection extends ConsumerWidget {
  final List<AlertNotification> notifications;

  const AlertHistorySection({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (notifications.isEmpty) {
      return const Center(
        child:  Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No Notifications Yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Triggered alerts will appear here',
                style:  TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header with actions
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text(
                'Notification History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (ref.watch(alertsProvider).unreadNotificationsCount > 0)
                TextButton(
                  onPressed:  () {
                    ref.read(alertsProvider.notifier).markAllNotificationsAsRead();
                  },
                  child: const Text('Mark all as read'),
                ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed:  () {
                  _showClearHistoryDialog(context, ref);
                },
                tooltip: 'Clear history',
              ),
            ],
          ),
        ),

        // Notifications list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Dismissible(
                key: Key(notification.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment:  Alignment.centerRight,
                  padding: const EdgeInsets. only(right: 16),
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  ref.read(alertsProvider.notifier).deleteNotification(notification.id);
                },
                child: _buildNotificationItem(context, ref, notification),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    WidgetRef ref,
    AlertNotification notification,
  ) {
    return InkWell(
      onTap: () {
        if (! notification.isRead) {
          ref.read(alertsProvider. notifier).markNotificationAsRead(notification.id);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        // ignore: deprecated_member_use
        color: notification.isRead ?  null : Colors.blue.withOpacity(0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding:  const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: notification.isRead
                    // ignore: deprecated_member_use
                    ? Colors.grey.withOpacity(0.1)
                    // ignore: deprecated_member_use
                    : Colors.orange.withOpacity(0.1),
                shape: BoxShape. circle,
              ),
              child: Icon(
                notification.isRead
                    ? Icons.notifications_outlined
                    : Icons.notifications_active,
                color: notification.isRead ? Colors. grey : Colors.orange,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.cityName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:  notification.isRead
                                ? FontWeight.w500
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                      if (! notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors. grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormatter.getRelativeTime(notification.triggeredAt),
                    style:  TextStyle(
                      fontSize:  12,
                      color:  Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'Are you sure you want to clear all notification history? ',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(alertsProvider.notifier).clearAllNotifications();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child:  const Text('Clear'),
          ),
        ],
      ),
    );
  }
}