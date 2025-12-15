import 'package:flutter/material.dart';
import '../../../../data/models/alert_model.dart';


class AlertCard extends StatelessWidget {
  final WeatherAlert alert;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AlertCard({
    super.key,
    required this. alert,
    required this.onToggle,
    required this. onEdit,
    required this. onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: alert.isEnabled ? 4 :  2,
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(16),
        side: alert.isEnabled
            ? BorderSide(
                color: _getAlertColor(),
                width: 2,
              )
            : BorderSide.none,
      ),
      child:  Opacity(
        opacity: alert.isEnabled ? 1.0 :  0.6,
        child:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children:  [
                  // Icon
                  Container(
                    padding: const EdgeInsets. all(12),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: _getAlertColor().withOpacity(0.1),
                      shape: BoxShape. circle,
                    ),
                    child: Text(
                      alert.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // City and type
                  Expanded(
                    child: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.cityName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight:  FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getAlertTypeName(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors. grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Toggle switch
                  Switch(
                    value: alert. isEnabled,
                    onChanged: (value) => onToggle(),
                    activeThumbColor: _getAlertColor(),
                  ),
                ],
              ),

              const SizedBox(height:  16),

              // Alert description
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: _getAlertColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:  Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: _getAlertColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        alert.description,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _getAlertColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style:  OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getAlertColor() {
    switch (alert.type) {
      case AlertType. temperature:
        return Colors.orange;
      case AlertType.rain:
        return Colors.blue;
      case AlertType.wind:
        return Colors.teal;
      case AlertType.humidity:
        return Colors.purple;
    }
  }

  String _getAlertTypeName() {
    switch (alert.type) {
      case AlertType.temperature:
        return 'Temperature Alert';
      case AlertType.rain:
        return 'Rain Alert';
      case AlertType.wind:
        return 'Wind Speed Alert';
      case AlertType. humidity:
        return 'Humidity Alert';
    }
  }
}