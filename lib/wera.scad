include <BOSL2/std.scad>

/* [Setup] */
// Minimum fragment angle
$fa = 4;
// Minimum fragment size
$fs = 0.25;

/* [Cutout] */
hole_diameter = 3.80; // 0.1

/* [Block] */
height = 20;
width = 20;
thick = 6;

diff()
  cuboid(size=[width, height, thick], anchor=TOP) {
    position(TOP) tag("remove") wera_kraftform_micro_nose(anchor=TOP);
    tag("remove") cyl(d=hole_diameter, l=thick, extra=0.1);
  }

module wera_kraftform_micro_nose(anchor = CENTER, spin = 0, orient = UP) {
  lower_radius = 3.5;
  upper_radius = 6.7;
  cone_height = 3.0;
  hex_height = 2.0;
  hex_chamfer = 0.4;
  attachable(
    anchor,
    spin,
    orient,
    r=upper_radius,
    l=cone_height + hex_height
  ) {
    down((cone_height + hex_height) / 2)
      tag_intersect("remove")
        cyl(r1=lower_radius, r2=upper_radius, h=cone_height, anchor=BOT) {
          tag("intersect") regular_prism(n=6, r=upper_radius, h=cone_height + 0.1);
          tag("keep") attach(TOP, BOT) regular_prism(n=6, r=upper_radius, h=hex_height, chamfer2=-hex_chamfer);
        }
    children();
  }
}
