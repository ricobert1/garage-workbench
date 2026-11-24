#!/usr/bin/env bash
# Export workbench_v2.scad as one STL per color group (OpenSCAD 2021 drops color on STL).
# Rewrites color("X"[,a]) -> csel("X") which renders children only when X == SEL.
# Labels (lbl module) and room shell (walls/floor/ceiling) are skipped: real room supplies them in AR.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/../workbench_v2.scad"
# OpenSCAD binary: env OPENSCAD wins, else PATH, else common Windows/Mac install spots
OS="${OPENSCAD:-$(command -v openscad || true)}"
for c in "/c/Program Files/OpenSCAD/openscad.com" "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"; do
  [ -z "$OS" ] && [ -x "$c" ] && OS="$c"
done
[ -n "$OS" ] || { echo "openscad not found: install it or set OPENSCAD=/path/to/openscad"; exit 1; }
TMP="$HERE/_sel.scad"
mkdir -p "$HERE/stl"

# 1) neutralize labels, 2) drop room-shell lines, 3) swap color() for selector
sed -E \
  -e 's/^module lbl\(.*$/module lbl(t, sz=2.2, dy=-8) {}\nmodule lbl_unused(t, sz=2.2, dy=-8) {/' \
  -e '/^color\("SaddleBrown", 0.55\)/d' \
  -e '/^color\("Peru", 0.35\)/d' \
  -e '/^color\("Gainsboro", 0.6\)/d' \
  -e '/^color\("White"\) translate\(\[-30, -2, CEIL\]\)/d' \
  -e '/fan window/,+1d' \
  -e 's/color\("([A-Za-z]+)"(, *[0-9.]+)?\)/csel("\1")/g' \
  "$SRC" > "$TMP"
printf '\nSEL = "";\nmodule csel(c) { if (c == SEL) children(); }\n' >> "$TMP"

COLORS=$(grep -oE 'csel\("[A-Za-z]+"\)' "$TMP" | sed -E 's/csel\("(.*)"\)/\1/' | sort -u)
for c in $COLORS; do
  "$OS" -o "$HERE/stl/$c.stl" -D "SEL=\"$c\"" "$TMP" 2>&1 | grep -i "error" || true
  [ -s "$HERE/stl/$c.stl" ] && echo "ok  $c" || echo "EMPTY $c"
done
