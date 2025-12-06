use <common.scad>

// T-образный соединитель со штырями (3 выхода)
// Выходы: право (0), перед (1), лево (2)

union() {
    // Основание центра со штырем
    draw_center_base(with_dowel = true);

    // Стенка центра на одной стороне без выхода
    place_center_wall(3);  // назад - закрыто

    // Рукава на трех сторонах (со штырями)
    place_sleeve(0, with_dowel = true);  // право
    place_sleeve(1, with_dowel = true);  // перед
    place_sleeve(2, with_dowel = true);  // лево
}
