VERSION = "v1.1.0";

module engrave_version_text(text, size=1.0, depth=0.3) {
    linear_extrude(height=depth)
        text(text, size=size, font="Liberation Sans:style=Bold", halign="left", valign="bottom");
}

module print_version_at(x, y, z) {
    translate([x, y, z])
        rotate([180, 0, 0])
            translate([0, 0, -0.29])
                engrave_version_text(VERSION);
}

module print_version(x=-5, y=-4, z=0) {
    print_version_at(x, y, z);
}

module print_version_sleeve(x=1.5, y=-4, z=0) {
    print_version_at(x, y, z);
}
