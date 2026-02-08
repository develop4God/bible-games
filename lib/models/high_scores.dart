// High Scores Model
class HighScores {
  const HighScores({
    this.trivia = 0,
    this.memory = 0,
    this.wordSearch = 0,
    this.quiz = 0,
  });

  final int trivia;
  final int memory;
  final int wordSearch;
  final int quiz;

  HighScores copyWith({
    int? trivia,
    int? memory,
    int? wordSearch,
    int? quiz,
  }) {
    return HighScores(
      trivia: trivia ?? this.trivia,
      memory: memory ?? this.memory,
      wordSearch: wordSearch ?? this.wordSearch,
      quiz: quiz ?? this.quiz,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trivia': trivia,
      'memory': memory,
      'wordSearch': wordSearch,
      'quiz': quiz,
    };
  }

  factory HighScores.fromJson(Map<String, dynamic> json) {
    return HighScores(
      trivia: json['trivia'] as int? ?? 0,
      memory: json['memory'] as int? ?? 0,
      wordSearch: json['wordSearch'] as int? ?? 0,
      quiz: json['quiz'] as int? ?? 0,
    );
  }
}
