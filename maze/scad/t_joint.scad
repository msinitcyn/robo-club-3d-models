use <common.scad>

// T-образный соединитель (3 выхода)
// Выходы: право (0), перед (1), лево (2)

union() {
    // Основание центра
    draw_center_base(with_dowel = false);

    // Стенка центра на одной стороне без выхода
    place_center_wall(3);  // назад - закрыто

    // Рукава на трех сторонах
    place_sleeve(0, with_dowel = false);  // право
    place_sleeve(1, with_dowel = false);  // перед
    place_sleeve(2, with_dowel = false);  // лево
}
