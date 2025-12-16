use <common.scad>
use <version.scad>

difference() {
    union() {
        draw_center_base(with_dowel = true);
        place_sleeve(0, with_dowel = true, wall_type = "flexible");
        place_sleeve(1, with_dowel = true, wall_type = "flexible");
        place_sleeve(2, with_dowel = true, wall_type = "flexible");
        place_sleeve(3, with_dowel = true, wall_type = "flexible");
    }

    print_version();
}
