include <common.scad>
use <version.scad>

difference() {
    union() {
        place_center_base(with_dowel = true);
        place_center_wall(1);
        place_center_wall(3);

        orient_sleeve(0) {
            union() {
                place_sleeve_base(SLEEVE_LENGTH, TOTAL_WIDTH);
                place_sleeve_walls(SLEEVE_LENGTH);
                place_sleeve_dowels(SLEEVE_LENGTH);
            }
        }

        orient_sleeve(2) {
            union() {
                place_sleeve_base(SLEEVE_LENGTH, TOTAL_WIDTH);
                place_sleeve_walls(SLEEVE_LENGTH);
                place_sleeve_dowels(SLEEVE_LENGTH);
            }
        }
    }

    print_version();
}
