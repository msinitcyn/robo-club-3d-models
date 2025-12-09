use <common.scad>

union() {
    draw_center_base(with_dowel = true);
    place_center_wall(1, "flexible");
    place_center_wall(3, "flexible");
    place_sleeve(0, with_dowel = true, wall_type = "flexible");
    place_sleeve(2, with_dowel = true, wall_type = "flexible");
}
