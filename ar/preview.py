"""Quick matplotlib render of workbench.glb in its own (glTF) frame to eyeball orientation/colors."""
from pathlib import Path
import trimesh, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

HERE = Path(__file__).parent
s = trimesh.load(HERE / "workbench.glb")
fig = plt.figure(figsize=(10, 7)); ax = fig.add_subplot(projection="3d")
for n in s.graph.nodes_geometry:
    T, g = s.graph[n]; m = s.geometry[g].copy().apply_transform(T)
    c = m.visual.material.baseColorFactor
    c = c / 255 if c.max() > 1 else c
    tri = m.vertices[m.faces] / 0.0254
    # plot glTF (x, y-up, z) as (x, z, y) so matplotlib z = up
    ax.add_collection3d(Poly3DCollection(tri[:, :, [0, 2, 1]], facecolor=c, edgecolor="none"))
ax.set_xlim(-144, 0); ax.set_ylim(0, 72); ax.set_zlim(0, 100)
ax.set_box_aspect((144, 72, 100)); ax.view_init(elev=20, azim=-60)
ax.set_xlabel("x in (0 = panel wall)"); ax.set_ylabel("+z = into room"); ax.set_zlabel("up")
fig.savefig(HERE / "preview_glb.png", dpi=110, bbox_inches="tight")
