/**
 * Straight wall ID containers with screw on caps using SP-400 thread.
 * Thread OD is picked based on minimum neck ID and wall thickness.
 **/
include <BOSL2/std.scad>
include <BOSL2/bottlecaps.scad>
use <../lib/sp400.scad>

/* [Setup] */
// Minimum fragment angle
$fa = 4;
// Minimum fragment size
$fs = 0.25;
// Thread slop
$slop = 0.15;
// Render sectional view of container
section_view = false;

/* [Container] */
// Minimum neck inner diameter (mm)
min_neck_id = 52; // [13:112]
// Neck wall thickness (mm)
neck_wall = 2.0; // 0.01
// Wall thickness in main body (mm)
body_wall = 2.0; // 0.01
// Container interior height (mm)
interior_height = 40; // [20:160]
bottom_thick = 2; // 0.1
bottom_inner_chamfer = 2; // 0.1
taper_inner_walls = true;

/* [Body Exterior] */
// Outside wall texture pattern
texture = "none"; // [none, bricks, checkers, cones, cubes, diamonds, dimples, dots, hex_grid, hills, pyramids, ribs, rough, tri_grid, trunc_diamonds, trunc_pyramids, trunc_ribs, wave_ribs]

// Only applies to "none" texture
bottom_outside_chamfer = 2; // 0.1

// Depth 
texture_depth = 0.5; // [-2:0.1:2]

// Tile size (mm)
texture_grid = [14, 14]; // [5:50]

// Length of transition from full texture to none
texture_taper = 0.1; // [0:0.05:0.5]

/* [Cap] */
// Cap wall thickness
cap_wall = 2.0; // 0.1
label_text = "";
label_font_size = 15; //[8:40]
font = "Liberation Sans:style=Bold";
// Cap outside texture
cap_pattern = "ribbed"; // [none, ribbed, knurled]

/* [Hidden] */
sp_row = sp400_row_for_neck_id(min_neck_id, neck_wall);
thread_od = sp_row[0];
neck_od = sp_row[6];
neck_id = neck_od - 2 * neck_wall;
neck_height = sp_row[3];

cap_height = sp_row[3] + cap_wall - 0.5;
neck_holdback = 0.2;

/**
 * sp_cap uses the thread profile height / 5 + 2 * $slop as the additional
 * space that needs to go between the neck and cap. We need this value so
 * we can have a rough idea of what the cap OD will be.
 */

space = sp_row[8] / 5 + 2 * $slop;
cap_od = thread_od + space + 2 * cap_wall;

body_od = cap_od;
max_body_id = taper_inner_walls ? body_od - 2 * body_wall : neck_id;
body_height = interior_height - neck_height + neck_holdback + bottom_thick;
total_height = body_height + neck_height;
delta_ir = (max_body_id - neck_id) / 2;

max_dim = cap_od > total_height ? cap_od : total_height;

if (section_view) {
  back_half(s=max_dim * 2) main();
} else {
  main();
}

module main() {
  if (texture == "none") {
    diff("cut")
      cyl(
        h=body_height,
        d=body_od,
        anchor=BOT,
        chamfer1=bottom_outside_chamfer,
      ) {
        attach(TOP, BOT) down(neck_holdback) sp_neck(thread_od, 400, id=neck_id);
        tag("cut") position(TOP) cutout();
      }
  } else {
    diff("cut")
      cyl(
        h=body_height,
        d=body_od,
        anchor=BOT,
        texture=texture,
        tex_size=texture_grid,
        tex_depth=texture_depth,
        tex_taper=texture_taper,
      ) {
        attach(TOP, BOT) down(neck_holdback) sp_neck(thread_od, 400, id=neck_id);
        tag("cut") position(TOP) cutout();
      }
  }

  back(cap_od + 10)
    diff("cut")
      sp_cap(diam=thread_od, type=400, wall=cap_wall, anchor=BOT, texture=cap_pattern)
        position(BOT)
          tag("cut") text3d(label_text, h=0.2, anchor=TOP, size=label_font_size, atype="ycenter", font=font, orient=DOWN);
}

module cutout() {
  cyl(h=neck_wall, d=neck_id, anchor=TOP, extra2=0.1)
    position(BOT) cyl(
        h=body_height - bottom_thick - neck_wall,
        d=max_body_id,
        chamfer1=bottom_inner_chamfer,
        chamfer2=delta_ir,
        extra2=0.1,
        anchor=TOP,
      );
}
