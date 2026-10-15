# Next figure lane, batch 1: Chemistry 9.1 and 5.6

**STATUS:** built, verified, and **live in Production** (`APPROVAL-0165`, 2026-10-15). A signed-in look in the real app has not yet been done.
**DATE:** 2026-10-15. **Ruling:** `DECISION-0123` item 4 (the chart-shaped entries outside `kind='diagram'` are the next lane).
**Governed by:** `docs/product/FIGURE_PRODUCTION_PROTOCOL.md`; classification in `LANE_A_GAP_CLASSIFICATION_2026_10_11.md`.

## What was built

Two figures on families that already exist in the app, so there is **no renderer change and no app port**.

| Figure | Family | Entry | Contract |
|---|---|---|---|
| `chem-mb-entropy` | `mb_distribution` (no markers) | Chemistry 9.1 convention "Entropy increases with temperature (energy dispersal)" | route (b), 4 labels |
| `chem-reaction-coordinate` | `energy_profile` | Chemistry 5.6 vocabulary "Reaction coordinate" | route (b), 3 labels |

Both entries author no `items[]`, so each figure's own labels are the contract (`DECISION-0116`).

**Why new figures and not extra uses of `chem-mb-energy` / `chem-energy-profile-single`.** The classification
guessed both were free `figure_uses` rows. They are not: route (b) makes every label a figure carries part of
the entry's contract, and `chem-mb-energy` carries an activation-energy marker and a shaded tail that the 9.1
body never mentions. Reusing it would assert a concept the entry does not teach.

## Gates

- **4a property tests:** 3,955 checks, 0 failed (full suite, 75 figures).
- **4b eye pass:** found one defect. `chem-reaction-coordinate` first declared "Reactants" and "Products" as
  labelled parts, but both compact layouts drop those captions. Declared coverage was not rendered coverage.
  The declared labels were narrowed to the two axes and the pathway, which draw at every size.
- **4c two readers** (`gpt-6.1-sol`, `gemini-3.5-flash`): both figures accepted by both readers. **Controls
  5/5 rejected, after one replacement.** Run 1 rejected 4 of 5. Control N3 (the energy axis relabelled as
  speed) was accepted by both readers and voided the batch as run. The control was checked first, per §4c: it
  was the defect, because a distribution that broadens with temperature broadens whether plotted against speed
  or energy, so nothing false was taught. It was replaced by N3' (both curves drawn at the same temperature but
  labelled lower and higher), and only the controls were re-run; that control was rejected by both readers.
  N1, N2 and N4 pass the property suite cleanly, so they measure the readers; N3' and N5 are caught by the suite.
  Run 1 is kept at `out/ced_check_next1_run1.json`; `out/ced_check.json` is the control re-run only.
- **Port parity** (Bun, same rule as `tests/figure-parity.ts`, no Deno available): 225/225 figure/layout pairs
  byte-identical across 23 families.

## Loaded

Development first, then Production, via `out/load_chem_next1_a.sql` and `out/load_chem_next1_b.sql` (tag
`batch=chem-next1-figures-2026-10-15`; two files because the two entries are different kinds). Both figures
resolve to the intended entries by natural key (5.6 and 9.1). Illustrative values; no human subject expert has
reviewed them (standing risk, `DECISION-0123` item 3 covers only the earlier named figures).

## Promoted

Loaded to Production under `APPROVAL-0165`; verification and rollback are recorded there. Production now holds 75
published figures, equal to Development.

## Next in the lane

Remaining drawable entries, in the classification's order: Stats §5 reuse checks (skew, gap, mean vs median,
which-graph-compares-which) on `density_curve`, then §4 extensions that need a renderer change (Chemistry 8.5
second equivalence point, Precalculus 2.15 log axis), then §3 new families (Stats 2.8 discrete distributions,
Stats 2.12 sampling distributions, Chemistry 5.3 linearised panels, Chemistry 3.11 spectrum band). The §5 reuse
checks should expect the same finding as here: reuse fails when the existing figure carries labels the entry
does not support.
