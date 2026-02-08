import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bible_games/screens/trivia_screen.dart';
import 'package:bible_games/providers/high_scores_provider.dart';

void main() {
  setUp(() async {
    // Initialize SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('TriviaScreen loads without crashing', (tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: TriviaScreen(),
        ),
      ),
    );

    // Wait for the widget to build
    await tester.pumpAndSettle();

    // Verify screen rendered successfully
    expect(find.byType(TriviaScreen), findsOneWidget);

    // Verify title is present
    expect(find.text('Trivia Bíblica'), findsOneWidget);
  });

  testWidgets('Screen has back button', (tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: TriviaScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify back button exists
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('Shows progress indicator', (tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: TriviaScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Should show question progress
    expect(find.textContaining('Pregunta'), findsWidgets);
  });
}
