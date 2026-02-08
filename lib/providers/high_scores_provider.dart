import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bible_games/models/high_scores.dart';

// High Scores Provider
class HighScoresNotifier extends StateNotifier<HighScores> {
  HighScoresNotifier(this._prefs) : super(const HighScores()) {
    _loadScores();
  }

  final SharedPreferences _prefs;

  Future<void> _loadScores() async {
    final scoresJson = _prefs.getString('highScores');
    if (scoresJson != null) {
      final Map<String, dynamic> decoded =
          jsonDecode(scoresJson) as Map<String, dynamic>;
      state = HighScores.fromJson(decoded);
    }
  }

  Future<void> _saveScores() async {
    await _prefs.setString('highScores', jsonEncode(state.toJson()));
  }

  Future<void> updateTriviaScore(int score) async {
    if (score > state.trivia) {
      state = state.copyWith(trivia: score);
      await _saveScores();
    }
  }

  Future<void> updateMemoryScore(int score) async {
    if (score > state.memory) {
      state = state.copyWith(memory: score);
      await _saveScores();
    }
  }

  Future<void> updateWordSearchScore(int score) async {
    if (score > state.wordSearch) {
      state = state.copyWith(wordSearch: score);
      await _saveScores();
    }
  }

  Future<void> updateQuizScore(int score) async {
    if (score > state.quiz) {
      state = state.copyWith(quiz: score);
      await _saveScores();
    }
  }

  Future<void> resetAllScores() async {
    state = const HighScores();
    await _saveScores();
  }
}

// Provider for SharedPreferences
final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

// Provider for High Scores
final highScoresProvider =
    StateNotifierProvider<HighScoresNotifier, HighScores>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return HighScoresNotifier(prefs);
});
