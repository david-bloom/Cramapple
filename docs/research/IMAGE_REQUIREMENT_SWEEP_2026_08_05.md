# Image requirement sweep — 2026-08-05

**Status:** In progress
**Scope:** Every published item (445 total, all 8 subjects) gets a careful
per-item read for whether the student must read a visual to answer
(`image_needed`), per `docs/tasks/TASK-0021-BIOLOGY-PROMPT-VISUAL-STUDENT-DELIVERY.md`.
**Approval mode:** Product Owner (David Bloom) explicitly authorized
auto-approval — generated images are set student-visible
(`content_asset_metadata.approved_at` populated) without a separate Learning
Quality review pass. This departs from TASK-0021's default ("this task does
not self-approve its own content") by the Product Owner's own instruction,
recorded here for audit. `decided_by`/`approved_by` on rows touched by this
sweep is set to David Bloom's profile (`f5a26c6b-3566-4d58-9e97-979fbb947564`)
as the accountable party, executed by an AI agent in this session.
**Detection method:** careful individual read of stem + stimulus + choices/
criteria for each item — not the keyword regex TASK-0021 found scored 0/44.
**Non-generatable visuals** (e.g. real photography): logged and skipped, not
auto-approved, not built as synthetic substitutes.

## Corrections to prior reviewer judgments

Where my read disagrees with an already-recorded `image_needed` value, my
read wins (Product Owner decision, 2026-08-05) and the record is corrected
here with rationale, since `app.content_visual_requirements` has no free-text
field of its own.

| content_key | prior value | corrected value | why |
| --- | --- | --- | --- |
| `APBIO-MCQ-022` | yes | no_not_needed | Endosymbiosis evidence item — all four evidence types and the correct-answer reasoning are given entirely in the text stimulus; no value depends on reading a diagram. |
| `APBIO-MCQ-038` | yes | no_not_needed | Cell-cycle arrest item — mentions flow cytometry but never supplies plotted data to read; the correct answer follows purely from each drug's stated mechanism. |

## Subject progress

| Subject | Published items | Read | image_needed=yes found | Images generated+published |
| --- | ---: | ---: | ---: | ---: |
| AP Biology | 94 (41 FRQ + 53 MCQ) | 94/94 | 8 FRQ (1 pre-existing unapproved-rights asset: S-009) | 8 |
| AP Statistics | 98 (70 FRQ + 28 MCQ) | 98/98 | 0 | 0 |
| AP Chemistry | 110 (42 FRQ + 68 MCQ) | 110/110 | 0 | 0 |
| AP Physics 1/2/C | 53 | 53/53 | 0 | 0 |
| AP Precalculus | 64 (35 FRQ + 29 MCQ) | 64/64 | 0 | 0 |
| AP Calculus AB/BC | 36 (22 FRQ + 14 MCQ) | 36/36 | 0 | 0 |

## AP Statistics MCQ audit (28/28 read, 0 gaps)

All 28 published MCQs are text-answerable; recorded `no_not_needed` for all.
Four items name a visual (`APSTATS-MCQ-004` residual plot, `-013` dotplot,
`-022` boxplot, `-036` scatterplot) but each stimulus states the visual's
relevant shape/pattern directly in prose, and the correct-answer rationale
depends only on that stated description, not on reading values off a picture
— so no image is required for any of them.

## AP Statistics FRQ audit (70/70 read, 0 gaps)

Read in 5 batches of 14. Result: 40 `no_constructs` (hand-drawn construction
items — student builds the boxplot/dotplot/scatterplot/segmented-bar/mosaic
plot themselves from raw data or a five-number-summary table already given in
the stimulus; showing an image would leak the answer) + 30 `no_not_needed`
(fully text/numeric-answerable). Zero `yes`. All 70 written to
`app.content_visual_requirements`.

Specifically re-checked `apstats-frq-u12-005` (today's Shazia fix) against the
"summary-stats-only but a specific raw value is needed" bug pattern by two
independent agents — confirmed the raw-data list added this morning resolves
it; no lingering issue, no other item in the corpus exhibits this pattern.

**Out-of-scope bug found during the read, logged for separate follow-up (not
acted on here):** `APSTATS-HDG-2026-GRAPH-024` (`content_item_versions.id =
e75d8820-7e85-4bad-8056-98ba27af3b0b`) has mismatched data between what
students see (`stimulus`/stem: Sales — Video 18, Hybrid 27, In-person 45) and
what the grading rubric keys off (`prompt_json`/`expected_graph_spec`: Video
20, Hybrid 30, In-person 50). This is a grading-accuracy bug, not a missing
image — separate from this sweep's scope.

## AP Chemistry audit (110/110 read, 0 gaps)

Read in 8 batches (3 FRQ batches of 14, 5 MCQ batches of 12-14). Result: 109
`no_not_needed` + 1 `no_constructs` (`apchem-sfrq-032`, student sketches the
titration pH curve themselves). Zero `yes`. Every needed numeric value
(reduction potentials, bond enthalpies, Ka/Kb/Ksp, titration data, spectral
peak areas) is already given as text/table in the stimulus, even on items
whose stems mention "titration curve" or "photoelectron spectrum" — the
grading rationale never depends on reading a value off an unshown picture.
All 110 written to `app.content_visual_requirements`.

**Out-of-scope issues found during the read, logged for separate follow-up
(not acted on here):**
- `apchem-sfrq-027` — stem references "its enthalpy diagram description" but
  no such figure exists or is needed; stray copy, not a missing image.
- `apchem-mcq-034` — the correct choice's stored rationale text is oddly
  prefixed "Incorrect." in the database; a data-quality issue unrelated to
  images.

## AP Physics 1/2/C audit (53/53 read, 0 gaps)

Read in 5 batches across Physics 1, Physics 2, Physics C: E&M, Physics C:
Mechanics. Despite physics being the subject most likely to need diagrams
(inclines, pulleys, circuits, fields), every published item either fully
specifies its geometry/circuit topology/graph shape in prose, or explicitly
asks the student to construct the diagram/graph themselves (`no_constructs`:
`apphy1-frq-025`, `apphy1-frq-028`, `apphycem-frq-007`, `apphycm-frq-006`,
`apphycm-frq-019`, `apphycm-frq-023`). Zero `yes`. All 53 written to
`app.content_visual_requirements`.

## AP Precalculus + Calculus AB/BC audit (100/100 read, 0 gaps)

Read in 8 batches, coverage independently cross-checked complete against a
fresh DB query. All 100 items give an explicit formula, equation, or complete
data table in the stimulus/stem text — none require reading values off an
unshown graph, polar curve, or parametric curve, despite this being the
subject area (alongside Physics) most likely to rely on graph-reading in the
real AP exam. Every item classified `no_not_needed`. All 100 written to
`app.content_visual_requirements`.

One borderline design smell flagged (not a gap): `apcalcab-frq-u13-002`'s
stem says "the graph of g," but the stimulus text gives every segment's exact
endpoints and open/closed status — functionally equivalent to a table, so no
image is missing, but a stricter reviewer might want it rendered as an actual
image for exam-format fidelity.

## AP Biology sweep completion (94/94 read, 0 new gaps)

The 7 pre-existing images (`L-003, 009, 011, 019, 020, 021, 027`, built under
TASK-0021 before this session) had no `content_visual_requirements` row —
backfilled with `image_needed='yes'`, `image_approval='approved'`. Their
`content_asset_metadata.approved_at` was also NULL (TASK-0021's own
deliberate hold pending Learning Quality review of the alt-text) — per
Product Owner instruction, also approved now for consistency with this
sweep's auto-approve mode.

`APBIO-FRQ-S-009` handled differently: it already has an image attached from
a 2026-07-12/08-03 historical recovery effort
(`docs/research/IMAGE_RELEASE_CANDIDATE_WORKFLOW_2026_08_03.md`), but that
image has its own documented, still-open release gates (scientific,
grading, accessibility, rights, construct-equivalence, answer-leakage) from
prior work — none of that was touched or re-evaluated today. Recorded
`image_needed='yes'`, `image_approval='missing'` (not auto-approved) so this
sweep doesn't silently override a pre-existing, unrelated content-governance
hold.

Remaining 72 items (26 FRQ + 46 MCQ) read in 6 batches: 7 `no_constructs`
(5 HDG-GRAPH hand-drawn items + 2 student-graphs-it-themselves FRQs),
65 `no_not_needed`. Zero new "yes" findings — repeatedly, topics that sound
visual (calico-cat X-inactivation, trophic cascades, pedigrees, cladograms,
flow-cytometry percentages) resolved to fully text-answerable rationales, the
same false-positive pattern already found and corrected on `APBIO-MCQ-022`/
`038` earlier today.

**Blocker surfaced but not acted on (Product Owner declined for this
session):** all 36 published AP Biology FRQs — not just the 7 with images —
have `practice_format IS NULL`, so `select_practice_frqs` cannot serve any of
them to a real student session regardless of image status. This is
TASK-0021's own known, deliberately-unapplied one-way-door backfill
(`20260805110000_backfill_practice_format_biology_frqs.sql`). The 7 approved
images are correctly recorded and reviewer-QA-visible, but **not yet
reachable by a real student** until this backfill runs as its own separately
reviewed action.

**Out-of-scope issue found during the read, logged for separate follow-up:**
`APBIO-MCQ-005`, `APBIO-MCQ-007`, `APBIO-MCQ-009` each returned two rows of
`mcq_choices` for their correct choice when queried by `content_item_version_id`
— worth checking for duplicate published versions per item (the sweep did not
find a scoring/data-fidelity difference between the variants, so this wasn't
blocking, but is unexplained).

## Items that needed non-generatable visuals — resolution log

`APBIO-FRQ-L-028` initially logged as needing real Mount St. Helens
succession photography that this sweep could not generate. Resolved
2026-08-06 by the Product Owner supplying three archival photographs
(1980 blast zone, ~1990s pioneer-stage, 2000s+ reforestation), composited
into one labeled three-panel figure (matching the item's existing "Figure 1"
singular-image convention, since the schema supports one `stimulus_image_path`
per item) and uploaded to `Biology/FRQ/APBIO-FRQ-L-028.png`.

- **Content match verified against the actual rubric** (`app.frq_criteria`,
  criterion `a`) before use — confirmed the three photos correspond to the
  three time points the item's stimulus text already described, and the
  facilitation-model reasoning the rubric grades does not depend on which
  specific photos illustrate the stages.
- **Answer-leakage caught and fixed**: an earlier draft of the composite
  labeled the ~1990s panel "Pioneer species (fireweed)" — this both handed
  the student the answer structure to criterion `a` ("name a specific type
  of early colonist (pioneer species)...") and named a species that doesn't
  match the rubric's accepted answer (*Lupinus lepidus*, not fireweed).
  Rebuilt with neutral date-only labels ("1980" / "~1990s" / "2000s+") and no
  ecological interpretation. Alt-text/long-description similarly describe
  only "plants with clustered pink flowers," never naming a species, per the
  same convention used on the other 7 Biology images.
- **Rights basis**: Product Owner asserted USGS (Cascades Volcano
  Observatory) sourcing for the 1980/pioneer-stage photos and USDA Forest
  Service for the reforestation photo. Not independently verified beyond
  plausibility — USGS CVO's own published teaching materials do document
  USDA Forest Service fireweed photography of this exact site and era,
  which is consistent with but does not confirm the specific images used
  here. Recorded as Product-Owner-asserted, not independently cleared,
  should this need re-checking later. An earlier attempt at this same fix
  using different photos was explicitly declined — those were sourced from
  social media with no attributable rights holder.
- `app.content_visual_requirements` (`image_needed='yes'`,
  `image_approval='approved'`) and `app.content_asset_metadata`
  (`approved_at` set) both written; verified against the live
  `student-session-items` and `review-queue` gating logic before publishing.
