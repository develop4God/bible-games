import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bible_games/models/biblical_content.dart';
import 'package:bible_games/providers/game_providers.dart';

void main() {
  group('gameDifficultyProvider', () {
    test('should default to kids difficulty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final difficulty = container.read(gameDifficultyProvider);
      expect(difficulty, DifficultyLevel.kids);
    });

    test('should allow changing difficulty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(gameDifficultyProvider.notifier).state =
          DifficultyLevel.adults;

      final difficulty = container.read(gameDifficultyProvider);
      expect(difficulty, DifficultyLevel.adults);
    });
  });

  group('TriviaGameState', () {
    test('should create with default values', () {
      const state = TriviaGameState();

      expect(state.currentQuestionIndex, 0);
      expect(state.score, 0);
      expect(state.answeredQuestions, isEmpty);
    });

    test('copyWith should update only specified values', () {
      const original = TriviaGameState(
        currentQuestionIndex: 5,
        score: 50,
        answeredQuestions: [true, false, true],
      );

      final updated = original.copyWith(score: 60);

      expect(updated.currentQuestionIndex, 5);
      expect(updated.score, 60);
      expect(updated.answeredQuestions, [true, false, true]);
    });
  });

  group('TriviaGameNotifier', () {
    test('should initialize with default state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(triviaGameProvider);
      expect(state.currentQuestionIndex, 0);
      expect(state.score, 0);
      expect(state.answeredQuestions, isEmpty);
    });

    test('should increment score and index when answer is correct', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(triviaGameProvider.notifier);
      notifier.answerQuestion(true);

      final state = container.read(triviaGameProvider);
      expect(state.currentQuestionIndex, 1);
      expect(state.score, 10);
      expect(state.answeredQuestions, [true]);
    });

    test('should increment index but not score when answer is wrong', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(triviaGameProvider.notifier);
      notifier.answerQuestion(false);

      final state = container.read(triviaGameProvider);
      expect(state.currentQuestionIndex, 1);
      expect(state.score, 0);
      expect(state.answeredQuestions, [false]);
    });

    test('should track multiple answers', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(triviaGameProvider.notifier);
      notifier.answerQuestion(true);
      notifier.answerQuestion(false);
      notifier.answerQuestion(true);

      final state = container.read(triviaGameProvider);
      expect(state.currentQuestionIndex, 3);
      expect(state.score, 20);
      expect(state.answeredQuestions, [true, false, true]);
    });

    test('should reset game to initial state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(triviaGameProvider.notifier);
      notifier.answerQuestion(true);
      notifier.answerQuestion(true);

      notifier.resetGame();

      final state = container.read(triviaGameProvider);
      expect(state.currentQuestionIndex, 0);
      expect(state.score, 0);
      expect(state.answeredQuestions, isEmpty);
    });
  });

  group('MemoryGameState', () {
    test('should create with default values', () {
      const state = MemoryGameState();

      expect(state.flippedCards, isEmpty);
      expect(state.matchedPairs, isEmpty);
      expect(state.moves, 0);
    });

    test('copyWith should update only specified values', () {
      const original = MemoryGameState(
        flippedCards: [1, 2],
        matchedPairs: [3, 4],
        moves: 5,
      );

      final updated = original.copyWith(moves: 6);

      expect(updated.flippedCards, [1, 2]);
      expect(updated.matchedPairs, [3, 4]);
      expect(updated.moves, 6);
    });
  });

  group('MemoryGameNotifier', () {
    test('should initialize with default state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(memoryGameProvider);
      expect(state.flippedCards, isEmpty);
      expect(state.matchedPairs, isEmpty);
      expect(state.moves, 0);
    });

    test('should flip card when none are flipped', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(memoryGameProvider.notifier);
      notifier.flipCard(1);

      final state = container.read(memoryGameProvider);
      expect(state.flippedCards, [1]);
    });

    test('should flip second card', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(memoryGameProvider.notifier);
      notifier.flipCard(1);
      notifier.flipCard(2);

      final state = container.read(memoryGameProvider);
      expect(state.flippedCards, [1, 2]);
    });

    test('should not flip more than 2 cards', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(memoryGameProvider.notifier);
      notifier.flipCard(1);
      notifier.flipCard(2);
      notifier.flipCard(3);

      final state = container.read(memoryGameProvider);
      expect(state.flippedCards, [1, 2]);
    });

    test('should not flip already matched card', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(memoryGameProvider.notifier);
      // Simulate matched cards
      container.read(memoryGameProvider.notifier).state =
          const MemoryGameState(matchedPairs: [1, 2]);

      notifier.flipCard(1);

      final state = container.read(memoryGameProvider);
      expect(state.flippedCards, isEmpty);
    });

    test('should detect matching cards', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final cards = [
        const MemoryCard(
            id: 1, text: 'Moisés', pairId: 1, difficulty: DifficultyLevel.kids),
        const MemoryCard(
            id: 2, text: 'Líder', pairId: 1, difficulty: DifficultyLevel.kids),
      ];

      final notifier = container.read(memoryGameProvider.notifier);
      notifier.flipCard(1);
      notifier.flipCard(2);
      notifier.checkMatch(cards);

      final state = container.read(memoryGameProvider);
      expect(state.matchedPairs, [1, 2]);
      expect(state.flippedCards, isEmpty);
      expect(state.moves, 1);
    });

    test('should increment moves on non-match', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final cards = [
        const MemoryCard(
            id: 1, text: 'Moisés', pairId: 1, difficulty: DifficultyLevel.kids),
        const MemoryCard(
            id: 2, text: 'David', pairId: 2, difficulty: DifficultyLevel.kids),
      ];

      final notifier = container.read(memoryGameProvider.notifier);
      notifier.flipCard(1);
      notifier.flipCard(2);
      notifier.checkMatch(cards);

      final state = container.read(memoryGameProvider);
      expect(state.matchedPairs, isEmpty);
      expect(state.flippedCards, [1, 2]); // Still flipped until reset
      expect(state.moves, 1);
    });

    test('should reset flipped cards', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(memoryGameProvider.notifier);
      notifier.flipCard(1);
      notifier.flipCard(2);
      notifier.resetFlipped();

      final state = container.read(memoryGameProvider);
      expect(state.flippedCards, isEmpty);
    });

    test('should reset game to initial state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(memoryGameProvider.notifier);
      notifier.flipCard(1);
      notifier.flipCard(2);

      notifier.resetGame();

      final state = container.read(memoryGameProvider);
      expect(state.flippedCards, isEmpty);
      expect(state.matchedPairs, isEmpty);
      expect(state.moves, 0);
    });
  });

  group('QuizGameState', () {
    test('should create with default values', () {
      const state = QuizGameState();

      expect(state.currentQuestionIndex, 0);
      expect(state.score, 0);
    });

    test('copyWith should update only specified values', () {
      const original = QuizGameState(
        currentQuestionIndex: 5,
        score: 25,
      );

      final updated = original.copyWith(score: 30);

      expect(updated.currentQuestionIndex, 5);
      expect(updated.score, 30);
    });
  });

  group('QuizGameNotifier', () {
    test('should initialize with default state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(quizGameProvider);
      expect(state.currentQuestionIndex, 0);
      expect(state.score, 0);
    });

    test('should increment score and index when answer is correct', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(quizGameProvider.notifier);
      notifier.answerQuestion(true);

      final state = container.read(quizGameProvider);
      expect(state.currentQuestionIndex, 1);
      expect(state.score, 5);
    });

    test('should increment index but not score when answer is wrong', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(quizGameProvider.notifier);
      notifier.answerQuestion(false);

      final state = container.read(quizGameProvider);
      expect(state.currentQuestionIndex, 1);
      expect(state.score, 0);
    });

    test('should accumulate score correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(quizGameProvider.notifier);
      notifier.answerQuestion(true);
      notifier.answerQuestion(false);
      notifier.answerQuestion(true);
      notifier.answerQuestion(true);

      final state = container.read(quizGameProvider);
      expect(state.currentQuestionIndex, 4);
      expect(state.score, 15); // 3 correct * 5 points
    });

    test('should reset game to initial state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(quizGameProvider.notifier);
      notifier.answerQuestion(true);
      notifier.answerQuestion(true);

      notifier.resetGame();

      final state = container.read(quizGameProvider);
      expect(state.currentQuestionIndex, 0);
      expect(state.score, 0);
    });
  });
}
