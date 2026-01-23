/**
 * Straight wall ID containers with screw on caps using SP-400 thread.
 * Thread size is picked from a list of the standard SP-400 sizes.
 **/
include <BOSL2/std.scad>
include <BOSL2/bottlecaps.scad>
use <../lib/sp400.scad>
use <sp400_cap.scad>

/* [Setup] */
// Minimum fragment angle
$fa = 4;
// Minimum fragment size
$fs = 0.25;
// Thread slop
$slop = 0.15;

/* [Container] */
// Thread outside diameter
thread_od = 60; // [18, 20, 22, 24, 28, 30, 33, 35, 38, 40, 43, 45, 48, 51, 53, 58, 60, 63, 66, 70, 75, 77, 83, 89, 100, 110, 120]
// Neck wall thickness
neck_wall = 2.0; // 0.01
neck_inner_height = 6.0; // 0.1
bottom_thick = 2; // 0.1
bottom_outside_chamfer = 2; // 0.1
bottom_inner_chamfer = 2; // 0.1

/* [Cap] */
// Cap wall thickness
cap_wall = 2.0; // 0.1
label_text = "";
label_font_size = 15; //[8:40]
font = "Liberation Sans:style=Bold";
// Cap outside texture
cap_pattern = "ribbed"; // [none, ribbed, knurled]

/* [Hex] */
// Distance across hex flats
hex_hole_size = 6.5; // [4:0.1:20]
hex_hole_depth = 9.0; // 0.1
// Distance between neighboring flats
hex_space = 3; // [0.8:0.2:6]
bit_length = 25.2; // 0.1
bit_cap_clearance = 1.0; // 0.1

/* [Hidden] */
apothem = hex_hole_size / 2;
sp_row = sp400_row(thread_od);
neck_od = sp_row[6];
neck_id = neck_od - 2 * neck_wall;
neck_height = sp_row[3];


height_above_neck = bit_length + bit_cap_clearance - hex_hole_depth - neck_inner_height;
internal_height = bit_length + bit_cap_clearance;
shoulder_height = internal_height - neck_height - height_above_neck + bottom_thick;

radius = neck_id / 2;


// sp_cap uses the thread profile height / 5 + 2 * $slop as the additional
// space that needs to go between the neck and cap. We need this value so
// we can have a rough idea of what the cap OD will be.
T = sp_row[1];
space = sp_row[8] / 5 + 2 * $slop;
cap_od = T + space + 2 * cap_wall;

diff("cut")
  cyl(
    h=shoulder_height + bottom_thick,
    d=cap_od,
    anchor=BOT,
    chamfer1=bottom_outside_chamfer,
  ) position(TOP) down(0.2) sp_neck(thread_od, 400, id=neck_id, anchor=BOT)
    position(TOP) down(neck_inner_height) cyl(d=neck_od, l=hex_hole_depth, extra1=0.1, anchor=TOP)
        tag("cut") position(TOP) up(0.1) orient(DOWN) {
            linear_extrude(height = hex_hole_depth) 
            hex_grid(a = apothem, s = hex_space, r = radius);
        }

back(cap_od + 10) sp400_tall_cap(
    nominal_thread_od=thread_od,
    cap_wall=cap_wall,
    neck_wall=1.84,
    height_above_neck=height_above_neck,
    top_chamfer=0.8,
    texture=cap_pattern,
    text=label_text,
    font=font,
    font_size=label_font_size,
    anchor=BOT
  );

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