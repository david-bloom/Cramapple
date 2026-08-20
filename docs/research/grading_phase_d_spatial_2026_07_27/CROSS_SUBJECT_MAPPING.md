# TASK-0016 Phase D — Stage D1: Cross-Subject Mapping (v1, 2026-08-19)

**Status:** Stage D1 deliverable. Companion to `SPATIAL_CONTRACT.md`. Per the Phase D prompt:

> Add cross-subject mappings showing how the same spatial primitive applies to at least:
> Statistics quantitative graphs; Biology quantitative graphs; Chemistry titration/experimental
> graphs; Economics multi-curve/equilibrium graphs; and Physics diagrams or plotted relationships.
> These mappings are extensibility evidence, not authorization to grade every listed form in V1.
> Unsupported forms must abstain.

**Read this boundary before anything else below:** every mapping in this document is evidence
that the record shapes in `SPATIAL_CONTRACT.md` (`visual_observation_result`,
`criterion_decision_result`, etc.) do not encode one subject's vocabulary into the architecture —
it is **not** a decision to grade any of these subjects/forms in V1. V1 is capped at exactly the 3
archetypes frozen in Stage D0: `categorical_comparison_supplied_uncertainty`,
`continuous_measured_series_supplied_uncertainty`, `continuous_relationship_graph_derived_estimate`.
Any response whose graphical form does not map cleanly onto one of those 3 archetypes must produce
a `confidence_and_abstention_result` with `decision = ABSTAIN_INSUFFICIENT_EVIDENCE` (or
`ABSTAIN_HUMAN_REVIEW`, at the operator's discretion) and `reason_code = UNSUPPORTED_ARCHETYPE` —
never a `criterion_decision_result` fabricated against a criterion taxonomy that doesn't actually
apply to that form. The `archetype` field on `criterion_decision_result.v1` is a closed 3-value
enum specifically so this cannot happen silently: a form that isn't one of the 3 has structurally
nowhere to put a criterion decision.

The launch subject is AP Statistics (Phase D prompt, "Objective"). Biology is reused
*development* evidence for the shared graph grammar (the existing 150-item synthetic seed + the
200-photo real corpus), not itself a launch target. This document covers both, plus the three
extensibility subjects, using the same 3-archetype/6-criterion vocabulary throughout so the
mapping is falsifiable rather than a marketing table — a subject that turns out to need a form
outside these 3 archetypes is a mapping *failure*, reported below as such, not glossed over.

## 1. The shared vocabulary being mapped

Three archetypes (Stage D0, unchanged) and the cross-item `criterion_label` taxonomy from
`criterion_decision_result.v1.schema.json`:

| Archetype | Shape | Supplied-uncertainty vs. derived |
|---|---|---|
| `categorical_comparison_supplied_uncertainty` | Bar/point comparison across discrete categories | Uncertainty (error bars/SEM) is given data the student plots, not computed by the student |
| `continuous_measured_series_supplied_uncertainty` | A measured quantity plotted against a continuous independent variable | Same — uncertainty marks are supplied, not derived |
| `continuous_relationship_graph_derived_estimate` | A scatter/line relationship where the student reads an estimate off a fitted/drawn relationship | The estimate itself is graph-derived (e.g. read off a best-fit line), not a value the student already had |

`criterion_label` values (from `criterion_decision_result.v1`): `REPRESENTATION_TYPE`,
`X_VARIABLE`, `Y_VARIABLE`, `X_UNIT`, `Y_UNIT`, `X_SCALE`, `Y_SCALE`, `CATEGORY_IDENTITY`,
`PLOT_VALUES`, `UNCERTAINTY_MARKS`, `POINT_CONNECTION`, `BEST_FIT_RELATIONSHIP`,
`ZERO_INTERCEPT_ANNOTATION`, `PLATEAU_ANNOTATION`, `ESTIMATE_VALUE`.

## 2. Per-subject mapping

For each subject: which archetype(s) its common graph forms map onto, which `criterion_label`
values apply, and — critically — which common forms in that subject do **not** map onto any V1
archetype and must therefore abstain today.

### 2.1 Statistics (launch subject)

| Common form | Archetype | Criteria that apply |
|---|---|---|
| Comparative dotplot/bar chart of group means with SEM bars (the actual `CAT` items in the existing corpus, e.g. `HDG-2026-P1-CAT-001`) | `categorical_comparison_supplied_uncertainty` | `REPRESENTATION_TYPE`, `CATEGORY_IDENTITY`, `Y_UNIT`, `Y_SCALE`, `PLOT_VALUES`, `UNCERTAINTY_MARKS` |
| Time-series/measured-value-vs-trial plot with SEM (the `SER` archetype) | `continuous_measured_series_supplied_uncertainty` | `REPRESENTATION_TYPE`, `X_VARIABLE`, `Y_VARIABLE`, `X_UNIT`, `Y_UNIT`, `X_SCALE`, `Y_SCALE`, `PLOT_VALUES`, `UNCERTAINTY_MARKS`, `POINT_CONNECTION` |
| Scatterplot with a hand-drawn best-fit line, reading off an estimate (the `EST` archetype) | `continuous_relationship_graph_derived_estimate` | `REPRESENTATION_TYPE`, `X_VARIABLE`, `Y_VARIABLE`, `X_SCALE`, `Y_SCALE`, `PLOT_VALUES`, `BEST_FIT_RELATIONSHIP`, `ESTIMATE_VALUE` |
| **Does not map — must abstain today:** boxplots/five-number-summary diagrams, normal-probability/QQ plots, residual plots, cumulative-relative-frequency ogives, two-way-table mosaic plots (the exact form flagged as a self-contradiction defect and later fixed in the DECISION-0045 verification work — see `ENGINE4_PRODUCTION_DESIGN_2026_08_18.md`) | none | none — `ABSTAIN_INSUFFICIENT_EVIDENCE` / `UNSUPPORTED_ARCHETYPE` |

Statistics is the subject with the least real-photo evidence today (Stage D0 blocker 5: only
29+28 uncatalogued/smoke-test photos against a 40-item real corpus and the 300-response target) —
this mapping table is grammar-level extensibility evidence, not a claim that Statistics accuracy
has been measured against it.

### 2.2 Biology (development evidence, not a launch target)

| Common form | Archetype | Criteria that apply |
|---|---|---|
| Bar chart of treatment-group means with SEM error bars (the majority of the 200-photo real corpus) | `categorical_comparison_supplied_uncertainty` | Same 6 as Statistics `CAT` |
| Enzyme-activity/growth-rate vs. time or temperature, with SEM | `continuous_measured_series_supplied_uncertainty` | Same as Statistics `SER`, plus `PLATEAU_ANNOTATION` where a saturation/plateau point is a scored feature |
| Dose-response or rate-vs-substrate-concentration scatter with a fitted curve and a read-off estimate (e.g. estimating a Km-like value) | `continuous_relationship_graph_derived_estimate` | Same as Statistics `EST`, plus `ZERO_INTERCEPT_ANNOTATION` where the origin-intercept is a scored feature |
| **Does not map — must abstain today:** phylogenetic trees, Punnett squares, cladograms, labeled-diagram anatomy responses (not graphs of measured quantities at all) | none | none |

This is exactly the corpus Stage D0 measured accuracy against (23.0% exact match / 84.5% F1 /
30.6% FAR / 20.5% FRR on the baseline arm) — the mapping generalizes at the *grammar* level even
though the measured *accuracy* on that same corpus is not yet launch-ready. Extensibility evidence
and accuracy evidence are two different claims; this document only makes the first one.

### 2.3 Chemistry (extensibility only — no corpus exists)

| Common form | Archetype | Criteria that apply |
|---|---|---|
| Titration curve (pH vs. volume of titrant added), reading off an equivalence-point estimate | `continuous_relationship_graph_derived_estimate` | `REPRESENTATION_TYPE`, `X_VARIABLE`, `Y_VARIABLE`, `X_UNIT`, `X_SCALE`, `Y_SCALE`, `PLOT_VALUES`, `BEST_FIT_RELATIONSHIP` (the titration curve's inflection region), `ESTIMATE_VALUE` (the equivalence point) |
| Reaction-rate vs. concentration/temperature with repeated-trial error bars | `continuous_measured_series_supplied_uncertainty` | Same as Biology `SER` |
| Comparative bar chart of measured yields/rates across conditions with SEM | `categorical_comparison_supplied_uncertainty` | Same as Statistics `CAT` |
| **Does not map — must abstain today:** particulate/molecular-level diagrams, Lewis structures, reaction mechanism arrows, periodic-trend annotated tables | none | none |

No Chemistry corpus (synthetic or real) exists anywhere in this repo today — this row is pure
grammar-level extensibility evidence with zero supporting data, and should be read as such.

### 2.4 Economics (extensibility only — no corpus exists)

| Common form | Archetype | Criteria that apply |
|---|---|---|
| Supply/demand or two-curve equilibrium diagram, reading off an equilibrium price/quantity estimate | `continuous_relationship_graph_derived_estimate` | `REPRESENTATION_TYPE`, `X_VARIABLE`, `Y_VARIABLE`, `X_UNIT`, `Y_UNIT`, `X_SCALE`, `Y_SCALE`, `PLOT_VALUES` (both curves), `BEST_FIT_RELATIONSHIP` (each curve's drawn line), `ESTIMATE_VALUE` (the equilibrium point) — **caveat below** |
| Comparative bar chart of a measured/reported economic indicator across categories (e.g. GDP by sector) | `categorical_comparison_supplied_uncertainty` | Same as Statistics `CAT`, minus `UNCERTAINTY_MARKS` where the source data has no supplied uncertainty (would need a v2 archetype variant without required error bars — flagged, not solved, here) |
| **Does not map — must abstain today:** a shifted-curve diagram showing *two* equilibria (before/after a shock) — the current archetype vocabulary has no `criterion_label` for "a second curve was drawn in the correct direction," which is the actual scored skill in that item type. This is a real, specific gap, not a hedge. | none (partial: single-equilibrium case maps, shift case does not) | none for the shift-specific skill |

Economics is the subject where the mapping most clearly **strains** the current 3-archetype
vocabulary — the single-equilibrium read-off case maps cleanly, but the pedagogically-central
shifted-equilibrium comparison does not have a criterion primitive yet. This is reported as a
mapping limitation, not smoothed over: extending to Economics for real would need either a new
`criterion_label` (e.g. `CURVE_SHIFT_DIRECTION`) or treating a shift diagram as two linked
`continuous_relationship_graph_derived_estimate` decisions — a design choice for whoever actually
takes Economics past extensibility evidence, not decided here.

### 2.5 Physics (extensibility only — no corpus exists)

| Common form | Archetype | Criteria that apply |
|---|---|---|
| Position/velocity/acceleration vs. time graph, linear or curved | `continuous_measured_series_supplied_uncertainty` (if error bars are given) or `continuous_relationship_graph_derived_estimate` (if a slope/intercept must be read off, e.g. reading acceleration from a v-t graph's slope) | `REPRESENTATION_TYPE`, `X_VARIABLE`, `Y_VARIABLE`, `X_UNIT`, `Y_UNIT`, `X_SCALE`, `Y_SCALE`, `PLOT_VALUES`, `POINT_CONNECTION`, and (for the slope-reading case) `BEST_FIT_RELATIONSHIP` + `ESTIMATE_VALUE` |
| Force diagram / free-body diagram | none | none — a labeled-vector diagram is not a plotted-quantity graph at all; this is the same category gap as Biology's Punnett squares |
| Circuit diagram | none | none — same reasoning |
| **Does not map — must abstain today:** the two "does not map" rows above are the common case, not the exception, for Physics — a large share of Physics "graph-shaped" responses are actually schematic diagrams (forces, circuits, ray diagrams), which this architecture was never designed to grade and should not attempt to. | none | none |

Physics is the subject where the extensibility claim is **weakest** among the five: only the
literal quantity-vs-time/vs-position graph forms map onto the existing archetypes; a large fraction
of what "Physics diagram" colloquially means (free-body diagrams, circuit diagrams, ray-tracing
diagrams) is out of scope for this architecture entirely, not merely V1-deferred. Reported plainly
rather than stretched to fit.

## 3. Summary: extensibility evidence vs. authorization

| Subject | Maps onto existing archetypes for at least one common form? | Corpus exists? | Authorized to grade in V1? |
|---|---|---|---|
| Statistics | Yes (all 3 archetypes) | Minimal (28–29 uncatalogued real photos, no 40-item cross-reference) | **No** — V1 gate is the calibrated bake-off + shadow gate (Stage D4–D6), not this mapping |
| Biology | Yes (all 3 archetypes) | Yes (200 real photos, ~150 synthetic; development evidence only) | **No** — explicitly development evidence for the shared grammar, not a launch target (Phase D prompt objective) |
| Chemistry | Yes (all 3 archetypes, by analogy — unverified against any real corpus) | No | **No** |
| Economics | Partial (1 of 2 common forms maps; the pedagogically-central shifted-equilibrium case does not) | No | **No** |
| Physics | Partial (quantity-vs-time graphs map; diagram-heavy forms — the majority — do not and are architecturally out of scope) | No | **No** |

No cell in the rightmost column is "Yes." That is the point of this document: it demonstrates the
record shapes generalize without hardcoding one subject's vocabulary, while making zero claim that
any additional subject or form is ready, measured, or approved for grading. Any implementation
that reads this table as authorization to grade Chemistry, Economics, or Physics responses has
misread it.
