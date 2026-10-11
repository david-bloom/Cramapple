# Lane A pilot

Spec -> SVG, deterministically, with no dependencies and no model at render time.
Measures the TASK-0006 Lane A approach on AP Chemistry's 10 Lane A reference entries.

    python3 -I scripts/lane-a-pilot/verify.py

Renders every spec to `out/`, runs 184 domain/geometry/structure checks, writes
`out/results.json`, and exits non-zero on any failure.

- `render.py`  6 chart families; the chemistry lives here, once.
- `specs.json` one spec per entry (~1 KB each); `covers` lists the authored
  `items[]` labelled parts that figure must render.
- `verify.py`  the checks. Coverage is asserted per ENTRY, so an entry whose
  labelled parts span two charts passes only when both exist.

Results and limitations: `docs/product/LANE_A_PILOT_RESULTS_2026_10_10.md`.
Not wired to any database; not published; Python, not yet the app's TypeScript.
