# Lane A: Classification of the Remaining Entries (2026-10-11)

**STATUS:** CURRENT. Classification and build plan only — **no figure has been authored, no spec
written, no migration drafted.** The next step needs a Product Owner decision (§6).

**Governing protocol:** `FIGURE_PRODUCTION_PROTOCOL.md` §2 ("Before a batch"). This document is that
section executed for everything Lane A outside AP Chemistry.

**Supersedes, in part:** `REFERENCE_DIAGRAM_RENDERING_ASSESSMENT_2026_10_10.md` §4's Lane A table, in
the four places noted below. That document classified against entry *titles*; this one classifies
against each entry's **published `kind` and authored `items[]`**, read from Production on 2026-10-11,
which is what the protocol actually requires.

---

## 1. Every candidate is published in Production

All thirteen were confirmed by title in Production (`pcntajvbdfqhbeewmdry`), `status = 'published'`.
Nine of them — every Physics and Precalculus entry here — only became reachable **today**, under
`APPROVAL-0154`. Before that promotion this batch could not have been built at all: protocol §2 step 3
requires the entry to be live, and §6 requires resolving `figure_uses` against the environment's own
entry ids.

## 2. The classification, entry by entry

`items[]` is the figure's contract: every labelled part must be visible in the rendered figure or
carried in its text. That is what sets the figure count, not the entry count.

| Subject | Topic | Entry | kind | Authored labelled parts | Verdict | Figures |
|---|---|---|---|---:|---|---:|
| AP Statistics | 1.4 | Bar chart | diagram | 2 | **Lane A** | 1 |
| AP Statistics | 1.4 | Pie chart | diagram | 3 | **Lane A** | 1 |
| AP Statistics | 1.5 | Dotplot | diagram | 3 | **Lane A** | 1 |
| AP Statistics | 1.5 | Histogram | diagram | 3 | **Lane A** | 1 |
| AP Statistics | 1.5 | Stem-and-leaf plot | diagram | 3 | **Lane A, own family** (§3) | 1 |
| AP Statistics | 1.8 | Boxplot | diagram | 5 | **Lane A** | 1 |
| AP Statistics | 2.1 | Graphs for two categorical variables | diagram | 3 | **Lane A, three figures** (§4) | 3 |
| AP Physics 2 | 9.1 | Maxwell–Boltzmann distribution (qualitative) | diagram | 3 | **Lane A, existing family** | 1 |
| AP Physics 2 | 9.4 | Pressure–volume (PV) diagram | diagram | 8 | **Lane A, two figures** (§4) | 2 |
| AP Physics 2 | 11.6 | Graph of electric potential versus position in a loop | diagram | 4 | **Lane A** | 1 |
| AP Physics C: Mechanics | 1.3 | Reading x(t), v(t), a(t) graphs | diagram | 4 | **Lane A, one three-panel figure** (§4) | 1 |
| AP Precalculus | 2.6 | Residual plot | **vocabulary** | **0** | **Lane A, but no labelled contract** (§5) | 1 |
| — | — | "one unattributed boxplot" (protocol §9) | — | — | **Does not exist** (§5) | 0 |

**Twelve entries, fifteen figures.** Not thirteen entries and thirteen figures, which is how the
protocol's §9 open-items list currently reads.

## 3. Corrections to the 2026-10-10 assessment

1. **AP Precalculus "Residual plot" is not a diagram entry.** It is published as `kind = 'vocabulary'`
   with no `items[]`. The assessment listed it in the Lane A diagram table on the strength of its
   title. A figure may still be attached — `app.figure_uses` has no constraint on the entry's kind, by
   design — but there is no authored contract for coverage to check, so what the figure shows is an
   authoring decision rather than a transcription of the entry. §5 gives the options.
2. **The "unattributed boxplot" does not exist.** Protocol §9 says "Statistics 7, Physics 4,
   Precalculus 1, plus one unattributed boxplot", totalling 13. AP Statistics' Boxplot (1.8) is
   attributed and already counted among the seven; a search of every published entry whose title
   mentions a box plot returns exactly that one row. The real total is **12 entries**.
3. **"Graphs for two categorical variables" is one entry needing three figures,** not one. Its three
   authored labels are three different chart types: side-by-side bar chart, segmented bar chart,
   mosaic plot. Coverage is asserted per entry, so this entry passes only when all three exist — the
   same shape as the approach-to-equilibrium precedent.
4. **Stem-and-leaf plot is Lane A but it is not a chart.** It is deterministic from data, which is the
   Lane A test, but it is typography on a grid with no axes: the renderer shares nothing with the
   chart families and its property tests are different in kind (every leaf is a single digit, leaves
   are ordered within a stem, and the plot reconstructs the original data exactly — a property no
   chart family has). Build it, but as its own family and with the expectation that it reuses none of
   the axis machinery.

## 4. Why fifteen figures and not twelve

- **PV diagram (8 labels)** names four distinct processes — isovolumetric, isobaric, isothermal,
  adiabatic — plus the isotherm, the axes and the area under the curve. One chart showing all four
  paths at once is unreadable at the 340-unit compact width; two are the minimum (one for the axes,
  isotherm and area-as-work; one for the four process paths).
- **Reading x(t), v(t), a(t) graphs (4 labels)** is the opposite case: its labels are *about the
  relationship between* three stacked panels (tangent slope on x–t gives v, area under v–t gives Δx).
  Three separate figures would destroy the teaching point. One figure, three vertically aligned
  panels, sharing a time axis.
- **Graphs for two categorical variables**: three, as above.

## 5. Two entries that need a decision rather than a renderer

**AP Precalculus "Residual plot" (vocabulary, no `items[]`).** A figure here is useful — a residual
plot is the single most visual idea in that topic — but with no authored labelled parts the figure's
content is not derivable from the entry. Options: (a) attach a figure and let its own `labels` carry
the parts, which the data model already supports and which the protocol's "labels live on the figure,
not the entry" rule arguably anticipates; (b) author `items[]` onto the entry first, through the
reference-pack pipeline with its checkers, then build the figure against it; (c) leave it out of this
batch. **(b) is the most defensible** and the cheapest to defend later, because it keeps the figure a
transcription of checked content rather than new unchecked teaching material entering through the
figures table — which is a side door the reference-pack protocol's checker gates do not watch.

**`chem-mb-catalysis` (built, rendering, no home).** Unchanged from protocol §9: the figure exists and
draws a real teaching point, but no published entry matches it. It stays out until an entry exists.
Worth noting that the same side-door question applies: it is easier to add a figure than to add a
checked entry, and the corpus should not acquire teaching content that way.

## 6. What this batch costs, and the one thing that makes it not data-only

**Six new renderer families for fifteen figures** — comfortably within protocol §2 step 2's test
("if a batch needs a new renderer per figure, it is probably not Lane A"):

| Family | Covers | Figures |
|---|---|---:|
| `categorical_bars` | Bar chart, Histogram, side-by-side bar, segmented bar | 4 |
| `pie_chart` | Pie chart, mosaic plot (area-proportional variant) | 2 |
| `dotplot` | Dotplot | 1 |
| `stem_leaf` | Stem-and-leaf plot (typographic, §3.4) | 1 |
| `boxplot` | Boxplot | 1 |
| `xy_series` | PV diagram ×2, potential vs. position in a loop, residual plot | 4 |
| `kinematic_panels` | Reading x(t), v(t), a(t) graphs | 1 |
| *(existing)* `mb_distribution` | Maxwell–Boltzmann (qualitative), AP Physics 2 | 1 |

That is seven new families, not six, once `kinematic_panels` is counted separately from `xy_series`;
whether the three-panel case is a mode of `xy_series` or its own family is an implementation call best
made while writing it.

**The thing to know before approving:** `app.figures` constrains `family` with a hard-coded CHECK —

```sql
constraint figures_family_check check (family in (
  'mb_distribution', 'energy_profile', 'stick_spectrum',
  'pe_vs_distance', 'approach_equilibrium', 'titration_curve'))
```

so **every new family requires a migration**. Unlike the AP Chemistry figures batch, which could be
seeded as data once the tables existed, this batch is a **schema change plus data**, in both
environments, and therefore a Hard Gate deploy rather than a content load. It also means the
renderer's family names and the constraint have to move together, and that a family added in
Development and forgotten in Production fails loudly on insert rather than silently — which is the
right failure, and worth keeping.

## 7. Verification this batch will need (unchanged, three gates)

Nothing here lets any gate be skipped, and two of them get materially harder:

- **Property tests** per family, and the new families' properties are mostly *structural* rather than
  physical: a boxplot's median lies within its box and its whiskers extend no further than 1.5 IQR; a
  histogram's bars are contiguous while a bar chart's are not (the one distinction the entry exists to
  teach); a pie chart's slices sum to exactly 360°; a stem-and-leaf plot reconstructs its own data; a
  residual plot's residuals sum to approximately zero about the fitted line. The AP Chemistry batch
  could lean on physics for its properties; this batch has to assert pedagogy, which is easier to get
  subtly wrong.
- **Legibility by eye at 272–460px**, which is where Statistics will hurt: a stem-and-leaf plot and a
  mosaic plot are both dense in a way an energy profile is not.
- **Two non-Anthropic model readers, five planted controls, at least three passing the property tests
  cleanly.** Cost at the Chemistry batch's rate (~$0.016/figure) is **about $0.25 for fifteen
  figures**. Ratify the slate per batch — protocol §4c records that a *newer* Gemini accepted a
  control with high confidence and voided its batch.

## 8. Recommended sequence

1. **AP Statistics first (7 entries, 9 figures, 5 of the 7 new families).** It is a Day-1 launch
   subject, its entries are the longest-published in the corpus, and `categorical_bars` plus
   `pie_chart` carry four and two figures respectively, so the family work pays for itself fastest.
2. **AP Physics 2 and Physics C: Mechanics (4 entries, 5 figures, `xy_series` + `kinematic_panels`),**
   one of which needs no new family at all (Maxwell–Boltzmann qualitative reuses `mb_distribution`).
3. **AP Precalculus' residual plot last,** after §5's decision — and ideally after `items[]` exist on
   the entry.

One migration can carry all seven families at once even if the figures land in slices, which avoids
three separate Hard Gate deploys for the same CHECK constraint.
