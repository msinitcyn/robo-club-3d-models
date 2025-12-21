include <lego.scad>
use <version.scad>

difference() {
    union() {
        place_center_base(LEGO_TOTAL_WIDTH);
        place_center_lego_stud();

        orient_sleeve(0, LEGO_BASE_CENTER_SIZE) {
            union() {
                place_sleeve_base(LEGO_SLEEVE_LENGTH, LEGO_TOTAL_WIDTH);
                place_sleeve_lego_studs(LEGO_SLEEVE_LENGTH);
            }
        }

        orient_sleeve(2, LEGO_BASE_CENTER_SIZE) {
            union() {
                place_sleeve_base(LEGO_SLEEVE_LENGTH, LEGO_TOTAL_WIDTH);
                place_sleeve_lego_studs(LEGO_SLEEVE_LENGTH);
            }
        }

        mirror([0, 0, 1])
            translate([0, 0, -LEGO_STUD_HEIGHT]) {
                place_center_base(LEGO_TOTAL_WIDTH);
                place_center_lego_stud();

                orient_sleeve(0, LEGO_BASE_CENTER_SIZE) {
                    union() {
                        place_sleeve_base(LEGO_SLEEVE_LENGTH, LEGO_TOTAL_WIDTH);
                        place_sleeve_lego_studs(LEGO_SLEEVE_LENGTH);
                    }
                }

                orient_sleeve(2, LEGO_BASE_CENTER_SIZE) {
                    union() {
                        place_sleeve_base(LEGO_SLEEVE_LENGTH, LEGO_TOTAL_WIDTH);
                        place_sleeve_lego_studs(LEGO_SLEEVE_LENGTH);
                    }
                }
            }
    }

    print_version(top_z=3.8);
}
