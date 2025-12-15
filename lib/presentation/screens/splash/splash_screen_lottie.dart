import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/weather_provider.dart';
import '../home/home_screen.dart';

class SplashScreenLottie extends ConsumerStatefulWidget {
  const SplashScreenLottie({super.key});

  @override
  ConsumerState<SplashScreenLottie> createState() => _SplashScreenLottieState();
}

class _SplashScreenLottieState extends ConsumerState<SplashScreenLottie> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Load initial weather data
    try {
      final weatherNotifier = ref.read(weatherProvider.notifier);
      final lastLocation = ref.read(localStorageServiceProvider).getLastLocation();
      
      await Future.wait([
        lastLocation != null
            ? weatherNotifier.fetchWeatherByCity(lastLocation)
            : weatherNotifier.fetchWeatherByCity('London'),
        Future.delayed(const Duration(seconds: 3)),
      ]);
    } catch (e) {
      // Continue anyway
    }

    // Navigate to home
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Lottie Animation
              // You need to add a weather. json animation file to assets/animations/
              FadeIn(
                duration: const Duration(milliseconds: 800),
                child:  Lottie.asset(
                  'assets/animations/weather.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if animation not found
                    return const Icon(
                      Icons.cloud,
                      size: 120,
                      color: Colors. white,
                    );
                  },
                ),
              ),

              const SizedBox(height:  40),

              // App Name
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay:  const Duration(milliseconds: 500),
                child: const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              FadeInUp(
                duration:  const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 700),
                child: const Text(
                  'Your Smart Weather Companion',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    letterSpacing:  1,
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Loading indicator
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay:  const Duration(milliseconds: 900),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),

              const SizedBox(height:  50),
            ],
          ),
        ),
      ),
    );
  }
}