"""workbench.glb -> workbench.usdz (iPhone Quick Look AR). Meters, Y-up, UsdPreviewSurface."""
from pathlib import Path
import trimesh
from pxr import Usd, UsdGeom, UsdShade, Sdf, Gf, UsdUtils, Vt

HERE = Path(__file__).parent
scene = trimesh.load(HERE / "workbench.glb")
usda = HERE / "_workbench.usdc"
stage = Usd.Stage.CreateNew(str(usda))
UsdGeom.SetStageUpAxis(stage, UsdGeom.Tokens.y)
UsdGeom.SetStageMetersPerUnit(stage, 1.0)
root = UsdGeom.Xform.Define(stage, "/Workbench")
stage.SetDefaultPrim(root.GetPrim())

for i, (node, (T, gname)) in enumerate(
        ((n, scene.graph[n]) for n in scene.graph.nodes_geometry)):
    g = scene.geometry[gname].copy()
    g.apply_transform(T)
    safe = "".join(c if c.isalnum() else "_" for c in gname)
    path = f"/Workbench/g{i}_{safe}"
    mesh = UsdGeom.Mesh.Define(stage, path)
    mesh.CreatePointsAttr(Vt.Vec3fArray([Gf.Vec3f(*map(float, v)) for v in g.vertices]))
    mesh.CreateFaceVertexCountsAttr(Vt.IntArray([3] * len(g.faces)))
    mesh.CreateFaceVertexIndicesAttr(Vt.IntArray(g.faces.flatten().tolist()))
    mesh.CreateDoubleSidedAttr(True)
    mesh.CreateSubdivisionSchemeAttr("none")

    mat_src = g.visual.material
    rgba = [float(c) for c in mat_src.baseColorFactor]
    if max(rgba) > 1.0:
        rgba = [c / 255.0 for c in rgba]
    mat = UsdShade.Material.Define(stage, path + "_mat")
    sh = UsdShade.Shader.Define(stage, path + "_mat/pbr")
    sh.CreateIdAttr("UsdPreviewSurface")
    sh.CreateInput("diffuseColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(*rgba[:3]))
    sh.CreateInput("opacity", Sdf.ValueTypeNames.Float).Set(rgba[3])
    sh.CreateInput("roughness", Sdf.ValueTypeNames.Float).Set(0.8)
    sh.CreateInput("metallic", Sdf.ValueTypeNames.Float).Set(0.0)
    mat.CreateSurfaceOutput().ConnectToSource(sh.ConnectableAPI(), "surface")
    UsdShade.MaterialBindingAPI.Apply(mesh.GetPrim()).Bind(mat)

stage.GetRootLayer().Save()
out = HERE / "workbench.usdz"
ok = UsdUtils.CreateNewARKitUsdzPackage(str(usda), str(out))
print("usdz ok" if ok else "usdz FAILED", out, f"{out.stat().st_size/1e6:.2f} MB")
