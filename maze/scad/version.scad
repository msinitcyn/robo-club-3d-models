VERSION = "v1.2.2";

module engrave_version_text(text, size=2.0, depth=0.3) {
    linear_extrude(height=depth)
        text(text, size=size, font="Liberation Sans:style=Bold", halign="left", valign="bottom");
}

module print_version_at(x, y, top_z, depth=0.3) {
    translate([x, y, top_z - depth])
        engrave_version_text(VERSION);
}

module print_version(x=-4, y=-4.5, top_z=2) {
    print_version_at(x, y, top_z);
}

module print_version_sleeve(x=2.5, y=-4.5, top_z=1.8) {
    print_version_at(x, y, top_z);
}
