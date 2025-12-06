use <common.scad>

// Угловой соединитель (L-образный)
// Выходы: право (0) и перед (1)

union() {
    // Основание центра
    draw_center_base(with_dowel = false);

    // Стенки центра на двух сторонах без выходов
    place_center_wall(2);  // лево - закрыто
    place_center_wall(3);  // назад - закрыто

    // Рукава на сторонах с выходами
    place_sleeve(0, with_dowel = false);  // право
    place_sleeve(1, with_dowel = false);  // перед
}
