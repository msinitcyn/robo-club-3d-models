use <common.scad>

// Заглушка со штырями и гибкими стенками (1 выход)
// Выход: право (0)
// Гибкие стенки для картона

union() {
    // Основание центра со штырем
    draw_center_base(with_dowel = true);

    // Гибкие стенки центра на трех сторонах без выходов
    place_center_wall(1, "flexible");  // перед - закрыто гибкой стенкой
    place_center_wall(2, "flexible");  // лево - закрыто гибкой стенкой
    place_center_wall(3, "flexible");  // назад - закрыто гибкой стенкой

    // Рукав на одной стороне с гибкими стенками (со штырем)
    place_sleeve(0, with_dowel = true, wall_type = "flexible");  // право
}
