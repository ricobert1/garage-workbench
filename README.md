# Garage workbench

OpenSCAD layout model of the garage built-in, exported to a 1:1 phone AR model for fit checks.
`workbench_v2.scad` is the source of truth. DRAFT, not field-validated.

## View on a phone
Open the GitHub Pages URL (Settings → Pages), tap the AR button, and line up the **green L**
with the real corner where the back wall meets the panel wall. Scale is locked 1:1.

## Edit
Change `workbench_v2.scad`, commit, push. GitHub Actions rebuilds and republishes in ~2 min
(Actions tab shows progress; the run fails if any `verify.py` check fails).

## Build locally (optional, any OS)
Needs OpenSCAD 2021.01+, Python 3.11+, and bash (Git Bash on Windows; built in on Mac).

```
python -m venv .venv
source .venv/bin/activate        # Windows Git Bash: source .venv/Scripts/activate
pip install -r requirements.txt
cd ar
bash export_parts.sh             # finds openscad on PATH or the default install; else set OPENSCAD=/path
python build_glb.py && python build_usdz.py && python verify.py && python build_html.py
```
Outputs: `ar/workbench.glb` (Android), `ar/workbench.usdz` (iPhone), `ar/index.html`.

## Coordinates
scad: inches, x along bench wall (0 = left end of design at window-2 trim, panel wall at x=170), y<0 into room, z up.
glTF/USD: meters, Y up, origin = floor at the back-wall/panel-wall corner.
