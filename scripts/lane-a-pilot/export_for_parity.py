"""Export every spec, and every SVG the Python renderer produces, for the parity check.

The app's TypeScript renderer must agree with this one BYTE FOR BYTE: the
student only ever sees the TypeScript, the two drift silently, and the protocol
(§6) says to prove a port by parity rather than by inspection. The last batch
agreed 45/45 only after four formatting differences were found this way.

Writes `out/parity/specs.json` (specs in the TypeScript `FigureSpec` shape) and
`out/parity/py/<figure_id>.<layout>.svg`. The TypeScript side of the check is
`tests/figure-parity.ts` in `david-bloom/ap-prep-blueprint`.

    python3 -I scripts/lane-a-pilot/export_for_parity.py
"""
from __future__ import annotations

import json, os, shutil, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import render as R  # noqa: E402

OUT = os.path.join(HERE, "out", "parity")

# The envelope is camelCase in TypeScript; `params` stays exactly as authored,
# because the params types are snake_case on both sides.
ENVELOPE = {
    "figure_id": "figureId", "short_title": "shortTitle", "x_label": "xLabel",
    "y_label": "yLabel", "values_note": "valuesNote", "used_by": "usedBy",
    "y_tick_fmt": "yTickFmt", "x_tick_fmt": "xTickFmt",
    "reference_entry_id": "referenceEntryId", "entry_title": "entryTitle",
}
KEEP = {"family", "title", "subtitle", "caption", "alt", "note", "synthetic",
        "labels", "covers", "params", "unpublished"}


def to_ts(spec: dict) -> dict:
    out = {}
    for k, v in spec.items():
        if k in ENVELOPE:
            out[ENVELOPE[k]] = v
        elif k in KEEP:
            out[k] = v
        # subject_key and the contract bookkeeping are governance-side only and
        # are deliberately not sent: the renderer must not read them.
    for u in out.get("usedBy", []) or []:
        u.pop("labels_carry_contract", None)
        u.pop("contract_note", None)
        u.pop("subject_key", None)
    return out


def main() -> int:
    specs = {k: v for k, v in json.load(
        open(os.path.join(HERE, "specs.json"), encoding="utf-8")).items()
        if not k.startswith("_")}
    shutil.rmtree(OUT, ignore_errors=True)
    os.makedirs(os.path.join(OUT, "py"), exist_ok=True)

    exported = []
    for sid, spec in sorted(specs.items()):
        exported.append(to_ts(spec))
        for lay in ("compact", "full", "expanded"):
            with open(os.path.join(OUT, "py", f"{sid}.{lay}.svg"), "w",
                      encoding="utf-8") as fh:
                fh.write(R.render(spec, lay))
    json.dump(exported, open(os.path.join(OUT, "specs.json"), "w", encoding="utf-8"),
              indent=2, ensure_ascii=False)

    # The app's catalogue.ts is generated separately, by build_catalogue_ts.py,
    # which reads the specs.json this writes.

    fams = sorted({s["family"] for s in exported})
    print(f"{len(exported)} specs, {len(exported)*3} SVGs, {len(fams)} families -> {OUT}")
    print("families:", ", ".join(fams))
    return 0


if __name__ == "__main__":
    sys.exit(main())
