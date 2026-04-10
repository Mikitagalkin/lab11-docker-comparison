#!/bin/bash
# Скрипт для сборки всех образов и сравнения размеров

set -e

echo "🔨 Сборка всех Docker образов..."
docker-compose build

echo "📊 Сравнение размеров образов..."
python compare_sizes.py

echo "✅ Готово!"
