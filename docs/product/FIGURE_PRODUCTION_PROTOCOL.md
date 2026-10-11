# Figure Production Protocol (TASK-0006 Lane A)

**Status:** v1.7, 2026-10-11. Written from the AP Chemistry pilot, which is live in Production
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

   > **`kind` IS NOT THE FILTER (2026-10-11).** `kind='diagram'` says what an entry is *about*,
   > not whether it is drawable. "Residual plot" is `vocabulary`, "Work from a force-displacement
   > graph" is `convention`, "Displacement from area under v–t graph" is `formula`. Lane A was
   > scoped to the `diagram` column and left about 24 chart-shaped entries behind. Classify on the
   > content — *is this a chart drawn from data or a function?* — and record the verdict durably,
   > or the next session re-derives it.
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

  > **AND THEY MAY BE THE CONTRACT (`DECISION-0116`, 2026-10-11).** When the published entry
  > authors no `items[]`, the figure's own `labels` are that entry's contract — route (b) of the
  > handoff's §3.2, ruled by the Product Owner over ~19 entries. Three conditions, all gated:
  > the **use** declares it (`labels_carry_contract` plus a `contract_note` naming the entry and
  > why its body supports the labels — it is a property of the use, not of the figure, because one
  > figure serves entries that do and do not author parts); every carried label is also in
  > `covers`; and the figure goes through §4c **with the entry's body in the prompt**, since that
  > reader gate is the only thing standing where the reference-pack checkers do not. An entry with
  > no `items[]` and no declaration fails.
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

> **ADDITION (2026-10-11).** Coverage is checked against a committed fixture of the published
> entries, `scripts/lane-a-pilot/prod_entries.json`, which carries each entry's authored `items[]`;
> `verify.py --entries` defaults to it. **An entry with no `items[]` fails rather than passing.**
> This exists because the default pointed at a scratch path outside the repository: once that file
> was gone, the gate ran over an empty set and reported a clean pass, which is how the ten published
> Chemistry figures came to have an unenforced coverage gate behind them. Re-run on the recovered
> fixture, all 38 authored labelled parts across the nine published entries are covered. When a
> batch adds entries, add their published `items[]` to the fixture in the same change — and take
> them from the environment, not from a candidate artifact, unless the digest matches (§6).

> **ADDITION (2026-10-11, v1.5).** Three further holes in this gate are closed. **Coverage is owed
> to every entry a figure is *used by*,** not only the one it was authored against: a figure
> legitimately serves two entries and the RPC does not filter by `subject_key`, so the second
> entry's parts went unchecked. **The fixture's `items_md5` is recomputed on every run,** so a
> retyped or edited `items[]` fails rather than quietly redefining what coverage asserts. And an
> entry with an empty `items[]` no longer merely prints a note — it must be declared under
> `DECISION-0116` or it fails. That third check failed on its first run against the **published**
> residual plot, which promised three labelled parts with an empty `covers`.
>
> **Coverage matches label strings exactly.** Two entries that author the same relationship in
> different words ("Area under v vs. t" against "Area under v–t curve") need **both** wordings in
> `covers` while `labels` keeps the one set the figure draws. Do not assume a shared figure is a
> free `figure_uses` row until the strings have been compared.

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
centre), ~980px (expanded). The `/dev-figures` and `/dev-qx-harness` local routes exist for this,
and **`build_eye_sheet.py` builds the contact sheet** — every named figure at all four containers
on one page — so the pass is a command rather than a page rebuilt from scratch each time:

```bash
python3 -I build_eye_sheet.py --prefix "chem-mb-" --out out/eye_mb.html
python3 -I serve.py   # http://localhost:5191/eye_mb.html
```

Its first run found a defect a green suite could not see: the compact layout drew **two**
activation-energy barriers and named only one, because a marker's label was dropped for every
marker past the first while its line was still drawn. A dropped label leaves an unexplained line.

> **ADDITION (2026-10-11).** Two of this table's defects — the overprinting pair — were still in the
> renderer months after being recorded here as found. Describing a defect is not fixing it, and an eye
> pass does not repeat itself. Both classes are now **checks**: every label's estimated box must lie
> inside the canvas at all three layouts, and no two labels may overlap. On their first run they found
> six further overflows, several in published figures. The eye is still required — it found all seven
> defects in the AP Statistics batch first — but what it finds should leave a test behind.

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

> **A CONTROL MUST BE A MISTAKE A READER CAN SEE (2026-10-11).** One control shuffled the ORDER of a
> figure's isoline radii. That draws the same four circles, so the picture a student sees is identical
> and nothing false is taught — a reader accepted it, correctly, and voided a batch that was sound.
> The control was the defect, not the reader. `ced_check.py` now refuses to run a control whose
> rendered output is a pure reordering of the original's elements with no change to its text. Note the
> obvious form of that guard is also wrong: splitting the SVG on `>` shreds each tag into an attribute
> part and a text part, so a control that swaps the CONTENTS of two elements compares equal and is
> rejected though it is real. Compare whole elements.
>
> The errors that survive a green suite are overwhelmingly **stated in words**: the geometry is
> generated from the parameters and is self-consistent by construction, while the title, subtitle,
> note and alt beside it are free to say anything. Three of the five controls in each Lane B batch
> were of exactly that kind, and all were caught.

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

**A new renderer family is a row, not a migration** (`DECISION-0115`). Insert it into
`app.figure_families` — `family_key`, `title`, `summary` and a `renderer_note` saying where it is
implemented — in the same load as the figures that use it. `figures_family_fkey` rejects a family that
was never seeded, so the failure lands in the loader rather than in a student's reference pane. What
the foreign key cannot check is whether the renderer exists: seeding `boxplot` without writing a
boxplot renderer still fails at render time, which is why the mandatory `alt` is the fallback.

Apply to Development first, verify there, then Production under a Hard Gate approval.

**And teach the app the family in the same breath.** `FIGURE_FAMILIES` in
`src/lib/topic-content.ts` is a whitelist and `mapFigure` returns `null` for anything else, so a
figure whose family the client does not know is **silently dropped**. Nine AP Statistics figures sat
in Production invisible for exactly this reason. Port the family to `src/lib/figures/render.ts` and
prove the port by **parity, not inspection**.

> **THE PARITY CHECK IS A COMMAND (2026-10-11).** It had only ever been run by hand.
>
> ```bash
> python3 -I scripts/lane-a-pilot/export_for_parity.py        # specs + every SVG, 3 layouts
> deno run --unstable-sloppy-imports --allow-read \
>     tests/figure-parity.ts <this-repo>/scripts/lane-a-pilot/out/parity   # in the app repo
> ```
>
> Run it over **every** family, not just the new one: its first run found four drifts in figures
> already live in Production, two in each renderer. The app's `catalogue.ts` is generated too, by
> `build_catalogue_ts.py`, because a catalogue that has drifted from `specs.json` looks exactly like
> one that has not.
>
> **Keep `hypot` out of anything that becomes a coordinate.** Python's `math.hypot` and JavaScript's
> `Math.hypot` are both carefully written and need not agree in the last bit, while an explicit
> `sqrt(a*a + b*b)` is IEEE-identical in both — that is what let 900-step traced field lines match
> exactly. The same care is why `pyFixed` exists on the TypeScript side: Python rounds half to even,
> `toFixed` rounds half away from zero, and only an exact binary tie is a real tie.
>
> **Merging is not publishing.** Until the app is published in Lovable, nothing reaches a student.

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

> **CURRENT AS OF 2026-10-11.** Every published `kind='diagram'` entry that is Lane A now has a
> figure, in every subject: 25 figures and 13 families live in Production (`APPROVAL-0153`, `0157`,
> `0158`), identical in Development. **But `kind='diagram'` was the wrong filter for the lane** — about
> 24 chart-shaped entries live in `vocabulary`, `convention`, `formula` and `list_sequence`, and only
> one of them (AP Precalculus' residual plot) was ever caught. Three of those need no new renderer at
> all, and three need only a `figure_uses` row.
>
> **The remaining work in both lanes, the labelling problems underneath it, and an execution plan are
> in `docs/handoffs/LANE_A_GAPS_AND_LANE_B_EXECUTION_2026_10_11.md`.** Read it before starting either
> lane. The list below is the pilot's original open set and is kept for history.
>
> **UPDATE (2026-10-11, later the same day).** That handoff's §2a and §2e are closed and **all of
> Lane B is built except the four AP Biology structures**, which remain blocked on the §4.4 decision.
> Ten new figures across five new families (`arrow_diagram`, `particulate_box`, `field_map`,
> `circuit_symbols`, plus three `xy_series` figures) cover **thirteen further published entries**, and
> are **in Development only — Production is still a Hard Gate.** The app HAS now been taught the four
> new families (`ap-prep-blueprint#11`), at **117 of 117 figure/layout pairs byte-identical across
> all 17 families**, the app is **published**, and all four batches are **LIVE IN PRODUCTION**
> (`APPROVAL-0159`): 39 published figures, 17 families, 47 uses over 43 entries, identical to
> Development by digest and verified as a real authenticated student. The AP Biology four remain
> blocked on the §4.4 decision, and the rest of the Lane A gap is classified but not built. The rest of the Lane A gap is classified but not
> built: `LANE_A_GAP_CLASSIFICATION_2026_10_11.md`. Next steps and traps:
> `SESSION_CLOSE_2026_10_11_LANE_A_GAPS_AND_LANE_B.md`.

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

  > **CORRECTION (2026-10-11).** Classified against each entry's published `kind` and authored
  > `items[]` rather than its title, it is **twelve entries and fifteen figures**, needing **seven**
  > new families. It was going to need **a migration** too, because `figures_family_check` hard-coded
  > the family list — `DECISION-0115` replaced that CHECK with an `app.figure_families` lookup and a
  > foreign key, so **a new family is now a one-row insert in the same load as its figures** and the
  > batch is a content load again. An unknown family still fails at insert rather than rendering
  > nothing. The "unattributed boxplot" does not
  > exist (Statistics' Boxplot 1.8 is attributed and already among the seven), Precalculus' "Residual
  > plot" is published as `kind='vocabulary'` with no labelled parts, and three entries need more than
  > one figure each. See `LANE_A_REMAINING_ENTRIES_CLASSIFICATION_2026_10_11.md`.
  >
  > **UPDATE (2026-10-11).** AP Statistics is built: nine figures, five families, all three gates
  > passed, loaded to Development, Production still a Hard Gate
  > (`LANE_A_STATISTICS_BATCH_2026_10_11.md`). **Five entries and six figures remain** — AP Physics 2
  > ×3, AP Physics C: Mechanics ×1, AP Precalculus ×1 — needing two further families. That batch also
  > found seven layout defects, four of them affecting already-published figures. **Three of those were
  > real in the app's TypeScript renderer and are fixed** (`ap-prep-blueprint` PR #6, not yet
  > published); the other defects existed only in the Python pilot renderer, which is worth stating
  > because the two renderers drift and the student only ever sees the TypeScript one.
- **One figure has no home.** `chem-mb-catalysis` draws a real teaching point but no published
  entry matches it; the nearest are a Unit 5 convention and a Unit 3 vocabulary entry. It is not
  production-eligible until an entry exists.

## Change note

v1.7 (2026-10-11): §6 gains the parity command, the instruction to run it over every family rather
than the new one, and the rule that `hypot` stays out of anything that becomes a coordinate. §9
records that the app now knows the four Lane B families.

v1.6 (2026-10-11): §9 records that Lane B is built bar AP Biology, and §4c gains the rule that a
control must be a mistake a reader can SEE -- a control that only reordered a figure's isoline radii
drew the same picture, was correctly accepted, and voided a sound batch.

v1.5 (2026-10-11): `DECISION-0116` in §3 — a figure's `labels` may be the contract for an entry that
authors no `items[]`, declared per use and gated. §2 records that `kind` is not the lane filter. §4a
gains coverage for every used entry, a fixture digest check, and the exact-string warning for shared
figures. §4b gains `build_eye_sheet.py`.

v1 (2026-10-11): written from the AP Chemistry pilot and its Production deploy
(`APPROVAL-0153`). Supersedes nothing; the four-lane model in
`../architecture/VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md` still governs, and TASK-0006's five owner
decisions remain formally open — this protocol records what was approved and built for Lane A
reference diagrams specifically.

v1.4 (2026-10-11): §9 records the AP Statistics batch, and §4b gains two checks that now enforce
what the eye used to have to catch — nothing drawn outside the canvas, and no two labels overprinting.
Both found defects in published figures on their first run.

v1.3 (2026-10-11): §6 and the §9 correction record `DECISION-0115` — a renderer family is a row in
`app.figure_families`, not a CHECK, so adding one is an insert rather than a migration.

v1.2 (2026-10-11): a §9 correction recording that the remaining Lane A work is twelve entries and
fifteen figures, needs seven new renderer families, and requires a migration because the family list is
a CHECK constraint. Classification: `LANE_A_REMAINING_ENTRIES_CLASSIFICATION_2026_10_11.md`.

v1.1 (2026-10-11): one addition in §4a, recording that the label-coverage gate checks against a
committed fixture of the published entries and fails on a missing one. No policy changed; the
addition closes a hole in how §4a was enforced, not in what it requires.
