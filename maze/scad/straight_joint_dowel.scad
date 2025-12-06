use <common.scad>

// Прямой соединитель со штырями (2 выхода напротив)
// Выходы: право (0) и лево (2)

union() {
    // Основание центра со штырем
    draw_center_base(with_dowel = true);

    // Стенки центра на двух сторонах без выходов
    place_center_wall(1);  // перед - закрыто
    place_center_wall(3);  // назад - закрыто

    // Рукава на противоположных сторонах (со штырями)
    place_sleeve(0, with_dowel = true);  // право
    place_sleeve(2, with_dowel = true);  // лево
}
