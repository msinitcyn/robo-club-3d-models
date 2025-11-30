// Прямой паз с шипами для вставки в основание
// Модульная конструкция: центральное основание + 2 рукава (лево-право) + шипы

// Параметры (все размеры в мм)
center_size = 10;     // Размер центрального квадрата (внутри)
sleeve_length = 30;   // Длина рукава
groove_width = 10;    // Ширина паза (внутри) - для фанеры 9.3мм
wall_height = 10;     // Высота стенок
wall_thickness = 2;   // Толщина стенок

// Параметры шипов
dowel_diameter = 5;   // Диаметр шипа
dowel_depth = 9;      // Глубина шипа (высота)
dowel_spacing = 20;   // Шаг между шипами

// Вычисляемые размеры
total_width = groove_width + 2 * wall_thickness;  // 14 мм
center_total = center_size + 2 * wall_thickness;  // 14 мм

// 1. Метод: нарисовать основание
module draw_base() {
    difference() {
        cube([center_total, center_total, wall_height]);
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([center_size, center_size, wall_height]);
    }
}

// Модуль для создания одного рукава
module single_sleeve() {
    difference() {
        cube([sleeve_length, total_width, wall_height]);
        translate([0, wall_thickness, wall_thickness])
            cube([sleeve_length, groove_width, wall_height]);
    }
}

// Метод: вырезать отверстие в стенке основания
module cut_wall_opening(side) {
    if (side == 0) {
        translate([center_total - wall_thickness - 0.1, wall_thickness, wall_thickness])
            cube([wall_thickness + 0.2, groove_width, wall_height]);
    } else if (side == 2) {
        translate([-0.1, wall_thickness, wall_thickness])
            cube([wall_thickness + 0.2, groove_width, wall_height]);
    }
}

// 2. Метод: прицепить рукав к основанию
module attach_sleeve(side) {
    if (side == 0) {
        translate([center_total, center_total/2 - total_width/2, 0])
            single_sleeve();
    } else if (side == 2) {
        translate([-sleeve_length, center_total/2 - total_width/2, 0])
            single_sleeve();
    }
}

// 3. Метод: добавить шип в позиции (x, y)
module add_dowel(x, y) {
    translate([x, y, -dowel_depth])
        cylinder(h=dowel_depth, d=dowel_diameter, $fn=30);
}

// Собираем прямую конструкцию с шипами
translate([-center_total/2, -center_total/2, 0]) {
    union() {
        difference() {
            draw_base();
            cut_wall_opening(0);  // Право
            cut_wall_opening(2);  // Лево
        }
        attach_sleeve(0);  // Право
        attach_sleeve(2);  // Лево

        // Шипы: центр + лево/право
        add_dowel(center_total/2, center_total/2);                    // Центр
        add_dowel(center_total/2 - dowel_spacing, center_total/2);   // Лево
        add_dowel(center_total/2 + dowel_spacing, center_total/2);   // Право
    }
}

// Информация для проверки
echo("=== Размеры прямого паза с шипами ===");
echo("Количество шипов: 3 (центр + лево/право)");
echo("Шаг между шипами:", dowel_spacing, "мм");
