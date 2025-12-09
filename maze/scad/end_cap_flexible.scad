use <common.scad>

union() {
    draw_center_base(with_dowel = false);
    place_center_wall(1, "flexible");
    place_center_wall(2, "flexible");
    place_center_wall(3, "flexible");
    place_sleeve(0, with_dowel = false, wall_type = "flexible");
}
