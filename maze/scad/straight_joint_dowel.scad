use <common.scad>

union() {
    draw_center_base(with_dowel = true);
    place_center_wall(1);
    place_center_wall(3);
    place_sleeve(0, with_dowel = true);
    place_sleeve(2, with_dowel = true);
}
