include <common.scad>
use <version.scad>

difference() {
    union() {
        place_center_base();
        place_center_wall(1, wall_type = "flexible");
        place_center_wall(2, wall_type = "flexible");
        place_center_wall(3, wall_type = "flexible");

        orient_sleeve(0) {
            union() {
                place_sleeve_base(SLEEVE_LENGTH, TOTAL_WIDTH);
                place_sleeve_walls(SLEEVE_LENGTH, "flexible");
            }
        }
    }

    print_version();
}
