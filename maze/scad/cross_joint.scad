use <common.scad>

// Крестовина (4 выхода)
// Выходы: право (0), перед (1), лево (2), назад (3)

union() {
    // Основание центра
    draw_center_base(with_dowel = false);

    // Без стенок центра - все стороны открыты

    // Рукава на всех четырех сторонах
    place_sleeve(0, with_dowel = false);  // право
    place_sleeve(1, with_dowel = false);  // перед
    place_sleeve(2, with_dowel = false);  // лево
    place_sleeve(3, with_dowel = false);  // назад
}
