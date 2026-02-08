import 'package:flutter_test/flutter_test.dart';
import 'package:bible_games/models/biblical_content.dart';

void main() {
  group('DifficultyLevel enum', () {
    test('should have kids and adults values', () {
      expect(DifficultyLevel.values.length, 2);
      expect(DifficultyLevel.values, contains(DifficultyLevel.kids));
      expect(DifficultyLevel.values, contains(DifficultyLevel.adults));
    });
  });

  group('Category enum', () {
    test('should have correct values', () {
      expect(Category.values.length, 4);
      expect(Category.oldTestament.value, 'old-testament');
      expect(Category.newTestament.value, 'new-testament');
      expect(Category.characters.value, 'characters');
      expect(Category.miracles.value, 'miracles');
    });
  });

  group('TriviaQuestion', () {
    test('should create a valid trivia question', () {
      const question = TriviaQuestion(
        id: 1,
        question: '¿Quién construyó el arca?',
        options: ['Noé', 'Moisés', 'Abraham', 'David'],
        correctAnswer: 0,
        difficulty: DifficultyLevel.kids,
        category: Category.oldTestament,
        explanation: 'Noé construyó el arca según Génesis 6',
      );

      expect(question.id, 1);
      expect(question.question, '¿Quién construyó el arca?');
      expect(question.options.length, 4);
      expect(question.correctAnswer, 0);
      expect(question.difficulty, DifficultyLevel.kids);
      expect(question.category, Category.oldTestament);
      expect(question.explanation, 'Noé construyó el arca según Génesis 6');
    });

    test('should work without explanation', () {
      const question = TriviaQuestion(
        id: 2,
        question: 'Test question',
        options: ['A', 'B', 'C', 'D'],
        correctAnswer: 1,
        difficulty: DifficultyLevel.adults,
        category: Category.newTestament,
      );

      expect(question.explanation, isNull);
    });
  });

  group('MemoryCard', () {
    test('should create a valid memory card', () {
      const card = MemoryCard(
        id: 1,
        text: 'Moisés',
        pairId: 1,
        difficulty: DifficultyLevel.kids,
      );

      expect(card.id, 1);
      expect(card.text, 'Moisés');
      expect(card.pairId, 1);
      expect(card.difficulty, DifficultyLevel.kids);
    });

    test('should allow matching pairs with same pairId', () {
      const card1 = MemoryCard(
        id: 1,
        text: 'Moisés',
        pairId: 1,
        difficulty: DifficultyLevel.kids,
      );

      const card2 = MemoryCard(
        id: 2,
        text: 'Líder de Israel',
        pairId: 1,
        difficulty: DifficultyLevel.kids,
      );

      expect(card1.pairId, card2.pairId);
    });
  });

  group('WordSearchPuzzle', () {
    test('should create a valid word search puzzle', () {
      const puzzle = WordSearchPuzzle(
        id: 1,
        grid: [
          ['A', 'B', 'C'],
          ['D', 'E', 'F'],
          ['G', 'H', 'I'],
        ],
        words: ['ABC', 'DEF'],
        difficulty: DifficultyLevel.kids,
        category: Category.characters,
      );

      expect(puzzle.id, 1);
      expect(puzzle.grid.length, 3);
      expect(puzzle.grid[0].length, 3);
      expect(puzzle.words.length, 2);
      expect(puzzle.difficulty, DifficultyLevel.kids);
      expect(puzzle.category, Category.characters);
    });
  });

  group('QuizQuestion', () {
    test('should create a valid quiz question', () {
      const question = QuizQuestion(
        id: 1,
        statement: 'Jesús nació en Belén',
        isTrue: true,
        difficulty: DifficultyLevel.kids,
        category: Category.newTestament,
        explanation: 'Según Mateo 2:1',
      );

      expect(question.id, 1);
      expect(question.statement, 'Jesús nació en Belén');
      expect(question.isTrue, true);
      expect(question.difficulty, DifficultyLevel.kids);
      expect(question.category, Category.newTestament);
      expect(question.explanation, 'Según Mateo 2:1');
    });

    test('should work with false statements', () {
      const question = QuizQuestion(
        id: 2,
        statement: 'David tenía 20 hijos',
        isTrue: false,
        difficulty: DifficultyLevel.adults,
        category: Category.characters,
      );

      expect(question.isTrue, false);
      expect(question.explanation, isNull);
    });
  });
}
