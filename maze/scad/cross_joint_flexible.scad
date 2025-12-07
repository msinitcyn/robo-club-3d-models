use <common.scad>

// Крестовина с гибкими стенками (4 выхода)
// Выходы: право (0), перед (1), лево (2), назад (3)
// Гибкие стенки для картона

union() {
    // Основание центра
    draw_center_base(with_dowel = false);

    // Без стенок центра - все стороны открыты

    // Рукава на всех четырех сторонах с гибкими стенками
    place_sleeve(0, with_dowel = false, wall_type = "flexible");  // право
    place_sleeve(1, with_dowel = false, wall_type = "flexible");  // перед
    place_sleeve(2, with_dowel = false, wall_type = "flexible");  // лево
    place_sleeve(3, with_dowel = false, wall_type = "flexible");  // назад
}
