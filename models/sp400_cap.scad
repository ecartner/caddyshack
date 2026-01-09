/**
 * Model for various configurations of SP-400 caps
 **/
include <BOSL2/std.scad>
include <BOSL2/bottlecaps.scad>

/* [Setup] */
// Minimum fragment angle
$fa = 4;
// Minimum fragment size
$fs = 0.25;
// Thread slop
$slop = 0.15;

/* [Cap] */
// Thread outside diameter
thread_od = 60; // [18, 20, 22, 24, 28, 30, 33, 35, 38, 40, 43, 45, 48, 51, 53, 58, 60, 63, 66, 70, 75, 77, 83, 89, 100, 110, 120]
// Cap wall thickness
cap_wall = 1.84; // 0.01
label_text = "";
label_font_size = 15; //[8:40]
font = "Liberation Sans:style=Bold";
// Cap outside texture
cap_pattern = "ribbed"; // [none, ribbed, knurled]

diff("cut")
  sp_cap(diam=thread_od, type=400, wall=cap_wall, anchor=BOT, texture=cap_pattern)
    position(BOT)
      tag("cut") text3d(label_text, h=0.2, anchor=TOP, size=label_font_size, atype="ycenter", font=font, orient=DOWN);
