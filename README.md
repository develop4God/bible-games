# 📖 Bible Games - Juegos Bíblicos (Flutter)

A Flutter mobile application for learning the Bible through interactive games. Migrated from React Native with Riverpod state management.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.6-blue.svg)](https://riverpod.dev/)

## 🎮 Features

### Games Included
- **📖 Trivia Bíblica**: Bible trivia with multiple choice questions
- **🧠 Memorama**: Memory matching game with biblical themes
- **🔤 Sopa de Letras**: Word search puzzles with Bible words
- **⚡ Quiz Rápido**: Fast-paced true/false quiz

### Key Features
- 🌟 Beautiful, modern UI with gradient designs
- 📊 High score tracking with persistent storage
- 🎯 Multiple difficulty levels (Kids & Adults)
- 📚 Content categories (Old Testament, New Testament, Characters, Miracles)
- 📱 Cross-platform (iOS, Android, Web)
- 🔄 Riverpod state management
- 💾 SharedPreferences for data persistence

## 🚀 Quick Start

### Prerequisites
- Flutter 3.2.0 or higher
- Dart SDK

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/develop4God/bible-games.git
cd bible-games
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

## 🛠️ Development

### Available Commands
- `flutter run` - Run the app in debug mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter test` - Run tests
- `dart analyze` - Analyze code
- `dart fix --apply` - Apply automated fixes
- `dart format .` - Format code

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── biblical_content.dart
│   └── high_scores.dart
├── data/                     # Static data
│   └── biblical_data.dart
├── providers/                # Riverpod providers
│   ├── game_providers.dart
│   └── high_scores_provider.dart
└── screens/                  # UI screens
    ├── home_screen.dart
    ├── trivia_screen.dart
    ├── memory_screen.dart
    ├── word_search_screen.dart
    └── quiz_screen.dart
```

## 🎨 Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Riverpod 2.6
- **Storage**: SharedPreferences
- **Fonts**: Google Fonts
- **Icons**: Lucide Icons
- **Language**: Dart 3.x

## 📚 Game Content

All biblical content is stored in `lib/data/biblical_data.dart` and includes:
- Trivia questions with explanations
- Memory card pairs
- Word search words and grids
- Quiz questions

Content is available in Spanish and categorized by difficulty and topic.

## 🙏 Credits

Built with ❤️ for Bible education and entertainment.

### Scripture Reference
"Instruye al niño en su camino, y aun cuando fuere viejo no se apartará de él" - Proverbios 22:6

---

Made with 🙏 by develop4God