// Garage workbench built-in -- layout v8 (2026-11-25). Inches. DRAFT.
// x = along bench wall, 0 = left end of design = right edge of window-2 trim; panel wall at x=170. y<0 = into room. z = up.
// MEASURED: ceiling 100, window 1 trim 38W (x 78..116), sill 40.5, trim top 86.5; window 2 same size, trim x -38..0
//           (near edge 170" from panel wall). Yukon 46W x 18.25D x 37.125H, vac 16 x 25H, compressor 17 x 17,
//           wrist height 37, old bench 35H x 36D. Existing 15A outlet behind compressor.
// DERIVED:  panel zone 134..170 (NEC 110.26, 36"D x 78"H). Apron removed per user.
// DECIDED:  v8: tall cab 24W x 24D x 94H moved to left end (x 0..24). 4" handle gap. Yukon x 28..74, keeps own top,
//           front flush with bench, parks 11.75 off wall. L top = back strip behind Yukon + main top x 74.125..133.5.
//           Top = doubled 23/32 ply + 1/4 hardboard = 1 11/16, surface 37 1/8. 18W drawer bank at right end of bay.
//           v8.8: sound - 2 all-weather passive speakers on the shelf ends, streaming amp on the shelf (HDMI ARC from TV),
//           8" sealed sub on isolation straps above the compressor; air port moved to x 112. Component sizes TBD.
//           v8.7: 40" TV on a long full-motion arm (30.2" reach) on the back wall between shelf end and panel wall,
//           bottom edge >= 78" (above the panel clear zone); drawn flush. Recessed power/network box behind it.
//           v8.6: front rail/leg set back 1.5" (clamping overhang); vac + air hose grommets through the main top;
//           anti-fatigue mat; folding stool hung on tall cab's left side. No compressor tray.
//           v8.5: LED bar under the shelf full length; outlet strip along the whole backsplash (under window sill) on
//           2 new 20A GFCI circuits from the panel; ABC extinguisher on tall cab's left side; 13-gal trash under window 2.
//           v8.4: one continuous 10"-deep cleat-hung shelf (no brackets), underside at window trim top 86.5, x 24..133.5.
//           v8.2: no uppers; full cleat wall left of window 1 (37 1/8..94). Chemicals go in the tall cabinet's upper doors.
//           Right of window 1: open charging station, 3 Greenworks 40V chargers side by side.
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
CL_X0 = TALL_W; CL_X1 = W1_X0 - 1;                 // cleat wall left of window 1
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
translate([TALL_X0 + TALL_W/2, -TALL_D, 54]) lbl("yard tools; chemicals up top", 1.5, -10);

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
RAIL_SET = 1.5;                                    // front rail + leg set back so clamps grab the front edge anywhere
color("Peru") translate([MAIN_X0, -TOP_D + RAIL_SET, UNDER - 3.5]) cube([DB_X0 - MAIN_X0, 1.5, 3.5]);         // front apron
color("Peru") translate([MAIN_X0, -TOP_D + 0.25 + RAIL_SET, 0]) cube([3.5, 3.5, UNDER - 3.5]);     // front leg by Yukon
color("Peru") translate([TALL_W, -1.5, UNDER - 3.5]) cube([MAIN_X0 - TALL_W, 1.5, 3.5]);           // wall ledger
for (x = [TALL_W, YUK_X0 + 21, MAIN_X0 - 1.5]) color("Peru") translate([x, YUK_Y1 + SEAM, UNDER - 3.5]) cube([1.5, -(YUK_Y1 + SEAM) - 1.5, 3.5]); // arms
translate([104, -TOP_D, TOP_Z + 2]) lbl("top 37 1/8\" flush w/ Yukon top, 30D", 1.6, -6);

// ---------- cleat wall left of window 1 (no uppers): ply backer 37 1/8..86.5 (up to the shelf), 45-deg cleats every 7" ----------
CL_TOP = TRIM_TOP;                                   // meets the shelf / window trim top
color("Wheat") translate([CL_X0, -0.75, TOP_Z]) cube([CL_X1 - CL_X0, 0.75, CL_TOP - TOP_Z]);
for (z = [TOP_Z + 4 : 7 : 82]) color("Peru") translate([CL_X0, -1.5, z]) cube([CL_X1 - CL_X0, 0.75, 2.5]);
translate([(CL_X0 + CL_X1)/2, -2.5, 65]) lbl("cleat wall 53W x 37\"-94\": heavy tools 45-70\"", 1.6, -6);
// charging station right of window 1: ply backer, strip, 3 chargers + batteries, shelf for the spare battery
color("Wheat") translate([W1_X1, -0.75, TOP_Z]) cube([CS_X1 - W1_X1, 0.75, TRIM_TOP - TOP_Z]);
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
// ---------- one continuous cleat-hung shelf: underside flush with window trim top (86.5), 10" deep, tall cab to panel-zone line ----------
// No brackets. Shelf = board + 6" back board with a 45-deg cleat at its top, hung on one long wall cleat (studs + window header).
// Back board bottom bears on the wall above the trim (3/4" spacer), so the whole run is supported continuously.
SH_Z = TRIM_TOP; SH_D = 10; SH_X0 = TALL_W; SH_X1 = MAIN_X1; SH_BACK = 6;
color("BurlyWood") translate([SH_X0, -SH_D, SH_Z]) cube([SH_X1 - SH_X0, SH_D, 0.75]);                              // shelf board
color("BurlyWood") translate([SH_X0, -1.5 - 0.75, SH_Z]) cube([SH_X1 - SH_X0, 0.75, SH_BACK]);                     // back board
color("Peru") translate([SH_X0, -0.75, SH_Z + SH_BACK - 3]) cube([SH_X1 - SH_X0, 0.75, 3]);                        // wall cleat (45 deg)
color("Peru") translate([SH_X0, -1.5, SH_Z + SH_BACK - 3.5]) cube([SH_X1 - SH_X0, 0.75, 3]);                        // mating cleat on back board
for (x = [SH_X0 + 9 : 8.5 : CL_X1 - 8]) color("DarkSlateGray") translate([x, -8.5, SH_Z + 0.75]) cube([7.5, 6, 5]);
translate([(SH_X0 + SH_X1)/2, -SH_D, SH_Z + 9]) lbl("cleat-hung shelf at 86.5\" (window trim top), 10D", 1.6, -4);

// ---------- dimension strip ----------
translate([85, -32, -4]) lbl("tall 24 | gap 4 | Yukon 46 | bay 41 + drawers 18 | 0.5 | panel zone 36  = 170\" to panel wall", 2.2, 0);

// ---------- v8.5 essentials ----------
// LED bar under the shelf, full length, near the front edge
color("WhiteSmoke") translate([SH_X0 + 1, -8.5, SH_Z - 0.6]) cube([SH_X1 - SH_X0 - 2, 1.2, 0.6]);
// outlet strip (plug-mold) along the whole backsplash, 37.75..39 so it clears the window sill (39.5); 2 x 20A GFCI circuits
PM_Z = 37.75;
color("WhiteSmoke") translate([TALL_W + 1, -2.0, PM_Z]) cube([MAIN_X1 - TALL_W - 2, 1.25, 1.25]);
for (x = [TALL_W + 6 : 12 : MAIN_X1 - 4]) color("DimGray") translate([x, -2.1, PM_Z + 0.3]) cube([1.6, 0.2, 0.65]);
translate([104, -2, PM_Z + 3]) lbl("outlet strip full length: 2 x 20A GFCI from panel", 1.4, -3);
// ABC fire extinguisher on the tall cabinet's left side (below window 2 sill), handle at ~40"
color("Red") translate([-3.5, -14, 24]) cylinder(h = 14, r = 2.5, $fn = 24);
color("Black") translate([-3.5, -14, 38]) cylinder(h = 2.5, r = 1.2, $fn = 16);
translate([-3.5, -14, 44]) lbl("ABC extinguisher", 1.4, -6);
// 13-gal trash can on the floor under window 2, left of the tall cabinet
color("DimGray") translate([-16.5, -12, 0]) cube([14, 11, 25]);
translate([-9.5, -12, 28]) lbl("13-gal trash", 1.4, -4);
// ---------- v8.6 ----------
// through-top grommets: vac hose (2.75" hole) and compressor air line (1.5" hole), near the back of the main top
VAC_PORT = [97, -4.5]; AIR_PORT = [112, -4];                 // v8.8: air port moved right to clear the sub
color("Black") translate([VAC_PORT[0], VAC_PORT[1], TOP_Z]) cylinder(h = 0.2, r = 1.375, $fn = 32);
color("Black") translate([AIR_PORT[0], AIR_PORT[1], TOP_Z]) cylinder(h = 0.2, r = 0.75, $fn = 24);
translate([101, -4, TOP_Z + 3]) lbl("vac + air ports", 1.4, -3);
// anti-fatigue mat in front of the main top
color("DarkSlateGray") translate([MAIN_X0 + 2, -(TOP_D + 26), 0]) cube([56, 24, 0.6]);
// folding stool hung on the tall cabinet's left side
color("Black") translate([-2.5, -25, 53]) rotate([0, 90, 0]) cylinder(h = 1, r = 6, $fn = 28);
color("Black") translate([-2, -22.5, 42]) cube([0.6, 1, 22]); color("Black") translate([-2, -16.5, 42]) cube([0.6, 1, 22]);
// ---------- v8.7: 40" TV on long arm, drawn pushed flush ----------
TV_W = 34.9; TV_H = 19.6; TV_X0 = MAIN_X1 + 0.8; TV_Z0 = 78.6;            // x 134.3..169.2, z 78.6..98.2 (above the 78" zone)
color("DimGray") translate([151.75 - 4, -1, 82]) cube([8, 1, 14]);                // arm wall plate, centered 18.25" from panel wall, 89" high
color("White") translate([160, -0.6, 85.5]) cube([4, 0.6, 5]);                     // recessed power + low-voltage box behind TV
color("Black") translate([TV_X0, -3.6 - 2.2, TV_Z0]) cube([TV_W, 2.2, TV_H]);
translate([151.75, -6, TV_Z0 + 10]) lbl("40\" TV, long arm (folds flush)", 1.5, -4);
// ---------- v8.8: sound (placeholder sizes until components are chosen) ----------
SPK = [6.5, 6.5, 10];                                                              // W x D x H, each
color("DimGray") translate([SH_X0 + 1, -8, SH_Z + 0.75]) cube(SPK);                // L speaker, shelf left end
color("DimGray") translate([SH_X1 - 7.5, -8, SH_Z + 0.75]) cube(SPK);             // R speaker, shelf right end
color("Black") translate([CS_X0 + 0.5, -9.2, SH_Z + 0.75]) cube([8.5, 8, 2.5]);    // streaming amp
color("Black") translate([98.6, -12.8, 21]) cube([11, 11, 11]);                    // 8" sealed sub above compressor (isolation straps)
translate([104, -13, 34]) lbl("8in sub (isolated)", 1.3, -4);
