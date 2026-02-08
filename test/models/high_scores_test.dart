import 'package:flutter_test/flutter_test.dart';
import 'package:bible_games/models/high_scores.dart';

void main() {
  group('HighScores', () {
    test('should create with default values of zero', () {
      const scores = HighScores();

      expect(scores.trivia, 0);
      expect(scores.memory, 0);
      expect(scores.wordSearch, 0);
      expect(scores.quiz, 0);
    });

    test('should create with provided values', () {
      const scores = HighScores(
        trivia: 100,
        memory: 50,
        wordSearch: 75,
        quiz: 25,
      );

      expect(scores.trivia, 100);
      expect(scores.memory, 50);
      expect(scores.wordSearch, 75);
      expect(scores.quiz, 25);
    });

    test('copyWith should update only specified values', () {
      const original = HighScores(
        trivia: 100,
        memory: 50,
        wordSearch: 75,
        quiz: 25,
      );

      final updated = original.copyWith(trivia: 200, quiz: 50);

      expect(updated.trivia, 200);
      expect(updated.memory, 50); // unchanged
      expect(updated.wordSearch, 75); // unchanged
      expect(updated.quiz, 50);
    });

    test('copyWith should keep original values when no parameters provided',
        () {
      const original = HighScores(
        trivia: 100,
        memory: 50,
        wordSearch: 75,
        quiz: 25,
      );

      final updated = original.copyWith();

      expect(updated.trivia, original.trivia);
      expect(updated.memory, original.memory);
      expect(updated.wordSearch, original.wordSearch);
      expect(updated.quiz, original.quiz);
    });

    test('toJson should serialize correctly', () {
      const scores = HighScores(
        trivia: 100,
        memory: 50,
        wordSearch: 75,
        quiz: 25,
      );

      final json = scores.toJson();

      expect(json, {
        'trivia': 100,
        'memory': 50,
        'wordSearch': 75,
        'quiz': 25,
      });
    });

    test('fromJson should deserialize correctly', () {
      final json = {
        'trivia': 100,
        'memory': 50,
        'wordSearch': 75,
        'quiz': 25,
      };

      final scores = HighScores.fromJson(json);

      expect(scores.trivia, 100);
      expect(scores.memory, 50);
      expect(scores.wordSearch, 75);
      expect(scores.quiz, 25);
    });

    test('fromJson should handle missing values with defaults', () {
      final json = {
        'trivia': 100,
        // memory missing
        'wordSearch': 75,
        // quiz missing
      };

      final scores = HighScores.fromJson(json);

      expect(scores.trivia, 100);
      expect(scores.memory, 0); // default
      expect(scores.wordSearch, 75);
      expect(scores.quiz, 0); // default
    });

    test('fromJson should handle empty map', () {
      final scores = HighScores.fromJson({});

      expect(scores.trivia, 0);
      expect(scores.memory, 0);
      expect(scores.wordSearch, 0);
      expect(scores.quiz, 0);
    });

    test('toJson followed by fromJson should preserve data', () {
      const original = HighScores(
        trivia: 100,
        memory: 50,
        wordSearch: 75,
        quiz: 25,
      );

      final json = original.toJson();
      final restored = HighScores.fromJson(json);

      expect(restored.trivia, original.trivia);
      expect(restored.memory, original.memory);
      expect(restored.wordSearch, original.wordSearch);
      expect(restored.quiz, original.quiz);
    });
  });
}
