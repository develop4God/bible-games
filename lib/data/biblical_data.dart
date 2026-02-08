import 'package:bible_games/models/biblical_content.dart';

// Trivia Questions Data
const List<TriviaQuestion> triviaQuestions = [
  // Kids - Old Testament
  TriviaQuestion(
    id: 1,
    question: '¿Quién construyó el arca?',
    options: ['Moisés', 'Noé', 'Abraham', 'David'],
    correctAnswer: 1,
    difficulty: DifficultyLevel.kids,
    category: Category.oldTestament,
    explanation: 'Noé construyó el arca siguiendo las instrucciones de Dios.',
  ),
  TriviaQuestion(
    id: 2,
    question: '¿Cuántos días y noches llovió durante el diluvio?',
    options: ['7', '30', '40', '100'],
    correctAnswer: 2,
    difficulty: DifficultyLevel.kids,
    category: Category.oldTestament,
  ),
  TriviaQuestion(
    id: 3,
    question: '¿Quién fue tragado por un gran pez?',
    options: ['Pedro', 'Jonás', 'Job', 'José'],
    correctAnswer: 1,
    difficulty: DifficultyLevel.kids,
    category: Category.oldTestament,
  ),
  TriviaQuestion(
    id: 4,
    question: '¿Qué usó David para vencer a Goliat?',
    options: ['Una espada', 'Una lanza', 'Una honda y piedras', 'Un arco'],
    correctAnswer: 2,
    difficulty: DifficultyLevel.kids,
    category: Category.characters,
  ),
  TriviaQuestion(
    id: 5,
    question: '¿Cuántos hermanos tenía José?',
    options: ['7', '10', '11', '12'],
    correctAnswer: 2,
    difficulty: DifficultyLevel.kids,
    category: Category.characters,
  ),
  // Kids - New Testament
  TriviaQuestion(
    id: 6,
    question: '¿Dónde nació Jesús?',
    options: ['Nazaret', 'Belén', 'Jerusalén', 'Galilea'],
    correctAnswer: 1,
    difficulty: DifficultyLevel.kids,
    category: Category.newTestament,
  ),
  TriviaQuestion(
    id: 7,
    question: '¿Cuántos discípulos tuvo Jesús?',
    options: ['7', '10', '12', '24'],
    correctAnswer: 2,
    difficulty: DifficultyLevel.kids,
    category: Category.newTestament,
  ),
  TriviaQuestion(
    id: 8,
    question: '¿Quién negó a Jesús tres veces?',
    options: ['Juan', 'Pedro', 'Judas', 'Tomás'],
    correctAnswer: 1,
    difficulty: DifficultyLevel.kids,
    category: Category.characters,
  ),
  TriviaQuestion(
    id: 9,
    question: '¿Con qué alimentó Jesús a 5000 personas?',
    options: ['Pan y agua', 'Pan y vino', '5 panes y 2 peces', 'Frutas'],
    correctAnswer: 2,
    difficulty: DifficultyLevel.kids,
    category: Category.miracles,
  ),
  TriviaQuestion(
    id: 10,
    question: '¿Quién caminó sobre el agua con Jesús?',
    options: ['Juan', 'Pedro', 'Santiago', 'Mateo'],
    correctAnswer: 1,
    difficulty: DifficultyLevel.kids,
    category: Category.miracles,
  ),
];

// Memory Cards Data
const List<MemoryCard> memoryCards = [
  // Kids pairs
  MemoryCard(id: 1, text: 'Adán', pairId: 1, difficulty: DifficultyLevel.kids),
  MemoryCard(id: 2, text: 'Eva', pairId: 1, difficulty: DifficultyLevel.kids),
  MemoryCard(id: 3, text: 'Moisés', pairId: 2, difficulty: DifficultyLevel.kids),
  MemoryCard(id: 4, text: 'Diez Mandamientos', pairId: 2, difficulty: DifficultyLevel.kids),
  MemoryCard(id: 5, text: 'David', pairId: 3, difficulty: DifficultyLevel.kids),
  MemoryCard(id: 6, text: 'Goliat', pairId: 3, difficulty: DifficultyLevel.kids),
  MemoryCard(id: 7, text: 'Noé', pairId: 4, difficulty: DifficultyLevel.kids),
  MemoryCard(id: 8, text: 'Arca', pairId: 4, difficulty: DifficultyLevel.kids),
  MemoryCard(id: 9, text: 'Jonás', pairId: 5, difficulty: DifficultyLevel.kids),
  MemoryCard(id: 10, text: 'Pez', pairId: 5, difficulty: DifficultyLevel.kids),
  MemoryCard(id: 11, text: 'José', pairId: 6, difficulty: DifficultyLevel.kids),
  MemoryCard(id: 12, text: 'Túnica de Colores', pairId: 6, difficulty: DifficultyLevel.kids),
];

// Quiz Questions Data
const List<QuizQuestion> quizQuestions = [
  // Kids
  QuizQuestion(
    id: 1,
    statement: 'Jesús nació en Belén',
    isTrue: true,
    difficulty: DifficultyLevel.kids,
    category: Category.newTestament,
  ),
  QuizQuestion(
    id: 2,
    statement: 'Noé construyó una torre',
    isTrue: false,
    difficulty: DifficultyLevel.kids,
    category: Category.oldTestament,
    explanation: 'Noé construyó un arca, no una torre.',
  ),
  QuizQuestion(
    id: 3,
    statement: 'Jesús tuvo 12 discípulos',
    isTrue: true,
    difficulty: DifficultyLevel.kids,
    category: Category.newTestament,
  ),
  QuizQuestion(
    id: 4,
    statement: 'David venció a Goliat con una espada',
    isTrue: false,
    difficulty: DifficultyLevel.kids,
    category: Category.characters,
    explanation: 'David usó una honda y piedras.',
  ),
  QuizQuestion(
    id: 5,
    statement: 'Moisés abrió el Mar Rojo',
    isTrue: true,
    difficulty: DifficultyLevel.kids,
    category: Category.miracles,
  ),
];

// Word Search Puzzles Data
const List<WordSearchPuzzle> wordSearchPuzzles = [
  WordSearchPuzzle(
    id: 1,
    grid: [
      ['J', 'E', 'S', 'U', 'S', 'M'],
      ['D', 'I', 'O', 'S', 'A', 'O'],
      ['A', 'M', 'O', 'R', 'R', 'I'],
      ['V', 'I', 'D', 'A', 'I', 'S'],
      ['P', 'A', 'Z', 'F', 'A', 'E'],
      ['F', 'E', 'P', 'E', 'D', 'S'],
    ],
    words: ['JESUS', 'DIOS', 'AMOR', 'VIDA', 'PAZ', 'FE', 'MARIA', 'MOISES'],
    difficulty: DifficultyLevel.kids,
    category: Category.newTestament,
  ),
];
