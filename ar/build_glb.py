"""Combine per-color STLs -> workbench.glb (1:1 meters, Y-up).

OpenSCAD frame: inches, x along bench wall, y<0 into room, z up.
glTF frame: meters, Y up, -Z forward.  Map (x, y, z)in -> (x, z, -y) * 0.0254.
Origin shifted to floor at back-wall / panel-wall corner (x=170, y=0, z=0) so the
anchor is a real, findable point in the garage. The Lime L-marker sits exactly there.
"""
from pathlib import Path
import numpy as np
import trimesh

HERE = Path(__file__).parent
IN2M = 0.0254
PANEL_X = 170.0

RGBA = {  # CSS named colors (+ scad alpha where used)
    "Black": (0, 0, 0, 255), "BurlyWood": (222, 184, 135, 255),
    "DarkGray": (169, 169, 169, 255), "DarkSlateGray": (47, 79, 79, 255),
    "DimGray": (105, 105, 105, 255), "Gainsboro": (220, 220, 220, 255),
    "Gold": (255, 215, 0, 255), "LightSkyBlue": (135, 206, 250, 180),
    "Lime": (0, 255, 0, 255),  # AR origin marker
    "SandyBrown": (244, 164, 96, 255),  # Yukon's own wood top
    "Peru": (205, 133, 63, 255), "Red": (255, 0, 0, 255),
    "Sienna": (160, 82, 45, 255), "Silver": (192, 192, 192, 255),
    "SlateGray": (112, 128, 144, 255), "Tan": (210, 180, 140, 255),
    "Wheat": (245, 222, 179, 255), "White": (255, 255, 255, 255),
    "WhiteSmoke": (245, 245, 245, 255),
}

# scad -> glTF transform
M = np.array([[1, 0, 0, -PANEL_X],
              [0, 0, 1, 0],
              [0, -1, 0, 0],
              [0, 0, 0, 1]], float)
M[:3, :] *= IN2M

scene = trimesh.Scene()
for stl in sorted((HERE / "stl").glob("*.stl")):
    name = stl.stem
    m = trimesh.load_mesh(stl)
    m.apply_transform(M)
    rgba = RGBA[name]
    if name == "Red":
        # split vac (opaque) from NEC zone box (translucent) by connected component
        parts = m.split(only_watertight=False)
        for i, p in enumerate(parts):
            ext = p.extents / IN2M
            zone = ext.max() > 40  # NEC zone ~36x78x36 in; vac 16x25x16
            c = (255, 0, 0, 60) if zone else rgba
            p.visual = trimesh.visual.ColorVisuals(p, face_colors=c)
            scene.add_geometry(p, geom_name=f"{'NEC_zone' if zone else 'vac'}_{i}")
        continue
    m.visual = trimesh.visual.ColorVisuals(m, face_colors=rgba)
    scene.add_geometry(m, geom_name=name)

# PBR materials so alpha survives export
for g in scene.geometry.values():
    fc = g.visual.face_colors[0]
    mat = trimesh.visual.material.PBRMaterial(
        baseColorFactor=fc / 255.0, metallicFactor=0.0, roughnessFactor=0.8,
        alphaMode="BLEND" if fc[3] < 255 else "OPAQUE", doubleSided=True)
    g.visual = trimesh.visual.TextureVisuals(material=mat)

out = HERE / "workbench.glb"
scene.export(out)
b = scene.bounds / IN2M
print(f"wrote {out}  ({out.stat().st_size/1e6:.2f} MB)")
print("bounds in (x, y-up, z):", np.round(b, 2).tolist())
print("extent in:", np.round(scene.extents / IN2M, 2).tolist())
