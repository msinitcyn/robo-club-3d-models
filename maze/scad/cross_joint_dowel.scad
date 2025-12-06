use <common.scad>

// Крестовина со штырями (4 выхода)
// Выходы: право (0), перед (1), лево (2), назад (3)

union() {
    // Основание центра со штырем
    draw_center_base(with_dowel = true);

    // Без стенок центра - все стороны открыты

    // Рукава на всех четырех сторонах (со штырями)
    place_sleeve(0, with_dowel = true);  // право
    place_sleeve(1, with_dowel = true);  // перед
    place_sleeve(2, with_dowel = true);  // лево
    place_sleeve(3, with_dowel = true);  // назад
}
