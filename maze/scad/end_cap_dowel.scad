use <common.scad>
use <version.scad>

difference() {
    union() {
        draw_center_base(with_dowel = true);
        place_center_wall(1);
        place_center_wall(2);
        place_center_wall(3);
        place_sleeve(0, with_dowel = true);
    }

    print_version();
}
