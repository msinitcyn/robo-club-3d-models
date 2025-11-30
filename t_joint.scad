// Т-образный паз для соединения 3х стенок
// Модульная конструкция: центральное основание + 3 рукава

// Параметры (все размеры в мм)
center_size = 10;     // Размер центрального квадрата (внутри)
sleeve_length = 30;   // Длина рукава
groove_width = 10;    // Ширина паза (внутри) - для фанеры 9.3мм
wall_height = 10;     // Высота стенок
wall_thickness = 2;   // Толщина стенок

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
    } else if (side == 1) {
        translate([wall_thickness, center_total - wall_thickness - 0.1, wall_thickness])
            cube([groove_width, wall_thickness + 0.2, wall_height]);
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
    } else if (side == 1) {
        translate([center_total/2 + total_width/2, center_total, 0])
            rotate([0, 0, 90])
                single_sleeve();
    } else if (side == 2) {
        translate([-sleeve_length, center_total/2 - total_width/2, 0])
            single_sleeve();
    }
}

// Собираем Т-образную конструкцию
translate([-center_total/2, -center_total/2, 0]) {
    union() {
        difference() {
            draw_base();
            cut_wall_opening(0);  // Право
            cut_wall_opening(1);  // Верх
            cut_wall_opening(2);  // Лево
        }
        attach_sleeve(0);  // Право
        attach_sleeve(1);  // Верх
        attach_sleeve(2);  // Лево
    }
}

// Информация для проверки
echo("=== Размеры Т-образного паза ===");
echo("Центральный квадрат (внутри):", center_size, "x", center_size, "мм");
echo("Длина рукава:", sleeve_length, "мм");
