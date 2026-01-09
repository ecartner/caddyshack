#!/usr/bin/env python3

import subprocess
from pathlib import Path
import sys

SCAD_FILE = Path("sp400_lid.scad")
OUT_DIR = Path("out_3mf")
VAR_NAME = "thread_od"
ODS = [18, 20, 22, 24, 28, 30, 33, 35, 38, 40, 43, 45, 48, 51, 53, 58, 60, 63, 66, 70, 75, 77, 83, 89, 100, 110, 120]
OPENSCAD = "/Applications/OpenSCAD.app/Contents/MacOS/openscad"

def run_one(od: int) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    out_file = OUT_DIR / f"sp400Lid_{od}.3mf"
    cmd = [
        OPENSCAD,
        "-o", str(out_file),
        "-D", f"{VAR_NAME}={od}",
        str(SCAD_FILE),
    ]

    print("Running:", " ".join(cmd))
    subprocess.run(cmd, check=True)


def main():
    if not SCAD_FILE.exists():
        print(f"SCAD file not found: {SCAD_FILE}", file=sys.stderr)

    for od in ODS:
        run_one(od)

    print(f"Done. Files are in: {OUT_DIR.resolve()}")

if __name__ == "__main__":
    main()