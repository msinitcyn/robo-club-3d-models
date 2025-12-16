CENTER_SIZE = 9;
SLEEVE_LENGTH = 55;
SLEEVE_REACH = SLEEVE_LENGTH + CENTER_SIZE/2;
GROOVE_WIDTH = 9;
WALL_HEIGHT = 10;
WALL_THICKNESS = 2;
BASE_THICKNESS = 2;
TOTAL_WIDTH = GROOVE_WIDTH + 2 * WALL_THICKNESS;
DOWEL_DIAMETER = 4.5;
DOWEL_DEPTH = 3;
CARDBOARD_THICKNESS = 2;
GROOVE_BOTTOM = CARDBOARD_THICKNESS;
CURVE_POWER = 2;
CURVE_POINTS = 20;
TILT_ANGLE_EXTRA = 5;
FLEXIBLE_WALL_HEIGHT = WALL_HEIGHT * 2;

LEFT = 3;
RIGHT = 1;

function wall_curve(z, wall_height) =
    GROOVE_BOTTOM/2 + (GROOVE_WIDTH/2 - GROOVE_BOTTOM/2) * pow(z/wall_height, CURVE_POWER);

module curved_wall_profile(side, wall_height) {
    points_inner = [for (i = [0:CURVE_POINTS])
        [wall_curve(i * wall_height / CURVE_POINTS, wall_height) * side,
         i * wall_height / CURVE_POINTS]
    ];
    points_outer = [for (i = [0:CURVE_POINTS])
        [(wall_curve(i * wall_height / CURVE_POINTS, wall_height) + WALL_THICKNESS) * side,
         i * wall_height / CURVE_POINTS]
    ];
    all_points = concat(
        [[points_inner[0][0], 0]],
        points_inner,
        [points_outer[len(points_outer)-1]],
        [for (i = [len(points_outer)-1:-1:0]) points_outer[i]],
        [[points_outer[0][0], 0]]
    );
    polygon(all_points);
}

module draw_regular_wall_base(width, z_offset = BASE_THICKNESS) {
    translate([0, 0, z_offset])
        cube([width, WALL_THICKNESS, WALL_HEIGHT]);
}

module draw_flexible_wall_base(width, z_offset = BASE_THICKNESS) {
    wall_height = FLEXIBLE_WALL_HEIGHT - z_offset;
    tilt_angle = atan((GROOVE_WIDTH/2 - GROOVE_BOTTOM/2) / wall_height) + TILT_ANGLE_EXTRA;
    translate([0, -WALL_THICKNESS/2, z_offset - 2])
        rotate([tilt_angle + 6, 0, 0])
            rotate([90, 0, 90])
                linear_extrude(height = width)
                    curved_wall_profile(1, wall_height);
}

module draw_center_base(with_dowel = false) {
    union() {
        translate([-TOTAL_WIDTH/2, -TOTAL_WIDTH/2, 0])
            cube([TOTAL_WIDTH, TOTAL_WIDTH, BASE_THICKNESS]);
        if (with_dowel) {
            translate([0, 0, -DOWEL_DEPTH])
                cylinder(h=DOWEL_DEPTH, d=DOWEL_DIAMETER, $fn=30);
        }
    }
}

module orient_wall(side) {
    if (side == 0) {
        rotate([0, 0, 270])
            children();
    } else if (side == 1) {
        children();
    } else if (side == 2) {
        rotate([0, 0, 90])
            children();
    } else if (side == 3) {
        rotate([0, 0, 180])
            children();
    }
}

module translate_center_wall(side) {
    if (side == 0) {
        translate([CENTER_SIZE/2, TOTAL_WIDTH/2, 0])
            children();
    } else if (side == 1) {
        translate([-TOTAL_WIDTH/2, CENTER_SIZE/2, 0])
            children();
    } else if (side == 2) {
        translate([-CENTER_SIZE/2, -TOTAL_WIDTH/2, 0])
            children();
    } else if (side == 3) {
        translate([TOTAL_WIDTH/2, -CENTER_SIZE/2, 0])
            children();
    }
}

module position_center_wall(side) {
    translate_center_wall(side) {
        orient_wall(side) {
            children();
        }
    }
}

module place_center_wall(side, wall_type = "regular", z_offset = BASE_THICKNESS) {
    position_center_wall(side) {
        if (wall_type == "regular") {
            draw_regular_wall_base(TOTAL_WIDTH, z_offset);
        } else {
            draw_flexible_wall_base(TOTAL_WIDTH, z_offset);
        }
    }
}

module draw_sleeve_base(with_dowel = false) {
    union() {
        translate([0, -TOTAL_WIDTH/2, 0])
            cube([SLEEVE_LENGTH, TOTAL_WIDTH, BASE_THICKNESS]);
        if (with_dowel) {
            translate([25 - CENTER_SIZE/2, 0, -DOWEL_DEPTH])
                cylinder(h=DOWEL_DEPTH, d=DOWEL_DIAMETER, $fn=30);
            translate([50 - CENTER_SIZE/2, 0, -DOWEL_DEPTH])
                cylinder(h=DOWEL_DEPTH, d=DOWEL_DIAMETER, $fn=30);
        }
    }
}

module translate_sleeve_wall(side) {
    if (side == LEFT) {
        translate([SLEEVE_LENGTH, -TOTAL_WIDTH/2 + WALL_THICKNESS, 0])
            children();
    } else if (side == RIGHT) {
        translate([0, TOTAL_WIDTH/2 - WALL_THICKNESS, 0])
            children();
    }
}

module position_sleeve_wall(side) {
    translate_sleeve_wall(side) {
        orient_wall(side) {
            children();
        }
    }
}

module draw_sleeve_wall(side, wall_type = "regular", z_offset = BASE_THICKNESS) {
    position_sleeve_wall(side) {
        if (wall_type == "regular") {
            draw_regular_wall_base(SLEEVE_LENGTH, z_offset);
        } else {
            draw_flexible_wall_base(SLEEVE_LENGTH, z_offset);
        }
    }
}

module draw_full_sleeve(with_dowel = false, wall_type = "regular", z_offset = BASE_THICKNESS) {
    union() {
        draw_sleeve_base(with_dowel);
        draw_sleeve_wall(LEFT, wall_type, z_offset);
        draw_sleeve_wall(RIGHT, wall_type, z_offset);
    }
}

module place_sleeve(side, with_dowel = false, wall_type = "regular", z_offset = BASE_THICKNESS) {
    if (side == 0) {
        translate([CENTER_SIZE/2, 0, 0])
            draw_full_sleeve(with_dowel, wall_type, z_offset);
    } else if (side == 1) {
        rotate([0, 0, 90])
            translate([CENTER_SIZE/2, 0, 0])
                draw_full_sleeve(with_dowel, wall_type, z_offset);
    } else if (side == 2) {
        rotate([0, 0, 180])
            translate([CENTER_SIZE/2, 0, 0])
                draw_full_sleeve(with_dowel, wall_type, z_offset);
    } else if (side == 3) {
        rotate([0, 0, 270])
            translate([CENTER_SIZE/2, 0, 0])
                draw_full_sleeve(with_dowel, wall_type, z_offset);
    }
}

module add_dowel(x, y, dowel_diameter, dowel_depth) {
    translate([x, y, -dowel_depth])
        cylinder(h=dowel_depth, d=dowel_diameter, $fn=30);
}
