include <common.scad>

LEGO_STUD_DIAMETER = 5.0;
LEGO_STUD_HEIGHT = 1.8;
LEGO_UNIT = 8;
LEGO_HOLE_DIAMETER = 5.0;
LEGO_NICHE_DEPTH = 1.8;
LEGO_NICHE_BASE_THICKNESS = LEGO_NICHE_DEPTH;
LEGO_NICHE_WIDTH = 4.8;
LEGO_NICHE_WALL_THICKNESS = 1.2;
LEGO_INTER_CYLINDER_DIAMETER = LEGO_UNIT - LEGO_STUD_DIAMETER;

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


module draw_sleeve_base_with_niche() {
    first_stud_candidate = LEGO_UNIT - (CENTER_SIZE/2 % LEGO_UNIT);
    first_stud = first_stud_candidate < LEGO_STUD_DIAMETER/2
                 ? first_stud_candidate + LEGO_UNIT
                 : first_stud_candidate;

    max_stud_position = SLEEVE_LENGTH - LEGO_STUD_DIAMETER/2;
    num_studs = floor((max_stud_position - first_stud) / LEGO_UNIT) + 1;

    niche_x_start = first_stud - LEGO_HOLE_DIAMETER/2 + 0.1;
    niche_x_end = first_stud + (num_studs - 1) * LEGO_UNIT + LEGO_HOLE_DIAMETER/2 - 0.1;
    niche_length = niche_x_end - niche_x_start;

    union() {
        difference() {
            translate([0, -TOTAL_WIDTH/2, 0])
                cube([SLEEVE_LENGTH, TOTAL_WIDTH, LEGO_NICHE_BASE_THICKNESS]);

            translate([niche_x_start, -LEGO_NICHE_WIDTH/2, 0])
                cube([niche_length, LEGO_NICHE_WIDTH, LEGO_NICHE_DEPTH + 0.1]);
        }

        for (i = [0:num_studs-2]) {
            translate([first_stud + i * LEGO_UNIT + LEGO_UNIT/2, 0, 0])
                cylinder(h=LEGO_NICHE_DEPTH, d=LEGO_INTER_CYLINDER_DIAMETER, $fn=30);
            translate([first_stud + i * LEGO_UNIT + LEGO_UNIT/2 - LEGO_NICHE_WALL_THICKNESS/2, -LEGO_NICHE_WIDTH/2, 0])
                cube([LEGO_NICHE_WALL_THICKNESS, LEGO_NICHE_WIDTH, LEGO_NICHE_DEPTH]);
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


module draw_sleeve_with_niche() {
    union() {
        draw_sleeve_base_with_niche();
        draw_sleeve_wall(LEFT, "regular", LEGO_NICHE_BASE_THICKNESS);
        draw_sleeve_wall(RIGHT, "regular", LEGO_NICHE_BASE_THICKNESS);
    }
}

module draw_sleeve_with_niche_flexible() {
    union() {
        draw_sleeve_base_with_niche();
        draw_sleeve_wall(LEFT, "flexible", LEGO_NICHE_BASE_THICKNESS);
        draw_sleeve_wall(RIGHT, "flexible", LEGO_NICHE_BASE_THICKNESS);
    }
}

