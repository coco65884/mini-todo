#!/bin/bash
set -euo pipefail

# Generate a simple app icon using macOS built-in tools
ICON_DIR="$(dirname "$0")/../Assets/AppIcon.appiconset"
mkdir -p "${ICON_DIR}"

# Create icon using Python with AppKit
python3 << 'PYTHON'
import subprocess, os

icon_dir = os.path.join(os.path.dirname(os.path.abspath("scripts/generate-icon.sh")), "Assets", "AppIcon.appiconset")
os.makedirs(icon_dir, exist_ok=True)

sizes = [16, 32, 64, 128, 256, 512, 1024]

for size in sizes:
    svg = f'''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {size} {size}" width="{size}" height="{size}">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#4A90D9"/>
      <stop offset="100%" style="stop-color:#357ABD"/>
    </linearGradient>
  </defs>
  <rect width="{size}" height="{size}" rx="{size*0.2}" fill="url(#bg)"/>
  <text x="50%" y="55%" text-anchor="middle" dominant-baseline="middle"
        font-family="-apple-system,Helvetica" font-weight="bold"
        font-size="{size*0.45}" fill="white">✓</text>
</svg>'''
    svg_path = os.path.join(icon_dir, f"icon_{size}.svg")
    png_path = os.path.join(icon_dir, f"icon_{size}.png")
    with open(svg_path, "w") as f:
        f.write(svg)
    subprocess.run(["sips", "-s", "format", "png", "--resampleWidth", str(size),
                    svg_path, "--out", png_path],
                   capture_output=True)
    os.remove(svg_path)

# Create Contents.json
import json
contents = {"images": [], "info": {"version": 1, "author": "xcode"}}
size_map = {16: "16x16", 32: "16x16", 64: "32x32", 128: "128x128", 256: "128x128", 512: "256x256", 1024: "512x512"}
scale_map = {16: "1x", 32: "2x", 64: "2x", 128: "1x", 256: "2x", 512: "1x", 1024: "2x"}
for s in sizes:
    contents["images"].append({
        "filename": f"icon_{s}.png",
        "idiom": "mac",
        "scale": scale_map[s],
        "size": size_map[s]
    })
with open(os.path.join(icon_dir, "Contents.json"), "w") as f:
    json.dump(contents, f, indent=2)

print("Icons generated.")
PYTHON
