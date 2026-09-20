#!/usr/bin/env python3
"""Emit the AP Stats Unit-1 pilot item-packages (10 cells) into ./out for the F4
loader. Uses the SAME seed basis as the D8 review pack so the SERVED items are the
REVIEWED items, and fresh seeds (90000+) so content_keys don't collide with the
items already loaded on Dev (fail-closed loader). Pilot-scoped: clears prior
non-pilot sample JSON so the load carries only the 10 pilot cells.

Run from scripts/course_mode_stats_generator/:  python3 emit_pilot.py
Then:  python3 build_load_sql.py --check  &&  python3 build_load_sql.py
"""
import glob, json, os, random
from pathlib import Path
import generator, slot_frames

OUT = Path(__file__).resolve().parent / "out"
OUT.mkdir(parents=True, exist_ok=True)
N = 20  # per cell (== D8 pack sample; CM-D19 will stamp exactly the reviewed set)

def is_valid(inst):
    return all(ok for _n, ok in inst["_property_checks"])

def write(inst):
    pkg = {k: v for k, v in inst.items() if k != "_property_checks"}
    (OUT / f"{inst['package_id']}.json").write_text(json.dumps(pkg, indent=2))

# 1) clear prior item-package JSON (keep the F1 registry seed); pilot-only load
removed = 0
for f in glob.glob(str(OUT / "*.json")):
    if Path(f).name.startswith("f1_"):
        continue
    os.remove(f); removed += 1

# 2) computational pilot cells (1.7x3.B, 1.9x3.B) — match D8 pack: base_seed 90000
emitted = 0
for proc in ("summary_stats", "compare_stats"):
    for inst in generator.generate_valid(proc, N, base_seed=90000):
        assert is_valid(inst)
        write(inst); emitted += 1

# 3) conceptual slot-frame pilot cells (the 8 FRAMES) — match D8 pack: base_seed + 90000
for spec in slot_frames.FRAMES:
    raw = spec["gen"](N * 3, spec["base_seed"] + 90000)
    valid = [i for i in raw if is_valid(i)][:N]
    assert len(valid) == N, f"{spec['frame_id']} only produced {len(valid)} valid"
    for inst in valid:
        write(inst); emitted += 1

# 4) report the cell coverage of what we just emitted
cells = {}
for f in glob.glob(str(OUT / "*.json")):
    if Path(f).name.startswith("f1_"):
        continue
    d = json.loads(Path(f).read_text())
    for c in d.get("cells", []):
        cells[f"{c['topic']}x{c['skill']}"] = cells.get(f"{c['topic']}x{c['skill']}", 0) + 1

print(f"removed {removed} prior json; emitted {emitted} pilot packages")
print("cell coverage:", json.dumps(dict(sorted(cells.items())), indent=0))
