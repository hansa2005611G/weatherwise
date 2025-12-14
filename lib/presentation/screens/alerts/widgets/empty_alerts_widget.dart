import 'package:flutter/material.dart';

class EmptyAlertsWidget extends StatelessWidget {
  const EmptyAlertsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state illustration
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons. notifications_none,
                size: 80,
                color: Theme. of(context).primaryColor,
              ),
            ),

            const SizedBox(height:  32),

            // Title
            Text(
              'No Weather Alerts',
              style: Theme.of(context).textTheme.headlineSmall?. copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              'Create custom weather alerts to get notified when weather conditions meet your criteria',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Features list
            _buildFeatureItem(
              icon: Icons.thermostat,
              title: 'Temperature Alerts',
              subtitle: 'Get notified about temperature changes',
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              icon: Icons.water_drop,
              title: 'Rain & Humidity',
              subtitle: 'Stay prepared for rain and humidity',
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              icon:  Icons.air,
              title: 'Wind Speed',
              subtitle: 'Track wind speed conditions',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}