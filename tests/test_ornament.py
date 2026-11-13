"""Render the ornament in a set of cases and check each one's solids and size.

usage: python3 tests/test_ornament.py [OPENSCAD]

Each case renders src/ChristmasNameOrnament.scad to a binary STL with
--hardwarnings, then counts its separate solids (triangles sharing a vertex
belong to the same solid) and measures its bounding box, to within 0.01 mm.

Every case sets both fonts to Liberation Sans. OpenSCAD substitutes another
font for a missing one without a warning, so the sizes below only hold with
Liberation Sans installed, and the script stops first if it isn't.
"""

import json
import os
import struct
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCAD = os.path.join(ROOT, "src", "ChristmasNameOrnament.scad")
PRESETS = os.path.join(ROOT, "src", "ChristmasNameOrnament.json")
FONT = "Liberation Sans"


def measure(path):
    data = open(path, "rb").read()
    (n,) = struct.unpack_from("<I", data, 80)
    parent = {}

    def find(v):
        while parent[v] != v:
            parent[v] = parent[parent[v]]
            v = parent[v]
        return v

    for i in range(n):
        v = struct.unpack_from("<9f", data, 84 + i * 50 + 12)
        corners = [v[0:3], v[3:6], v[6:9]]
        for c in corners:
            parent.setdefault(c, c)
        root = find(corners[0])
        for c in corners[1:]:
            parent[find(c)] = root
    solids = len({find(v) for v in parent})
    size = [max(p[i] for p in parent) - min(p[i] for p in parent) for i in range(3)]
    return solids, size


def literal(value):
    return json.dumps(value) if isinstance(value, str) else str(value)


def render(openscad, out, params, preset=None):
    cmd = [openscad, "--hardwarnings", "--export-format", "binstl", "-o", out]
    if preset:
        cmd += ["-p", PRESETS, "-P", preset]
    fonts = {
        "font_name": 0,
        "other_font": FONT,
        "text2_font": 0,
        "text2_other_font": FONT,
    }
    for name, value in {**fonts, **params}.items():
        cmd += ["-D", f"{name}={literal(value)}"]
    return subprocess.run(cmd + [SCAD], capture_output=True, text=True)


LONG = "Christopher"  # 106.28 mm wide at font_size 15 in Liberation Sans
FLAT = 1.61  # with no background the details sit 0.01 mm below the ring

CASES = [
    # (label, parameters, solids, x, y, z)
    ("defaults", {}, 1, 79, 85, 2),
    ("ball outline", {"part": 1}, 1, 79, 85, 2),
    ("name", {"part": 2}, 1, 73.63, 19.42, 1.6),
    ("additional text", {"part": 3, "text2": "2026"}, 4, 20.71, 6.88, 1.6),
    ("snowflakes", {"part": 4}, 4, 63.75, 74.76, 1.6),
    ("background", {"part": 5}, 1, 75.01, 75.01, 0.4),
    ("long name", {"name": LONG}, 1, 79, 85, 2),
    (
        "long name, fitted to 70 mm",
        {"name": LONG, "part": 2, "line_under_name": "no"},
        12,
        70,
        12.79,
        1.6,
    ),
    ("long name, not fitted", {"name": LONG, "name_max_width": 0}, 3, 106.28, 85, 2),
    ("no background", {"background_thickness": 0}, 1, 79, 85, FLAT),
    # The underline holds the letters to the ring, so it stays when there's
    # no background even if line_under_name says no.
    (
        "no background, underline turned off",
        {"background_thickness": 0, "line_under_name": "no"},
        1,
        79,
        85,
        FLAT,
    ),
]
# With no background only the ring holds the design together, so each flake
# has to reach it from every position.
for flake in range(1, 7):
    spots = {f"position_{p}_flake": flake for p in range(1, 5)}
    CASES.append(
        (f"no background, flake {flake} in every position",
         {"background_thickness": 0, **spots}, 1, 79, 85, FLAT)
    )


def main():
    openscad = sys.argv[1] if len(sys.argv) > 1 else "openscad"
    fonts = subprocess.run(["fc-list", FONT], capture_output=True, text=True)
    if fonts.returncode != 0 or not fonts.stdout.strip():
        sys.exit(f"{FONT} is not installed (fc-list found nothing); "
                 "the expected sizes depend on it.")

    presets = json.load(open(PRESETS))["parameterSets"]
    runs = [(label, params, None, want) for label, params, *want in CASES]
    for name, values in presets.items():
        z = float(values.get("background_thickness", "0.4")) + float(
            values.get("details_thickness", "1.6"))
        if float(values.get("background_thickness", "0.4")) == 0:
            z += 0.01
        runs.append((f"preset: {name}", {}, name, (1, 79, 85, z)))

    failed = 0
    with tempfile.TemporaryDirectory() as tmp:
        out = os.path.join(tmp, "case.stl")
        for label, params, preset, (want_solids, *want_size) in runs:
            result = render(openscad, out, params, preset)
            if result.returncode != 0:
                failed += 1
                errors = [l for l in result.stderr.splitlines()
                          if "WARNING" in l or "ERROR" in l]
                print(f"FAIL {label}: openscad exited {result.returncode}")
                for line in errors:
                    print(f"     {line}")
                continue
            solids, size = measure(out)
            ok = solids == want_solids and all(
                abs(a - b) <= 0.01 for a, b in zip(size, want_size))
            got = f"{solids} solids, {' x '.join(f'{s:.2f}' for s in size)} mm"
            if ok:
                print(f"ok   {label}: {got}")
            else:
                failed += 1
                want = f"{want_solids} solids, {' x '.join(f'{s:.2f}' for s in want_size)} mm"
                print(f"FAIL {label}: {got}; expected {want}")
    print(f"{len(runs) - failed} of {len(runs)} cases passed")
    sys.exit(1 if failed else 0)


main()
