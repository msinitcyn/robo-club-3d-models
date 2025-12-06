use <common.scad>

// Заглушка (1 выход)
// Выход: право (0)

union() {
    // Основание центра
    draw_center_base(with_dowel = false);

    // Стенки центра на трех сторонах без выходов
    place_center_wall(1);  // перед - закрыто
    place_center_wall(2);  // лево - закрыто
    place_center_wall(3);  // назад - закрыто

    // Рукав на одной стороне
    place_sleeve(0, with_dowel = false);  // право
}
