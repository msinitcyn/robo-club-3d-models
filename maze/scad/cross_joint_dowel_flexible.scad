include <common.scad>
use <version.scad>

difference() {
    union() {
        place_center_base(with_dowel = true);

        orient_sleeve(0) {
            union() {
                place_sleeve_base(SLEEVE_LENGTH, TOTAL_WIDTH);
                place_sleeve_walls(SLEEVE_LENGTH, "flexible");
                place_sleeve_dowels(SLEEVE_LENGTH);
            }
        }

        orient_sleeve(1) {
            union() {
                place_sleeve_base(SLEEVE_LENGTH, TOTAL_WIDTH);
                place_sleeve_walls(SLEEVE_LENGTH, "flexible");
                place_sleeve_dowels(SLEEVE_LENGTH);
            }
        }

        orient_sleeve(2) {
            union() {
                place_sleeve_base(SLEEVE_LENGTH, TOTAL_WIDTH);
                place_sleeve_walls(SLEEVE_LENGTH, "flexible");
                place_sleeve_dowels(SLEEVE_LENGTH);
            }
        }

        orient_sleeve(3) {
            union() {
                place_sleeve_base(SLEEVE_LENGTH, TOTAL_WIDTH);
                place_sleeve_walls(SLEEVE_LENGTH, "flexible");
                place_sleeve_dowels(SLEEVE_LENGTH);
            }
        }
    }

    print_version();
}
