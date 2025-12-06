// ============================================
// КОНСТАНТЫ
// ============================================

// Основные размеры
CENTER_SIZE = 9;           // размер центрального квадрата (под фанеру)
SLEEVE_REACH = 56.5;       // расстояние от центра до монтажного отверстия
GROOVE_WIDTH = 9;          // ширина паза для фанеры
WALL_HEIGHT = 10;          // высота стенок
WALL_THICKNESS = 2;        // толщина стенок
BASE_THICKNESS = 2;        // толщина основания (пола)

// Вычисляемые константы
TOTAL_WIDTH = GROOVE_WIDTH + 2 * WALL_THICKNESS;  // полная ширина (13мм)
SLEEVE_LENGTH = SLEEVE_REACH - CENTER_SIZE/2;     // длина рукава

// Штыри
DOWEL_DIAMETER = 4.8;      // диаметр штыря (чуть меньше 5мм отверстия)
DOWEL_DEPTH = 3;           // глубина штыря

// ============================================
// МОДУЛИ ДЛЯ ЦЕНТРА
// ============================================

// Нарисовать основание центра (платформа без стенок)
module draw_center_base(with_dowel = false) {
    union() {
        // Платформа
        translate([-TOTAL_WIDTH/2, -TOTAL_WIDTH/2, 0])
            cube([TOTAL_WIDTH, TOTAL_WIDTH, BASE_THICKNESS]);

        // Добавляем штырь если нужно (выступает вниз)
        if (with_dowel) {
            translate([0, 0, -DOWEL_DEPTH])
                cylinder(h=DOWEL_DEPTH, d=DOWEL_DIAMETER, $fn=30);
        }
    }
}

// Установить стенку центра на нужную сторону
// side: 0=право, 1=перед, 2=лево, 3=назад
// Стенки идут вдоль всего основания (внахлест)
module place_center_wall(side) {
    if (side == 0) {
        // Право - вертикальная стенка вдоль Y
        translate([CENTER_SIZE/2, -TOTAL_WIDTH/2, BASE_THICKNESS])
            cube([WALL_THICKNESS, TOTAL_WIDTH, WALL_HEIGHT - BASE_THICKNESS]);
    } else if (side == 1) {
        // Перед - горизонтальная стенка вдоль X
        translate([-TOTAL_WIDTH/2, CENTER_SIZE/2, BASE_THICKNESS])
            cube([TOTAL_WIDTH, WALL_THICKNESS, WALL_HEIGHT - BASE_THICKNESS]);
    } else if (side == 2) {
        // Лево - вертикальная стенка вдоль Y
        translate([-CENTER_SIZE/2 - WALL_THICKNESS, -TOTAL_WIDTH/2, BASE_THICKNESS])
            cube([WALL_THICKNESS, TOTAL_WIDTH, WALL_HEIGHT - BASE_THICKNESS]);
    } else if (side == 3) {
        // Назад - горизонтальная стенка вдоль X
        translate([-TOTAL_WIDTH/2, -CENTER_SIZE/2 - WALL_THICKNESS, BASE_THICKNESS])
            cube([TOTAL_WIDTH, WALL_THICKNESS, WALL_HEIGHT - BASE_THICKNESS]);
    }
}

// ============================================
// МОДУЛИ ДЛЯ РУКАВА
// ============================================

// Нарисовать основание рукава (платформа рукава)
module draw_sleeve_base(with_dowel = false) {
    union() {
        // Платформа рукава
        translate([CENTER_SIZE/2, -TOTAL_WIDTH/2, 0])
            cube([SLEEVE_LENGTH, TOTAL_WIDTH, BASE_THICKNESS]);

        // Добавляем штыри если нужно (выступают вниз на 25мм и 50мм от центра)
        if (with_dowel) {
            translate([25, 0, -DOWEL_DEPTH])
                cylinder(h=DOWEL_DEPTH, d=DOWEL_DIAMETER, $fn=30);
            translate([50, 0, -DOWEL_DEPTH])
                cylinder(h=DOWEL_DEPTH, d=DOWEL_DIAMETER, $fn=30);
        }
    }
}

// Нарисовать одну прямую стенку рукава
// wall_side: "left" или "right"
module draw_sleeve_straight_wall(wall_side) {
    y_offset = (wall_side == "left") ? -TOTAL_WIDTH/2 : TOTAL_WIDTH/2 - WALL_THICKNESS;

    translate([CENTER_SIZE/2, y_offset, BASE_THICKNESS])
        cube([SLEEVE_LENGTH, WALL_THICKNESS, WALL_HEIGHT - BASE_THICKNESS]);
}

// Нарисовать полный рукав (основание + 2 стенки)
module draw_full_sleeve(with_dowel = false) {
    union() {
        draw_sleeve_base(with_dowel);
        draw_sleeve_straight_wall("left");
        draw_sleeve_straight_wall("right");
    }
}

// Установить рукав на нужную сторону
// side: 0=право, 1=перед, 2=лево, 3=назад
module place_sleeve(side, with_dowel = false) {
    if (side == 0) {
        draw_full_sleeve(with_dowel);
    } else if (side == 1) {
        rotate([0, 0, 90])
            draw_full_sleeve(with_dowel);
    } else if (side == 2) {
        rotate([0, 0, 180])
            draw_full_sleeve(with_dowel);
    } else if (side == 3) {
        rotate([0, 0, 270])
            draw_full_sleeve(with_dowel);
    }
}

// ============================================
// ВСПОМОГАТЕЛЬНЫЕ МОДУЛИ (для обратной совместимости)
// ============================================

// Добавить штырь (старый интерфейс)
module add_dowel(x, y, dowel_diameter, dowel_depth) {
    translate([x, y, -dowel_depth])
        cylinder(h=dowel_depth, d=dowel_diameter, $fn=30);
}
