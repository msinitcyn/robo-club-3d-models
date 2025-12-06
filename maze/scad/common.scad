module draw_base(center_size, total_width, wall_height, wall_thickness) {
    difference() {
        translate([-total_width/2, -total_width/2, 0])
            cube([total_width, total_width, wall_height]);
        translate([-center_size/2, -center_size/2, wall_thickness])
            cube([center_size, center_size, wall_height]);
    }
}

module single_sleeve(sleeve_length, total_width, groove_width, wall_height, wall_thickness, center_size) {
    difference() {
        translate([center_size/2, -total_width/2, 0])
            cube([sleeve_length, total_width, wall_height]);
        translate([center_size/2, -total_width/2 + wall_thickness, wall_thickness])
            cube([sleeve_length, groove_width, wall_height]);
    }
}

module cut_wall_opening(side, center_size, groove_width, wall_height, wall_thickness) {
    if (side == 0) {
        translate([center_size/2, -center_size/2, wall_thickness])
            cube([wall_thickness, groove_width, wall_height]);
    } else if (side == 1) {
        translate([-center_size/2, center_size/2, wall_thickness])
            cube([groove_width, wall_thickness, wall_height]);
    } else if (side == 2) {
        translate([-center_size/2 - wall_thickness, -center_size/2, wall_thickness])
            cube([wall_thickness, groove_width, wall_height]);
    } else if (side == 3) {
        translate([-center_size/2, -center_size/2 - wall_thickness, wall_thickness])
            cube([groove_width, wall_thickness, wall_height]);
    }
}

module attach_sleeve(side, sleeve_length, total_width, groove_width, wall_height, wall_thickness, center_size) {
    if (side == 0) {
        single_sleeve(sleeve_length, total_width, groove_width, wall_height, wall_thickness, center_size);
    } else if (side == 1) {
        rotate([0, 0, 90])
            single_sleeve(sleeve_length, total_width, groove_width, wall_height, wall_thickness, center_size);
    } else if (side == 2) {
        rotate([0, 0, 180])
            single_sleeve(sleeve_length, total_width, groove_width, wall_height, wall_thickness, center_size);
    } else if (side == 3) {
        rotate([0, 0, 270])
            single_sleeve(sleeve_length, total_width, groove_width, wall_height, wall_thickness, center_size);
    }
}

module add_dowel(x, y, dowel_diameter, dowel_depth) {
    translate([x, y, -dowel_depth])
        cylinder(h=dowel_depth, d=dowel_diameter, $fn=30);
}
