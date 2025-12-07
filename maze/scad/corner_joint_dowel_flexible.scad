use <common.scad>

// Угловой соединитель со штырями и гибкими стенками (L-образный)
// Выходы: право (0) и перед (1)
// Гибкие стенки для картона

union() {
    // Основание центра со штырем
    draw_center_base(with_dowel = true);

    // Гибкие стенки центра на двух сторонах без выходов
    place_center_wall(2, "flexible");  // лево - закрыто гибкой стенкой
    place_center_wall(3, "flexible");  // назад - закрыто гибкой стенкой

    // Рукава на сторонах с выходами с гибкими стенками (со штырями)
    place_sleeve(0, with_dowel = true, wall_type = "flexible");  // право
    place_sleeve(1, with_dowel = true, wall_type = "flexible");  // перед
}
