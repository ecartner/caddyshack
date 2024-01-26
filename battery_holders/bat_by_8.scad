include <BOSL2/std.scad>
include <BOSL2/threading.scad>

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
bottom_thick = 2; // [1:0.1:6]
top_thick = 2; // [1:0.1:6]
side_wall = 2;//[1:0.1:6]
min_wall = 1.24; // 0.01
thread_pitch = 3.5;    //[2:0.5:6]
slop = 0.15; //[0:0.05:3]
chamfer = 1.4; //[0:0.2:4]
label_font_size = 20; //[8:40]

module __Customizer_Limit__() {}
// Place constants that should not be displayed in the customizer here

packing_radius = (battery_diameter + min_wall) / 2 + battery_clearance;
enclosing_radius = (1 + 1 / sin(180 / 7)) * packing_radius;
hole_pattern_radius = packing_radius / sin(180 / 7);

thread_depth = 1.07217 * 5 / 8 * cos(30) * thread_pitch;
thread_od = 2 * (enclosing_radius + side_wall + thread_depth);

bottle_id = 2 * enclosing_radius;
neck_height = 3 * thread_pitch;
inside_height = 0.75 * battery_height;
bottle_od = 2 * slop + thread_od + 2 * side_wall;
bottle_od_height = inside_height - neck_height + bottom_thick;

hole_offset = 0.2 * battery_height;
hole_depth = inside_height - hole_offset;
hole_diameter = battery_diameter + 2 * battery_clearance;

lid_inside_height = battery_height - inside_height + 2 + neck_height;
lid_neck_inside_height = neck_height + 0.5;
lid_neck_outside_height = lid_neck_inside_height * (1 + sin(22.5));

bottle();
back(bottle_od + 10) up(lid_inside_height + top_thick) lid();

module battery_holes() {
    arc_copies(7, r = hole_pattern_radius) {
    cyl(d = hole_diameter, h=hole_depth, anchor = TOP);
    }
    cyl(d = hole_diameter, h = hole_depth, anchor = TOP);
}

module bottle() {
    diff("hole")
    cyl(h=bottle_od_height, d = bottle_od, anchor=BOTTOM, chamfer1=chamfer) {
        position(TOP) threaded_rod(
            d = thread_od,
            pitch = thread_pitch,
            l = neck_height,
            end_len = thread_pitch/2,
            blunt_start = true,
            anchor = BOT
        ) {
            tag("hole") {
                position(TOP) up(0.01) cyl(h=inside_height - hole_depth, r = enclosing_radius, anchor=TOP) 
                position(BOT) up(0.01) battery_holes();
            }
        };
    }
}

module lid() {
    diff("cut")
    cyl(h=lid_neck_outside_height, d = bottle_od, anchor=TOP, chamfer1=2*side_wall) {
        position(BOT)
        cyl(h=lid_inside_height + top_thick - lid_neck_outside_height, d = bottle_id + 2*side_wall, anchor=TOP, chamfer1=chamfer){
            tag("cut") position(BOT) zrot(180) text3d(label, h=0.2, anchor=BOT,size=label_font_size,atype="ycenter");
        };
        tag("cut") {
            position(TOP) up(0.01) threaded_rod(
                d = thread_od,
                l = lid_neck_inside_height,
                pitch = thread_pitch,
                internal = true,
                blunt_start = true,
                $slop = slop,
                anchor = TOP,
                end_len1 = 0.5 * thread_pitch + 0.5,
                end_len2 = 0.5 * thread_pitch 
            ) position(TOP) cyl(h=lid_inside_height,d = bottle_id, anchor=TOP, chamfer2 = -side_wall);
        }
    }
}
