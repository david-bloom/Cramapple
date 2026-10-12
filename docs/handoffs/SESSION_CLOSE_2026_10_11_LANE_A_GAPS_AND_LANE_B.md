# Session close: Lane A gaps closed, Lane B built (13 of 18 entries)

> **CORRECTED 2026-10-11.** This was titled "Lane B built (bar AP Biology)" and said so throughout.
> Wrong: **five** published `kind='diagram'` entries have no figure, not four. **AP Chemistry 9.8
> "Electrochemical cell diagram" is unbuilt and blocked on nothing.** The handoff's §1 counted 18
> Lane B entries; its §4 plan covers 17. The cell diagram fell between them and the claim was
> repeated from the plan without being checked against the database. See
> `FIGURE_PRODUCTION_PROTOCOL.md` §9 for the query that settles it.

**STATUS:** CURRENT, 2026-10-11. Branch `claude/lane-a-gaps-and-lane-b-build`.
**Executes:** `LANE_A_GAPS_AND_LANE_B_EXECUTION_2026_10_11.md`. **Governed by:**
`FIGURE_PRODUCTION_PROTOCOL.md` v1.6.

**UPDATE, same day: this is now LIVE IN PRODUCTION** under `APPROVAL-0159`, and the app is
published. 39 published figures, 17 families, 47 uses over 43 entries; Development and Production
hash identically. Verified as a real authenticated student, including that a planted draft stays
invisible. The one thing left undone is a human signed-in look in the browser.

The TypeScript port is merged (`ap-prep-blueprint#11`) and **published** — the live `Figure-*.js`
bundle carries all four new families and the per-figure `aria-labelledby` ids — and the four
batches are **loaded to Production** (`APPROVAL-0159`).

## 1. What is done

**Fourteen new figures and four new families, over thirteen further published entries.** (Ten of the fourteen use the four new families; the other four — three `xy_series` and `chem-mb-catalysis` — use families that already existed.) The suite went
from 26 figures / 21 entries / 1 241 checks to **39 figures / 43 entries / 17 families / 2 091
checks, 0 failed**.

| Batch | Figures | Entries | Gates |
|---|---:|---:|---|
| Lane A §2a + §2e reuse | 3 new, 5 new uses on 3 existing | 9 | 4a ✓ 4b ✓ 4c 5/5 controls, 1 flag arbitrated |
| Lane B §4.1 arrows | 2 | 4 | 4a ✓ 4b ✓ 4c 5/5, 1 flag arbitrated |
| Lane B §4.2 particulate | 5 | 5 | 4a ✓ 4b ✓ 4c 5/5, 1 flag arbitrated |
| Lane B §4.3 fields + circuit key | 3 | 4 | 4a ✓ 4b ✓ 4c **voided once**, then 5/5, 3/3 clean |

New families: `arrow_diagram`, `particulate_box`, `field_map`, `circuit_symbols`. The three Lane A
figures reuse `xy_series`.

**`DECISION-0116`** (Product Owner, in session) settles the handoff's §3.2: when a published entry
authors no `items[]`, the figure's own `labels` are the contract — route (b), declared **per use**,
gated in `verify.py`. On its first run it failed against the **published** residual plot, which
promised three labelled parts with an empty `covers`.

## 2. The three corrections to the handoff

1. **Physics 1 1.3 was not a free row.** Its four authored labels are the same relationships in
   different words ("Area under v vs. t" against "Area under v–t curve"), and coverage matches
   strings exactly. Both wordings are in `covers`.
2. **The orphan's home is Chemistry 5.11 "How a catalyst increases rate"**, whose body names the
   lower-activation-energy path — not 3.5, which §2e guessed. 3.5 is a second use of the existing
   `chem-mb-energy`. `chem-mb-catalysis` is production-eligible for the first time.
3. **The §4c reader gate was not seeing the entry's claim.** `ced_check.py` puts the entry `body`
   in the prompt, but no fixture entry carried one, so it read `claim: (not available)`. All 36
   entries were re-read from Production (items compared byte for byte, none drifted); twelve
   carried no `items_md5` at all.

## 3. Three structural fixes that outlive this batch

- **An entry is identified by SUBJECT AND TITLE.** Two published entries are both called "Vector
  arrow representation" and two more are both "Electric field map and field line diagram". The
  title-only fixture key silently dropped one of each. Every `used_by` now names its own subject.
- **Coverage is owed to every entry a figure is *used by*,** not only the one it was authored
  against, and `build_load_sql.py` emits a `figure_uses` row per use, resolved against that
  entry's own subject and kind.
- **A control must be a mistake a reader can SEE.** A control that shuffled isoline radii drew the
  same four circles; `gemini-3.5-flash` accepted it and voided a sound batch. `ced_check.py` now
  refuses a control that is a pure reordering. The obvious form of that guard is also wrong — see
  protocol §4c.

## 4. What gate 4b found that a green suite could not

Fourteen defects, every one invisible to the tests that passed beside it. The ones worth carrying:
`U+2225` renders as a plain "I", so an axis read "F I"; two activation-energy barriers drawn and
only one named; water bonded H-to-H with the oxygen sitting on the line; the ammeter and voltmeter
drawn as two identical empty circles because the letter was dropped on the way to the canvas while
the property test read the spec and passed; most of a "sea" of twenty-six electrons placed outside
its box and silently discarded; the liquid indistinguishable from the solid; solute clumped in the
top two rows of a figure whose alt said each particle was surrounded by solvent.

Each left a test behind. `build_eye_sheet.py` makes the pass a command.

## 5. NEXT, in order

1. ~~**TEACH THE APP THE FOUR NEW FAMILIES.**~~ **DONE** — `david-bloom/ap-prep-blueprint#11`,
   **117 of 117 figure/layout pairs byte-identical across all 17 families**, 985 app tests passing,
   `tsc` clean. The check is now a command (`export_for_parity.py` here,
   `tests/figure-parity.ts` there) and its first run found four drifts in figures already live in
   Production — two in each renderer, all fixed. **Merged and PUBLISHED** (2026-10-11): the live
   bundle at `app.cramapple.com` carries all four families. The 25 published figures are visually
   unchanged by it — no live figure has more than one captioned marker, which was the only rule that
   moved — and every one of them gains correct per-figure accessible ids.
2. ~~**Production load**~~ **DONE** — `APPROVAL-0159`, all four batches. Production: 39 published
   figures, 17 families, 47 uses, 43 entries, 0 drafts, identical to Development by digest.
   Verified as an authenticated student, draft row invisible, cross-subject sharing working.
   **CLOSED 2026-10-11.** The Product Owner confirmed in the live signed-in app that the notes
   template renders correctly AND that the figures draw: AP Statistics 2.11 (five figures), 3.6
   (three p-value tails on one entry), AP Chemistry 4.3 (particulate) and AP Physics 1 2.2 (the
   free-body diagram, which is a cross-subject shared figure). `field_map`, `circuit_symbols` and
   the three `xy_series` gap figures have still not been looked at by anyone. Four loaders are
   generated and applied to Development:
   `out/load_lane_a_gaps.sql`, `out/load_lane_b_arrows.sql`, `out/load_lane_b_particulate.sql`,
   `out/load_lane_b_fields.sql`. `--workdir /Users/davidbloom` is PRODUCTION; confirm the ref in the
   `--debug` line before the write and pass an ABSOLUTE path.
3. **The rest of the Lane A gap**, classified in `LANE_A_GAP_CLASSIFICATION_2026_10_11.md` but not
   built. `density_curve` first (8 AP Statistics entries, up to 12), then `function_plot` (15
   entries — and the only thing that gives AP Precalculus and AP Calculus AB any figures at all).
4. **§5 of that document**: four entries that may be free `figure_uses` rows against figures that
   already exist. Compare the label strings first.

## 6. Open decisions for the Product Owner

1. **§4.4 — the four AP Biology structures** (DNA helix, fluid mosaic membrane, chloroplast,
   mitochondrion): commission, license, or a crude labelled schematic. **This is the only part of
   Lane B not built, and it is blocked on this.** The handoff says do not start there.
2. **§3.3 — the cross-subject duplicates.** Deferred, not resolved: this session made one figure
   serve both entries and carried both wordings in `covers`, which works, but the same concept is
   still authored twice and still drifting. Alias, normalise, or accept.
3. Standing: **no human subject expert has reviewed any batch's illustrative values.**

## 7. Do not

- Do not assume a shared figure is a free `figure_uses` row. Coverage matches label strings exactly.
- Do not change `render.py`'s number formatting without re-running the parity check.
- Do not re-run a voided batch against a different model slate to make it pass. Check the control
  first: in this session the control was wrong both times it was questioned.
