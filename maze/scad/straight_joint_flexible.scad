use <common.scad>

// Прямой соединитель с гибкими стенками (2 выхода напротив)
// Выходы: право (0) и лево (2)
// Гибкие стенки для картона

union() {
    // Основание центра
    draw_center_base(with_dowel = false);

    // Гибкие стенки центра на двух сторонах без выходов
    place_center_wall(1, "flexible");  // перед - закрыто гибкой стенкой
    place_center_wall(3, "flexible");  // назад - закрыто гибкой стенкой

    // Рукава на противоположных сторонах с гибкими стенками
    place_sleeve(0, with_dowel = false, wall_type = "flexible");  // право
    place_sleeve(2, with_dowel = false, wall_type = "flexible");  // лево
}
