#!/bin/bash

# Script to validate Flutter project
# Run this after installing Flutter SDK

set -e

echo "=== Flutter Bible Games Validation Script ==="
echo ""

# Check Flutter installation
echo "1. Checking Flutter installation..."
flutter --version
echo ""

# Get dependencies
echo "2. Getting dependencies..."
flutter pub get
echo ""

# Run dart fix
echo "3. Running dart fix..."
dart fix --dry-run
dart fix --apply
echo ""

# Run dart format
echo "4. Running dart format..."
dart format lib/ test/ --set-exit-if-changed || true
dart format lib/ test/
echo ""

# Run dart analyze
echo "5. Running dart analyze..."
dart analyze --fatal-infos --fatal-warnings
echo ""

# Run tests
echo "6. Running tests..."
flutter test
echo ""

echo "=== All validations passed! ==="
echo ""
echo "To run the app:"
echo "  flutter run"
echo ""
echo "To build for production:"
echo "  flutter build apk    # For Android"
echo "  flutter build ios    # For iOS"
