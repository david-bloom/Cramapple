"""Verify the read-only packet and vote artifacts before requesting a write gate."""

import glob
import hashlib
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
packets = [p for name in sorted(glob.glob(str(HERE / "packets_*.json"))) for p in json.loads(Path(name).read_text())]
by_version = {p["v"]: p for p in packets}
decisions = json.loads((HERE / "decisions.json").read_text())
model = decisions["results"]
deterministic = decisions["deterministic"]
all_decisions = model + deterministic

assert len(packets) == len(by_version) == 390
assert Counter(p["t"] for p in packets) == {"mcq": 364, "frq": 26}
assert len(model) == 291 and len(deterministic) == 99
assert len({d["content_item_version_id"] for d in all_decisions}) == 390
assert all(d["outcome"] == "validated" for d in all_decisions)
assert all(d["skill_code"] in {c["c"] for c in by_version[d["content_item_version_id"]]["cands"]} for d in all_decisions)
assert all(len(d["votes"]) == 3 and all("skill_code" in vote for vote in d["votes"].values()) for d in model)
assert Counter(d["agreement"] for d in model) == {"unanimous": 247, "majority_earned": 44}
assert len([d for d in deterministic if len(by_version[d["content_item_version_id"]]["cands"]) == 1]) == 99

ids_md5 = hashlib.md5(",".join(sorted(by_version)).encode()).hexdigest()
assert ids_md5 == "306bfc70759360396c912683cbb68f9a"

baseline = json.loads((HERE / "baseline_cell_counts.json").read_text())
cells = {(r["topic_code"], r["skill_code"]): [r["mcq_n"], r["frq_n"]] for r in baseline}
assert sum(mcq >= 2 and frq >= 1 for mcq, frq in cells.values()) == 12
for d in all_decisions:
    key = (d["topic_code"], d["skill_code"])
    cells.setdefault(key, [0, 0])[0 if by_version[d["content_item_version_id"]]["t"] == "mcq" else 1] += 1
assert len(cells) == 102
assert sum(mcq >= 2 and frq >= 1 for mcq, frq in cells.values()) == 49

sql = (HERE / "write_skill_codes.sql").read_text()
for guard in ("ci.status = 'published'", "civ.status = 'published'", "prim.topic_code = proposed.topic_code", "inserted_count <> 390"):
    assert guard in sql, guard

print("PASS: 390 unique, allowed decisions; 291 complete three-model votes; 99 deterministic")
print("PASS: packet IDs match post-run Production missing-set digest", ids_md5)
print("Projected inventory-threshold cells: 12 baseline -> 49 after approved write")
