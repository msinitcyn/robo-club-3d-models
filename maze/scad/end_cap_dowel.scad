use <common.scad>

// Заглушка со штырями (1 выход)
// Выход: право (0)

union() {
    // Основание центра со штырем
    draw_center_base(with_dowel = true);

    // Стенки центра на трех сторонах без выходов
    place_center_wall(1);  // перед - закрыто
    place_center_wall(2);  // лево - закрыто
    place_center_wall(3);  // назад - закрыто

    // Рукав на одной стороне (со штырем)
    place_sleeve(0, with_dowel = true);  // право
}
