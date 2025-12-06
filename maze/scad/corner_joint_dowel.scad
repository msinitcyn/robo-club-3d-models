use <common.scad>

// Угловой соединитель со штырями (L-образный)
// Выходы: право (0) и перед (1)

union() {
    // Основание центра со штырем
    draw_center_base(with_dowel = true);

    // Стенки центра на двух сторонах без выходов
    place_center_wall(2);  // лево - закрыто
    place_center_wall(3);  // назад - закрыто

    // Рукава на сторонах с выходами (со штырями)
    place_sleeve(0, with_dowel = true);  // право
    place_sleeve(1, with_dowel = true);  // перед
}
