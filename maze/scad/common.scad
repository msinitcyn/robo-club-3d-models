CENTER_SIZE = 9;
SLEEVE_LENGTH = 55;
SLEEVE_REACH = SLEEVE_LENGTH + CENTER_SIZE/2;
GROOVE_WIDTH = 9;
WALL_HEIGHT = 10;
WALL_THICKNESS = 2;
BASE_THICKNESS = 2;
TOTAL_WIDTH = GROOVE_WIDTH + 2 * WALL_THICKNESS;
DOWEL_DIAMETER = 4.5;
DOWEL_DEPTH = 3.5;
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

module translate_center_wall(side, center_size, base_width) {
    if (side == 0) {
        translate([center_size/2, base_width/2, 0])
            children();
    } else if (side == 1) {
        translate([-base_width/2, center_size/2, 0])
            children();
    } else if (side == 2) {
        translate([-center_size/2, -base_width/2, 0])
            children();
    } else if (side == 3) {
        translate([base_width/2, -center_size/2, 0])
            children();
    }
}

module place_sleeve_dowels(length, base_width = CENTER_SIZE) {
    offset = base_width / 2;
    first_pos = 25 - offset;

    for (i = [0:10]) {
        pos = first_pos + i * 25;
        if (pos + DOWEL_DIAMETER/2 <= length) {
            translate([pos, 0, -DOWEL_DEPTH])
                cylinder(h=DOWEL_DEPTH, d=DOWEL_DIAMETER, $fn=30);
        }
    }
}

module place_center_base(size = TOTAL_WIDTH, height = BASE_THICKNESS) {
    union() {
        translate([-size/2, -size/2, 0])
            cube([size, size, height]);
    }
}

module place_center_wall(side, center_width = TOTAL_WIDTH, z_offset = BASE_THICKNESS, wall_type = "regular") {
    translate_center_wall(side, center_width - 2*WALL_THICKNESS, center_width) {
        orient_wall(side) {
            if (wall_type == "regular") {
                draw_regular_wall_base(center_width, z_offset);
            } else {
                draw_flexible_wall_base(center_width, z_offset);
            }
        }
    }
}

module place_center_dowel(dowel_diameter = DOWEL_DIAMETER, dowel_depth = DOWEL_DEPTH) {
    translate([0, 0, -dowel_depth])
        cylinder(h=dowel_depth, d=dowel_diameter, $fn=30);
}

module place_sleeve_base(length, width, height = BASE_THICKNESS) {
    translate([0, -width/2, 0])
        cube([length, width, height]);
}

module place_sleeve_walls(length, wall_type = "regular", z_offset = BASE_THICKNESS) {
    position_sleeve_wall(LEFT, length) {
        if (wall_type == "regular") {
            draw_regular_wall_base(length, z_offset);
        } else {
            draw_flexible_wall_base(length, z_offset);
        }
    }
    position_sleeve_wall(RIGHT, length) {
        if (wall_type == "regular") {
            draw_regular_wall_base(length, z_offset);
        } else {
            draw_flexible_wall_base(length, z_offset);
        }
    }
}

module orient_sleeve(side, center_size = CENTER_SIZE) {
    if (side == 0) {
        translate([center_size/2, 0, 0])
            children();
    } else if (side == 1) {
        rotate([0, 0, 90])
            translate([center_size/2, 0, 0])
                children();
    } else if (side == 2) {
        rotate([0, 0, 180])
            translate([center_size/2, 0, 0])
                children();
    } else if (side == 3) {
        rotate([0, 0, 270])
            translate([center_size/2, 0, 0])
                children();
    }
}

module translate_sleeve_wall(side, length) {
    if (side == LEFT) {
        translate([length, -TOTAL_WIDTH/2 + WALL_THICKNESS, 0])
            children();
    } else if (side == RIGHT) {
        translate([0, TOTAL_WIDTH/2 - WALL_THICKNESS, 0])
            children();
    }
}

module position_sleeve_wall(side, length) {
    translate_sleeve_wall(side, length) {
        orient_wall(side) {
            children();
        }
    }
}
