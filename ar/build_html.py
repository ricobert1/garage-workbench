"""Write index.html that sits next to workbench.glb + workbench.usdz, for hosting over HTTPS.

Phone AR needs real file URLs: Scene Viewer and Quick Look can't open a data-URI model,
so this page references the files instead of embedding them. Host all three files together
(e.g. a GitHub Pages repo) and open the page on the phone. model-viewer JS loads from Google's CDN.
ar-scale="fixed" locks 1:1 in Scene Viewer, WebXR and Quick Look (no accidental pinch-resize).
"""
from pathlib import Path

HERE = Path(__file__).parent
for f in ("workbench.glb", "workbench.usdz"):
    assert (HERE / f).exists(), f"missing {f}: run build_glb.py and build_usdz.py first"

html = """<!doctype html><html><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Workbench AR 1:1</title>
<script type="module" src="https://ajax.googleapis.com/ajax/libs/model-viewer/4.0.0/model-viewer.min.js"></script>
<style>body{margin:0;background:#111;color:#ddd;font-family:Segoe UI,system-ui,sans-serif}
model-viewer{width:100vw;height:85vh;background:#1b1b1b}p{margin:6px 12px;font-size:13px;line-height:1.4}</style>
</head><body>
<model-viewer src="workbench.glb" ios-src="workbench.usdz"
  ar ar-modes="scene-viewer webxr quick-look" ar-scale="fixed" ar-placement="floor"
  camera-controls shadow-intensity="0.6" camera-orbit="-30deg 75deg auto" exposure="1.1">
</model-viewer>
<p>Tap the AR button. Drag and rotate until the <b>green L</b> sits in the real back-wall/panel-wall
corner, then check the far end (Yukon left edge) against a tape mark before judging clearances.
Red box = NEC 110.26 clear zone. Scale is locked 1:1. DRAFT, not validated.</p>
</body></html>"""
(HERE / "index.html").write_text(html, encoding="utf-8")
print("ok -> index.html (host together with workbench.glb and workbench.usdz)")
