use <lego.scad>
use <version.scad>

difference() {
    union() {
        draw_center_with_studs(with_dowel = true);
        place_sleeve_with_studs(0, with_dowel = true);
        place_sleeve_with_studs(1, with_dowel = true);
    }

    print_version();
}
