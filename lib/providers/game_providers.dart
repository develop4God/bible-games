import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bible_games/data/biblical_data.dart';
import 'package:bible_games/models/biblical_content.dart';

// Current game difficulty
final gameDifficultyProvider =
    StateProvider<DifficultyLevel>((ref) => DifficultyLevel.kids);

// Trivia Game State
class TriviaGameState {
  const TriviaGameState({
    this.currentQuestionIndex = 0,
    this.score = 0,
    this.answeredQuestions = const [],
  });

  final int currentQuestionIndex;
  final int score;
  final List<bool> answeredQuestions;

  TriviaGameState copyWith({
    int? currentQuestionIndex,
    int? score,
    List<bool>? answeredQuestions,
  }) {
    return TriviaGameState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
    );
  }
}

class TriviaGameNotifier extends StateNotifier<TriviaGameState> {
  TriviaGameNotifier() : super(const TriviaGameState());

  void answerQuestion(bool isCorrect) {
    state = state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex + 1,
      score: isCorrect ? state.score + 10 : state.score,
      answeredQuestions: [...state.answeredQuestions, isCorrect],
    );
  }

  void resetGame() {
    state = const TriviaGameState();
  }
}

final triviaGameProvider =
    StateNotifierProvider.autoDispose<TriviaGameNotifier, TriviaGameState>(
  (ref) => TriviaGameNotifier(),
);

// Filtered trivia questions based on difficulty
final filteredTriviaQuestionsProvider =
    Provider.autoDispose<List<TriviaQuestion>>((ref) {
  final difficulty = ref.watch(gameDifficultyProvider);
  return triviaQuestions.where((q) => q.difficulty == difficulty).toList()
    ..shuffle();
});

// Memory Game State
class MemoryGameState {
  const MemoryGameState({
    this.flippedCards = const [],
    this.matchedPairs = const [],
    this.moves = 0,
  });

  final List<int> flippedCards;
  final List<int> matchedPairs;
  final int moves;

  MemoryGameState copyWith({
    List<int>? flippedCards,
    List<int>? matchedPairs,
    int? moves,
  }) {
    return MemoryGameState(
      flippedCards: flippedCards ?? this.flippedCards,
      matchedPairs: matchedPairs ?? this.matchedPairs,
      moves: moves ?? this.moves,
    );
  }
}

class MemoryGameNotifier extends StateNotifier<MemoryGameState> {
  MemoryGameNotifier() : super(const MemoryGameState());

  void flipCard(int cardId) {
    if (state.flippedCards.length < 2 &&
        !state.flippedCards.contains(cardId) &&
        !state.matchedPairs.contains(cardId)) {
      state = state.copyWith(
        flippedCards: [...state.flippedCards, cardId],
      );
    }
  }

  void checkMatch(List<MemoryCard> cards) {
    if (state.flippedCards.length == 2) {
      final card1 = cards.firstWhere((c) => c.id == state.flippedCards[0]);
      final card2 = cards.firstWhere((c) => c.id == state.flippedCards[1]);

      if (card1.pairId == card2.pairId) {
        // Match found
        state = state.copyWith(
          matchedPairs: [...state.matchedPairs, ...state.flippedCards],
          flippedCards: [],
          moves: state.moves + 1,
        );
      } else {
        // No match - will reset in UI after delay
        state = state.copyWith(
          moves: state.moves + 1,
        );
      }
    }
  }

  void resetFlipped() {
    state = state.copyWith(flippedCards: []);
  }

  void resetGame() {
    state = const MemoryGameState();
  }
}

final memoryGameProvider =
    StateNotifierProvider.autoDispose<MemoryGameNotifier, MemoryGameState>(
  (ref) => MemoryGameNotifier(),
);

// Quiz Game State
class QuizGameState {
  const QuizGameState({
    this.currentQuestionIndex = 0,
    this.score = 0,
  });

  final int currentQuestionIndex;
  final int score;

  QuizGameState copyWith({
    int? currentQuestionIndex,
    int? score,
  }) {
    return QuizGameState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
    );
  }
}

class QuizGameNotifier extends StateNotifier<QuizGameState> {
  QuizGameNotifier() : super(const QuizGameState());

  void answerQuestion(bool isCorrect) {
    state = state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex + 1,
      score: isCorrect ? state.score + 5 : state.score,
    );
  }

  void resetGame() {
    state = const QuizGameState();
  }
}

final quizGameProvider =
    StateNotifierProvider.autoDispose<QuizGameNotifier, QuizGameState>(
  (ref) => QuizGameNotifier(),
);

// Filtered quiz questions based on difficulty
final filteredQuizQuestionsProvider =
    Provider.autoDispose<List<QuizQuestion>>((ref) {
  final difficulty = ref.watch(gameDifficultyProvider);
  return quizQuestions.where((q) => q.difficulty == difficulty).toList()
    ..shuffle();
});
