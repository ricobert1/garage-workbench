// Garage workbench built-in -- layout v2 (2026-11-24). Inches. DRAFT.
// x = along bench wall, 0 = left end of 9 ft span; panel wall at x=144. y<0 = into room. z = up.
// MEASURED: ceiling 100, sill 40.5, window trim 38W (x 52..90), trim top 86.5, Yukon 46W x 18.25D x 37.125H,
//           vac 16 x 25H, compressor 17 x 17, wrist height 37. Existing 15A outlet behind compressor.
// DERIVED:  panel zone 108..144 (NEC 36"), tall cab 17W in x 90..107. Apron removed per user.
// ASSUMED:  Yukon look/handles, Yukon wood top 1.75, 12" upper depth, cleat spacing.
// v7 (2026-11-24): option B. Yukon keeps its own top, stays mobile, fronts aligned with bench (parks 11.75 off wall).
//           Fixed L-shaped top = 11.75" back strip behind Yukon + main top over bay; 1/8" roll-clearance seams.
//           Top = doubled 23/32 ply + 1/4 hardboard = 1 11/16. Side handle on outside (x<0).

CEIL = 100; SPAN = 108; WALL_X = 144;
TOP_Z = 37.125; TOP_T = 23/32*2 + 0.25; TOP_D = 30;
YUK_W = 46; YUK_D = 18.25; YUK_H = 37.125; YUK_TOP_T = 1.75;
SEAM = 0.125;                    // roll clearance at Yukon/bench seams
YUK_Y0 = -TOP_D;                 // Yukon front aligned with bench front
YUK_Y1 = YUK_Y0 + YUK_D;         // Yukon back = -11.75
MAIN_X0 = YUK_W + SEAM;          // main top starts right of Yukon
BAY_X0 = 46; BAY_X1 = 90;
TRIM_X0 = 52; TRIM_X1 = 90; SILL = 40.5; TRIM_TOP = 86.5;
TALL_X0 = 90; TALL_W = 17; TALL_D = 24; TALL_H = 94; PLINTH = 4;
UP_X0 = 0; UP_X1 = 51; UP_Z0 = 55; UP_H = 30; UP_D = 12;
gap = 0.125;

billboard = [90, 0, 0];
module lbl(t, sz=2.2, dy=-8) {
  w = len(t) * sz * 0.68 + sz;  h = sz * 1.8;
  translate([0, dy, 0]) rotate(billboard) {
    color("Black") translate([-w/2, -h/2, -0.3]) cube([w, h, 0.2]);
    color("White") linear_extrude(0.2) text(t, size=sz, halign="center", valign="center", font="Liberation Sans:style=Bold");
  }
}

// ---------- room ----------
color("SaddleBrown", 0.55) translate([-30, 0, 0]) cube([WALL_X + 30, 1, CEIL]);
color("Peru", 0.35) translate([WALL_X, -70, 0]) cube([1, 71, CEIL]);
color("Gainsboro", 0.6) translate([-30, -70, -0.5]) cube([WALL_X + 31, 71, 0.5]);
color("White") translate([-30, -2, CEIL]) cube([WALL_X + 31, 3, 0.5]);
// fan window just left of span (position not measured)
color("LightSkyBlue", 0.7) translate([-26, -0.2, SILL]) cube([24, 0.2, 43]);
// spreader window: glass + side/top casing + sill (apron removed)
color("LightSkyBlue", 0.7) translate([TRIM_X0 + 3, -0.2, SILL]) cube([TRIM_X1 - TRIM_X0 - 6, 0.2, TRIM_TOP - 3 - SILL]);
color("Sienna") {
  translate([TRIM_X0, -0.8, SILL]) cube([3, 0.8, TRIM_TOP - SILL]);
  translate([TRIM_X1 - 3, -0.8, SILL]) cube([3, 0.8, TRIM_TOP - SILL]);
  translate([TRIM_X0, -0.8, TRIM_TOP - 3]) cube([TRIM_X1 - TRIM_X0, 0.8, 3]);
  translate([TRIM_X0, -2.5, SILL - 1]) cube([TRIM_X1 - TRIM_X0, 2.5, 1]);
}
// panel + NEC zone
color("DarkGray") translate([WALL_X - 1.5, -28, 48]) cube([1.5, 14, 30]);
color("Red", 0.18) translate([SPAN, -36, 0]) cube([WALL_X - SPAN, 36, 78]);
translate([126, -36, 40]) lbl("KEEP CLEAR", 2.6, -10);
translate([126, -36, 35]) lbl("NEC panel zone", 2, -10);

// ---------- AR origin marker ----------
// Bright L on the floor, outside corner exactly at the back-wall/panel-wall corner (x=144, y=0, z=0),
// i.e. the glTF/USD origin. Arms 12" long, 2" wide, 1" tall. Line this up with the real corner in AR.
MK_L = 12; MK_W = 2; MK_H = 1;
color("Lime") {
  translate([WALL_X - MK_L, -MK_W, 0]) cube([MK_L, MK_W, MK_H]);   // along back wall
  translate([WALL_X - MK_W, -MK_L, 0]) cube([MK_W, MK_L, MK_H]);   // along panel wall
}

// ---------- Yukon chest (owned, mobile) 0..46, front flush with bench ----------
color("Gainsboro") translate([0, YUK_Y0, 0]) cube([YUK_W, YUK_D, YUK_H - YUK_TOP_T]);
color("SandyBrown") translate([0, YUK_Y0, YUK_H - YUK_TOP_T]) cube([YUK_W, YUK_D, YUK_TOP_T]);  // Yukon's own wood top
yd = [4, 4, 4, 6, 8, 8];   // drawer heights (approx)
for (i = [0:len(yd)-1]) {
  z0 = 3 + (i == 0 ? 0 : sumv(yd, i));
  color("Silver") translate([0.5, YUK_Y0 - 0.4, z0 + gap]) cube([YUK_W - 1, 0.4, yd[i] - 2*gap]);
  color("DimGray") translate([4, YUK_Y0 - 1.0, z0 + yd[i] - 1.2]) cube([YUK_W - 8, 0.6, 0.6]);
}
function sumv(v, n) = n == 0 ? 0 : v[n-1] + sumv(v, n-1);
color("DimGray") translate([-3, YUK_Y0 + 4, 30]) cube([3, YUK_D - 8, 1]);                   // side handle, outside (x<0); pos approx
for (x = [2, YUK_W - 4]) color("DimGray") translate([x, YUK_Y1 + 0.25, 0]) cube([2, 1.5, 1]); // floor stops behind rear casters
translate([23, YUK_Y0, 20]) lbl("YUKON 46W (owned, rolls out)", 1.8, -6);

// ---------- open bay 46..90 ----------
color("Tan") translate([BAY_X0, -1.5, 0]) cube([BAY_X1 - BAY_X0, 0.75, TOP_Z - TOP_T]);    // back panel
color("Red") translate([BAY_X0 + 10, -12, 0]) cylinder(h = 25, r = 8, $fn = 40);              // vac
color("Gold") translate([BAY_X0 + 31, -12, 8.5]) rotate([90,0,0]) cylinder(h = 14, r = 8.5, center = true, $fn = 40); // compressor
color("White") translate([BAY_X0 + 31, -1.9, 18]) cube([2.5, 0.5, 4]);                        // existing 15A outlet
translate([68, -24, 22]) lbl("open bay 44W: vac + compressor", 1.6, -10);

// ---------- fixed L top: back strip behind Yukon + main top over bay ----------
color("BurlyWood") {
  translate([0, YUK_Y1 + SEAM, TOP_Z - TOP_T]) cube([MAIN_X0, -(YUK_Y1 + SEAM), TOP_T]);   // back strip x 0..46.125, y -11.625..0
  translate([MAIN_X0, -TOP_D, TOP_Z - TOP_T]) cube([BAY_X1 - MAIN_X0, TOP_D, TOP_T]);     // main top x 46.125..90
}
// support: front rail + front legs (leveling feet not drawn), wall ledger + cantilever arms under back strip
color("Peru") translate([MAIN_X0, -TOP_D, TOP_Z - TOP_T - 3.5]) cube([BAY_X1 - MAIN_X0, 1.5, 3.5]);   // front apron rail 2x4
for (x = [MAIN_X0, BAY_X1 - 3.5]) color("Peru") translate([x, -TOP_D + 0.25, 0]) cube([3.5, 3.5, TOP_Z - TOP_T - 3.5]); // front legs
color("Peru") translate([0, -1.5, TOP_Z - TOP_T - 3.5]) cube([MAIN_X0, 1.5, 3.5]);                       // wall ledger 2x4
for (x = [0, 21, MAIN_X0 - 1.5]) color("Peru") translate([x, YUK_Y1 + SEAM, TOP_Z - TOP_T - 3.5]) cube([1.5, -(YUK_Y1 + SEAM) - 1.5, 3.5]); // arms
translate([68, -TOP_D, TOP_Z + 2]) lbl("top 37 1/8\" flush w/ Yukon top, 30D", 1.6, -6);

// ---------- work wall + uppers 0..51 ----------
color("Wheat") translate([UP_X0, -0.75, TOP_Z]) cube([UP_X1, 0.75, UP_Z0 - TOP_Z]);
for (z = [41 : 5 : 52]) color("Peru") translate([UP_X0, -1.5, z]) cube([UP_X1, 0.75, 2.5]);
color("WhiteSmoke") translate([UP_X0, -2.5, 45.5]) cube([UP_X1, 1.5, 2]);
translate([25.5, -2.5, 50]) lbl("cleats + new 20A strip", 1.6, -4);
up_w = UP_X1 / 2;
for (i = [0:1]) {
  x = UP_X0 + i * up_w;
  color("Tan") translate([x, -UP_D, UP_Z0]) cube([up_w, UP_D, UP_H]);
  color("SlateGray") translate([x + gap, -UP_D - 0.75, UP_Z0 + gap]) cube([up_w/2 - 1.5*gap, 0.75, UP_H - 2*gap]);
  color("SlateGray") translate([x + up_w/2 + 0.5*gap, -UP_D - 0.75, UP_Z0 + gap]) cube([up_w/2 - 1.5*gap, 0.75, UP_H - 2*gap]);
}
translate([25.5, -UP_D, UP_Z0 + UP_H/2]) lbl("uppers 51W x 12D x 30H", 1.8, -10);
for (x = [1 : 12.5 : UP_X1 - 12]) color("DarkSlateGray") translate([x, -11, UP_Z0 + UP_H]) cube([12, 10, 10]);
// shelf above window
color("BurlyWood") translate([TRIM_X0, -10, TRIM_TOP + 2]) cube([TRIM_X1 - TRIM_X0, 10, 0.75]);
translate([71, -10, TRIM_TOP + 6]) lbl("shelf over window", 1.6, -4);

// ---------- tall cabinet 90..107, single door ----------
color("Tan") translate([TALL_X0, -TALL_D, PLINTH]) cube([TALL_W, TALL_D, TALL_H - PLINTH]);
color("DimGray") translate([TALL_X0 + 1, -(TALL_D - 2), 0]) cube([TALL_W - 2, TALL_D - 2, PLINTH]);
color("SlateGray") translate([TALL_X0 + gap, -TALL_D - 0.75, PLINTH + gap]) cube([TALL_W - 2*gap, 0.75, 72 - 2*gap]);
color("SlateGray") translate([TALL_X0 + gap, -TALL_D - 0.75, PLINTH + 72 + gap]) cube([TALL_W - 2*gap, 0.75, TALL_H - PLINTH - 72 - 2*gap]);
color("Silver") translate([TALL_X0 + 1.5, -TALL_D - 1.5, 38]) cube([0.75, 0.75, 10]);
translate([TALL_X0 + TALL_W/2, -TALL_D, 58]) lbl("TALL 17W", 2, -10);
translate([TALL_X0 + TALL_W/2, -TALL_D, 54]) lbl("yard tools", 1.5, -10);
translate([TALL_X0 + TALL_W/2, -TALL_D, 51]) lbl("+ chargers", 1.5, -10);
color("DarkSlateGray") translate([TALL_X0 + 2, -20, TALL_H]) cube([13, 18, CEIL - TALL_H - 0.5]);

// ---------- hose reel on ceiling near door ----------
color("Black") translate([124, -50, CEIL - 10]) rotate([0, 90, 0]) cylinder(h = 10, r = 9, $fn = 40);
translate([129, -50, CEIL - 22]) lbl("hose reel (ceiling)", 1.8, -6);

// ---------- dimension strip ----------
translate([54, -32, -4]) lbl("Yukon 46 | open bay 44 | tall 17 | 1 | panel zone 36  = 144\" to panel wall", 2.2, 0);
