#!/bin/bash
# Скрипт для экспорта всех OpenSCAD моделей в STL

# Цвета для вывода
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Экспорт всех моделей в STL ===${NC}"
echo ""

# Директория с моделями
DIR="/home/msin/robo_club/3d-models"
cd "$DIR"

# Создаём папку для STL файлов
mkdir -p maze/stl

# Счётчик
count=0
total=$(ls maze/scad/*.scad 2>/dev/null | grep -v common.scad | wc -l)

# Экспортируем каждый .scad файл (кроме common.scad)
for scad_file in maze/scad/*.scad; do
    if [ -f "$scad_file" ] && [[ ! "$scad_file" =~ common\.scad$ ]]; then
        count=$((count + 1))
        filename=$(basename "$scad_file" .scad)
        stl_file="maze/stl/${filename}.stl"

        echo -e "${BLUE}[$count/$total]${NC} Экспорт: $scad_file → $stl_file"

        # Запускаем OpenSCAD для экспорта (единицы: миллиметры)
        openscad -o "$stl_file" "$scad_file" 2>/dev/null

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Готово${NC}"
        else
            echo -e "✗ Ошибка при экспорте $scad_file"
        fi
        echo ""
    fi
done

echo -e "${GREEN}=== Экспорт завершён! ===${NC}"
echo "Всего экспортировано: $count моделей"
echo "STL файлы находятся в: $DIR/maze/stl/"
