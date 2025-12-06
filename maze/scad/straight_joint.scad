use <common.scad>

// Прямой соединитель (2 выхода напротив)
// Выходы: право (0) и лево (2)

union() {
    // Основание центра
    draw_center_base(with_dowel = false);

    // Стенки центра на двух сторонах без выходов
    place_center_wall(1);  // перед - закрыто
    place_center_wall(3);  // назад - закрыто

    // Рукава на противоположных сторонах
    place_sleeve(0, with_dowel = false);  // право
    place_sleeve(2, with_dowel = false);  // лево
}
