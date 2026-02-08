import 'package:flutter_test/flutter_test.dart';

import 'package:bible_games/models/biblical_content.dart';
import 'package:bible_games/data/biblical_data.dart';

void main() {
  group('Biblical Content Tests', () {
    test('Trivia questions are loaded', () {
      expect(triviaQuestions.isNotEmpty, true);
      expect(triviaQuestions.length, greaterThan(5));
    });

    test('Trivia questions have correct structure', () {
      final question = triviaQuestions.first;
      expect(question.question.isNotEmpty, true);
      expect(question.options.length, 4);
      expect(question.correctAnswer, lessThan(4));
    });

    test('Memory cards are loaded', () {
      expect(memoryCards.isNotEmpty, true);
      expect(memoryCards.length, 12);
    });

    test('Memory cards have matching pairs', () {
      final pairs = <int, List<int>>{};
      for (final card in memoryCards) {
        pairs.putIfAbsent(card.pairId, () => []).add(card.id);
      }

      // Each pair should have exactly 2 cards
      for (final pair in pairs.values) {
        expect(pair.length, 2);
      }
    });

    test('Quiz questions are loaded', () {
      expect(quizQuestions.isNotEmpty, true);
      expect(quizQuestions.length, greaterThan(3));
    });

    test('Word search puzzles are loaded', () {
      expect(wordSearchPuzzles.isNotEmpty, true);
    });

    test('Word search has valid grid', () {
      final puzzle = wordSearchPuzzles.first;
      expect(puzzle.grid.isNotEmpty, true);
      expect(puzzle.words.isNotEmpty, true);

      // Grid should be square or rectangular
      final rowLength = puzzle.grid.first.length;
      for (final row in puzzle.grid) {
        expect(row.length, rowLength);
      }
    });
  });

  group('Difficulty Levels', () {
    test('Questions have kids difficulty', () {
      final kidsQuestions = triviaQuestions
          .where((q) => q.difficulty == DifficultyLevel.kids)
          .toList();
      expect(kidsQuestions.isNotEmpty, true);
    });
  });

  group('Categories', () {
    test('Questions have different categories', () {
      final categories = triviaQuestions.map((q) => q.category).toSet();
      expect(categories.length, greaterThan(1));
    });
  });
}
