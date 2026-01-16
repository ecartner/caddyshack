/**
 * Model for various configurations of SP-400 caps
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

/* [Cap] */
// Thread outside diameter
thread_od = 60; // [18, 20, 22, 24, 28, 30, 33, 35, 38, 40, 43, 45, 48, 51, 53, 58, 60, 63, 66, 70, 75, 77, 83, 89, 100, 110, 120]
// Cap wall thickness
cap_wall = 1.84; // 0.01
height_above_neck = 20; //[10:50]
top_chamfer = 0.8; // [0:0.1:2]

/* [Label] */
label_text = "";
label_font_size = 15; //[8:40]
font = "Liberation Sans:style=Bold";
// Cap outside texture
texture = "ribbed"; // [none, ribbed, knurled]

/* Hidden */

sp400_tall_cap(
  nominal_thread_od=thread_od,
  cap_wall=cap_wall,
  neck_wall=1.84,
  height_above_neck=height_above_neck,
  top_chamfer=top_chamfer,
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

module sp400_tall_cap(
  nominal_thread_od,
  cap_wall,
  neck_wall,
  height_above_neck,
  top_chamfer = 0.6,
  texture = "ribbed",
  text = "",
  text_depth = 0.2,
  font = "Liberation Sans:style=Bold",
  font_size = 10,
  anchor,
  spin = 0,
  orient = UP
) {

  sp_row = sp400_row(nominal_thread_od);
  T = sp_row[1];
  neck_od = sp_row[6];
  neck_id = neck_od - 2 * neck_wall;
  std_cap_height = sp_row[3] + cap_wall - 0.5;
  // sp_cap uses the thread profile height / 5 + 2 * $slop as the additional
  // space that needs to go between the neck and cap. We need this value so
  // we can have a rough idea of what the cap OD will be.
  space = sp_row[8] / 5 + 2 * $slop;
  cap_od = T + space + 2 * cap_wall;

  // We'll assume the top of the neck touches the bottom of the cap top
  extension_height = height_above_neck;
  extension_diameter = neck_id + 2 * cap_wall;
  merge_chamfer = (cap_od - extension_diameter) / 2;
  chamfer_size = texture == "knurled" ? merge_chamfer : merge_chamfer - 0.8;
  total_height = std_cap_height + extension_height;

  attachable(
    anchor,
    spin,
    orient,
    r=cap_od / 2,
    l=total_height
  ) {

    up(total_height / 2) diff() sp_cap(
          diam=nominal_thread_od,
          type=400,
          wall=cap_wall,
          anchor=TOP,
          spin=spin,
          orient=orient,
          texture=texture
        ) position(BOT) {
            cyl(
              d=extension_diameter,
              l=extension_height,
              anchor=TOP,
              chamfer1=top_chamfer,
              chamfer2=-chamfer_size
            ) position(BOT) tag("remove") down(0.01)
                    text3d(
                      text,
                      h=text_depth + 0.01,
                      anchor=TOP,
                      size=font_size,
                      atype="ycenter",
                      font=font,
                      orient=DOWN
                    );
            up(cap_wall) tag("remove") cyl(
                  d=neck_id,
                  l=extension_height,
                  extra2=0.1,
                  chamfer1=top_chamfer,
                  anchor=(TOP),
                );
          }
    children();
  }
}
