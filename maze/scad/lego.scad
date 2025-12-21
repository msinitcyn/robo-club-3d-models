include <common.scad>

LEGO_STUD_DIAMETER = 5.0;
LEGO_STUD_HEIGHT = 1.8;
LEGO_UNIT = 8;
LEGO_HOLE_DIAMETER = 5.0;

LEGO_BASE_WIDTH = 8.0;
LEGO_BASE_CENTER_SIZE = LEGO_UNIT;
LEGO_SLEEVE_STUDS = 7;
LEGO_SLEEVE_LENGTH = LEGO_SLEEVE_STUDS * LEGO_UNIT;
LEGO_TOTAL_WIDTH = LEGO_BASE_WIDTH;

module draw_lego_stud() {
    cylinder(h=LEGO_STUD_HEIGHT, d=LEGO_STUD_DIAMETER, $fn=30);
}

module draw_lego_hole() {
    cylinder(h=LEGO_STUD_HEIGHT + 0.1, d=LEGO_HOLE_DIAMETER, $fn=30);
}

module draw_lego_niche() {
    translate([-LEGO_HOLE_DIAMETER/2, -LEGO_HOLE_DIAMETER/2, 0])
        cube([LEGO_HOLE_DIAMETER, LEGO_HOLE_DIAMETER, LEGO_STUD_HEIGHT+0.1]);
}

module place_center_lego_stud() {
    translate([0, 0, BASE_THICKNESS])
        draw_lego_stud();
}

module place_sleeve_lego_studs(length, base_width = LEGO_BASE_CENTER_SIZE) {
    offset = base_width / 2;
    first_pos = LEGO_UNIT - offset;

    for (i = [0:20]) {
        pos = first_pos + i * LEGO_UNIT;
        if (pos + LEGO_STUD_DIAMETER/2 <= length) {
            translate([pos, 0, BASE_THICKNESS])
                draw_lego_stud();
        }
    }
}

module place_sleeve_lego_holes(length, base_width = LEGO_BASE_CENTER_SIZE) {
    offset = base_width / 2;
    first_pos = LEGO_UNIT - offset;

    for (i = [0:20]) {
        pos = first_pos + i * LEGO_UNIT;
        if (pos + LEGO_HOLE_DIAMETER/2 <= length) {
            translate([pos, 0, -0.05])
                draw_lego_hole();
        }
    }
}

module place_sleeve_lego_niche(length, base_width = LEGO_BASE_CENTER_SIZE) {
    offset = base_width / 2;
    first_pos = LEGO_UNIT - offset;

    for (i = [0:20]) {
        pos = first_pos + i * LEGO_UNIT;
        if (pos + LEGO_HOLE_DIAMETER/2 <= length) {
            translate([pos, 0, -0.05])
                draw_lego_niche();
        }
    }
}