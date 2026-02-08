import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bible_games/providers/high_scores_provider.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  group('HighScoresNotifier', () {
    test('should initialize with default scores', () async {
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      // Wait for async initialization
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final scores = container.read(highScoresProvider);
      expect(scores.trivia, 0);
      expect(scores.memory, 0);
      expect(scores.wordSearch, 0);
      expect(scores.quiz, 0);
    });

    test('should update trivia score only if higher', () async {
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(highScoresProvider.notifier);
      await notifier.updateTriviaScore(100);

      var scores = container.read(highScoresProvider);
      expect(scores.trivia, 100);

      // Try to update with lower score
      await notifier.updateTriviaScore(50);
      scores = container.read(highScoresProvider);
      expect(scores.trivia, 100); // Should remain unchanged

      // Update with higher score
      await notifier.updateTriviaScore(150);
      scores = container.read(highScoresProvider);
      expect(scores.trivia, 150);
    });

    test('should update memory score only if higher', () async {
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(highScoresProvider.notifier);
      await notifier.updateMemoryScore(80);

      var scores = container.read(highScoresProvider);
      expect(scores.memory, 80);

      await notifier.updateMemoryScore(60);
      scores = container.read(highScoresProvider);
      expect(scores.memory, 80);

      await notifier.updateMemoryScore(100);
      scores = container.read(highScoresProvider);
      expect(scores.memory, 100);
    });

    test('should update word search score only if higher', () async {
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(highScoresProvider.notifier);
      await notifier.updateWordSearchScore(60);

      var scores = container.read(highScoresProvider);
      expect(scores.wordSearch, 60);

      await notifier.updateWordSearchScore(40);
      scores = container.read(highScoresProvider);
      expect(scores.wordSearch, 60);

      await notifier.updateWordSearchScore(90);
      scores = container.read(highScoresProvider);
      expect(scores.wordSearch, 90);
    });

    test('should update quiz score only if higher', () async {
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(highScoresProvider.notifier);
      await notifier.updateQuizScore(45);

      var scores = container.read(highScoresProvider);
      expect(scores.quiz, 45);

      await notifier.updateQuizScore(30);
      scores = container.read(highScoresProvider);
      expect(scores.quiz, 45);

      await notifier.updateQuizScore(55);
      scores = container.read(highScoresProvider);
      expect(scores.quiz, 55);
    });

    test('should persist scores to SharedPreferences', () async {
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(highScoresProvider.notifier);
      await notifier.updateTriviaScore(100);
      await notifier.updateMemoryScore(80);
      await notifier.updateWordSearchScore(60);
      await notifier.updateQuizScore(40);

      // Verify data was saved to SharedPreferences
      final savedJson = prefs.getString('highScores');
      expect(savedJson, isNotNull);
      expect(savedJson, contains('100')); // trivia score
      expect(savedJson, contains('80'));  // memory score
      expect(savedJson, contains('60'));  // wordSearch score
      expect(savedJson, contains('40'));  // quiz score
    });

    test('should load persisted scores on initialization', () async {
      // Set up initial data in SharedPreferences
      await prefs.setString(
        'highScores',
        '{"trivia":100,"memory":80,"wordSearch":60,"quiz":40}',
      );

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      // Wait for async initialization
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final scores = container.read(highScoresProvider);
      expect(scores.trivia, 100);
      expect(scores.memory, 80);
      expect(scores.wordSearch, 60);
      expect(scores.quiz, 40);
    });

    test('should handle corrupted data gracefully', () async {
      // Set up corrupted data in SharedPreferences
      await prefs.setString('highScores', 'corrupted{invalid:json}');

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      // Wait for async initialization
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Should fall back to default scores
      final scores = container.read(highScoresProvider);
      expect(scores.trivia, 0);
      expect(scores.memory, 0);
      expect(scores.wordSearch, 0);
      expect(scores.quiz, 0);
    });

    test('should reset all scores', () async {
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(highScoresProvider.notifier);

      // Set some scores
      await notifier.updateTriviaScore(100);
      await notifier.updateMemoryScore(80);
      await notifier.updateWordSearchScore(60);
      await notifier.updateQuizScore(40);

      var scores = container.read(highScoresProvider);
      expect(scores.trivia, 100);

      // Reset all scores
      await notifier.resetAllScores();

      scores = container.read(highScoresProvider);
      expect(scores.trivia, 0);
      expect(scores.memory, 0);
      expect(scores.wordSearch, 0);
      expect(scores.quiz, 0);

      // Verify reset was persisted
      final savedJson = prefs.getString('highScores');
      expect(savedJson, isNotNull);
      expect(savedJson, contains('"trivia":0'));
    });
  });
}


