/**
 * Straight wall ID containers with screw on lids using SP-400 thread.
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

/* [Container] */
// Minimum neck inner diameter (mm)
min_neck_id = 52; // [13:112]
// Neck wall thickness (mm)
neck_wall = 2.0; // 0.01
// Container interior height (mm)
interior_height = 40; // [20:160]
bottom_thick = 2; // 0.1
bottom_outside_chamfer = 2; // 0.1
bottom_inner_chamfer = 2; // 0.1

/* [Lid] */
// Lid wall thickness
lid_wall = 2.0; // 0.1
label_text = "";
label_font_size = 15; //[8:40]
font = "Liberation Sans:style=Bold";
// Lid outside texture
lid_pattern = "ribbed"; // [none, ribbed, knurled]

/* [Hidden] */
sp_row = sp400_row_for_neck_id(min_neck_id, neck_wall);
thread_od = sp_row[0];
neck_od = sp_row[6];
neck_id = neck_od - 2 * neck_wall;
neck_height = sp_row[3];

lid_height = sp_row[3] + lid_wall - 0.5;
neck_holdback = 0.2;

/**
 * sp_cap uses the thread profile height / 5 + 2 * $slop as the additional
 * space that needs to go between the neck and cap. We need this value so
 * we can have a rough idea of what the lid OD will be.
 */

space = sp_row[8] / 5 + 2 * $slop;
lid_od = thread_od + space + 2 * lid_wall;
body_height = interior_height - neck_height + neck_holdback + bottom_thick;

diff("cut")
  cyl(
    h=body_height,
    d=lid_od,
    anchor=BOT,
    chamfer1=bottom_outside_chamfer,
  ) {
    attach(TOP, BOT) down(neck_holdback) sp_neck(thread_od, 400, id=neck_id);
    tag("cut") attach(TOP, TOP) cyl(h=body_height - bottom_thick, d=neck_id, chamfer1=bottom_inner_chamfer, extra2=0.1);
  }

back(lid_od + 10)
  diff("cut")
    sp_cap(diam=thread_od, type=400, wall=lid_wall, anchor=BOT, texture=lid_pattern)
      position(BOT)
        tag("cut") text3d(label_text, h=0.2, anchor=TOP, size=label_font_size, atype="ycenter", font=font, orient=DOWN);
