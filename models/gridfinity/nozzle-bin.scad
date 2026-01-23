include <gridfinity-rebuilt-openscad/src/core/standard.scad>
use <gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>
use <gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-holes.scad>
use <gridfinity-rebuilt-openscad/src/core/bin.scad>
use <gridfinity-rebuilt-openscad/src/core/cutouts.scad>
include <BOSL2/std.scad>

/* [Setup Parameters] */
// Minimum fragment angle
$fa = 4;
// Minimum fragment size
$fs = 0.25; // .01

/* [Gridfinity] */
// number of bases along x-axis
gridX = 2;
// number of bases along y-axis
gridY = 2;
// bin height in 7mm Gridfinity units
gridZ = 3;

// Place magnet holes at corners only
only_corners = true;

// If the top lip should exist.  Not included in height calculations.
include_lip = true;

/* [Hole] */
bin_size = 12.9;
clearance = 0.2;
from_lip = 4;
min_wall= 2;

/* [Hidden] */

hole_options = bundle_hole_options(
  refined_hole=true,
  magnet_hole=false,
  screw_hole=false,
  crush_ribs=false,
  chamfer=false,
  supportless=false
);

bin = new_bin(
    grid_size = [gridX, gridY],
    height_mm = fromGridfinityUnits(gridZ),
    fill_height = 0,
    include_lip = include_lip,
    hole_options = hole_options,
    only_corners = only_corners,
    thumbscrew = false,
    grid_dimensions = GRID_DIMENSIONS_MM,
);

hole_size = bin_size + 2 * clearance;

infill_size = bin_get_infill_size_mm(bin);

x_size = infill_size.x - 2 * from_lip;
n_x = floor(x_size / (hole_size + min_wall));
x_spacing = (x_size - n_x * hole_size) / (n_x - 1) + hole_size;
y_size = infill_size.y - 2 * from_lip;
n_y = floor(y_size / (hole_size + min_wall));
y_spacing = (y_size - n_y * hole_size) / (n_y - 1) + hole_size;
hole_depth = infill_size.z;

bin_render(bin) {
    bin_translate(bin, [gridX / 2, gridY / 2])
       holes();
}

module holes() {
    grid_copies(
        spacing = [x_spacing, y_spacing],
        n = [n_x, n_y]
    ) cuboid([hole_size, hole_size, hole_depth], anchor=TOP);

}
/*

  N * hole_size + (N - 1) * min_wall <= x_size

  N * hole_size + N * min_wall - min_wall
  N * (hole_size + min_wall) <= x_size 
  N <= x_size / (hole_size + min_wall)

  N * (hole_size) + (N - 1) * spacing = x_size
  spacing = (x_size - N * (hole_size))/(N - 1);

 */
