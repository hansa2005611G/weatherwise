import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../providers/alerts_provider.dart';
import 'widgets/alert_card.dart';
import 'widgets/create_alert_dialog.dart';
import 'widgets/empty_alerts_widget.dart';
import 'widgets/alert_history_section.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alertsState = ref.watch(alertsProvider);
    final activeAlerts = alertsState.alerts.where((a) => a.isEnabled).toList();
    final inactiveAlerts = alertsState.alerts.where((a) => !a.isEnabled).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Alerts'),
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back),
          onPressed:  () => Navigator.pop(context),
        ),
        actions: [
          if (alertsState.alerts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _showClearAllDialog(context),
              tooltip: 'Clear All',
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Active'),
                  if (activeAlerts.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${activeAlerts.length}',
                        style: const TextStyle(
                          color: Colors. white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('History'),
                  if (alertsState.unreadNotificationsCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${alertsState.unreadNotificationsCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Alerts Tab
          _buildAlertsTab(alertsState),

          // History Tab
          AlertHistorySection(
            notifications: alertsState.notifications,
          ),
        ],
      ),
      floatingActionButton: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: FloatingActionButton. extended(
          onPressed: () => _showCreateAlertDialog(context),
          icon: const Icon(Icons.add_alert),
          label: const Text('New Alert'),
        ),
      ),
    );
  }

  Widget _buildAlertsTab(AlertsState alertsState) {
    if (alertsState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (alertsState.alerts.isEmpty) {
      return const EmptyAlertsWidget();
    }

    final activeAlerts = alertsState. alerts.where((a) => a.isEnabled).toList();
    final inactiveAlerts = alertsState.alerts.where((a) => !a.isEnabled).toList();

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh alerts
        ref.read(alertsProvider.notifier);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          // Active Alerts Section
          if (activeAlerts.isNotEmpty) ...[
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child:  Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green. withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Active Alerts (${activeAlerts.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ...activeAlerts.asMap().entries.map((entry) {
              return FadeInUp(
                duration:  const Duration(milliseconds: 400),
                delay: Duration(milliseconds: entry. key * 50),
                child: AlertCard(
                  alert: entry.value,
                  onToggle: () => _toggleAlert(entry.value.id),
                  onEdit: () => _editAlert(entry.value),
                  onDelete: () => _deleteAlert(entry.value. id),
                ),
              );
            }),
          ],

          // Inactive Alerts Section
          if (inactiveAlerts.isNotEmpty) ...[
            const SizedBox(height: 24),
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding:  const EdgeInsets.only(bottom: 12),
                child:  Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration:  BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_off,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Inactive Alerts (${inactiveAlerts.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:  FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ...inactiveAlerts. asMap().entries.map((entry) {
              return FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: Duration(milliseconds:  entry.key * 50),
                child: AlertCard(
                  alert: entry.value,
                  onToggle: () => _toggleAlert(entry.value. id),
                  onEdit:  () => _editAlert(entry. value),
                  onDelete:  () => _deleteAlert(entry. value.id),
                ),
              );
            }),
          ],

          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  void _showCreateAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateAlertDialog(),
    );
  }

  void _toggleAlert(String alertId) {
    ref.read(alertsProvider.notifier).toggleAlert(alertId);
  }

  void _editAlert(alert) {
    showDialog(
      context: context,
      builder: (context) => CreateAlertDialog(existingAlert: alert),
    );
  }

  void _deleteAlert(String alertId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Alert'),
        content: const Text('Are you sure you want to delete this alert?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(alertsProvider.notifier).deleteAlert(alertId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alert deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Alerts'),
        content: const Text(
          'Are you sure you want to delete all alerts?  This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final alerts = ref.read(alertsProvider).alerts;
              for (var alert in alerts) {
                await ref.read(alertsProvider. notifier).deleteAlert(alert.id);
              }
              if (context.mounted) {
                Navigator. pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All alerts deleted'),
                    backgroundColor:  Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors. red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}