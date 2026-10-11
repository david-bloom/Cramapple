# Figure Production Protocol (TASK-0006 Lane A)

**Status:** v1, 2026-10-11. Written from the AP Chemistry pilot, which is live in Production
(`APPROVAL-0153`). Covers Lane A only — charts drawn deterministically from a spec. Lane B
(spatial and schematic diagrams) and Lane D (generative images) are out of scope and unchanged.

**Companion documents.** `LANE_A_PILOT_RESULTS_2026_10_10.md` (what the pilot measured),
`LANE_A_FIGURE_DISPLAY_DESIGN_2026_10_10.md` (layouts, recall, export),
`REFERENCE_DIAGRAM_RENDERING_ASSESSMENT_2026_10_10.md` (lane classification of all 41 diagram
entries), `MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md` (the entries figures attach to),
and the governing design in `../architecture/VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md`.

---

## 1. What this produces, and what it never produces

**Produces:** a row in `app.figures` holding a small JSON spec, plus one or more rows in
`app.figure_uses` saying where it is shown. The client renders the spec. That is the whole artifact.

**Never produces:** a stored image. No PNG, no SVG file, no bucket object, no
`visual_asset_ref`. A Lane A figure has no binary at any point in its life except the PNG the
browser rasterises at copy time and throws away.

**Never involves a model at render time.** The same spec produces byte-identical SVG on every
run, offline, forever. Nothing to re-verify after a model upgrade, no per-view cost, no drift.

**Why a table and not a column.** A figure is not owned by one reference entry. `usedBy` is a
list, so the same figure can be shown beside a different entry or, later, a question. A
`visual_spec` column on `unit_reference_entries` would re-create exactly the single-owner problem
that blocks that. `visual_asset_ref` stays reserved for Lane B, where a stored asset is the right
shape.

## 2. Before a batch

1. **Classify the entries.** Lane A is a chart drawn from data or a function: distributions,
   energy profiles, spectra, titration curves, concentration-time curves, kinematic graphs.
   Anything spatial or schematic — particulate models, circuits, cell diagrams, apparatus — is
   Lane B and stops here. The existing classification of all 41 published diagram entries is in
   the assessment document.
2. **Count the families, not the figures.** Six renderers covered ten Chemistry figures. If a
   batch needs a new renderer per figure, it is probably not Lane A.
3. **Confirm the entries are published,** in Production, by title. Development and Production hold
   the same entries under **different UUIDs** — see §6.
4. **Read the entry's authored `items[]`.** Those labelled parts are the figure's contract: every
   one must be visible in the rendered figure or carried in its text.

## 3. Authoring

Claude authors the spec in session. The gateway is not paid to author
(`feedback-author-in-session-arbitrate`).

A spec carries: `figureId` (stable slug), `family`, `title`, `shortTitle` (compact layout),
`subtitle`, `caption`, `alt`, axis labels, `labels` (the parts this figure draws), `params`, and
`usedBy`.

Three rules that are not negotiable:

- **`alt` is the figure when the picture does not arrive.** At least 80 characters, enforced by
  constraint. It is what a student reads in a pasted document, and what a screen reader gets.
- **`labels` live on the figure, not the entry.** A second consumer inherits them without
  re-deriving.
- **Disclose the data.** `synthetic: true` renders ILLUSTRATIVE on the figure; `false` renders
  FROM DATA and *requires* a `values_note` saying what is sourced. If you cannot trace a number to
  a source, it is illustrative. The pilot's photoelectron spectrum was marked measured, a checker
  challenged it, and the 2s/2p values could not be traced — it is now illustrative.

One entry may need more than one figure. The approach-to-equilibrium entry needs two, because one
chart cannot be both concentration-vs-time and rate-vs-time. Coverage is asserted **per entry**,
not per figure.

## 4. Verification: three gates, none optional

### 4a. Property tests — the science

Assert the facts a wrong chart violates, in code, per family. From the pilot: the
Maxwell-Boltzmann curve peaks at θ/2 and integrates to 1 (the *speed* distribution does neither,
and substituting it yields a plausible-looking wrong figure); every transition state is a local
maximum and every intermediate a local minimum; the rate-determining step is the largest barrier;
isotope abundances reproduce the element's average mass; PES peak heights sum to Z; pH equals pKa
at the half-equivalence point and *not* at the equivalence point.

**This is why Lane A does not need the four-model checker pipeline.** A chart's correctness is
machine-checkable in a way prose is not. The claim the figure draws was already checked when the
entry was authored; the spec does not re-open it.

Also assert geometry — every annotation and curve inside the axes. This exists because an
annotation placed beyond `r_max` rendered off-canvas while the figure still claimed to show that
labelled part. **Declared coverage is not rendered coverage.**

### 4b. Look at it — legibility

The tests cannot see. Every defect below passed a green suite and was found by eye:

| Defect | How it presented |
| --- | --- |
| Legend swatch heavier than the curve it labels | hardcoded stroke width |
| Annotation rendered off-canvas | coverage still claimed it was shown |
| Two marker captions overprinting | "catalyseduncatalysed" |
| Two peak labels overprinting | "25Mg 10.00⁠26Mg 11.01%" |
| Axis ticks at fifths of the range | pH labelled 0/3/6/8/11/14 |
| Title running off the canvas | compact is 340 units wide |

Check at the **real widths**, not in isolation: 272–460px (reference pane), ~680px (question
centre), ~980px (expanded). The `/dev-figures` and `/dev-qx-harness` local routes exist for this.

### 4c. Model review — the illustrative values

One step, **two readers of different non-Anthropic families**, one round, no veto, no patch loop.
An Anthropic model would be marking its own author's homework. Readers see the authored entry and
the exact drawing parameters, and judge one question: *would a student who reads this figure learn
something false?*

**Plant five controls**, and choose at least three that pass the property tests cleanly — that is
what measures whether the readers add anything over the suite. The pilot's controls that defeated
the tests were: temperature labels swapped against their thetas; an alt text calling the first
barrier rate-determining when it was not; and a nitrogen PES with 2s=3 and 2p=2 electrons that
still summed to Z. All three were caught.

**Any control accepted voids the batch.** Cost: **$0.18 for eleven figures**, about $0.016 each.

Two findings worth carrying forward:

- **A newer model was worse, confidently.** `gemini-3.8-flash` accepted a control with *high
  confidence*, voiding its batch; the protocol's ratified `gemini-3.5-flash` scored 5/5. Ratify the
  slate per batch; do not reach for the newest id.
- **Set `max_tokens` to 4000 or more.** At 1200, reasoning models exhausted their budget before
  emitting JSON and looked like they were failing the task. A harness limit is indistinguishable
  from a bad model until you check.

## 5. Display

Three layouts from one spec, chosen by the container:

| Layout | Canvas | Where |
| --- | --- | --- |
| `compact` | 340×344 | reference pane (272–460px) and phone |
| `full` | 680×440 | question centre pane, notes two-column flow |
| `expanded` | 980×620 | the enlarge control, notes single column |

`compact` keeps the title, axes, curves and the single marker carrying the teaching point; every
measured annotation moves up. **The enlarge control is required, not a nicety** — at 272px the
compact figure is a legible thumbnail, not a readable diagram.

This is the part a stored image cannot do. A PNG in a 300px column can only shrink. A spec drops
annotations, re-wraps its title and grows its type.

**A figure dialog opened from inside the notes sheet must mount inside that dialog.** The sheet
marks every other `<body>` child `inert` and watches for new ones, so a dialog portaled to
`<body>` is dead on arrival.

## 6. Loading

**Resolve `figure_uses` by natural key — subject, kind and title — never by a hardcoded
`reference_entry_id`.** Development and Production hold the same entries under different UUIDs. A
seed written with Production ids fails the foreign key on Development, which is exactly how this
was caught. Matching on title keeps the migration portable without weakening the constraint.

Include a guard that raises if any figure ends up with no use, so a batch cannot ship dead rows.

Apply to Development first, verify there, then Production under a Hard Gate approval.

## 7. Production (Hard Gate every time)

Verify **as a real authenticated student**, not as `service_role`: RLS is the thing being tested,
and `service_role` bypasses it. Plant a draft row and confirm the student cannot see it.

Check per topic, per unit and per subject; confirm a topic with no figure returns `[]`; and
confirm an unrelated subject still returns what it did before.

**Compare the function hash across environments.** After replacing
`get_topic_point_guides`, Production's `pg_get_functiondef` md5 should equal Development's. That is
how you know the body deployed is the one that was reviewed.

`apply_migration` **stamps its own version**, not the committed filename. Correct the ledger row to
the filename afterwards. Do not rename the file instead unless you have checked it will not reorder
against migrations that depend on it.

**Rollback:** `update app.figures set status = 'retired';` — the RPC's `figures` key returns `[]`,
the student views go empty, and no function or schema change is reverted.

## 8. Export

Figures are **never omitted** from Copy notes. They get their own Figures section carrying the
title, caption, the picture, the prose description and every labelled part as text.

**Rasterise to PNG at copy time. Never put inline SVG on the clipboard.** Settled by testing a
real paste into Google Docs on 2026-10-10:

| Variant | Result |
| --- | --- |
| PNG `data:` URI | **Works** — the diagram arrives rendered and legible |
| inline `<svg>` | **Fails badly** — Docs drops the drawing *and* flattens the SVG's own `<text>` nodes into the document as a run-on paragraph of axis ticks |
| text only | Clean |

The SVG failure is corruption, not degradation, which is why it is barred outright rather than kept
as a fallback for untested targets. Public raster hosting is **not** needed and that option is
withdrawn.

A notice fires only when a figure genuinely fails to rasterise. There is no blanket warning:
warning every student about a problem they will not hit is noise.

## 9. What is still open

- **No human expert has reviewed the illustrative values.** Two model readers accepted them with
  the controls gate passing, which is meaningful evidence but not a subject expert's sign-off.
- **The readers never see pixels.** They judge parameters and text, so they verify the chemistry,
  not the drawing. Legibility stays a human visual pass.
- **Lane B is untouched.** Eighteen published entries are spatial or schematic. Free-body diagrams,
  vector arrows and chemistry particulate boxes are small constrained grammars and are the cheapest
  real Lane B start — not the phylogenetic trees TASK-0006 §10 proposes, of which the corpus
  contains none.
- **Thirteen Lane A entries remain** outside Chemistry: Statistics 7, Physics 4, Precalculus 1,
  plus one unattributed boxplot. Expect five or six further families.
- **One figure has no home.** `chem-mb-catalysis` draws a real teaching point but no published
  entry matches it; the nearest are a Unit 5 convention and a Unit 3 vocabulary entry. It is not
  production-eligible until an entry exists.

## Change note

v1 (2026-10-11): written from the AP Chemistry pilot and its Production deploy
(`APPROVAL-0153`). Supersedes nothing; the four-lane model in
`../architecture/VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md` still governs, and TASK-0006's five owner
decisions remain formally open — this protocol records what was approved and built for Lane A
reference diagrams specifically.
