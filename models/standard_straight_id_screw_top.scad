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
// Body wall thickness
body_wall = 2.88;
// Container height below neck
height = 40; // [10:160]
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

/* [Hidden] */
sp_row = sp400_row(thread_od);
neck_od = sp_row[6];
neck_id = neck_od - 2 * neck_wall;

// sp_cap uses the thread profile height / 5 + 2 * $slop as the additional
// space that needs to go between the neck and cap. We need this value so
// we can have a rough idea of what the cap OD will be.
T = sp_row[1];
space = sp_row[8] / 5 + 2 * $slop;
cap_od = T + space + 2 * cap_wall;

diff("cut")
  cyl(
    h=height,
    d=cap_od,
    anchor=BOT,
    chamfer1=bottom_outside_chamfer,
  ) {

    position(TOP) down(0.1) sp_neck(thread_od, 400, id=neck_id, anchor=BOT);
    tag("cut") position(TOP) cyl(h=height - bottom_thick, d=neck_id, anchor=TOP, chamfer1=bottom_inner_chamfer, extra2=0.1);
  }

back(cap_od + 10) sp400_standard_cap(
    nominal_thread_od=thread_od,
    cap_wall=cap_wall,
    texture=cap_pattern,
    text=label_text,
    font=font,
    font_size=label_font_size,
    anchor=BOT
  );
