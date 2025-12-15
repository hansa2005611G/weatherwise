// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../providers/settings_provider.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';
import 'widgets/theme_selector.dart';
import 'widgets/about_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref. watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back),
          onPressed:  () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          // General Section
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            child: SettingsSection(
              title: 'GENERAL',
              children: [
                // Temperature Unit
                SettingsTile(
                  icon: Icons.thermostat,
                  iconColor: Colors.orange,
                  title: 'Temperature Unit',
                  subtitle: settings.isCelsius ?  'Celsius (°C)' : 'Fahrenheit (°F)',
                  trailing: Row(
                    mainAxisSize:  MainAxisSize.min,
                    children: [
                      _buildUnitChip(
                        context:  context,
                        label: '°C',
                        isSelected: settings.isCelsius,
                        onTap: () {
                          ref.read(settingsProvider.notifier).setTemperatureUnit(true);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildUnitChip(
                        context: context,
                        label:  '°F',
                        isSelected: !settings.isCelsius,
                        onTap: () {
                          ref. read(settingsProvider.notifier).setTemperatureUnit(false);
                        },
                      ),
                    ],
                  ),
                ),

                // Wind Speed Unit
                SettingsTile(
                  icon: Icons.air,
                  iconColor: Colors.teal,
                  title: 'Wind Speed Unit',
                  subtitle: settings.windSpeedUnit,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildUnitChip(
                        context: context,
                        label: 'km/h',
                        isSelected: settings.windSpeedUnit == 'km/h',
                        onTap: () {
                          ref. read(settingsProvider.notifier).setWindSpeedUnit('km/h');
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildUnitChip(
                        context: context,
                        label: 'mph',
                        isSelected:  settings.windSpeedUnit == 'mph',
                        onTap: () {
                          ref. read(settingsProvider.notifier).setWindSpeedUnit('mph');
                        },
                      ),
                    ],
                  ),
                ),

                // Theme Mode
                SettingsTile(
                  icon: Icons. palette,
                  iconColor: Colors.purple,
                  title: 'Theme',
                  subtitle: settings.isDarkMode ? 'Dark Mode' : 'Light Mode',
                  onTap: () {
                    _showThemeDialog(context, ref);
                  },
                ),

                // Language (Placeholder)
                SettingsTile(
                  icon: Icons.language,
                  iconColor: Colors.blue,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Multiple languages coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Notifications Section
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 100),
            child: SettingsSection(
              title: 'NOTIFICATIONS',
              children: [
                // Push Notifications
                SettingsTile(
                  icon: Icons.notifications,
                  iconColor: Colors.amber,
                  title: 'Push Notifications',
                  subtitle: settings.notificationsEnabled
                      ? 'Enabled'
                      : 'Disabled',
                  trailing: Switch(
                    value: settings.notificationsEnabled,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).toggleNotifications();
                    },
                  ),
                ),

                // Weather Alerts
                SettingsTile(
                  icon: Icons.warning_amber,
                  iconColor:  Colors.red,
                  title: 'Weather Alerts',
                  subtitle: 'Severe weather warnings',
                  trailing:  Switch(
                    value: settings.notificationsEnabled,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).toggleNotifications();
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Data & Storage Section
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 200),
            child: SettingsSection(
              title: 'DATA & STORAGE',
              children: [
                // Refresh Interval
                SettingsTile(
                  icon: Icons.refresh,
                  iconColor: Colors.green,
                  title: 'Auto Refresh',
                  subtitle: 'Every ${settings.refreshInterval} minutes',
                  onTap: () {
                    _showRefreshIntervalDialog(context, ref);
                  },
                ),

                // Clear Cache
                SettingsTile(
                  icon: Icons. cleaning_services,
                  iconColor: Colors.orange,
                  title: 'Clear Cache',
                  subtitle:  'Remove cached weather data',
                  onTap: () {
                    _showClearCacheDialog(context, ref);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // About Section
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 300),
            child: const AboutSection(),
          ),

          const SizedBox(height:  16),

          // Danger Zone
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 400),
            child: SettingsSection(
              title:  'DANGER ZONE',
              children: [
                SettingsTile(
                  icon: Icons.restore,
                  iconColor: Colors.red,
                  title: 'Reset Settings',
                  subtitle: 'Restore default settings',
                  onTap: () {
                    _showResetDialog(context, ref);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height:  32),
        ],
      ),
    );
  }

  Widget _buildUnitChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ?  Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => ThemeSelector(
        currentTheme: ref.read(settingsProvider).isDarkMode,
        onThemeChanged:  (isDark) {
          ref.read(settingsProvider.notifier).toggleThemeMode();
        },
      ),
    );
  }

  void _showRefreshIntervalDialog(BuildContext context, WidgetRef ref) {
    final intervals = [15, 30, 60, 120, 240];
    final currentInterval = ref.read(settingsProvider).refreshInterval;

    showDialog(
      context:  context,
      builder: (context) => AlertDialog(
        title: const Text('Auto Refresh Interval'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: intervals.map((interval) {
            return RadioListTile<int>(
              title: Text('Every $interval minutes'),
              value:  interval,
              groupValue: currentInterval,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setRefreshInterval(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will remove all cached weather data. You\'ll need to refresh to see weather information again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(settingsProvider.notifier).clearCache();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values?  This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(settingsProvider.notifier).resetSettings();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings reset to defaults'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}