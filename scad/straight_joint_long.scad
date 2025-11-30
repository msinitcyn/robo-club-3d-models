use <common.scad>

center_size = 9;
sleeve_reach = 60;
groove_width = 9;
wall_height = 10;
wall_thickness = 2;

total_width = groove_width + 2 * wall_thickness;
sleeve_length = sleeve_reach - center_size/2;

union() {
    difference() {
        draw_base(center_size, total_width, wall_height, wall_thickness);
        cut_wall_opening(0, center_size, groove_width, wall_height, wall_thickness);
        cut_wall_opening(2, center_size, groove_width, wall_height, wall_thickness);
    }
    attach_sleeve(0, sleeve_length, total_width, groove_width, wall_height, wall_thickness, center_size);
    attach_sleeve(2, sleeve_length, total_width, groove_width, wall_height, wall_thickness, center_size);
}
