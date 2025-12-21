include <lego.scad>
use <version.scad>

difference() {
    union() {
        place_sleeve_base(LEGO_SLEEVE_LENGTH, TOTAL_WIDTH, LEGO_STUD_HEIGHT);
        place_sleeve_walls(LEGO_SLEEVE_LENGTH, "flexible", LEGO_STUD_HEIGHT);
    }

    place_sleeve_lego_holes(LEGO_SLEEVE_LENGTH);
    print_version_sleeve();
}
