include <BOSL2/std.scad>

/* [Setup] */
// Minimum fragment angle
$fa = 4;
// Minimum fragment size
$fs = 0.25;

/* [Geometry] */
Width = 80; // [20:140]

Length = 80; // [20:140]

Wall_Height = 6; // [4:12]
Wall_Base_Width = 4; // [2:0.2:8]
Wall_Taper = 7.5; // [0:0.1:15]
Base_Thick = 2; // [0.5:0.1:4]

Rib_Height = 4; // [2:0.2:8]
Rib_Base_Width = 2; // [1.6:0.2:8]
Rib_Taper = 7.5; // [0:0.5:30]
Rib_Spacing = 8; // [2:0.2:14]
Num_Ribs = 1; // [0:20]

/* [Hidden] */

outer_bottom_size = [Width, Length];
outer_top_size = add_scalar(outer_bottom_size, -2 * tan(Wall_Taper * Wall_Height));
inner_bottom_size = add_scalar(outer_bottom_size, -2 * (Wall_Base_Width - tan(Wall_Taper) * Base_Thick));
inner_top_size = add_scalar(outer_bottom_size, -2 * (Wall_Base_Width - tan(Wall_Taper) * Wall_Height));
rib_bottom_size = [Width - Wall_Base_Width, Rib_Base_Width];
rib_top_size = [Width - Wall_Base_Width, Rib_Base_Width - 2 * tan(Rib_Taper) * Rib_Height];

diff() prismoid(
    size1=outer_bottom_size,
    size2=outer_top_size,
    h=Wall_Height,
    anchor=BOT
  ) {
    position(BOT) up(Base_Thick) {
        tag("keep") position(BACK) fwd(Wall_Base_Width / 2)for (i = [1:Num_Ribs]) {
            fwd(Rib_Spacing * i) prismoid(
                size1=rib_bottom_size,
                size2=rib_top_size,
                h=Rib_Height
              );
          }
        tag("remove") prismoid(
            size1=inner_bottom_size,
            size2=inner_top_size,
            h=Wall_Height - Base_Thick,
            anchor=BOT
          );

      }
  }
