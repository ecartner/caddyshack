include <BOSL2/std.scad>

/* [Setup] */
$fa = 8;
$fs = 0.25;

/* [Base] */
// Base length (mm)
length = 20; // [10:60]

// Base width (mm)
width = 10; // [10:60]

// Base thickness (mm)
height = 2.2; // [1.2:0.1:4]

// Corner Radius (mm)
corner_radius = 4; // [0:0.2:8]

// Chamfer Size (setback)
chamfer = 0.4; // [0.1:0.1:1]

/* [Hidden] */

soap_bar(
  l=length,
  w=width,
  h=height,
  radius=corner_radius,
  chamfer=chamfer,
);

module soap_bar(l, w, h, radius, chamfer, anchor = CENTER, spin = 0, orient = UP) {
  attachable(
    anchor,
    spin,
    orient,
    size=[l, w, h],
  ) {
    down(h / 2) prismoid(
      size1=[l - 2 * chamfer, w - 2 * chamfer],
      size2=[l, w],
      h=chamfer,
      rounding=radius,
    ) {
      position(TOP) prismoid(
          size1=[l, w],
          size2=[l, w],
          h=h - 2 * chamfer,
          rounding=radius,
        )
          position(TOP) prismoid(
              size1=[l, w],
              size2=[l - 2 * chamfer, w - 2 * chamfer],
              h=chamfer,
              rounding=radius,
            );
    }
    children();
  }
}
