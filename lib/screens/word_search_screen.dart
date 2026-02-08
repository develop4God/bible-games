import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bible_games/data/biblical_data.dart';
import 'package:bible_games/providers/high_scores_provider.dart';

class WordSearchScreen extends ConsumerStatefulWidget {
  const WordSearchScreen({super.key});

  @override
  ConsumerState<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends ConsumerState<WordSearchScreen> {
  final Set<String> foundWords = {};
  int score = 0;

  // For interactive grid
  int? _startDragIndex;
  int? _currentDragIndex;
  final Set<int> _foundIndices = {};

  void _checkWord(List<int> indices) {
    final puzzle = wordSearchPuzzles.first;
    final grid = puzzle.grid;
    final crossAxisCount = grid[0].length;

    final selectedLetters =
        indices.map((index) => grid[index ~/ crossAxisCount][index % crossAxisCount]).toList();

    final forwardWord = selectedLetters.join();
    final backwardWord = selectedLetters.reversed.join();

    void processFoundWord(String word) {
      if (!foundWords.contains(word)) {
        setState(() {
          foundWords.add(word);
          _foundIndices.addAll(indices);
          score += 10;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Encontraste "$word"!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }

    if (puzzle.words.contains(forwardWord)) {
      processFoundWord(forwardWord);
    } else if (puzzle.words.contains(backwardWord)) {
      processFoundWord(backwardWord);
    }
  }

  int _getIndexFromPosition(
      Offset localPosition, int crossAxisCount, double cellSize, int rowCount) {
    final col =
        (localPosition.dx / cellSize).floor().clamp(0, crossAxisCount - 1);
    final row = (localPosition.dy / cellSize).floor().clamp(0, rowCount - 1);
    return row * crossAxisCount + col;
  }

  List<int> _getIndicesBetween(int startIndex, int endIndex, int crossAxisCount) {
    final startRow = startIndex ~/ crossAxisCount;
    final startCol = startIndex % crossAxisCount;
    final endRow = endIndex ~/ crossAxisCount;
    final endCol = endIndex % crossAxisCount;
    final indices = <int>[];

    if (startRow == endRow) { // Horizontal
      final step = endCol > startCol ? 1 : -1;
      for (var c = startCol; c != endCol + step; c += step) {
        indices.add(startRow * crossAxisCount + c);
      }
    } else if (startCol == endCol) { // Vertical
      final step = endRow > startRow ? 1 : -1;
      for (var r = startRow; r != endRow + step; r += step) {
        indices.add(r * crossAxisCount + startCol);
      }
    } else if ((endRow - startRow).abs() == (endCol - startCol).abs()) { // Diagonal
      final rowStep = endRow > startRow ? 1 : -1;
      final colStep = endCol > startCol ? 1 : -1;
      int row = startRow;
      int col = startCol;
      while (true) {
        indices.add(row * crossAxisCount + col);
        if (row == endRow && col == endCol) break;
        row += rowStep;
        col += colStep;
      }
    }
    return indices;
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = wordSearchPuzzles.first;
    final isGameComplete = foundWords.length == puzzle.words.length;

    if (isGameComplete) {
      return _buildResultScreen(context, ref, score);
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Sopa de Letras',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Score
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Encontradas: ${foundWords.length}/${puzzle.words.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Word Grid
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final crossAxisCount = puzzle.grid[0].length;
                            final cellSize =
                                constraints.maxWidth / crossAxisCount;
                            
                            List<int> selectedIndices = [];
                            if(_startDragIndex != null && _currentDragIndex != null){
                                selectedIndices = _getIndicesBetween(_startDragIndex!, _currentDragIndex!, crossAxisCount);
                            }

                            return GestureDetector(
                              onPanStart: (details) {
                                setState(() {
                                  _startDragIndex = _getIndexFromPosition(
                                      details.localPosition,
                                      crossAxisCount,
                                      cellSize,
                                      puzzle.grid.length);
                                  _currentDragIndex = _startDragIndex;
                                });
                              },
                              onPanUpdate: (details) {
                                final index = _getIndexFromPosition(
                                    details.localPosition,
                                    crossAxisCount,
                                    cellSize,
                                    puzzle.grid.length);
                                if (index != _currentDragIndex) {
                                  setState(() {
                                    _currentDragIndex = index;
                                  });
                                }
                              },
                              onPanEnd: (details) {
                                if (_startDragIndex != null &&
                                    _currentDragIndex != null) {
                                  final indices = _getIndicesBetween(
                                      _startDragIndex!,
                                      _currentDragIndex!,
                                      crossAxisCount);
                                  if (indices.isNotEmpty) {
                                    _checkWord(indices);
                                  }
                                }
                                setState(() {
                                  _startDragIndex = null;
                                  _currentDragIndex = null;
                                });
                              },
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                ),
                                itemCount:
                                    puzzle.grid.length * crossAxisCount,
                                itemBuilder: (context, index) {
                                  final row = index ~/ crossAxisCount;
                                  final col = index % crossAxisCount;
                                  final letter = puzzle.grid[row][col];
                                  final isSelected = selectedIndices.contains(index);
                                  final isFound = _foundIndices.contains(index);

                                  Color backgroundColor;
                                  if (isFound) {
                                    backgroundColor =
                                        Colors.green.withOpacity(0.5);
                                  } else if (isSelected) {
                                    backgroundColor =
                                        Colors.blue.withOpacity(0.5);
                                  } else {
                                    backgroundColor = const Color(0xFF4facfe)
                                        .withOpacity(0.1);
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        letter,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: isFound
                                              ? Colors.white
                                              : const Color(0xFF4facfe),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Words List
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Palabras a encontrar:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: puzzle.words.map((word) {
                        final isFound = foundWords.contains(word);
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isFound
                                ? Colors.green
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            word,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              decoration:
                                  isFound ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(
      BuildContext context, WidgetRef ref, int finalScore) {
    // Update high score
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(highScoresProvider.notifier).updateWordSearchScore(finalScore);
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '¡Todas las Palabras Encontradas!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Puntuación Final',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$finalScore',
                          style: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'puntos',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              foundWords.clear();
                              _foundIndices.clear();
                              score = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF4facfe),
                          ),
                          child: const Text(
                            'Jugar de Nuevo',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor:
                                Colors.white.withOpacity(0.3),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Volver al Inicio',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
