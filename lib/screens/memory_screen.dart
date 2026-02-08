import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bible_games/data/biblical_data.dart';
import 'package:bible_games/models/biblical_content.dart';
import 'package:bible_games/providers/game_providers.dart';
import 'package:bible_games/providers/high_scores_provider.dart';

class MemoryScreen extends ConsumerStatefulWidget {
  const MemoryScreen({super.key});

  @override
  ConsumerState<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends ConsumerState<MemoryScreen> {
  late List<MemoryCard> _shuffledCards;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _shuffledCards = memoryCards.toList()..shuffle();
    // Reset game when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(memoryGameProvider.notifier).resetGame();
    });
  }

  void _handleCardTap(MemoryCard card) {
    if (_isProcessing) return;

    final gameState = ref.read(memoryGameProvider);
    
    // Ignore if already matched or already flipped
    if (gameState.matchedPairs.contains(card.id) || 
        gameState.flippedCards.contains(card.id)) {
      return;
    }

    ref.read(memoryGameProvider.notifier).flipCard(card.id);

    final newState = ref.read(memoryGameProvider);
    if (newState.flippedCards.length == 2) {
      _isProcessing = true;
      
      // Check for match after flip animation roughly finishes
      Future.delayed(const Duration(milliseconds: 500), () {
        final card1 = _shuffledCards.firstWhere((c) => c.id == newState.flippedCards[0]);
        final card2 = _shuffledCards.firstWhere((c) => c.id == newState.flippedCards[1]);
        
        final isMatch = card1.pairId == card2.pairId;
        
        if (isMatch) {
          ref.read(memoryGameProvider.notifier).checkMatch(_shuffledCards);
          _isProcessing = false;
        } else {
          // Keep cards visible for a second before flipping back
          Future.delayed(const Duration(milliseconds: 1000), () {
            ref.read(memoryGameProvider.notifier).checkMatch(_shuffledCards); // Increment moves
            ref.read(memoryGameProvider.notifier).resetFlipped();
            _isProcessing = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(memoryGameProvider);
    final isGameComplete = gameState.matchedPairs.length == _shuffledCards.length;

    if (isGameComplete) {
      return _buildResultScreen(context, ref, gameState.moves);
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
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
                        'Memorama',
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

              // Moves counter
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
                    const Icon(Icons.swap_horiz, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Movimientos: ${gameState.moves}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Memory grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _shuffledCards.length,
                  itemBuilder: (context, index) {
                    final card = _shuffledCards[index];
                    final isFlipped = gameState.flippedCards.contains(card.id);
                    final isMatched = gameState.matchedPairs.contains(card.id);
                    
                    // Determine if we should show red (wrong match)
                    bool isWrong = false;
                    if (gameState.flippedCards.length == 2 && isFlipped) {
                        final c1 = _shuffledCards.firstWhere((c) => c.id == gameState.flippedCards[0]);
                        final c2 = _shuffledCards.firstWhere((c) => c.id == gameState.flippedCards[1]);
                        isWrong = c1.pairId != c2.pairId;
                    }

                    return MemoryCardWidget(
                      card: card,
                      isFlipped: isFlipped || isMatched,
                      isMatched: isMatched,
                      isWrong: isWrong,
                      onTap: () => _handleCardTap(card),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(
      BuildContext context, WidgetRef ref, int totalMoves) {
    final score = (100 - totalMoves).clamp(0, 100);

    // Update high score
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(highScoresProvider.notifier).updateMemoryScore(score);
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
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
                    '¡Felicitaciones!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                        Text(
                          'Completaste el juego en $totalMoves movimientos',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Puntuación',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$score',
                          style: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
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
                                _shuffledCards.shuffle();
                            });
                            ref.read(memoryGameProvider.notifier).resetGame();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFf093fb),
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

class MemoryCardWidget extends StatelessWidget {
  final MemoryCard card;
  final bool isFlipped;
  final bool isMatched;
  final bool isWrong;
  final VoidCallback onTap;

  const MemoryCardWidget({
    super.key,
    required this.card,
    required this.isFlipped,
    required this.isMatched,
    required this.isWrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: 0, end: isFlipped ? 180 : 0),
        builder: (context, double value, child) {
          final isBack = value > 90;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value * pi / 180),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isMatched 
                            ? Colors.green.withOpacity(0.8)
                            : (isWrong ? Colors.red.withOpacity(0.8) : Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            card.text,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: (isMatched || isWrong) ? Colors.white : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white.withOpacity(0.4), Colors.white.withOpacity(0.1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.help_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
