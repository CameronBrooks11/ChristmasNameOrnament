// Christmas Name Ornament: a flat ball ornament with a name across it, up to four
// snowflakes and an optional second line of text. Each part exports on its own, for
// printing in more than one colour. MIT licence; see LICENSE.

/* [Basic Parameters] */
// The name across the ornament
name = "Lyle";
// Height of the name, ring, underline and snowflakes above the background (mm)
details_thickness = 1.6; // [1:0.01:10]
// Thickness of the disc behind the details; 0 leaves it out (mm)
background_thickness = 0.4; // [0:0.01:5]
// A bar under the name, across the ball. Always drawn when there is no background
line_under_name = "yes"; // [yes, no]

/* [Font Parameters] */
// Height of the name's letters
font_size = 15; // [5:1:30]
// A wider name is scaled down to this width, keeping its proportions; 0 turns this off (mm)
name_max_width = 70; // [0:1:79]
// Font for the name; "other" uses the font named below
font_name = 3; // [0:other, 1:Arial Black, 2:Arial Bold Italic, 3:Berkshire Swash, 4:Courgette, 5:Sriracha, 6:Yellowtail, 7:Tangerine, 8:Parisienne, 9:Italianno]
// Any installed font, as fontconfig names it, for font_name "other"
other_font = "Nunito Sans";

/* [Flake Parameters] */
// Snowflake at the upper left; 0 for none
position_1_flake = 5; // [0:6]
// Snowflake at the upper right; 0 for none
position_2_flake = 1; // [0:6]
// Snowflake at the lower left; 0 for none
position_3_flake = 6; // [0:6]
// Snowflake at the lower right; 0 for none
position_4_flake = 3; // [0:6]

/* [Advanced Parameters] */
// Move the name left or right (mm)
name_X_offset = 0; // [-10:0.1:10]
// Move the name up or down (mm)
name_Y_offset = 0; // [-1:0.1:10]
// Which part to draw, for exporting one colour at a time
part = 6; // [1:Ball outline, 2:Name, 3:Additional Text, 4:Snowflakes, 5:Background, 6:Everything]
// Preview colours: one colour change, or one colour per part
preview_colors = 1; // [1:one nozzle, 2:multiple nozzles]

/* [Optional Additional Text Parameters] */
// A second line of text, such as a year; empty for none
text2 = "";
// Height of the second line's letters
text2_font_size = 7; // [4:1:30]
// Font for the second line; "other" uses the font named below
text2_font = 4; // [0:other, 1:Arial Black, 2:Arial Bold Italic, 3:Berkshire Swash, 4:Courgette, 5:Sriracha, 6:Yellowtail, 7:Tangerine, 8:Parisienne, 9:Italianno]
// Any installed font, for text2_font "other"
text2_other_font = "Nunito Sans";
// Move the second line left or right (mm)
text2_X_offset = 0; // [-20:0.1:20]
// Move the second line up or down (mm)
text2_Y_offset = 0; // [-40:0.1:50]

/* [Hidden] */
$fn = 96;

FONTS = ["", "Arial Black", "Arial:style=Bold Italic", "Berkshire Swash", "Courgette", "Sriracha",
         "Yellowtail", "Tangerine", "Parisienne", "Italianno"];
function font(choice, other) = choice == 0 ? other : FONTS[choice];

// The ball: a ring around a background disc, and a tab with a hole to hang it by.
BALL_R = 39.5;
RING_W = 2;
INNER_R = BALL_R - RING_W;
TAB_W = 10;
TAB_TOP = 45.5;   // 85 mm from the bottom of the ball
HOLE_D = 3;
UNDERLINE_W = 2;
// The name's baseline, before name_Y_offset; the underline sits just below it.
NAME_BASE = -4;
// A tiny solid inside the ring, exported in place of an empty part.
PLACEHOLDER = 0.01;

has_background = background_thickness > 0;
z0 = background_thickness;
underline = line_under_name == "yes" || !has_background;

// ---------------- Shapes, in 2D ----------------

module ring_2d() {
  difference() {
    union() {
      circle(r = BALL_R);
      // The tab: a stem up from the ball, rounded at the top.
      hull() {
        translate([-TAB_W / 2, INNER_R]) square([TAB_W, 1]);
        translate([0, TAB_TOP - TAB_W / 2]) circle(d = TAB_W);
      }
    }
    circle(r = INNER_R);
    translate([0, TAB_TOP - TAB_W / 2]) circle(d = HOLE_D);
  }
}

module name_2d() {
  f = font(font_name, other_font);
  width = textmetrics(name, size = font_size, font = f, halign = "center").size.x;
  s = (name_max_width > 0 && is_num(width) && width > name_max_width) ? name_max_width / width : 1;
  translate([name_X_offset, NAME_BASE + name_Y_offset]) scale(s)
    text(name, size = font_size, font = f, halign = "center", valign = "baseline");
  if (underline)
    // A chord of the ring under the name, its ends inside the ring so it joins it.
    intersection() {
      circle(r = INNER_R + RING_W / 2);
      translate([-BALL_R, NAME_BASE + name_Y_offset - UNDERLINE_W]) square([2 * BALL_R, UNDERLINE_W]);
    }
}

module text2_2d() {
  translate([text2_X_offset, text2_Y_offset])
    text(text2, size = text2_font_size, font = font(text2_font, text2_other_font),
         halign = "center", valign = "center");
}

// A six-armed snowflake of radius r, one arm along +x. Each arm carries `branches`
// pairs of side branches at `angle` to it, each `reach` times the arm's length
// at its root and shorter toward the tip; `w` is the stroke width and `hub` the
// radius of the solid centre.
module flake_2d(r, branches, angle, reach, w, hub) {
  module stroke(a, b) hull() { translate(a) circle(d = w, $fn = 16); translate(b) circle(d = w, $fn = 16); }
  for (k = [0:5]) rotate(60 * k) {
    stroke([0, 0], [r, 0]);
    for (i = [1:branches]) {
      x = r * i / (branches + 1);
      len = r * reach * (1 - (i - 1) / (branches + 1));
      for (s = [-1, 1]) stroke([x, 0], [x + len * cos(angle), s * len * sin(angle)]);
    }
  }
  circle(r = hub, $fn = 6);
}

// The six designs: [radius, branches, angle, reach, stroke width, hub].
FLAKES = [
  [12, 2, 45, 0.45, 1.4, 2.5],   // 1: two broad branches
  [12, 3, 60, 0.30, 1.2, 1.8],   // 2: three fine branches, wide angle
  [13, 1, 35, 0.55, 1.8, 3.2],   // 3: one long branch, a heavy hub
  [12, 4, 50, 0.22, 1.1, 2.0],   // 4: four short branches, fern-like
  [11.5, 2, 70, 0.40, 1.6, 2.8], // 5: two branches almost square to the arm
  [13, 3, 30, 0.38, 1.2, 1.4],   // 6: three swept-back branches, a small hub
];

// Where each position's flake sits, as an angle and a distance from the centre.
POSITIONS = [[130, 27], [50, 27], [230, 27], [310, 27]];
FLAKE_CHOICES = [position_1_flake, position_2_flake, position_3_flake, position_4_flake];

module flakes_2d() {
  for (p = [0:3]) if (FLAKE_CHOICES[p] > 0) {
    d = FLAKES[FLAKE_CHOICES[p] - 1];
    a = POSITIONS[p][0];
    // One arm points straight at the ring, which it reaches from every position, so a
    // flake holds on with no background. Anything past the ring is trimmed away.
    intersection() {
      circle(r = INNER_R + RING_W / 2);
      rotate(a) translate([POSITIONS[p][1], 0]) flake_2d(d[0], d[1], d[2], d[3], d[4], d[5]);
    }
  }
}

assert(len([for (p = POSITIONS) if (p[1] + min([for (f = FLAKES) f[0]]) <= INNER_R) 1]) == 0,
       "a snowflake would not reach the ring");

// ---------------- Parts, in 3D ----------------

module details(colour) color(colour) translate([0, 0, z0]) linear_extrude(details_thickness) children();
module placeholder() translate([0, -INNER_R + 1, z0]) cube(PLACEHOLDER);

ONE = ["silver", "silver", "silver", "silver", "firebrick"];
MANY = ["silver", "gold", "white", "lightblue", "firebrick"];
COLOURS = preview_colors == 1 ? ONE : MANY;

// The ring stands on the bed beside the background disc, so it runs the full height.
module ball_part() color(COLOURS[0]) linear_extrude(z0 + details_thickness) ring_2d();
module name_part() details(COLOURS[1]) name_2d();
module text2_part() if (text2 != "") details(COLOURS[2]) text2_2d(); else placeholder();
module flakes_part() details(COLOURS[3]) flakes_2d();
module background_part()
  if (has_background) color(COLOURS[4]) linear_extrude(background_thickness) circle(r = INNER_R + PLACEHOLDER);
  else placeholder();

if (part == 1) ball_part();
else if (part == 2) name_part();
else if (part == 3) text2_part();
else if (part == 4) flakes_part();
else if (part == 5) background_part();
else if (part == 6) {
  ball_part();
  name_part();
  if (text2 != "") text2_part();
  flakes_part();
  if (has_background) background_part();
}
else assert(false, str("part must be 1 to 6, not ", part));
