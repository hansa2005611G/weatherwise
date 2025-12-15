import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../data/models/forecast_model.dart';
import '../../providers/weather_provider.dart';
import '../../providers/settings_provider.dart';
import 'widgets/temperature_chart.dart';
import 'widgets/hourly_detail_card.dart';
import 'widgets/daily_summary_card.dart';

class ForecastDetailScreen extends ConsumerStatefulWidget {
  final String cityName;

  const ForecastDetailScreen({
    super.key,
    required this. cityName,
  });

  @override
  ConsumerState<ForecastDetailScreen> createState() =>
      _ForecastDetailScreenState();
}

class _ForecastDetailScreenState extends ConsumerState<ForecastDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load forecast data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(weatherProvider.notifier).fetchForecast(widget.cityName);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    final forecast = weatherState.forecast;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName),
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Hourly'),
            Tab(text: 'Daily'),
          ],
        ),
      ),
      body: forecast == null
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Hourly Tab
                _buildHourlyView(forecast, settings. isCelsius),
                
                // Daily Tab
                _buildDailyView(forecast, settings.isCelsius),
              ],
            ),
    );
  }

  Widget _buildHourlyView(ForecastModel forecast, bool isCelsius) {
    // Get next 24 hours (8 items * 3 hours each)
    final hourlyData = forecast.forecasts. take(8).toList();

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(weatherProvider.notifier).fetchForecast(widget.cityName);
      },
      child:  ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          // Temperature Chart
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            child: TemperatureChart(
              forecasts: hourlyData,
              isCelsius: isCelsius,
            ),
          ),

          const SizedBox(height: 24),

          // Hourly Details
          FadeInUp(
            duration:  const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 100),
            child: const Text(
              'Hourly Forecast',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight. bold,
              ),
            ),
          ),

          const SizedBox(height:  16),

          // Hourly cards
          ...hourlyData.asMap().entries.map((entry) {
            return FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: 150 + (entry.key * 50)),
              child: HourlyDetailCard(
                forecast: entry.value,
                isCelsius: isCelsius,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDailyView(ForecastModel forecast, bool isCelsius) {
    // Group by day
    final dailyData = _groupForecastsByDay(forecast.forecasts);

    return RefreshIndicator(
      onRefresh:  () async {
        await ref. read(weatherProvider.notifier).fetchForecast(widget.cityName);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          FadeInUp(
            duration:  const Duration(milliseconds: 400),
            child: const Text(
              '5-Day Forecast',
              style: TextStyle(
                fontSize:  20,
                fontWeight:  FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          ...dailyData.asMap().entries.map((entry) {
            return FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: 100 + (entry.key * 50)),
              child: DailySummaryCard(
                date: entry.value['date'] as DateTime,
                forecasts: entry.value['forecasts'] as List<ForecastItemModel>,
                isCelsius: isCelsius,
              ),
            );
          }),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _groupForecastsByDay(
    List<ForecastItemModel> forecasts,
  ) {
    final Map<String, List<ForecastItemModel>> grouped = {};

    for (var forecast in forecasts) {
      final dateKey =
          '${forecast.dateTime.year}-${forecast.dateTime.month}-${forecast.dateTime.day}';

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!. add(forecast);
    }

    return grouped. entries.map((entry) {
      return {
        'date': entry. value.first.dateTime,
        'forecasts': entry.value,
      };
    }).toList();
  }
}