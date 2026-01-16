include <BOSL2/std.scad>

/* [Setup] */
// Minimum fragment angle
$fa = 4;
// Minimum fragment size
$fs = 0.25;

/* [Geometry] */
// Distance across hex flats
hex_size = 6.5; // [4:0.1:20]
// Distance between neighboring flats
hex_space = 2; // [0.8:0.1:3]
circle_diameter = 40; // [13:112]

/* [Hidden] */
apothem = hex_size / 2;
radius = circle_diameter / 2;

// ---------- helpers ----------
function hex_radius(apothem) = apothem / cos(30); 

function inside_circle(cx, cy, R, shrink) = (cx*cx + cy*cy) <= (R - shrink)*(R - shrink);

module hex2d(r){
    hexagon(r = r, spin=90);
}

// Hex grid spacing for pointy-top orientation:
// horizontal center spacing = sqrt(3) * (apothem+gap/2)
// vertical   center spacing = 2 * (apothem+gap/2) * 3/2  -> 3*apothem-ish
// More directly: for pointy-top hex with circumradius r,
// width across flats = 2*apothem(r). To get "gap" between flats,
// increase center distance by gap in the flat-to-flat direction.
module hex_grid_clipped(apothem, gap, R){
    a = apothem;
    hex_r = hex_radius(apothem);
    // center-to-center spacing:
    dx = 2*a + gap;            // across flats (horizontal for pointy-top)
    dy = 1.5*hex_r + gap*0.8660254; // row-to-row; gap projected along that direction

    // containment shrink: farthest vertex distance
    shrink = hex_r;

    // bounds: only generate cells that could possibly be kept
    // generous bounding box, then filter with inside_circle().
    xmin = -R; xmax = R;
    ymin = -R; ymax = R;

    for (row = [floor(ymin/dy)-2 : ceil(ymax/dy)+2]) {
        y = row*dy;
        x_offset = (row % 2) * (dx/2);

        for (col = [floor(xmin/dx)-2 : ceil(xmax/dx)+2]) {
            x = col*dx + x_offset;

            if (inside_circle(x, y, R, shrink)) {
                translate([x,y]) hex2d(hex_r);
            }
        }
    }
}

function inside_circle(x, y, r, shrink) = (x * x + y * y) <= (r - shrink) * (r - shrink);

/**
 * Make a grid of hexagons that fit inside a circle
 * Arguments
 *   a = hexagon apothem
 *   s = space between hexagon sides
 *   r = radius of the enclosing circle
 **/
module hex_grid(a, s, r) {
    hex_r = apothem / cos(30);

    // Calculate center to center spacing
    dx = 2 * a + s;
    dy = 1.5 * hex_r + s * cos(30);

    // containment shrink
    shrink = hex_r;

    // rough approximation of bounds
    xmin = -r;
    xmax = r;
    ymin = -r;
    ymax = r;

    count = 0;
    for (row = [floor(ymin / dy) - 2 : ceil(ymax / dy) + 2]) {
        y = row * dy;
        x_offset = (row % 2) * (dx / 2);

        for (col = [floor(xmin / dx) - 2 : ceil(xmax /dx) + 2]) {
            x = col * dx + x_offset;

            if (inside_circle(x, y, r, shrink)) {
                translate([x, y]) hexagon(r = hex_r, spin = 90);
            }
        }
    }

}


hex_grid(a = apothem, s = hex_space, r = radius);
%circle(r = radius);
