# Lane A: the AP Statistics figures (2026-10-11)

**STATUS:** CURRENT. **LIVE IN PRODUCTION 2026-10-11 (`APPROVAL-0157`)** — nine figures, five family
rows and nine uses, verified in both environments, which now hold identical figure content.

**Scope:** all seven AP Statistics Lane A reference entries, as **nine figures** across **five new
renderer families**. Built to `FIGURE_PRODUCTION_PROTOCOL.md` (v1.3); classification in
`LANE_A_REMAINING_ENTRIES_CLASSIFICATION_2026_10_11.md`; families are data rather than schema per
`DECISION-0115`, so this was a content load.

---

## 1. What was built

| Figure | Entry (topic) | Family | Labels covered |
|---|---|---|---|
| `stats-bar-chart` | Bar chart (1.4) | `categorical_bars` | 2 |
| `stats-pie-chart` | Pie chart (1.4) | `pie_chart` | 3 |
| `stats-dotplot` | Dotplot (1.5) | `dotplot` | 3 |
| `stats-histogram` | Histogram (1.5) | `categorical_bars` | 3 |
| `stats-stem-leaf` | Stem-and-leaf plot (1.5) | `stem_leaf` | 3 |
| `stats-boxplot` | Boxplot (1.8) | `boxplot` | 5 |
| `stats-two-cat-side-by-side` | Graphs for two categorical variables (2.1) | `categorical_bars` | 1 |
| `stats-two-cat-segmented` | " | `categorical_bars` | 1 |
| `stats-two-cat-mosaic` | " | `categorical_bars` | 1 |

All values are illustrative and render the ILLUSTRATIVE flag; none claims to be measured, so no
`values_note` is required. The bar chart and the pie chart deliberately show **the same 60 students**,
so a student meets one variable in two displays.

**The distinctions are the teaching points, so each is a property rather than a drawing convention:**
a bar chart's bars are separated because the variable is categorical, a histogram's touch because it is
quantitative, a segmented chart's bars are equal width, and a mosaic's widths are proportional to the
category totals. Those four assertions are what stop the four displays collapsing into each other.

## 2. The three gates

**4a. Property tests — passed, 934 checks, 0 failed** across all 20 figures and 11 families. The new
assertions are pedagogical rather than physical: slices sum to exactly 360°; one dot per observation
and stack heights equal to the counts; every leaf a single digit, ordered, and the plot reconstructing
its own data exactly; quartiles by the AP halves convention, fences at 1.5 IQR, and **whiskers stopping
at the most extreme non-outlier rather than at the fence** — the error the entry's own label exists to
prevent.

**4b. Legibility by eye — seven defects found, none of which the suite could see.** Four of them
affect the ten AP Chemistry figures already live in Production:

| Defect | Where | Fixed by |
|---|---|---|
| Rotated y-axis title centred on x=0, half off-canvas at compact | **every figure**, incl. published | per-layout inset, then computed from the real tick extent |
| Percentage tick labels running through the rotated y title | segmented, mosaic | left margin sized from the widest tick label |
| Legend sharing a band with the x-axis title | **published chemistry figures** and three new ones | legend moved above the plot |
| Two marker captions overprinting ("catalyseduncatalysed") | `chem-mb-catalysis` | at compact only the first marker is captioned |
| Peak labels overprinting ("25Mg 10.00%26Mg 11.01%") | **`chem-mass-spectrum`, published** | stick labels are an annotation, dropped at compact |
| Long captions and notes running off the canvas edge | published chemistry figures and two new ones | fit-to-width, and captions flip side near the right edge |
| Stem-and-leaf a postage stamp in the expanded frame | `stats-stem-leaf` | row height and type scale to the canvas |

Two of these — the overprinting pair — are listed in the protocol's own §4b table as defects the pilot
*found*. They were found and described, but they were still in the renderer.

**Both were then turned into checks**, so the class cannot recur silently: every label's estimated box
must lie inside the canvas at all three layouts, and no two labels may overlap. Those two checks found
six further overflows on their first run, including in published figures.

**4c. Model review — passed.** Two non-Anthropic readers, one round, no veto: **controls 5/5 correctly
rejected, figures 9/9 accepted by both readers.** Five controls were planted and **four of the five pass
the property suite cleanly** (a pie subtitle calling 40% "half"; a boxplot claiming its whisker reaches
the maximum and denying its outliers; a segmented chart whose alt text contradicts its own table; a
mosaic drawn with equal widths while still calling itself a mosaic), so they measure what the readers
add over the tests. Cost **$0.25**, 28 calls.

**The slate was corrected before running.** `ced_check.py`'s committed default was
`google/gemini-3.8-flash` — the model §4c records as having accepted a control with high confidence and
voided its batch. The ratified `gemini-3.5-flash` is now the default.

## 3. Loading

`scripts/lane-a-pilot/build_load_sql.py` generates `out/load_ap_statistics_figures.sql`: five family
rows, nine figures, nine uses. Entries are resolved by **natural key** (subject, kind, title), never by
a hardcoded id, because Development and Production hold the same entries under different UUIDs. Guards
raise if any figure would ship with no use, or if the figure count is not nine.

One trap worth recording: `figure_uses`' unique index is **partial** (`where reference_entry_id is not
null`), so `on conflict` has to repeat that predicate or Postgres cannot match the index.

**Verified in Development, as an authenticated student:**

| Check | Result |
|---|---|
| Topic 1.4 | bar chart + pie chart |
| Topic 1.5 | dotplot + histogram + stem-and-leaf |
| Topic 1.8 | boxplot |
| Topic 2.1 | all three two-variable figures |
| Unit 1 / Unit 2 roll-ups | 6 and 3 |
| A topic with no figure (1.7) | `[]` |
| AP Chemistry 5.5, AP Biology 1.1 | unchanged (1 and 0) |
| Dead figures | 0 |
| Re-apply | idempotent; 11 families, 19 figures, 19 uses |

## 4. What is still open

- ~~Production is a Hard Gate~~ — **done** (`APPROVAL-0157`). The figures render for students through
  the **unfixed** frontend renderer until `ap-prep-blueprint` PR #6 is merged and published.
- **The app's TypeScript renderer — now fixed, in `ap-prep-blueprint` PR #6, not yet published.**

  **A correction to what this document first said.** It claimed the frontend had all seven defects.
  It had **three**. Checked against the actual TypeScript rather than assumed from the Python:
  the mass spectrum already truncated its peak labels at compact (`s.label.split(" ")[0]`) and marker
  captions already dropped a line each, so neither overprinted for students; and the stem-and-leaf
  family does not exist there. The three that were real, and did affect the ten published chemistry
  figures at the reference pane's width, are the clipped rotated y-axis title (in every figure), the
  legend overprinting the x-axis title, and long notes and captions running off the canvas.

  All three are fixed, and **both defect classes are now tests in the app's own suite** — nothing
  drawn outside the canvas at any layout, no two labels overprinting — which fail on the pre-fix
  renderer and pass after. Verified in the browser at 332px and 680px, not only in jsdom; tsc clean,
  898/898 tests. **Publishing in Lovable is a separate step and has not happened**, so students still
  see the old rendering until the app is published.
- **Five Lane A entries remain**: AP Physics 2 ×3 (Maxwell–Boltzmann qualitative, which needs no new
  family; the PV diagram, which needs two figures; electric potential versus position), AP Physics C:
  Mechanics ×1 (x(t), v(t), a(t) as one three-panel figure) and AP Precalculus ×1 (the residual plot,
  which first needs `items[]` authored onto its entry — see the classification doc §5). That is six
  figures and two further families.
- **No human expert has reviewed the illustrative values.** Unchanged from the pilot.
