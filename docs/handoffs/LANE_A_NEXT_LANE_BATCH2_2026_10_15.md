# Next figure lane, batch 2: four AP Statistics figures

**STATUS:** built and verified; **in Development only. Production is a Hard Gate and has no approval for this batch.**
**DATE:** 2026-10-15. **Ruling:** `DECISION-0123` item 4. **Continues:** `LANE_A_NEXT_LANE_BATCH1_2026_10_15.md`.

## What was built

Four figures on the existing `categorical_bars` family, so **no renderer change and no app port**.

| Figure | Entry | Mode | Contract |
|---|---|---|---|
| `stats-gap-histogram` | AP Statistics 1.6 vocabulary "Gap" | histogram with one empty bin | route (b), 3 labels |
| `stats-compare-two-datasets` | 1.4 convention "Comparing categorical data sets" | grouped, relative frequencies | route (b), 3 labels |
| `stats-association-yes` | 2.1 convention "Judging association from two categorical variables" | segmented, distributions differ | route (b), 2 labels |
| `stats-association-no` | same entry | segmented, distributions match | route (b), 2 labels |

All three entries author no `items[]`. The association entry takes two figures (a differing pair and a matching
pair) because one chart cannot show both cases, and coverage is asserted per entry. Both figures say "in these
data": an association in a sample is not causation, and the wording stays on that side of the line.

## Verdicts on the rest of the Statistics rows

- **1.9 "Which graphs compare which features": not a figure.** It is a mapping from graph type to compared features.
- **1.6 skew direction and 1.8 mean vs. median under skew: not free.** `density_curve` draws normal and chi-square
  curves, so a left-skewed curve does not exist. They need a new curve kind in both renderers, an app port and a
  Lovable publish before any Production load. They are the next sub-batch and need that scope agreed first.
- The classification's reuse guesses failed here as they did in batch 1: the published bar charts show one data
  set or belong to a different entry, so reusing them would carry labels these entries do not support.

## Gates

- **4a:** 4,145 checks, 0 failed (79 figures).
- **4b eye pass at four widths:** all four legible. One observation, not a defect: the gap bracket ("gap: no data")
  draws only in the full and expanded layouts; the empty bin is visible and the title names the gap in all four.
  The published `stats-histogram` bin-width annotation behaves the same way.
- **4c two readers** (`gpt-6.1-sol`, `gemini-3.5-flash`): all four figures accepted by both; **controls 5/5
  rejected**, all five passing the property suite cleanly (a filled-in gap bin, a gap defined as the most data,
  the two classes' data swapped against their labels, equal distributions called different, association read as
  causation). No control had to be replaced this time.
- **Port parity** (Bun): 237/237 figure/layout pairs byte-identical across 23 families.

## Loaded

Development only, tag `batch=stats-next2-figures-2026-10-15`, via `out/load_stats_next2_a.sql`, `_b.sql`, `_c.sql`
(three files because the entries differ in kind). All four resolve to their entries by natural key. Illustrative
values; no human subject expert has reviewed them.

## To promote

Production Hard Gate: an `APPROVAL-` entry naming the four figures and their three entries, rollback
`update app.figures set status='retired' where source_note like '%batch=stats-next2-figures-2026-10-15%'`.
The app already knows the family, so no Lovable publish is needed first. Verify as an authenticated student on
Statistics 1.4, 1.6 and 2.1 and compare unrelated topics before and after, as in `APPROVAL-0165`.
