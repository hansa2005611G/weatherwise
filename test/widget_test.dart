

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weatherwise/main.dart';

void main() {
  testWidgets('WeatherWise app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      const ProviderScope(
        child: WeatherWiseApp(),
      ),
    );

    // Wait for all animations and async operations to complete
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify that MaterialApp is rendered
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App has correct title', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(
      const ProviderScope(
        child: WeatherWiseApp(),
      ),
    );

    // Get the MaterialApp widget
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    
    // Verify the title
    expect(app.title, 'WeatherWise');
  });

  testWidgets('App uses correct theme mode', (WidgetTester tester) async {
    // Build the app
    await tester. pumpWidget(
      const ProviderScope(
        child:  WeatherWiseApp(),
      ),
    );

    // Get the MaterialApp widget
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    
    // Verify theme is configured
    expect(app.theme, isNotNull);
    expect(app.darkTheme, isNotNull);
  });
}