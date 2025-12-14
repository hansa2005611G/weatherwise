import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/alert_model.dart';
import '../../../providers/alerts_provider.dart';
import '../../../providers/favorites_provider.dart';

class CreateAlertDialog extends ConsumerStatefulWidget {
  final WeatherAlert? existingAlert;

  const CreateAlertDialog({
    super.key,
    this.existingAlert,
  });

  @override
  ConsumerState<CreateAlertDialog> createState() => _CreateAlertDialogState();
}

class _CreateAlertDialogState extends ConsumerState<CreateAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  
  String?  _selectedCity;
  AlertType _selectedType = AlertType.temperature;
  AlertCondition _selectedCondition = AlertCondition.above;
  double _threshold = 30.0;

  @override
  void initState() {
    super.initState();
    if (widget.existingAlert != null) {
      _selectedCity = widget. existingAlert!.cityName;
      _selectedType = widget. existingAlert!.type;
      _selectedCondition = widget. existingAlert!.condition;
      _threshold = widget.existingAlert!.threshold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteCities = ref.watch(favoritesProvider).cities;

    return AlertDialog(
      title: Text(widget.existingAlert == null ? 'Create Alert' : 'Edit Alert'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // City Selector
              const Text(
                'Select City',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height:  8),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets. symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                hint: const Text('Choose a city'),
                items: favoriteCities.isEmpty
                    ? [
                        const DropdownMenuItem(
                          value: 'London',
                          child: Text('London'),
                        ),
                      ]
                    : favoriteCities
                        .map((city) => DropdownMenuItem(
                              value: city. cityName,
                              child: Text(city.cityName),
                            ))
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a city';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Alert Type
              const Text(
                'Alert Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: AlertType.values.map((type) {
                  return ChoiceChip(
                    label: Text(_getTypeName(type)),
                    avatar: Text(_getTypeIcon(type)),
                    selected: _selectedType == type,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedType = type;
                          _updateThresholdDefaults();
                        });
                      }
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Condition (only for temperature and humidity)
              if (_selectedType == AlertType.temperature ||
                  _selectedType == AlertType.humidity) ...[
                const Text(
                  'Condition',
                  style: TextStyle(
                    fontWeight:  FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<AlertCondition>(
                        title: const Text('Above'),
                        value: AlertCondition.above,
                        groupValue: _selectedCondition,
                        onChanged: (value) {
                          setState(() {
                            _selectedCondition = value! ;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child:  RadioListTile<AlertCondition>(
                        title: const Text('Below'),
                        value:  AlertCondition.below,
                        groupValue: _selectedCondition,
                        onChanged: (value) {
                          setState(() {
                            _selectedCondition = value!;
                          });
                        },
                        contentPadding: EdgeInsets. zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Threshold
              const Text(
                'Threshold',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child:  Slider(
                      value: _threshold,
                      min: _getMinValue(),
                      max: _getMaxValue(),
                      divisions:  (_getMaxValue() - _getMinValue()).toInt(),
                      label: '${_threshold.round()}${_getUnit()}',
                      onChanged: (value) {
                        setState(() {
                          _threshold = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor. withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_threshold.round()}${_getUnit()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme. of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveAlert,
          child: Text(widget.existingAlert == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }

  void _updateThresholdDefaults() {
    switch (_selectedType) {
      case AlertType.temperature:
        _threshold = 30.0;
        break;
      case AlertType.rain:
        _threshold = 50.0;
        break;
      case AlertType.wind:
        _threshold = 30.0;
        break;
      case AlertType.humidity:
        _threshold = 70.0;
        break;
    }
  }

  double _getMinValue() {
    switch (_selectedType) {
      case AlertType.temperature:
        return -20.0;
      case AlertType.rain:
      case AlertType.humidity:
        return 0.0;
      case AlertType.wind:
        return 0.0;
    }
  }

  double _getMaxValue() {
    switch (_selectedType) {
      case AlertType.temperature:
        return 50.0;
      case AlertType.rain:
      case AlertType.humidity:
        return 100.0;
      case AlertType.wind:
        return 100.0;
    }
  }

  String _getUnit() {
    switch (_selectedType) {
      case AlertType.temperature:
        return '°C';
      case AlertType.rain:
      case AlertType.humidity:
        return '%';
      case AlertType.wind:
        return ' km/h';
    }
  }

  String _getTypeName(AlertType type) {
    switch (type) {
      case AlertType.temperature:
        return 'Temperature';
      case AlertType.rain:
        return 'Rain';
      case AlertType.wind:
        return 'Wind';
      case AlertType.humidity:
        return 'Humidity';
    }
  }

  String _getTypeIcon(AlertType type) {
    switch (type) {
      case AlertType. temperature:
        return '🌡️';
      case AlertType.rain:
        return '🌧️';
      case AlertType.wind:
        return '💨';
      case AlertType.humidity:
        return '💧';
    }
  }

  void _saveAlert() {
    if (_formKey.currentState!. validate() && _selectedCity != null) {
      if (widget.existingAlert == null) {
        // Create new alert
        ref.read(alertsProvider. notifier).createAlert(
              cityName: _selectedCity!,
              type: _selectedType,
              condition: _selectedCondition,
              threshold: _threshold,
            );
      } else {
        // Update existing alert
        ref.read(alertsProvider.notifier).updateAlert(
              widget.existingAlert!.copyWith(
                cityName: _selectedCity,
                type: _selectedType,
                condition: _selectedCondition,
                threshold: _threshold,
              ),
            );
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existingAlert == null
                ? 'Alert created successfully'
                : 'Alert updated successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}