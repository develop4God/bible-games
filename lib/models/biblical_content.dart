// Biblical Content Data Models

enum DifficultyLevel {
  kids,
  adults,
}

enum Category {
  oldTestament('old-testament'),
  newTestament('new-testament'),
  characters('characters'),
  miracles('miracles');

  const Category(this.value);
  final String value;
}

// Trivia Question Model
class TriviaQuestion {
  const TriviaQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.category,
    this.explanation,
  });

  final int id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final DifficultyLevel difficulty;
  final Category category;
  final String? explanation;
}

// Memory Card Model
class MemoryCard {
  const MemoryCard({
    required this.id,
    required this.text,
    required this.pairId,
    required this.difficulty,
  });

  final int id;
  final String text;
  final int pairId;
  final DifficultyLevel difficulty;
}

// Word Search Model
class WordSearchPuzzle {
  const WordSearchPuzzle({
    required this.id,
    required this.grid,
    required this.words,
    required this.difficulty,
    required this.category,
  });

  final int id;
  final List<List<String>> grid;
  final List<String> words;
  final DifficultyLevel difficulty;
  final Category category;
}

// Quiz Question Model
class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.statement,
    required this.isTrue,
    required this.difficulty,
    required this.category,
    this.explanation,
  });

  final int id;
  final String statement;
  final bool isTrue;
  final DifficultyLevel difficulty;
  final Category category;
  final String? explanation;
}
