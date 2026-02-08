import 'dart:async';

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
  @override
  void initState() {
    super.initState();
    // Reset game when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(memoryGameProvider.notifier).resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(memoryGameProvider);
    final cards = memoryCards.toList()..shuffle();

    final isGameComplete = gameState.matchedPairs.length == cards.length;

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
                  color: Colors.white.withValues(alpha: 0.2),
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
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    final isFlipped = gameState.flippedCards.contains(card.id);
                    final isMatched = gameState.matchedPairs.contains(card.id);

                    return _buildMemoryCard(
                      context,
                      card,
                      isFlipped || isMatched,
                      isMatched,
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

  Widget _buildMemoryCard(
    BuildContext context,
    MemoryCard card,
    bool isFlipped,
    bool isMatched,
  ) {
    return GestureDetector(
      onTap: isMatched
          ? null
          : () {
              final gameState = ref.read(memoryGameProvider);
              if (gameState.flippedCards.length < 2) {
                ref.read(memoryGameProvider.notifier).flipCard(card.id);

                // Check for match after a short delay
                Future.delayed(const Duration(milliseconds: 100), () {
                  final newState = ref.read(memoryGameProvider);
                  if (newState.flippedCards.length == 2) {
                    ref
                        .read(memoryGameProvider.notifier)
                        .checkMatch(memoryCards);

                    // Reset flipped cards if no match
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      final currentState = ref.read(memoryGameProvider);
                      if (currentState.flippedCards.length == 2) {
                        ref.read(memoryGameProvider.notifier).resetFlipped();
                      }
                    });
                  }
                });
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isMatched
              ? Colors.green.withValues(alpha: 0.5)
              : (isFlipped
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Center(
          child: isFlipped || isMatched
              ? Text(
                  card.text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                )
              : const Icon(
                  Icons.help_outline,
                  color: Colors.white,
                  size: 40,
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
                      color: Colors.white.withValues(alpha: 0.2),
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
                                Colors.white.withValues(alpha: 0.3),
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
