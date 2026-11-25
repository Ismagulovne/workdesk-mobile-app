#!/bin/bash

# Подготовка WorkDesk для Google Play Console

WORKDIR="$(pwd)"
PLAY_ASSETS="$WORKDIR/google_play_assets"

echo "📦 Подготовка WorkDesk для Google Play Console..."

# 1. Создать директорию для ассетов
mkdir -p "$PLAY_ASSETS/screenshots"
mkdir -p "$PLAY_ASSETS/promotional_graphics"

# 2. Информация приложения
cat > "$PLAY_ASSETS/app_info.txt" << 'INFO'
=== WorkDesk - Информация приложения ===

Название: WorkDesk
Пакет: kz.workdesk.app
Версия: 1.0.0
Категория: Productivity / Business

Описание (короткое - макс 50 символов):
Управление рабочим временем

Описание (полное - макс 4000 символов):
WorkDesk — приложение для управления рабочим временем и удалённого доступа к компьютерам в компании.

Основные возможности:
✓ Отслеживание рабочего времени
✓ Управление задачами
✓ Уведомления о важных событиях
✓ Удалённый доступ к устройствам
✓ Синхронизация с Active Directory

Требования:
- Android 5.0 (API 21) и выше
- Интернет-соединение

Автор: WorkTime
Контакт: info@worktime.kz
Сайт: https://worktime.kz
Политика конфиденциальности: https://worktime.kz/privacy

Категория возраста: 4+ (нет возрастных ограничений)
Содержит объявления: Нет
Требует платежей: Нет

INFO

echo "✅ Создана информация приложения"

# 3. Инструкция по скриншотам
cat > "$PLAY_ASSETS/screenshots_guide.txt" << 'GUIDE'
=== Требования к скриншотам для Google Play ===

Размеры для разных устройств:
1. Телефон (required):
   - Минимум 2 скриншота
   - Максимум 8 скриншотов
   - Размер: 1080 x 1920 px (или 1440 x 2560 px)

2. Планшет (optional):
   - Размер: 1536 x 2048 px (или 1200 x 1920 px)

Формат: PNG или JPEG

Что показывать:
1. Главный экран / Dashboard
2. Список задач / Работа
3. Статистика / Отчеты
4. Параметры / Настройки
5. Уведомления / События

GUIDE

echo "✅ Создана инструкция по скриншотам"

# 4. Графика
mkdir -p "$PLAY_ASSETS/graphics/icons"

cat > "$PLAY_ASSETS/graphics/icon_requirements.txt" << 'ICONS'
=== Требования к иконкам ===

1. Иконка приложения (512x512 px):
   - PNG с прозрачностью
   - Имя: app_icon_512.png
   - Вес: < 1 MB
   - Должна быть узнаваемой и читаемой

2. Иконка Feature Graphic (1024x500 px):
   - PNG или JPG
   - Имя: feature_graphic_1024x500.png
   - Показывается на странице приложения

3. Иконка для нескольких экранов (adaptive icon):
   - Background: 108x108 px
   - Foreground: 108x108 px (с 18px padding)

ICONS

echo "✅ Создана информация об иконках"

# 5. Контактная информация
cat > "$PLAY_ASSETS/contact_info.txt" << 'CONTACT'
=== Контактная информация для Google Play ===

Издатель: WorkTime
Страна: Kazakhstan
Email: info@worktime.kz
Телефон: +7 (XXX) XXX-XX-XX
Сайт: https://worktime.kz

Адрес: Almaty, Kazakhstan

Политика конфиденциальности: https://worktime.kz/privacy
Условия использования: https://worktime.kz/terms

CONTACT

echo "✅ Создана контактная информация"

# 6. Инструкции по сборке
cat > "$PLAY_ASSETS/build_instructions.txt" << 'BUILD'
=== Инструкции по сборке APK ===

1. Создать keystore для подписи:
   keytool -genkey -v -keystore release.keystore \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias workdesk -storepass password -keypass password

2. Собрать подписанный APK:
   flutter build apk --release

3. Собрать App Bundle (рекомендуется):
   flutter build appbundle --release

4. Файлы находятся в:
   - APK: build/app/outputs/flutter-apk/app-release.apk
   - AAB: build/app/outputs/bundle/release/app-release.aab

BUILD

echo "✅ Созданы инструкции по сборке"

echo ""
echo "📂 Структура создана в: $PLAY_ASSETS"
ls -la "$PLAY_ASSETS"

