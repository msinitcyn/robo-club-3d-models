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

// Параметры для гибких стенок
CARDBOARD_THICKNESS = 2;   // толщина картона
GROOVE_BOTTOM = CARDBOARD_THICKNESS;  // ширина паза внизу
CURVE_POWER = 2;           // степень кривой (2=парабола)
CURVE_POINTS = 20;         // количество точек для гладкости
TILT_ANGLE_EXTRA = 5;      // дополнительный угол наклона
FLEXIBLE_WALL_HEIGHT = WALL_HEIGHT * 2;  // высота гибких стенок (в 2 раза выше обычных)

// ============================================
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ ГИБКИХ СТЕНОК
// ============================================

// Функция для расчета изгиба стенки
// z - высота от 0 до wall_height
// возвращает расстояние от центра
function wall_curve(z) =
    GROOVE_BOTTOM/2 + (GROOVE_WIDTH/2 - GROOVE_BOTTOM/2) * pow(z/(FLEXIBLE_WALL_HEIGHT - BASE_THICKNESS), CURVE_POWER);

// Модуль для создания профиля одной изогнутой стенки
// side: -1 для одной стороны, +1 для другой
module curved_wall_profile(side) {
    wall_h = FLEXIBLE_WALL_HEIGHT - BASE_THICKNESS;

    points_inner = [for (i = [0:CURVE_POINTS])
        [wall_curve(i * wall_h / CURVE_POINTS) * side,
         i * wall_h / CURVE_POINTS]
    ];

    points_outer = [for (i = [0:CURVE_POINTS])
        [(wall_curve(i * wall_h / CURVE_POINTS) + WALL_THICKNESS) * side,
         i * wall_h / CURVE_POINTS]
    ];

    // Создаем замкнутый контур стенки
    all_points = concat(
        [[points_inner[0][0], 0]],
        points_inner,
        [points_outer[len(points_outer)-1]],
        [for (i = [len(points_outer)-1:-1:0]) points_outer[i]],
        [[points_outer[0][0], 0]]
    );

    polygon(all_points);
}

// ============================================
// ОБЩИЕ МОДУЛИ ДЛЯ РИСОВАНИЯ СТЕНОК
// ============================================

// Нарисовать одну обычную (прямую) стенку заданной ширины
// width: длина стенки вдоль X
// Рисуется от начала координат вдоль оси X, с толщиной вдоль Y
module draw_regular_wall_base(width) {
    translate([0, 0, BASE_THICKNESS])
        cube([width, WALL_THICKNESS, WALL_HEIGHT - BASE_THICKNESS]);
}

// Нарисовать базовую гибкую стенку заданной ширины
// Рисует стенку как для стороны 2 (лево) - это базовая ориентация
// width: длина стенки
// mirror_flag: true для зеркальной версии (как сторона 0 - право)
module draw_flexible_wall_base(width) {
    tilt_angle = atan((GROOVE_WIDTH/2 - GROOVE_BOTTOM/2) / (FLEXIBLE_WALL_HEIGHT - BASE_THICKNESS)) + TILT_ANGLE_EXTRA;

    rotate([0, 0, 90])
        rotate([tilt_angle + 6, 0, 0])
            rotate([90, 0, 90])
                linear_extrude(height = width)
                    curved_wall_profile(1);
}

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

// Установить обычную (прямую) стенку центра
// side: 0=право, 1=перед, 2=лево, 3=назад
module place_regular_center_wall(side) {
    if (side == 0) {
        // Право - вертикальная стенка вдоль Y
        translate([CENTER_SIZE/2 + WALL_THICKNESS, -TOTAL_WIDTH/2, 0])
            rotate([0, 0, 90])
                draw_regular_wall_base(TOTAL_WIDTH);
    } else if (side == 1) {
        // Перед - горизонтальная стенка вдоль X
        translate([-TOTAL_WIDTH/2, CENTER_SIZE/2, 0])
            draw_regular_wall_base(TOTAL_WIDTH);
    } else if (side == 2) {
        // Лево - вертикальная стенка вдоль Y
        translate([-CENTER_SIZE/2, -TOTAL_WIDTH/2, 0])
            rotate([0, 0, 90])
                draw_regular_wall_base(TOTAL_WIDTH);
    } else if (side == 3) {
        // Назад - горизонтальная стенка вдоль X
        translate([-TOTAL_WIDTH/2, -CENTER_SIZE/2 - WALL_THICKNESS, 0])
            draw_regular_wall_base(TOTAL_WIDTH);
    }
}

// Установить гибкую (изогнутую) стенку центра
// side: 0=право, 1=перед, 2=лево, 3=назад
module place_flexible_center_wall(side) {
    if (side == 0) {
        // Право
        translate([CENTER_SIZE/2 - WALL_THICKNESS/2, TOTAL_WIDTH/2, 0])
            rotate([0, 0, 180])
                draw_flexible_wall_base(TOTAL_WIDTH);
    } else if (side == 1) {
        // Перед
        translate([-TOTAL_WIDTH/2, CENTER_SIZE/2 - WALL_THICKNESS/2, 0])
            rotate([0, 0, 270])
                draw_flexible_wall_base(TOTAL_WIDTH);
    } else if (side == 2) {
        // Лево - базовая ориентация
        translate([-CENTER_SIZE/2 + WALL_THICKNESS/2, -TOTAL_WIDTH/2, 0])
            draw_flexible_wall_base(TOTAL_WIDTH);
    } else if (side == 3) {
        // Назад
        translate([CENTER_SIZE/2 + WALL_THICKNESS, -TOTAL_WIDTH/2 + WALL_THICKNESS + WALL_THICKNESS/2, 0])
            rotate([0, 0, 90])
                draw_flexible_wall_base(TOTAL_WIDTH);
    }
}

// Установить стенку центра с выбором типа
// side: 0=право, 1=перед, 2=лево, 3=назад
// wall_type: "regular" или "flexible"
module place_center_wall(side, wall_type = "regular") {
    if (wall_type == "regular") {
        place_regular_center_wall(side);
    } else if (wall_type == "flexible") {
        place_flexible_center_wall(side);
    }
}

// ============================================
// МОДУЛИ ДЛЯ РУКАВА
// ============================================

// Нарисовать основание рукава (платформа рукава)
// Рисуется в начале координат, потом будет сдвинут и повернут
module draw_sleeve_base(with_dowel = false) {
    union() {
        // Платформа рукава - прямоугольник (вытянутое основание)
        translate([0, -TOTAL_WIDTH/2, 0])
            cube([SLEEVE_LENGTH, TOTAL_WIDTH, BASE_THICKNESS]);

        // Добавляем штыри если нужно (выступают вниз)
        // Штыри на расстояниях 25 и 50 от центра конструкции
        // Минус CENTER_SIZE/2 так как рукав начинается на расстоянии CENTER_SIZE/2 от центра
        if (with_dowel) {
            translate([25 - CENTER_SIZE/2, 0, -DOWEL_DEPTH])
                cylinder(h=DOWEL_DEPTH, d=DOWEL_DIAMETER, $fn=30);
            translate([50 - CENTER_SIZE/2, 0, -DOWEL_DEPTH])
                cylinder(h=DOWEL_DEPTH, d=DOWEL_DIAMETER, $fn=30);
        }
    }
}

// Нарисовать одну обычную (прямую) стенку рукава
// wall_side: "left" или "right"
// Рисуется в начале координат
module draw_regular_sleeve_wall(wall_side) {
    y_offset = (wall_side == "left") ? -TOTAL_WIDTH/2 : TOTAL_WIDTH/2 - WALL_THICKNESS;

    translate([0, y_offset, 0])
        draw_regular_wall_base(SLEEVE_LENGTH);
}

// Нарисовать одну гибкую (изогнутую) стенку рукава
// wall_side: "left" или "right"
// Рисуется в начале координат
module draw_flexible_sleeve_wall(side) {
    if (side == "left") {
        // Перед
        translate([0, TOTAL_WIDTH/2 - WALL_THICKNESS/2 - WALL_THICKNESS, 0])
            rotate([0, 0, 270])
                draw_flexible_wall_base(SLEEVE_LENGTH);
    } else if (side == "right") {
        // Назад
        translate([SLEEVE_LENGTH, -TOTAL_WIDTH/2 + WALL_THICKNESS + WALL_THICKNESS/2, 0])
            rotate([0, 0, 90])
                draw_flexible_wall_base(SLEEVE_LENGTH);
    }
}

// Нарисовать стенку рукава с выбором типа
// wall_side: "left" или "right"
// wall_type: "regular" или "flexible"
module draw_sleeve_wall(wall_side, wall_type = "regular") {
    if (wall_type == "regular") {
        draw_regular_sleeve_wall(wall_side);
    } else if (wall_type == "flexible") {
        draw_flexible_sleeve_wall(wall_side);
    }
}

// Нарисовать полный рукав (основание + 2 стенки)
// wall_type: "regular" или "flexible"
module draw_full_sleeve(with_dowel = false, wall_type = "regular") {
    union() {
        draw_sleeve_base(with_dowel);
        draw_sleeve_wall("left", wall_type);
        draw_sleeve_wall("right", wall_type);
    }
}

// Установить рукав на нужную сторону
// side: 0=право, 1=перед, 2=лево, 3=назад
// wall_type: "regular" или "flexible"
// Сдвигает рукав на нужное расстояние и поворачивает
module place_sleeve(side, with_dowel = false, wall_type = "regular") {
    if (side == 0) {
        // Право - сдвигаем на CENTER_SIZE/2 вправо
        translate([CENTER_SIZE/2, 0, 0])
            draw_full_sleeve(with_dowel, wall_type);
    } else if (side == 1) {
        // Перед - поворачиваем на 90° и сдвигаем
        rotate([0, 0, 90])
            translate([CENTER_SIZE/2, 0, 0])
                draw_full_sleeve(with_dowel, wall_type);
    } else if (side == 2) {
        // Лево - поворачиваем на 180° и сдвигаем
        rotate([0, 0, 180])
            translate([CENTER_SIZE/2, 0, 0])
                draw_full_sleeve(with_dowel, wall_type);
    } else if (side == 3) {
        // Назад - поворачиваем на 270° и сдвигаем
        rotate([0, 0, 270])
            translate([CENTER_SIZE/2, 0, 0])
                draw_full_sleeve(with_dowel, wall_type);
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
