#!/bin/bash
# Скрипт для исправления параметров во всех .scad файлах

DIR="/home/msin/robo_club/3d-models/scad"
cd "$DIR"

echo "=== Исправление параметров ==="
echo ""

for file in *.scad; do
    echo "Обработка: $file"

    # 1. Изменить center_size с 10 на 9
    sed -i 's/^center_size = 10;/center_size = 9;/' "$file"

    # 2. Изменить groove_width с 10 на 9
    sed -i 's/^groove_width = 10;/groove_width = 9;/' "$file"

    # 3. Для НЕ-long версий: изменить dowel_spacing с 20 на 40
    if [[ ! $file =~ _long\.scad$ ]]; then
        sed -i 's/^dowel_spacing = 20;/dowel_spacing = 40;/' "$file"
        echo "  - dowel_spacing: 20 → 40мм"
    fi

    echo "  - center_size: 10 → 9мм"
    echo "  - groove_width: 10 → 9мм"
    echo "  ✓ Готово"
    echo ""
done

echo "=== Все файлы исправлены! ==="
