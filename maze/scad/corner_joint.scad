use <common.scad>

union() {
    draw_center_base(with_dowel = false);
    place_center_wall(2);
    place_center_wall(3);
    place_sleeve(0, with_dowel = false);
    place_sleeve(1, with_dowel = false);
}
