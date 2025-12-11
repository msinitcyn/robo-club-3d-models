use <lego.scad>

union() {
    draw_center_with_studs(with_dowel = false);
    place_sleeve_with_studs(0, with_dowel = false);
    place_sleeve_with_studs(1, with_dowel = false);
    place_sleeve_with_studs(2, with_dowel = false);
    place_sleeve_with_studs(3, with_dowel = false);
}
