// Garage workbench built-in -- layout v8 (2026-11-25). Inches. DRAFT.
// x = along bench wall, 0 = left end of design = right edge of window-2 trim; panel wall at x=170. y<0 = into room. z = up.
// MEASURED: ceiling 100, window 1 trim 38W (x 78..116), sill 40.5, trim top 86.5; window 2 same size, trim x -38..0
//           (near edge 170" from panel wall). Yukon 46W x 18.25D x 37.125H, vac 16 x 25H, compressor 17 x 17,
//           wrist height 37, old bench 35H x 36D. Existing 15A outlet behind compressor.
// DERIVED:  panel zone 134..170 (NEC 110.26, 36"D x 78"H). Apron removed per user.
// DECIDED:  v8: tall cab 24W x 24D x 94H moved to left end (x 0..24). 4" handle gap. Yukon x 28..74, keeps own top,
//           front flush with bench, parks 11.75 off wall. L top = back strip behind Yukon + main top x 74.125..133.5.
//           Top = doubled 23/32 ply + 1/4 hardboard = 1 11/16, surface 37 1/8. 18W drawer bank at right end of bay.
//           Uppers 53W left of window 1. Right of window 1: open charging station, 3 Greenworks 40V chargers side by side.
//           No ceiling hose reel (deferred until a bigger compressor).
// ASSUMED:  Yukon look/handle position, Yukon wood top 1.75, 12" upper depth, cleat spacing, drawer bank 18W x 24D.

CEIL = 100; WALL_X = 170; ZONE_X = WALL_X - 36;
TOP_Z = 37.125; TOP_T = 23/32*2 + 0.25; TOP_D = 30;
SEAM = 0.125; gap = 0.125; PLINTH = 4;
// tall cabinet
TALL_X0 = 0; TALL_W = 24; TALL_D = 24; TALL_H = 94;
// Yukon
YUK_X0 = 28; YUK_W = 46; YUK_D = 18.25; YUK_H = 37.125; YUK_TOP_T = 1.75;
YUK_Y0 = -TOP_D; YUK_Y1 = YUK_Y0 + YUK_D;          // front -30, back -11.75
// main top + bay
MAIN_X0 = YUK_X0 + YUK_W + SEAM; MAIN_X1 = ZONE_X - 0.5;
DB_W = 18; DB_D = 24; DB_X0 = MAIN_X1 - DB_W;      // drawer bank
// windows
W1_X0 = 78; W1_X1 = 116; W2_X0 = -38; W2_X1 = 0; SILL = 40.5; TRIM_TOP = 86.5;
// uppers
UP_X0 = TALL_W; UP_X1 = W1_X0 - 1; UP_Z0 = 55; UP_H = 30; UP_D = 12;
CS_X0 = W1_X1 + 0.5; CS_X1 = MAIN_X1;                // charging station right of window 1
CH_W = 4.56; CH_H = 6.63; CH_D = 2.83;              // charger (measured), battery 3.2W x 6.38L x 2.06 on its face
BAT_W = 3.2; BAT_L = 6.38; BAT_T = 2.06; CH_Z = 58;
UNDER = TOP_Z - TOP_T;

billboard = [90, 0, 0];
module lbl(t, sz=2.2, dy=-8) {
  w = len(t) * sz * 0.68 + sz;  h = sz * 1.8;
  translate([0, dy, 0]) rotate(billboard) {
    color("Black") translate([-w/2, -h/2, -0.3]) cube([w, h, 0.2]);
    color("White") linear_extrude(0.2) text(t, size=sz, halign="center", valign="center", font="Liberation Sans:style=Bold");
  }
}
module window(x0, x1) {
  color("LightSkyBlue", 0.7) translate([x0 + 3, -0.2, SILL]) cube([x1 - x0 - 6, 0.2, TRIM_TOP - 3 - SILL]);
  color("Sienna") {
    translate([x0, -0.8, SILL]) cube([3, 0.8, TRIM_TOP - SILL]);
    translate([x1 - 3, -0.8, SILL]) cube([3, 0.8, TRIM_TOP - SILL]);
    translate([x0, -0.8, TRIM_TOP - 3]) cube([x1 - x0, 0.8, 3]);
    translate([x0, -2.5, SILL - 1]) cube([x1 - x0, 2.5, 1]);
  }
}
module doors2(x, z, w, h, yfront) {   // pair of doors
  color("SlateGray") translate([x + gap, yfront - 0.75, z + gap]) cube([w/2 - 1.5*gap, 0.75, h - 2*gap]);
  color("SlateGray") translate([x + w/2 + 0.5*gap, yfront - 0.75, z + gap]) cube([w/2 - 1.5*gap, 0.75, h - 2*gap]);
}
function sumv(v, n) = n == 0 ? 0 : v[n-1] + sumv(v, n-1);

// ---------- room ----------
color("SaddleBrown", 0.55) translate([-70, 0, 0]) cube([WALL_X + 70, 1, CEIL]);
color("Peru", 0.35) translate([WALL_X, -70, 0]) cube([1, 71, CEIL]);
color("Gainsboro", 0.6) translate([-70, -70, -0.5]) cube([WALL_X + 71, 71, 0.5]);
color("White") translate([-70, -2, CEIL]) cube([WALL_X + 71, 3, 0.5]);
window(W1_X0, W1_X1);
window(W2_X0, W2_X1);
// panel + NEC zone
color("DarkGray") translate([WALL_X - 1.5, -28, 48]) cube([1.5, 14, 30]);
color("Red", 0.18) translate([ZONE_X, -36, 0]) cube([WALL_X - ZONE_X, 36, 78]);
translate([152, -36, 40]) lbl("KEEP CLEAR", 2.6, -10);
translate([152, -36, 35]) lbl("NEC panel zone", 2, -10);

// ---------- AR origin marker: outside corner at back-wall/panel-wall corner (x=170, y=0, z=0) ----------
MK_L = 12; MK_W = 2; MK_H = 1;
color("Lime") {
  translate([WALL_X - MK_L, -MK_W, 0]) cube([MK_L, MK_W, MK_H]);
  translate([WALL_X - MK_W, -MK_L, 0]) cube([MK_W, MK_L, MK_H]);
}

// ---------- tall cabinet 0..24, two doors (72 + upper) ----------
color("DimGray") translate([TALL_X0 + 1, -(TALL_D - 2), 0]) cube([TALL_W - 2, TALL_D - 2, PLINTH]);
color("Tan") translate([TALL_X0, -TALL_D, PLINTH]) cube([TALL_W, TALL_D, TALL_H - PLINTH]);
doors2(TALL_X0, PLINTH, TALL_W, 72, -TALL_D);
doors2(TALL_X0, PLINTH + 72, TALL_W, TALL_H - PLINTH - 72, -TALL_D);
translate([TALL_X0 + TALL_W/2, -TALL_D, 58]) lbl("TALL 24W x 94H", 2, -10);
translate([TALL_X0 + TALL_W/2, -TALL_D, 54]) lbl("yard tools + chargers", 1.5, -10);

// ---------- Yukon chest (owned, mobile) 28..74, front flush with bench ----------
color("Gainsboro") translate([YUK_X0, YUK_Y0, 0]) cube([YUK_W, YUK_D, YUK_H - YUK_TOP_T]);
color("SandyBrown") translate([YUK_X0, YUK_Y0, YUK_H - YUK_TOP_T]) cube([YUK_W, YUK_D, YUK_TOP_T]);
yd = [4, 4, 4, 6, 8, 8];
for (i = [0:len(yd)-1]) {
  z0 = 3 + (i == 0 ? 0 : sumv(yd, i));
  color("Silver") translate([YUK_X0 + 0.5, YUK_Y0 - 0.4, z0 + gap]) cube([YUK_W - 1, 0.4, yd[i] - 2*gap]);
  color("DimGray") translate([YUK_X0 + 4, YUK_Y0 - 1.0, z0 + yd[i] - 1.2]) cube([YUK_W - 8, 0.6, 0.6]);
}
color("DimGray") translate([YUK_X0 - 3, YUK_Y0 + 4, 30]) cube([3, YUK_D - 8, 1]);                    // side handle, in the 4" gap
for (x = [YUK_X0 + 2, YUK_X0 + YUK_W - 4]) color("DimGray") translate([x, YUK_Y1 + 0.25, 0]) cube([2, 1.5, 1]); // floor stops
translate([YUK_X0 + 23, YUK_Y0, 20]) lbl("YUKON 46W (owned, rolls out)", 1.8, -6);

// ---------- bay: back panel, vac, compressor, outlet, drawer bank ----------
color("Tan") translate([MAIN_X0, -1.5, 0]) cube([DB_X0 - MAIN_X0, 0.75, UNDER - 3.5]);
color("Red") translate([MAIN_X0 + 10, -12, 0]) cylinder(h = 25, r = 8, $fn = 40);                              // vac
color("Gold") translate([MAIN_X0 + 30, -12, 8.5]) rotate([90,0,0]) cylinder(h = 14, r = 8.5, center = true, $fn = 40); // compressor
color("White") translate([MAIN_X0 + 29, -1.9, 18]) cube([2.5, 0.5, 4]);                                     // existing 15A outlet
translate([(MAIN_X0 + DB_X0)/2, -24, 22]) lbl("open bay 41W: vac + compressor", 1.6, -10);
color("DimGray") translate([DB_X0 + 1, -(DB_D - 2), 0]) cube([DB_W - 2, DB_D - 2, PLINTH]);
color("Tan") translate([DB_X0, -DB_D, PLINTH]) cube([DB_W, DB_D, UNDER - PLINTH]);
dbh = [5, 7, 9, UNDER - PLINTH - 21];
for (i = [0:3]) color("SlateGray") translate([DB_X0 + gap, -DB_D - 0.75, PLINTH + sumv(dbh, i) + gap]) cube([DB_W - 2*gap, 0.75, dbh[i] - 2*gap]);
translate([DB_X0 + DB_W/2, -DB_D, 20]) lbl("drawers 18W", 1.6, -10);

// ---------- fixed L top: back strip behind gap + Yukon, main top over bay ----------
color("BurlyWood") {
  translate([TALL_W, YUK_Y1 + SEAM, UNDER]) cube([MAIN_X0 - TALL_W, -(YUK_Y1 + SEAM), TOP_T]);   // back strip x 24..74.125
  translate([MAIN_X0, -TOP_D, UNDER]) cube([MAIN_X1 - MAIN_X0, TOP_D, TOP_T]);                     // main top x 74.125..133.5
}
color("Peru") translate([MAIN_X0, -TOP_D, UNDER - 3.5]) cube([DB_X0 - MAIN_X0, 1.5, 3.5]);         // front apron
color("Peru") translate([MAIN_X0, -TOP_D + 0.25, 0]) cube([3.5, 3.5, UNDER - 3.5]);                // front leg by Yukon
color("Peru") translate([TALL_W, -1.5, UNDER - 3.5]) cube([MAIN_X0 - TALL_W, 1.5, 3.5]);           // wall ledger
for (x = [TALL_W, YUK_X0 + 21, MAIN_X0 - 1.5]) color("Peru") translate([x, YUK_Y1 + SEAM, UNDER - 3.5]) cube([1.5, -(YUK_Y1 + SEAM) - 1.5, 3.5]); // arms
translate([104, -TOP_D, TOP_Z + 2]) lbl("top 37 1/8\" flush w/ Yukon top, 30D", 1.6, -6);

// ---------- work wall + uppers left of window 1 ----------
color("Wheat") translate([UP_X0, -0.75, TOP_Z]) cube([UP_X1 - UP_X0, 0.75, UP_Z0 - TOP_Z]);
for (z = [41 : 5 : 52]) color("Peru") translate([UP_X0, -1.5, z]) cube([UP_X1 - UP_X0, 0.75, 2.5]);
color("WhiteSmoke") translate([UP_X0, -2.5, 45.5]) cube([UP_X1 - UP_X0, 1.5, 2]);
translate([(UP_X0 + UP_X1)/2, -2.5, 50]) lbl("cleats + new 20A strip", 1.6, -4);
up_w = (UP_X1 - UP_X0) / 2;
for (i = [0:1]) {
  x = UP_X0 + i * up_w;
  color("Tan") translate([x, -UP_D, UP_Z0]) cube([up_w, UP_D, UP_H]);
  doors2(x, UP_Z0, up_w, UP_H, -UP_D);
}
translate([(UP_X0 + UP_X1)/2, -UP_D, UP_Z0 + UP_H/2]) lbl("uppers 53W x 12D x 30H", 1.8, -10);
for (x = [UP_X0 + 1 : 12.5 : UP_X1 - 12]) color("DarkSlateGray") translate([x, -11, UP_Z0 + UP_H]) cube([12, 10, 10]);
// charging station right of window 1: ply backer, strip, 3 chargers + batteries, shelf for the spare battery
color("Wheat") translate([W1_X1, -0.75, TOP_Z]) cube([CS_X1 - W1_X1, 0.75, 85 - TOP_Z]);
color("WhiteSmoke") translate([CS_X0 + 1, -2.25, 48]) cube([CS_X1 - CS_X0 - 2, 1.5, 2]);
ch_gap = (CS_X1 - CS_X0 - 3 * CH_W) / 4;
for (i = [0:2]) {
  x = CS_X0 + ch_gap + i * (CH_W + ch_gap);
  color("Black") translate([x, -0.75 - CH_D, CH_Z]) cube([CH_W, CH_D, CH_H]);
  color("LimeGreen") translate([x + (CH_W - BAT_W)/2, -0.75 - CH_D - BAT_T, CH_Z + 0.25]) cube([BAT_W, BAT_T, BAT_L]);
}
color("BurlyWood") translate([CS_X0, -6, 74]) cube([CS_X1 - CS_X0, 5.25, 0.75]);
color("LimeGreen") translate([CS_X0 + 2, -4.5, 74.75]) cube([BAT_W, BAT_T, BAT_L]);
translate([(CS_X0 + CS_X1)/2, -6, 80]) lbl("40V chargers x3", 1.6, -4);
// shelf above window 1
color("BurlyWood") translate([W1_X0, -10, TRIM_TOP + 2]) cube([W1_X1 - W1_X0, 10, 0.75]);
translate([(W1_X0 + W1_X1)/2, -10, TRIM_TOP + 6]) lbl("shelf over window", 1.6, -4);

// ---------- dimension strip ----------
translate([85, -32, -4]) lbl("tall 24 | gap 4 | Yukon 46 | bay 41 + drawers 18 | 0.5 | panel zone 36  = 170\" to panel wall", 2.2, 0);
