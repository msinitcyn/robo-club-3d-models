CENTER_SIZE = 9;
SLEEVE_REACH = 56.5;
GROOVE_WIDTH = 9;
WALL_HEIGHT = 10;
WALL_THICKNESS = 2;
BASE_THICKNESS = 2;
TOTAL_WIDTH = GROOVE_WIDTH + 2 * WALL_THICKNESS;
SLEEVE_LENGTH = SLEEVE_REACH - CENTER_SIZE/2;
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

function wall_curve(z) =
    GROOVE_BOTTOM/2 + (GROOVE_WIDTH/2 - GROOVE_BOTTOM/2) * pow(z/(FLEXIBLE_WALL_HEIGHT - BASE_THICKNESS), CURVE_POWER);

module curved_wall_profile(side) {
    wall_h = FLEXIBLE_WALL_HEIGHT - BASE_THICKNESS;
    points_inner = [for (i = [0:CURVE_POINTS])
        [wall_curve(i * wall_h / CURVE_POINTS) * side,
         i * wall_h / CURVE_POINTS]
    ];
    points_outer = [for (i = [0:CURVE_POINTS])
        [(wall_curve(i * wall_h / CURVE_POINTS) + WALL_THICKNESS) * side,
         i * wall_h / CURVE_POINTS]
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

module draw_regular_wall_base(width) {
    translate([0, 0, BASE_THICKNESS])
        cube([width, WALL_THICKNESS, WALL_HEIGHT - BASE_THICKNESS]);
}

module draw_flexible_wall_base(width) {
    tilt_angle = atan((GROOVE_WIDTH/2 - GROOVE_BOTTOM/2) / (FLEXIBLE_WALL_HEIGHT - BASE_THICKNESS)) + TILT_ANGLE_EXTRA;
    translate([0, -WALL_THICKNESS/2, 0])
        rotate([tilt_angle + 6, 0, 0])
            rotate([90, 0, 90])
                linear_extrude(height = width)
                    curved_wall_profile(1);
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

module place_center_wall(side, wall_type = "regular") {
    position_center_wall(side) {
        if (wall_type == "regular") {
            draw_regular_wall_base(TOTAL_WIDTH);
        } else {
            draw_flexible_wall_base(TOTAL_WIDTH);
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

module draw_sleeve_wall(side, wall_type = "regular") {
    position_sleeve_wall(side) {
        if (wall_type == "regular") {
            draw_regular_wall_base(SLEEVE_LENGTH);
        } else {
            draw_flexible_wall_base(SLEEVE_LENGTH);
        }
    }
}

module draw_full_sleeve(with_dowel = false, wall_type = "regular") {
    union() {
        draw_sleeve_base(with_dowel);
        draw_sleeve_wall(LEFT, wall_type);
        draw_sleeve_wall(RIGHT, wall_type);
    }
}

module place_sleeve(side, with_dowel = false, wall_type = "regular") {
    if (side == 0) {
        translate([CENTER_SIZE/2, 0, 0])
            draw_full_sleeve(with_dowel, wall_type);
    } else if (side == 1) {
        rotate([0, 0, 90])
            translate([CENTER_SIZE/2, 0, 0])
                draw_full_sleeve(with_dowel, wall_type);
    } else if (side == 2) {
        rotate([0, 0, 180])
            translate([CENTER_SIZE/2, 0, 0])
                draw_full_sleeve(with_dowel, wall_type);
    } else if (side == 3) {
        rotate([0, 0, 270])
            translate([CENTER_SIZE/2, 0, 0])
                draw_full_sleeve(with_dowel, wall_type);
    }
}

module add_dowel(x, y, dowel_diameter, dowel_depth) {
    translate([x, y, -dowel_depth])
        cylinder(h=dowel_depth, d=dowel_diameter, $fn=30);
}
