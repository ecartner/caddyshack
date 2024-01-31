include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/threading.scad>
include <BOSL2/bottlecaps.scad>

/* [Setup] */
// Minimum fragment angle
$fa = 4;
// Minimum fragment size
$fs = 0.25;

/* [Battery] */
battery_diameter = 14.5;
battery_height = 50.5;
battery_clearance = 0.25; // [0:0.05:1]
label = "AA";

/* [Geometry] */
thread_slop = 0.15; //[0:0.05:1]
bottom_thick = 2; // [1:0.1:6]
top_thick = 2; // [1:0.1:6]
side_wall = 2;//[1:0.1:6]
min_wall = 1.24; // 0.01
label_font_size = 20; //[8:40]

module __Customizer_Limit__() {}
// Place constants that should not be displayed in the customizer here

// If we fix the neck length at 10mm all of the following values
// are constant for SP-400 sizes 28 to 75mm which will cover our needs
H = 10;
S = 1.17;
P = 4.24;
a = 2.39;
b = 1.19;
c = 1.02;

bottle_profile = _sp_thread_profile(6, a, S, "L");
oprofile = _sp_thread_profile(6, a, S+0.75*a, "L", flip=true);
bounds = pointlist_bounds(oprofile);
cap_profile = fwd(-bounds[0].y,yflip(oprofile));

packing_radius = (battery_diameter + min_wall) / 2 + battery_clearance;
enclosing_radius = (1 + 1 / sin(180 / 7)) * packing_radius;
hole_pattern_radius = packing_radius / sin(180 / 7);

bottle_id = 2 * enclosing_radius - min_wall;
T = bottle_id + 2*b + 2*side_wall;
space = a/10 + 2 * thread_slop;

bottle_inside_height = 0.75 * battery_height;
bottle_od = T + space + 2*side_wall;
bottle_od_height = bottle_inside_height - H + bottom_thick;

hole_offset = 0.2 * battery_height;
hole_depth = bottle_inside_height - hole_offset;
hole_diameter = battery_diameter + 2 * battery_clearance;

cap_inside_height = battery_height - bottle_inside_height + 2 + H;
cap_shoulder_width = (bottle_od - T + 2*b)/2;

up(bottle_inside_height + bottom_thick) bottle();

diff("cut") 
back(bottle_od + 10) up(cap_inside_height - H) simple_cap(anchor=BOT) {
    position(BOT) cyl(d=T-2*b, h=cap_inside_height - H, anchor=TOP,chamfer2 = - cap_shoulder_width, chamfer1 = 0.8)
    tag("cut") position(BOT) zrot(180) down(0.01) text3d(label, h=0.2, anchor=BOT,size=label_font_size,atype="ycenter");
    tag("cut") position(TOP) cyl(d=bottle_id, h = cap_inside_height, anchor=TOP);
};

module battery_holes() {
    arc_copies(7, r = hole_pattern_radius) {
    cyl(d = hole_diameter, h=hole_depth, anchor = TOP);
    }
    cyl(d = hole_diameter, h = hole_depth, anchor = TOP);
}

module bottle() {
    difference() {
        union() {
            thread_helix(d=T-0.01, profile=bottle_profile, pitch=P, turns=1, lead_in = 2*a, anchor=TOP);
            cyl(d=T-a,h=H,anchor=TOP) position(BOT) cyl(d=bottle_od,h=bottle_od_height, anchor=TOP, chamfer1 = 0.8, $fa=12);
        }
        up(0.1) cyl(d=T-a-2*side_wall,h=hole_offset, anchor=TOP)
        position(BOT) up(0.01) battery_holes();
    }
}

// Takes values it needs from globals and only does SP-400
module simple_cap(anchor, spin, orient) {
  attachable(anchor, spin, orient, r = bottle_od / 2, l = H + top_thick) {
    xrot(180) up((H - top_thick) / 2) {
        difference() {
            up(top_thick) {
                cyl(d=bottle_od, l=H+top_thick,anchor=TOP,
                tex_taper=0, texture="trunc_ribs", tex_size=[3,3], tex_style="min_edge");
            }
            cyl(d=T+space, l=H+1, anchor=TOP);
        }
        thread_helix(d=T+space -0.01, profile=cap_profile, pitch = P, turns = 1, lead_in = 2 * a, anchor=TOP, internal=true);
    }
    children();
  }
}