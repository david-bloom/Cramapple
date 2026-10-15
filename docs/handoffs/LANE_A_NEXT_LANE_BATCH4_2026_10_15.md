# Next figure lane, batch 4: a log axis for Precalculus 2.15 and a diprotic titration for Chemistry 8.5

**STATUS:** built and verified in both renderers; **not loaded to Development or Production, app change not merged or published.** **Gate 4c is VOID** (one control was accepted by one reader), so the batch cannot be loaded as it stands. A Production load needs the three things in "To release" below.
**DATE:** 2026-10-15. **Ruling:** the Product Owner's 2026-10-15 "Fix the renderer to address precalculus 2.15 and other", read as the two section-4 renderer extensions of `LANE_A_GAP_CLASSIFICATION_2026_10_11.md`. The section-3 items that need new families (Statistics 2.8 and 2.12, Chemistry 5.3 and 3.11) are NOT in this batch.

## What was built

| Figure | Entry | Family | What it shows |
|---|---|---|---|
| `precalc-semilog-plot` | Precalculus 2.15 "Semi-log plot" (vocabulary, no `items[]`) | `xy_series`, new `y_scale: "log"` | Seven exact exponential points (y = 5 * 2^x) on a log y axis marked 1, 10, 100, 1,000: one straight line |
| `precalc-semilog-justify` | Precalculus 2.15 "Using a semi-log plot to justify an exponential model" (convention, no `items[]`) | `xy_series`, `y_scale: "log"` | Nine points; from x = 3 they sit on the least-squares line, the first two sit above it, and the note says the model is still justified |
| `chem-polyprotic-titration` | Chemistry 8.5 "Polyprotic acid titration curves" (3 authored items) | `titration_curve`, new diprotic branch (`pkas`) | A diprotic acid with a strong base: two equivalence points (25 and 50 mL), pKa1 4.0 and pKa2 9.0 read at the half-equivalence points, and the major species named along the curve |

Both Precalculus figures are route (b) under `DECISION-0116` (labels carry the contract, declared per use). The Chemistry figure covers the three authored items.

## Renderer changes (reference `render.py`, app `render.ts`, `maths.ts`, `types.ts`)

- **Log axis.** Values go through log10 when the geometry is built, so the shared drawing code keeps one linear mapping; tick labels read 1, 10, 100, 1,000 at equal spacing. A ticks list may now hold `[position, label]` pairs. A log axis rejects non-positive values, `fill_under`, and hand-set ticks.
- **`texts` on `xy_series`**, so a label does not need a point marker (a marker drew a stray extra dot beside a data point in the first eye pass).
- **Mark placement `left`**, used for the second equivalence point.
- **`diprotic_ph` / `diproticPh`**: the charge balance solved by bisection (no textbook shortcut), identical in both languages.

## Gates

| Gate | Result |
|---|---|
| 4a property tests | 4,595 checks, 0 failed. New: log axis spans whole decades and is labelled 1/10/100/1,000; plotted heights are log10 of the values; the exponential data are exactly y = a*b^x with one constant slope; the trend line is the least-squares line through the later points, the later points sit within 0.04 decades of it and the early points are visibly off; the diprotic curve satisfies the charge balance, pH = pKa1 and pKa2 at the two half-equivalence points, two steep rises at 25 and 50 mL, and each species named is the dominant one at that volume |
| 4b eye pass | Three figures at four widths. One defect found and fixed (the stray dot above) |
| Port parity | 264 of 264 figure/layout pairs byte-identical across 23 families, existing figures included |
| App tests | The figure and reference suites pass (216 tests) with the regenerated 88-figure catalogue |
| **4c two readers** | **Both readers accepted all three figures. Controls: 4 of 5 rejected by both readers; `CONTROL-P3-pka-values-on-the-wrong-half-equivalence-points` was accepted by `gemini-3.5-flash` (rejected by `gpt-6.1-sol`). Under the protocol, any control accepted voids the batch.** |

**About P3.** The control puts the two pKa labels on the wrong half-equivalence points ("pH = pKa2 = 9.0" at the first one, where the curve is at pH 4). It is a real, visible mistake, so it is not a flawed control to replace. It was not re-run to look for a pass. `verify.py` catches this exact class deterministically (it checks each half-equivalence label against the pKa at the same index), so the defect cannot ship unnoticed, but the protocol's gate did not clear it. This needs a Product Owner decision: accept the deterministic check as covering P3 and record an exception, or re-run the whole gate (new controls, fresh readers).

## To release

1. **Resolve gate 4c** (the decision above).
2. **Merge and publish the app change** (`ap-prep-blueprint`, the log axis and diprotic branch). Without it a log-axis figure would draw on a linear axis with log tick labels, and the diprotic parameters would crash `fTitrationCurve`; the same dependency as `mirror_about` (`APPROVAL-0170`).
3. **A Production load approval** in `APPROVALS_LOG.md` first (Hard Gate), then `build_load_sql.py --prefix "precalc-semilog-,chem-polyprotic"`, baseline probes, load, digest against Development, planted-draft invisibility check.

Evidence: `scripts/lane-a-pilot/out/ced_check_next4.log`, `out/eye_next4.html`, `out/parity/`.

## Gate 4c re-run (David's instruction, 2026-10-15)

Same readers, same five controls, run again in full (`out/ced_check_next4_rerun.log`).
Result identical: 3/3 figures accepted by both readers; 4/5 controls rejected;
CONTROL-P3 (pKa values on the wrong half-equivalence points) accepted again by
gemini-3.5-flash, rejected by gpt-6.1-sol. **Batch still VOID.** The miss is
repeatable, so it is a reader blind spot, not noise. No further re-runs.

## Gate 4c passed with the swapped slate (2026-10-15)

David's ruling: swap the weak reader. Slate for this batch: `openai/gpt-6.1-sol` +
`deepseek/deepseek-v4-pro` (replacing `google/gemini-3.5-flash`, which missed
CONTROL-P3 twice).

- gpt-6.1-sol (`out/ced_check_next4_deepseek.log`, plus both earlier runs): 3/3 figures accepted, 5/5 controls rejected, in every run.
- deepseek-v4-pro, first pass at `--max-tokens 4000`: two items returned empty output (reasoning exhausted the budget): errors, not votes.
- deepseek-v4-pro, rerun alone at `--max-tokens 16000` (`out/ced_check_next4_deepseek2.log`): 3/3 figures accepted, 5/5 controls rejected, including CONTROL-P3.

**Gate 4c: PASSED, no controls accepted.** Gemini's two misses stay on record as a reader blind spot (label-to-curve position checks). Remaining before Production: merge ap-prep-blueprint #27 and publish the app, then APPROVALS_LOG entry and David's explicit approval.

## Loaded to Production (2026-10-15, APPROVAL-0176)

Renderer merged (`ap-prep-blueprint` #27, `2fbb345`) and published (APPROVAL-0175); the three figures were then loaded to Production under APPROVAL-0176 and verified (88 published, 96 uses; params/labels equal the fixture; student RPC returns them on 2.15 and 8.5; planted draft invisible). **Live check done:** David signed in and confirmed the images ("Images are good"). Rollback: retire the three figures (see the approval).
