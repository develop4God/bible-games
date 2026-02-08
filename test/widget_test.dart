// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bible_games/main.dart';
import 'package:bible_games/providers/high_scores_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home screen loads and shows main title',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const BibleGamesApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Check for the main title
    expect(find.text('Juegos Bíblicos'), findsOneWidget);
    // Check for a unique subtitle
    expect(find.textContaining('Aprende y diviértete'), findsOneWidget);
    // Check for a game card title
    expect(find.text('Trivia Bíblica'), findsOneWidget);
  });
}
