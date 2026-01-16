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
texture = "ribbed"; // [none, ribbed, knurled]

/* Hidden */

sp400_standard_cap(
  nominal_thread_od=thread_od,
  cap_wall=cap_wall,
  texture=texture,
  text=label_text,
  font_size=label_font_size,
  font=font,
  anchor=BOT,
);

// Module: sp400_standard_cap()
// Synopsis: Generate a standard (flat) SP-400 cap with optional labeling
module sp400_standard_cap(
  nominal_thread_od,
  cap_wall,
  texture = "ribbed",
  text = "",
  text_depth = 0.2,
  font = "Liberation Sans:style=Bold",
  font_size = 10,
  anchor,
  spin = 0,
  orient = UP
) {

  diff() sp_cap(
      diam=nominal_thread_od,
      type=400,
      wall=cap_wall,
      anchor=anchor,
      spin=spin,
      orient=orient,
      texture=texture
    ) position(BOT) tag("remove") text3d(
            text,
            h=text_depth,
            anchor=TOP,
            size=font_size,
            atype="ycenter",
            font=font,
            orient=DOWN
          );
}
