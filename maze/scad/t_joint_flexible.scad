use <common.scad>

union() {
    draw_center_base(with_dowel = false);
    place_center_wall(3, "flexible");
    place_sleeve(0, with_dowel = false, wall_type = "flexible");
    place_sleeve(1, with_dowel = false, wall_type = "flexible");
    place_sleeve(2, with_dowel = false, wall_type = "flexible");
}
