// Угловой паз с шипами для вставки в основание (УДЛИНЕННАЯ ВЕРСИЯ)
// Модульная конструкция: центральное основание + 2 рукава (угол) + шипы

// Параметры (все размеры в мм)
center_size = 10;     // Размер центрального квадрата (внутри)
sleeve_length = 50;   // Длина рукава (удлиненная)
groove_width = 10;    // Ширина паза (внутри) - для фанеры 9.3мм
wall_height = 10;     // Высота стенок
wall_thickness = 2;   // Толщина стенок

// Параметры шипов
dowel_diameter = 5;   // Диаметр шипа
dowel_depth = 9;      // Глубина шипа (высота)
dowel_spacing = 40;   // Шаг между шипами (удлиненный)

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
    }
}

// 3. Метод: добавить шип в позиции (x, y)
module add_dowel(x, y) {
    translate([x, y, -dowel_depth])
        cylinder(h=dowel_depth, d=dowel_diameter, $fn=30);
}

// Собираем L-образную конструкцию с шипами
translate([-center_total/2, -center_total/2, 0]) {
    union() {
        difference() {
            draw_base();
            cut_wall_opening(0);  // Право
            cut_wall_opening(1);  // Верх
        }
        attach_sleeve(0);  // Право
        attach_sleeve(1);  // Верх

        // Шипы: центр + 2 направления
        add_dowel(center_total/2, center_total/2);                    // Центр (угол)
        add_dowel(center_total/2 + dowel_spacing, center_total/2);   // Право
        add_dowel(center_total/2, center_total/2 + dowel_spacing);   // Верх
    }
}

// Информация для проверки
echo("=== Размеры углового паза с шипами (LONG) ===");
echo("Длина рукава:", sleeve_length, "мм");
echo("Количество шипов: 3 (угол + 2 направления)");
echo("Шаг между шипами:", dowel_spacing, "мм");
