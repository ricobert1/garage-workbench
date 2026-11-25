"""Assert key dims in exported GLB/USDZ match workbench_v2.scad v8 (inches). Expect 19/19."""
from pathlib import Path
import numpy as np, trimesh
from pxr import Usd, UsdGeom

HERE = Path(__file__).parent
IN = 0.0254
PX = 170.0   # panel wall x in scad frame
s = trimesh.load(HERE / "workbench.glb")
geo = {n: s.geometry[g].copy().apply_transform(T) for n, (T, g) in
       ((n, s.graph[n]) for n in s.graph.nodes_geometry)}

def bb(name):  # back to scad frame: x_scad = x+PX, y_scad = -z, z_scad = y
    b = geo[name].bounds / IN
    return np.array([[b[0,0]+PX, -b[1,2], b[0,1]], [b[1,0]+PX, -b[0,2], b[1,1]]]).round(3)

checks = []
def chk(label, got, want, tol=0.01):
    ok = abs(got - want) <= tol; checks.append(ok)
    print(f"{'PASS' if ok else 'FAIL'}  {label}: got {got:.3f} want {want}")

# bench top pieces = BurlyWood parts below 60" (window shelf is above)
tops = [p for p in geo["BurlyWood"].split(only_watertight=False) if p.bounds[1,1] / IN < 60]
chk("bench top z max (37 1/8)", max(p.bounds[1,1] for p in tops) / IN if tops else -1, 37.125)
chk("bench top right end clear of panel zone (133.5)", max(p.bounds[1,0] for p in tops) / IN + PX, 133.5)
chk("bench top left end at tall cab (24)", min(p.bounds[0,0] for p in tops) / IN + PX, 24)
# tall cab: only Tan geometry above 86" is the tall cabinet carcass
v = geo["Tan"].vertices / IN
v = v[v[:,1] > 86]
tall = np.array([v.min(0), v.max(0)])
chk("tall cab x0", tall[0,0] + PX, 0); chk("tall cab x1", tall[1,0] + PX, 24)
chk("tall cab top", tall[1,1], 94); chk("tall cab depth", tall[1,2] - tall[0,2], 24)
yuk = bb("Gainsboro")
chk("Yukon x0", yuk[0,0], 28); chk("Yukon width", yuk[1,0] - yuk[0,0], 46)
chk("Yukon front flush w/ bench front (y)", yuk[0,1], -30); chk("Yukon back (y)", yuk[1,1], -11.75)
ytop = bb("SandyBrown"); chk("Yukon top z == bench top z", ytop[1,2], 37.125)
zone = [g for n, g in geo.items() if n.startswith("NEC")][0].bounds / IN
chk("NEC zone x0", zone[0,0] + PX, 134); chk("NEC zone depth", zone[1,2] - zone[0,2], 36)
mk = bb("Lime")
chk("marker at panel wall (x)", mk[1,0], PX); chk("marker at back wall (y)", mk[1,1], 0)
chk("marker on floor (z)", mk[0,2], 0)

st = Usd.Stage.Open(str(HERE / "workbench.usdz"))
n_mesh = sum(1 for p in st.Traverse() if p.IsA(UsdGeom.Mesh))
chk("usdz mesh count == glb", n_mesh, len(geo), 0)
chk("usdz metersPerUnit", UsdGeom.GetStageMetersPerUnit(st), 1.0)
print(f"\n{sum(checks)}/{len(checks)} pass")
