/**
 * Implementation of Really Right Stuff dovetail plate
 **/
include <BOSL2/std.scad>

/* [Setup] */
// Minimum fragment angle
$fa = 4;
// Minimum fragment size
$fs = 0.25;

/* [Plate] */
// length in mm
length = 25; // 0.1

/* [Hidden] */

rrs_plate(25);

module rrs_plate(length, anchor=CENTER, spin=0, orient=UP) {
    width = 25.4 * 1.5;
    bottom_radius = 25.4 / 16;
    base_height = 25.4 * 0.075;
    total_height = 25.4 * 0.19;
    dovetail_height = total_height - base_height;
    width_at_top = width - 2 * dovetail_height;

    attachable(
        anchor,
        spin,
        orient,
        size = [width, length, total_height]) {
        down(total_height / 2)
        cuboid(
            [width, length, base_height],
            rounding=bottom_radius,
            edges=[BOT+LEFT, BOT+RIGHT],
            anchor=BOT,
        ) attach(TOP, BOT) prismoid(size1=[width, length], h=dovetail_height, xang=45, yang=90);

        children();
    }
}