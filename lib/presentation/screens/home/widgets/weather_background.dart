import 'package:flutter/material.dart';

class WeatherBackground extends StatelessWidget {
  final List<Color> gradient;
  final String condition;

  const WeatherBackground({
    super.key,
    required this.gradient,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradient,
        ),
      ),
      child: _buildWeatherEffects(),
    );
  }

  Widget _buildWeatherEffects() {
    // You can add animated weather effects here
    // For now, we'll keep it simple
    return Container();
  }
}