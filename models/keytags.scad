/**
 * Key tag generator
 *
 * A couple notes:
 *
 *  1) Requires you to enable the `textmetrics` feature in your OpenSCAD preferences/settings 
 *  2) The fonts I've listed are from MacOS Tahoe, you may need to supply your own font names
 *     which can be found inside OpenScad with Help > Font List
 */

include <BOSL2/std.scad>
use <../lib/soap_bar.scad>

/* [Setup] */
$fa = 8;
$fs = 0.25;

/* [Base] */
// Base thickness (mm)
baseThick = 2.2; // [1.2:0.1:4]

// Corner Radius (mm)
cornerRadius = 4; // [0:0.2:8]

// Chamfer Size (setback)
chamferSize = 0.4; // [0.1:0.1:1]

// Slot Wall (mm)
slotWall = 3; // [1.5:0.1:6]

// Slot Diameter (mm)
slotDiameter = 5.8; // [4:0.1:8]

/* [Text] */
textHeight = 0.8; //[0.2:0.1:2]

// Margin (mm)
margin = 3.0; //[1:0.2:6]

// Text Size
fontSize = 10; // [4:0.2:16]

text = "KEYCHAIN";

font = "Arial Rounded MT Bold"; // ["Arial Rounded MT Bold","Futura","Futura:style=Condensed Medium","Futura:style=Condensed ExtraBold","Gill Sans:style=UltraBold"]


// Place constants or values that should not show in customizer here
metrics = textmetrics(text, font=font, size=fontSize);
tX = slotWall + slotDiameter + margin - metrics.position.x;

tY = margin - metrics.position.y;

width = tY + metrics.position.y + metrics.size.y + margin;

length = tX + metrics.position.x + metrics.size.x + margin;

difference() {
    union() {
        soap_bar(length, width, baseThick, cornerRadius, chamferSize, anchor=BOT+FWD+LEFT);
        translate([tX, tY, baseThick - 0.1]) {
            linear_extrude(height=textHeight)
                text(text, font=font, size=fontSize);
        }
    }
    translate([slotWall + slotDiameter / 2, width / 2, 0])
    rotate([0,0,90])
    slot(slotDiameter, width - 2 * slotWall, baseThick, chamferSize);
}

module slot(d, l, h, c) {
  translate([(l - d) / 2, 0, -0.1]) cyl(d = d, h = h + 0.2,
    chamfer = -c, anchor=BOTTOM);
  translate([-(l - d) / 2, 0, -0.1]) cyl(d = d, h = h + 0.2,
    chamfer = -c, anchor=BOTTOM);
  translate([0,0,-0.1])
    cuboid([l - d, d, h + 0.2], chamfer = -c, anchor=BOTTOM);
}
