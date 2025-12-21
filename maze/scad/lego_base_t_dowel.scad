include <lego.scad>
use <version.scad>

difference() {
    union() {
        place_center_base(LEGO_TOTAL_WIDTH);
        place_center_lego_stud();
        place_center_dowel();

        orient_sleeve(0, LEGO_BASE_CENTER_SIZE) {
            union() {
                place_sleeve_base(LEGO_SLEEVE_LENGTH, LEGO_TOTAL_WIDTH);
                place_sleeve_lego_studs(LEGO_SLEEVE_LENGTH);
                place_sleeve_dowels(LEGO_SLEEVE_LENGTH, LEGO_TOTAL_WIDTH);
            }
        }

        orient_sleeve(1, LEGO_BASE_CENTER_SIZE) {
            union() {
                place_sleeve_base(LEGO_SLEEVE_LENGTH, LEGO_TOTAL_WIDTH);
                place_sleeve_lego_studs(LEGO_SLEEVE_LENGTH);
                place_sleeve_dowels(LEGO_SLEEVE_LENGTH, LEGO_TOTAL_WIDTH);
            }
        }

        orient_sleeve(2, LEGO_BASE_CENTER_SIZE) {
            union() {
                place_sleeve_base(LEGO_SLEEVE_LENGTH, LEGO_TOTAL_WIDTH);
                place_sleeve_lego_studs(LEGO_SLEEVE_LENGTH);
                place_sleeve_dowels(LEGO_SLEEVE_LENGTH, LEGO_TOTAL_WIDTH);
            }
        }
    }

    print_version(top_z=3.8);
}
