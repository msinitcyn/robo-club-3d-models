// Крестообразный паз для соединения 4х стенок
// Модульная конструкция: центральное основание + 4 рукава

// Параметры (все размеры в мм)
center_size = 10;     // Размер центрального квадрата (внутри)
sleeve_length = 30;   // Длина рукава
groove_width = 10;    // Ширина паза (внутри) - для фанеры 9.3мм
wall_height = 10;     // Высота стенок
wall_thickness = 2;   // Толщина стенок

// Вычисляемые размеры
total_width = groove_width + 2 * wall_thickness;  // 14 мм
center_total = center_size + 2 * wall_thickness;  // 14 мм (размер центра со стенками)

// 1. Метод: нарисовать основание (центральный квадрат)
module draw_base() {
    difference() {
        // Внешний куб
        cube([center_total, center_total, wall_height]);

        // Вычитаем внутренний паз (сквозной)
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([center_size, center_size, wall_height]);
    }
}

// Модуль для создания одного рукава (паза)
module single_sleeve() {
    difference() {
        // Внешний блок
        cube([sleeve_length, total_width, wall_height]);

        // Вычитаем внутренний паз
        translate([0, wall_thickness, wall_thickness])
            cube([sleeve_length, groove_width, wall_height]);
    }
}

// Метод: вырезать отверстие в стенке основания
// side: 0=право, 1=верх, 2=лево, 3=низ
module cut_wall_opening(side) {
    if (side == 0) {
        // Право - вырезаем правую стенку
        translate([center_total - wall_thickness - 0.1, wall_thickness, wall_thickness])
            cube([wall_thickness + 0.2, groove_width, wall_height]);
    } else if (side == 1) {
        // Верх - вырезаем верхнюю стенку
        translate([wall_thickness, center_total - wall_thickness - 0.1, wall_thickness])
            cube([groove_width, wall_thickness + 0.2, wall_height]);
    } else if (side == 2) {
        // Лево - вырезаем левую стенку
        translate([-0.1, wall_thickness, wall_thickness])
            cube([wall_thickness + 0.2, groove_width, wall_height]);
    } else if (side == 3) {
        // Низ - вырезаем нижнюю стенку
        translate([wall_thickness, -0.1, wall_thickness])
            cube([groove_width, wall_thickness + 0.2, wall_height]);
    }
}

// 2. Метод: прицепить рукав к основанию
// side: 0=право, 1=верх, 2=лево, 3=низ
module attach_sleeve(side) {
    if (side == 0) {
        // Право (+X)
        translate([center_total, center_total/2 - total_width/2, 0])
            single_sleeve();
    } else if (side == 1) {
        // Верх (+Y)
        translate([center_total/2 + total_width/2, center_total, 0])
            rotate([0, 0, 90])
                single_sleeve();
    } else if (side == 2) {
        // Лево (-X)
        translate([-sleeve_length, center_total/2 - total_width/2, 0])
            single_sleeve();
    } else if (side == 3) {
        // Низ (-Y)
        translate([center_total/2 + total_width/2, -sleeve_length, 0])
            rotate([0, 0, 90])
                single_sleeve();
    }
}

// Собираем крестообразную конструкцию
// Центр основания в начале координат
translate([-center_total/2, -center_total/2, 0]) {
    union() {
        // Центральное основание с вырезами для рукавов
        difference() {
            draw_base();

            // Вырезаем отверстия в стенках для всех рукавов
            cut_wall_opening(0);  // Право
            cut_wall_opening(1);  // Верх
            cut_wall_opening(2);  // Лево
            cut_wall_opening(3);  // Низ
        }

        // Прицепляем 4 рукава
        attach_sleeve(0);  // Право
        attach_sleeve(1);  // Верх
        attach_sleeve(2);  // Лево
        attach_sleeve(3);  // Низ
    }
}

// Информация для проверки
echo("=== Размеры крестообразного паза ===");
echo("Центральный квадрат (внутри):", center_size, "x", center_size, "мм");
echo("Центр со стенками:", center_total, "x", center_total, "мм");
echo("Длина рукава:", sleeve_length, "мм");
echo("Ширина паза (внутри):", groove_width, "мм");
echo("Общая ширина рукава:", total_width, "мм");
echo("Высота стенок:", wall_height, "мм");
echo("Толщина стенок:", wall_thickness, "мм");
