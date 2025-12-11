include <common.scad>

LEGO_STUD_DIAMETER = 4.8;
LEGO_STUD_HEIGHT = 1.8;
LEGO_UNIT = 8;
LEGO_HOLE_DIAMETER = 5.0;
LEGO_TUBE_OUTER_DIAMETER = 6.5;
LEGO_TUBE_INNER_DIAMETER = 5.0;
LEGO_TUBE_HEIGHT = LEGO_STUD_HEIGHT - 0.2;

module draw_lego_stud() {
    cylinder(h=LEGO_STUD_HEIGHT, d=LEGO_STUD_DIAMETER, $fn=30);
}

module draw_lego_hole() {
    cylinder(h=LEGO_STUD_HEIGHT + 0.1, d=LEGO_HOLE_DIAMETER, $fn=30);
}

module draw_center_with_studs(with_dowel = false) {
    union() {
        draw_center_base(with_dowel);
        translate([0, 0, BASE_THICKNESS])
            draw_lego_stud();
    }
}

module draw_sleeve_with_studs(with_dowel = false) {
    first_stud_candidate = LEGO_UNIT - (CENTER_SIZE/2 % LEGO_UNIT);
    first_stud = first_stud_candidate < LEGO_STUD_DIAMETER/2
                 ? first_stud_candidate + LEGO_UNIT
                 : first_stud_candidate;

    max_stud_position = SLEEVE_LENGTH - LEGO_STUD_DIAMETER/2;
    num_studs = floor((max_stud_position - first_stud) / LEGO_UNIT) + 1;

    union() {
        draw_sleeve_base(with_dowel);
        for (i = [0:num_studs-1]) {
            translate([first_stud + i * LEGO_UNIT, 0, BASE_THICKNESS])
                draw_lego_stud();
        }
    }
}

module place_sleeve_with_studs(side, with_dowel = false) {
    if (side == 0) {
        translate([CENTER_SIZE/2, 0, 0])
            draw_sleeve_with_studs(with_dowel);
    } else if (side == 1) {
        rotate([0, 0, 90])
            translate([CENTER_SIZE/2, 0, 0])
                draw_sleeve_with_studs(with_dowel);
    } else if (side == 2) {
        rotate([0, 0, 180])
            translate([CENTER_SIZE/2, 0, 0])
                draw_sleeve_with_studs(with_dowel);
    } else if (side == 3) {
        rotate([0, 0, 270])
            translate([CENTER_SIZE/2, 0, 0])
                draw_sleeve_with_studs(with_dowel);
    }
}

module draw_sleeve_base_with_simple_holes() {
    first_stud_candidate = LEGO_UNIT - (CENTER_SIZE/2 % LEGO_UNIT);
    first_stud = first_stud_candidate < LEGO_STUD_DIAMETER/2
                 ? first_stud_candidate + LEGO_UNIT
                 : first_stud_candidate;

    max_stud_position = SLEEVE_LENGTH - LEGO_STUD_DIAMETER/2;
    num_studs = floor((max_stud_position - first_stud) / LEGO_UNIT) + 1;

    difference() {
        translate([0, -TOTAL_WIDTH/2, 0])
            cube([SLEEVE_LENGTH, TOTAL_WIDTH, LEGO_STUD_HEIGHT]);

        for (i = [0:num_studs-1]) {
            translate([first_stud + i * LEGO_UNIT, 0, -0.05])
                draw_lego_hole();
        }
    }
}

module draw_sleeve_base_with_tubes() {
    first_stud_candidate = LEGO_UNIT - (CENTER_SIZE/2 % LEGO_UNIT);
    first_stud = first_stud_candidate < LEGO_STUD_DIAMETER/2
                 ? first_stud_candidate + LEGO_UNIT
                 : first_stud_candidate;

    max_stud_position = SLEEVE_LENGTH - LEGO_STUD_DIAMETER/2;
    num_studs = floor((max_stud_position - first_stud) / LEGO_UNIT) + 1;

    difference() {
        union() {
            translate([0, -TOTAL_WIDTH/2, 0])
                cube([SLEEVE_LENGTH, TOTAL_WIDTH, LEGO_STUD_HEIGHT]);

            for (i = [0:num_studs-1]) {
                translate([first_stud + i * LEGO_UNIT, 0, 0])
                    cylinder(h=LEGO_TUBE_HEIGHT, d=LEGO_TUBE_OUTER_DIAMETER, $fn=30);
            }
        }

        for (i = [0:num_studs-1]) {
            translate([first_stud + i * LEGO_UNIT, 0, -0.05])
                cylinder(h=LEGO_STUD_HEIGHT + 0.1, d=LEGO_TUBE_INNER_DIAMETER, $fn=30);
        }
    }
}

module draw_sleeve_with_simple_holes() {
    union() {
        draw_sleeve_base_with_simple_holes();
        draw_sleeve_wall(LEFT, "regular", LEGO_STUD_HEIGHT);
        draw_sleeve_wall(RIGHT, "regular", LEGO_STUD_HEIGHT);
    }
}

module draw_sleeve_with_simple_holes_flexible() {
    union() {
        draw_sleeve_base_with_simple_holes();
        draw_sleeve_wall(LEFT, "flexible", LEGO_STUD_HEIGHT);
        draw_sleeve_wall(RIGHT, "flexible", LEGO_STUD_HEIGHT);
    }
}

module draw_sleeve_with_tubes() {
    union() {
        draw_sleeve_base_with_tubes();
        draw_sleeve_wall(LEFT, "regular", LEGO_STUD_HEIGHT);
        draw_sleeve_wall(RIGHT, "regular", LEGO_STUD_HEIGHT);
    }
}

module draw_sleeve_with_tubes_flexible() {
    union() {
        draw_sleeve_base_with_tubes();
        draw_sleeve_wall(LEFT, "flexible", LEGO_STUD_HEIGHT);
        draw_sleeve_wall(RIGHT, "flexible", LEGO_STUD_HEIGHT);
    }
}
