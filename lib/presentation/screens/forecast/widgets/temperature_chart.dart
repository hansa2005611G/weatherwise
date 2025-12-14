import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../data/models/forecast_model.dart';
import '../../../../core/utils/temperature_converter.dart';
import '../../../../core/utils/date_formatter.dart';

class TemperatureChart extends StatelessWidget {
  final List<ForecastItemModel> forecasts;
  final bool isCelsius;

  const TemperatureChart({
    super.key,
    required this.forecasts,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Temperature Trend',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                _buildChartData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildChartData() {
    final spots = forecasts.asMap().entries.map((entry) {
      final temp = TemperatureConverter.getTemperatureInUnit(
        entry.value.main.temperature,
        isCelsius,
      );
      return FlSpot(entry.key. toDouble(), temp);
    }).toList();

    // Calculate min/max for Y axis
    final temps = spots.map((e) => e.y).toList();
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final padding = (maxTemp - minTemp) * 0.2;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors. grey.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles:  false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < forecasts.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormatter.formatHourShort(forecasts[index].dateTime),
                    style: const TextStyle(
                      fontSize:  10,
                      color: Colors. grey,
                    ),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 5,
            getTitlesWidget:  (value, meta) {
              return Text(
                '${value.toInt()}°',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (forecasts.length - 1).toDouble(),
      minY: minTemp - padding,
      maxY: maxTemp + padding,
      lineBarsData: [
        LineChartBarData(
          spots:  spots,
          isCurved: true,
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: const Color(0xFF4A90E2),
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4A90E2).withOpacity(0.3),
                const Color(0xFF87CEEB).withOpacity(0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment. bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final index = spot.x.toInt();
              final forecast = forecasts[index];
              return LineTooltipItem(
                '${spot.y.round()}°\n${DateFormatter.formatTime(forecast.dateTime)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}