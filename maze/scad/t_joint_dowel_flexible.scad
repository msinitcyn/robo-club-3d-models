use <common.scad>

// T-образный соединитель со штырями и гибкими стенками (3 выхода)
// Выходы: право (0), перед (1), лево (2)
// Гибкие стенки для картона

union() {
    // Основание центра со штырем
    draw_center_base(with_dowel = true);

    // Гибкая стенка центра на одной стороне без выхода
    place_center_wall(3, "flexible");  // назад - закрыто гибкой стенкой

    // Рукава на трех сторонах с гибкими стенками (со штырями)
    place_sleeve(0, with_dowel = true, wall_type = "flexible");  // право
    place_sleeve(1, with_dowel = true, wall_type = "flexible");  // перед
    place_sleeve(2, with_dowel = true, wall_type = "flexible");  // лево
}
