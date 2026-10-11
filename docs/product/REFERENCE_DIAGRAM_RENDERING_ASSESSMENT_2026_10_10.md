# Turning diagram descriptions into drawn diagrams — assessment

**Date:** 2026-10-10
**Status:** Proposal for Product Owner decision. No code, content or log changes.
**Governing design:** `docs/architecture/VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md`
(four-lane model), gated by `TASK-0006`, **Approval: Pending since 2026-06-12**.

## 1. Where the "text only" line comes from

`app.unit_reference_entries` rows of `kind = 'diagram'` carry a one-line `body`
description, an ordered `items[]` of `{label, meaning}` labelled parts, an optional
`caution`, and `visual_asset_ref text`.

`visual_asset_ref` is a **forward declaration that points at nothing**. Its migration
comment names "an existing visual-stimulus asset (TASK-0006 governed-diagram lane)";
no assets table exists, and the only constraint on the column is that it may be set
solely when `kind = 'diagram'`. It is null on every row. The frontend
(`GraphEntries` in `QuestionExperience.jsx`) therefore prints the honest fallback:
"Text only for now. The drawn version isn't available yet."

So nothing is broken. The picture slot was designed, named and left empty on purpose,
pending a decision that has not been taken.

## 2. The description is not a placeholder for the picture — it is the picture's
   required companion

Lane C of the governing design requires every visual to ship an accessible companion:
alt text, a structured table of underlying values where they exist, labels and units
reachable by assistive technology, and no reliance on colour alone. The authored
`body` + `items[]` + `caution` already satisfy most of that, and they are already on
screen.

This matters for the framing of the question. We are not replacing descriptions with
graphs. We are **adding a drawn form above a description that must stay**, and the
description we would keep is already written and already checked. Lane C is the part
that is done.

## 3. Delivery is already built and live — do not build a second one

The student-facing image path exists end to end:

- `content_item_versions.stimulus_image_path`, with `image_needed` and
  `image_approval` gating columns;
- a private stimulus bucket signed **server-side inside
  `supabase/functions/student-session-items`**, which also carries the
  `teaching_image` mode returning `{url, alt, long_description}` for a
  `(subject_key, topic_code)` pair;
- `src/lib/question-experience/worked-example.ts` in the live app consumes exactly
  that shape and `QuestionExperience.jsx` renders it as `qx-figure` with alt text.

Note the deliberate rule in that code: **students never call `storage-sign-url`**.
That function's `canAccessBucket` grants `content-assets` to `admin` and
`content_author` only; the live app uses it from reviewer routes alone
(`reviewer.gold-set.verify.tsx`, `reviewer.review.$assignmentId.tsx`). Any reference
diagram lane must sign server-side the same way, not widen `storage-sign-url`.

Whatever we decide below, the answer to "how does the drawn version reach the
student" is: reuse this. The open work is authoring and rendering, not delivery.

> **Correction (same day).** The first version of this document counted 30 entries
> from a working branch that was 95 commits behind `main`. Counted against `main` the
> figure is **41**, because the `task0067-chem-u5-u9-2026-10-10` pack adds nine
> Chemistry entries, almost all of them charts. The corrected split and a changed
> pilot recommendation are below.

## 4. The real scope is 41 entries, and it splits cleanly in two

Every `diagram` entry across all nine subject reference packs, classified against the
four-lane model:

### Lane A — deterministic rendering from a structured spec (23)

Standard chart archetypes and function curves. These need **data plus axes, not an
artist**. Most are teaching what a chart *type* looks like, so pedagogically synthetic
illustrative data is sufficient (owner decision 4 in TASK-0006 §11 covers exactly
this).

| Subject | Entry |
| --- | --- |
| AP Statistics | Bar chart, Boxplot, Dotplot, Histogram, Pie chart, Stem-and-leaf plot, Graphs for two categorical variables |
| AP Precalculus | Residual plot |
| AP Chemistry | Mass spectrum of a single element; Potential energy vs. internuclear distance graph; Maxwell–Boltzmann energy distribution; Maxwell–Boltzmann distribution (catalysis); Single-step reaction energy profile; Multistep reaction energy profile; Energy diagram for a physical or chemical process; Graphs showing the approach to equilibrium; Titration curve (pH vs. volume of titrant); Photoelectron spectrum (PES) |
| AP Physics 2 | PV diagram; Graph of electric potential versus position in a loop; Maxwell–Boltzmann distribution (qualitative) |
| AP Physics C Mech | Reading x(t), v(t), a(t) graphs |

### Lane B — constrained grammar or commissioned asset (18)

Spatial and schematic. Not plottable from data.

| Subject | Entry | Sub-kind |
| --- | --- | --- |
| AP Physics 1 / C Mech | Free-body diagram (×2), Vector arrow representation (×2) | **constrained grammar** — labelled arrows from an origin |
| AP Physics 2 / C E&M | Electric field map and field line diagram (×2), Equipotential (isoline) map, Circuit schematic symbols | constrained grammar / symbol library |
| AP Chemistry | Particulate model of solid, liquid and gas; Particulate representation of a balanced equation; Particulate representation of a solution; Sea-of-electrons model of metallic bonding | **constrained grammar** — coloured circles in a box |
| AP Biology | Antiparallel DNA double helix; Chloroplast structure; Fluid mosaic model of the plasma membrane; Mitochondrion: regions and functions | commissioned or licensed asset |

## 5. Two findings that should change TASK-0006's V1 proposal

**TASK-0006 §10 names phylogenetic trees as the first Lane B prototype. No reference
entry in any pack is a phylogenetic tree.** That proposal was written in June 2026
against the 964-item question plan, not against the reference-content corpus that now
exists. Building it first would serve nothing currently authored.

**The cheapest real Lane B prototype is free-body / vector-arrow diagrams (4 entries,
2 subjects), followed by chemistry particulate boxes (4 entries).** Both are tiny
constrained grammars — arrows with magnitude, direction and label; circles with
colour, count and arrangement — rendered deterministically from a spec with no rights
exposure and no generative images. Only the four Biology entries genuinely need a
commissioned asset.

## 6. Recommended path

1. **Take the TASK-0006 owner decisions** (§11, five of them). They have blocked this
   lane for four months. Decisions 1 and 4 are the ones that unblock the work here:
   approve the four-lane model, and allow pedagogically synthetic illustrative data
   under the stated disclosure and validation rules. Without 4, the fourteen Lane A
   chart archetypes cannot be drawn at all, because they have no real dataset.
2. **Amend the V1 prototype scope** per §5 above: Lane A charts first, free-body and
   particulate grammars as the Lane B prototype, phylogenetic trees dropped from V1,
   Biology's four entries deferred to a commissioning decision.
3. **Add a structured spec column, do not reuse `visual_asset_ref` for Lane A.**
   `visual_asset_ref` is a pointer to a stored binary — the right shape for Lane B and
   the wrong shape for Lane A. Lane A wants a validated `visual_spec jsonb` holding
   chart type, series, axes, units and labels, rendered client-side by a constrained
   component. Keeping them as separate columns keeps the two lanes independently
   gated and keeps untrusted SVG out, as §Data/Security of TASK-0006 requires.
4. **Pilot on AP Chemistry, not AP Statistics.** The corrected count moves the centre
   of gravity: Chemistry now has ten Lane A entries to Statistics' seven, and more
   importantly it is where the **reuse** is concentrated. Three entries across two
   subjects are Maxwell–Boltzmann curves (Chemistry's energy distribution, Chemistry's
   catalysis variant, Physics 2's qualitative one) and three more are reaction energy
   profiles (single-step, multistep, and the general process diagram). Six of
   Chemistry's ten entries are therefore served by **two** parameterised specs.

   That is the whole argument for spec-over-picture, measurable: six pictures to
   commission and maintain separately, or two renderers with different parameters.
   Statistics remains a good second slice — its seven archetypes are seven genuinely
   different charts, so it proves breadth where Chemistry proves reuse.
5. **Keep the text under every drawing.** Lane C is not optional and the fallback line
   should remain accurate for entries without a spec — one surface, two states, never
   a silent swap.

## 7. What not to do

- Do not generate the diagrams with an image model. Lane D is explicitly deferred
  from production, and these are scientific figures where a plausible-looking wrong
  axis is worse than prose.
- Do not widen `storage-sign-url` to students (§3).
- Do not start by commissioning Biology art. It is the smallest slice, the highest
  unit cost and the only one with a rights question.
