use <lego.scad>
use <version.scad>

difference() {
    union() {
        draw_center_with_studs_double();
        place_sleeve_with_studs_double(0);
        place_sleeve_with_studs_double(1);
    }

    print_version(top_z=3.8);
}
