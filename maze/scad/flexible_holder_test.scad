// Тестовая модель гибкого держателя для картона
// Паз с изогнутыми стенками (изгиб по параболе)

// Параметры
length = 50;           // длина держателя
cardboard_thickness = 2; // толщина картона
groove_top = 9;        // ширина паза вверху
groove_bottom = cardboard_thickness; // ширина паза внизу = толщина картона
wall_height = 20;      // высота стенки над основанием
wall_thickness = 2;    // толщина стенки
base_width = 9;        // ширина основания
base_thickness = 2;    // толщина основания

// Параметр изгиба (чем больше, тем более выпуклая парабола)
curve_power = 2;       // 2 = парабола, 3 = кубическая, 1 = линейная

// Количество точек для построения кривой
curve_points = 20;

// Функция для расчета изгиба стенки
// z - высота от 0 до wall_height
// возвращает расстояние от центра (внизу = groove_bottom/2, вверху = groove_top/2)
function wall_curve(z) =
    groove_bottom/2 + (groove_top/2 - groove_bottom/2) * pow(z/wall_height, curve_power);

// Модуль для создания профиля одной изогнутой стенки
module curved_wall_profile(side) {
    // side: -1 для левой стенки, +1 для правой стенки
    points_inner = [for (i = [0:curve_points])
        [wall_curve(i * wall_height / curve_points) * side,
         base_thickness + i * wall_height / curve_points]
    ];

    points_outer = [for (i = [0:curve_points])
        [(wall_curve(i * wall_height / curve_points) + wall_thickness * side) * side,
         base_thickness + i * wall_height / curve_points]
    ];

    // Создаем замкнутый контур стенки
    all_points = concat(
        [[points_inner[0][0], 0]],  // начало у основания
        points_inner,
        [points_outer[len(points_outer)-1]],  // верхняя точка
        [for (i = [len(points_outer)-1:-1:0]) points_outer[i]],
        [[points_outer[0][0], 0]]  // замыкание
    );

    polygon(all_points);
}

// Основная модель
union() {
    // Основание - параллелепипед
    translate([-length/2, -base_width/2, 0])
        cube([length, base_width, base_thickness]);

    // Одна изогнутая стенка
    // Наклоняем к центру (вычисляем угол по геометрии)
    tilt_angle = atan((groove_top/2 - groove_bottom/2) / wall_height) + 5;

    translate([-length/2, -base_width/2, 0])
        rotate([-tilt_angle, 0, 0])
            rotate([90, 0, 90])
                linear_extrude(height = length)
                    curved_wall_profile(-1);
}

// Информация для печати
echo("=== Параметры держателя ===");
echo("Длина:", length, "мм");
echo("Ширина паза вверху:", groove_top, "мм");
echo("Ширина паза внизу:", groove_bottom, "мм (= толщина картона)");
echo("Высота стенки:", wall_height, "мм");
echo("Толщина стенки:", wall_thickness, "мм");
echo("Параметр кривизны:", curve_power, "(2=парабола)");
