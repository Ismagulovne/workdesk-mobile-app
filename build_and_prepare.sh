#!/bin/bash
set -e

echo "🚀 === Сборка и подготовка WorkDesk для Google Play ==="
echo ""

# 1. СБОРКА APK И AAB
echo "📦 1️⃣ СБОРКА ФАЙЛОВ ПРИЛОЖЕНИЯ..."
echo "================================================"

# Очищу flutter кеш
echo "🧹 Очистка кеша Flutter..."
flutter clean

# Получу зависимости
echo "📥 Загрузка зависимостей..."
flutter pub get

# Собираю APK для release
echo "🔨 Сборка APK в режиме release..."
flutter build apk --release 2>&1 | tail -5

# Собираю App Bundle для release
echo "🔨 Сборка App Bundle (AAB) в режиме release..."
flutter build appbundle --release 2>&1 | tail -5

echo ""
echo "✅ Файлы собраны!"
echo ""
echo "📂 Расположение файлов:"
ls -lh build/app/outputs/flutter-apk/app-release.apk 2>/dev/null && echo "✅ APK: build/app/outputs/flutter-apk/app-release.apk" || echo "❌ APK не найден"
ls -lh build/app/outputs/bundle/release/app-release.aab 2>/dev/null && echo "✅ AAB: build/app/outputs/bundle/release/app-release.aab" || echo "❌ AAB не найден"

