use <common.scad>
use <version.scad>

difference() {
    union() {
        draw_center_base(with_dowel = false);
        place_sleeve(0, with_dowel = false);
        place_sleeve(1, with_dowel = false);
        place_sleeve(2, with_dowel = false);
        place_sleeve(3, with_dowel = false);
    }

    print_version();
}
