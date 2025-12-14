import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherwise/presentation/screens/forecast/forecast_detail_screen.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/search/search_screen.dart';
import 'presentation/screens/favorites/favorites_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/alerts/alerts_screen.dart';
import 'presentation/providers/settings_provider.dart';
import 'data/data_sources/local/local_storage_service.dart';


void main() async {
  WidgetsFlutterBinding. ensureInitialized();

  // Initialize local storage
  final localStorage = LocalStorageService();
  await localStorage.init();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors. transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: WeatherWiseApp(),
    ),
  );
}

class WeatherWiseApp extends ConsumerWidget {
  const WeatherWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'WeatherWise',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Start with Splash Screen
      home: const SplashScreen(),  // Changed from HomeScreen

      // Routes
      routes: {
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/alerts': (context) => const AlertsScreen(),
        '/forecast':  (context) => const ForecastDetailScreen(cityName: 'London'),
      },
    );
  }
}