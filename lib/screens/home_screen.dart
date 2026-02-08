import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bible_games/providers/high_scores_provider.dart';
import 'package:bible_games/screens/trivia_screen.dart';
import 'package:bible_games/screens/memory_screen.dart';
import 'package:bible_games/screens/word_search_screen.dart';
import 'package:bible_games/screens/quiz_screen.dart';

class GameCard {
  const GameCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.screen,
    required this.emoji,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final Widget screen;
  final String emoji;
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highScores = ref.watch(highScoresProvider);

    final gameCards = [
      const GameCard(
        title: 'Trivia Bíblica',
        subtitle: 'Preguntas y Respuestas',
        icon: Icons.auto_stories,
        gradientColors: [Color(0xFF667eea), Color(0xFF764ba2)],
        screen: TriviaScreen(),
        emoji: '📖',
      ),
      const GameCard(
        title: 'Memorama',
        subtitle: 'Encuentra las Parejas',
        icon: Icons.psychology,
        gradientColors: [Color(0xFFf093fb), Color(0xFFf5576c)],
        screen: MemoryScreen(),
        emoji: '🧠',
      ),
      const GameCard(
        title: 'Sopa de Letras',
        subtitle: 'Encuentra las Palabras',
        icon: Icons.grid_3x3,
        gradientColors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
        screen: WordSearchScreen(),
        emoji: '🔤',
      ),
      const GameCard(
        title: 'Quiz Rápido',
        subtitle: 'Verdadero o Falso',
        icon: Icons.flash_on,
        gradientColors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
        screen: QuizScreen(),
        emoji: '⚡',
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '✝️',
                            style: TextStyle(fontSize: 48),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 32,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Juegos Bíblicos',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Aprende y diviértete con la Palabra de Dios',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Stats Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    color: Colors.white.withValues(alpha: 0.2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Récords Personales',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildScoreStat(
                                  'Trivia', highScores.trivia.toString()),
                              _buildScoreStat(
                                  'Memorama', highScores.memory.toString()),
                              _buildScoreStat(
                                  'Sopa', highScores.wordSearch.toString()),
                              _buildScoreStat(
                                  'Quiz', highScores.quiz.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Game Cards
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final game = gameCards[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildGameCard(context, game),
                      );
                    },
                    childCount: gameCards.length,
                  ),
                ),
              ),

              // Footer
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        '"Instruye al niño en su camino, y aun cuando fuere viejo no se apartará de él"',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Proverbios 22:6',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildGameCard(BuildContext context, GameCard game) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => game.screen),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: game.gradientColors,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Text(
              game.emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    game.subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                game.icon,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
