# Lovable Patch - Beta Review Findings

Apply targeted fixes to the existing Cramapple beta at
`https://cramapple-beta.lovable.app/beta`. This patch supersedes the narrower
revision-scoring patch in `LOVABLE_BETA_FIX_REVISION_SCORING.md` and folds in
findings from a second walkthrough.

The patch is organized so an iterator who stops after Section 1 still ships
value. Do Section 1 first, then Section 2, then Section 3.

The patch is UI-only unless otherwise noted. Do not redesign anything that
already works. Do not touch the live grader, persistence, or anonymous-session
behavior except where E1 requires reading a different field on the existing
merge output.

Do not promise "human review", "dispute", "recheck", or "regrade" anywhere in
the beta, including preview surfaces. Use the existing `Report wrong feedback`
modal and the disclaimer copy it already carries.

---

## Section 1 - Errors

### E1. Comparison panel still misreports revised totals and buckets

**Backend is correct as-is.** `submitRevisionFn` in
`beta-attempt.functions.ts` already loads the prior grade, sends only the
target criterion to the grader, and merges the result with the carried-forward
baseline. Do not change it. The bug lives in the comparison panel render.

Observed on the Photosynthesis FRQ historic attempt: `ORIGINAL 2/4`,
`REVISED 2/4`, `Δ +0` rendered alongside `GAINED 1` (the electron-path
criterion correctly shown as `0 → 1/1`). The arithmetic cannot be right. The
panel is reading the raw revised-text grading output rather than the merged
criterion decisions returned by the backend.

**Fix.** Make the comparison panel render strictly from the merged criterion
decisions. The `REVISED` tile, the `Δ` value, and every per-criterion bucket
must derive from the same merged result the backend produces.

Replace the current three-bucket layout (`GAINED / UNCHANGED / STILL MISSING`)
with a four-bucket layout that makes the semantically distinct states
explicit:

```
GAINED                 (targeted criteria that now earn the point)
UNCHANGED — EARNED     (originally 1/1, untouched, still 1/1)
TARGETED — NOT EARNED  (targeted this round, revision did not earn it)
STILL MISSING          (originally 0/1, not the focus of this repair)
```

Empty buckets must not render. Order is fixed.

**Targeted chip and evidence line.** Within `GAINED` and `TARGETED — NOT
EARNED`, the criterion must carry an explicit `Targeted` chip. The targeted
criterion (whether `GAINED` or `TARGETED — NOT EARNED`) must include an
evidence line for the grader's decision on the revised text, using the same
`Missing: …` / `Try: …` pattern the result-state previews already use.
Non-targeted criteria do not need new evidence lines; their decisions are
carried forward unchanged from the original grade.

**Lost delta.** Omit `Lost` from the rendered UI. The `Fix this part` entry
point only opens for missed criteria, so the targeted criterion can only
Gain or stay Missed. Keep the data-layer enum extensible (`gained /
unchanged / still_missing / lost`) so a future full-regrade mode can use
it, but do not render an empty `Lost` bucket today.

**Score tile format.** Keep `ORIGINAL` and `REVISED` as labels with the
score as the value, exactly as today. Do not change the tile.

**Stale historical data.** If older stored attempts predate the backend
fix and contain pre-merge revision rows, those rows may render with the
wrong values until they're recomputed on read. Backfilling old rows is
optional; the acceptance check below is on fresh attempts.

Spec: `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md` §§6.2, 9, 11.

### E2. UX-007 preview uses `mastery` and percentage bars

`/beta/preview/learner` headlines a "Skill / criterion mastery" section with
`71% / 58% / 62%` bars. This is the single most explicit thing the prior
prompt forbade.

**Fix.** Replace with evidence-state language only. Each row must use one
of these seven states:

- `Independent success now`
- `Supported success`
- `Review due`
- `Retained evidence`
- `Mixed evidence`
- `Needs attention`
- `Evidence withheld`

No `%`. No bars. No `Mastered`. The "Recent scores" tile must drop the
bare `3/4 · today` framing and instead use a labeled row, e.g.
`Independent attempt · 3/4 earned, gap on heterozygote prediction · today`.

Spec: `docs/product/PROGRESS_REVIEW_RECOMMENDATIONS_DESIGN.md` §5.

### E3. Result-state previews use forbidden review-service language

Several `/beta/preview/result/*` slugs use language the prompt explicitly
disallowed even in preview:

- `low_confidence` and `abstained`: button labeled `Request human review`.
- `disputed_pending`: section header `Dispute · pending`, status
  `Queued for reviewer`.
- `regraded_changed`: description `Human reviewer adjusted the score`,
  header `Regrade · score changed`.

**Fix.** Sweep the following replacements across all eight result-state
fixtures and any other beta surface that uses these words:

- `Request human review` → `Report wrong feedback` (open the existing
  modal).
- `Dispute · pending` → `Report received · reviewing`.
- `Queued for reviewer` → `Saved for review`.
- `Human reviewer adjusted the score` → `Cramapple reviewed and updated
  this grade.`
- `Regrade · score changed` → `Updated grade · changed`.
- `Regrade · score unchanged` → `Updated grade · unchanged`.

After the sweep, no instance of `Human review`, `Dispute`, `Recheck`, or
`Regrade` appears in any rendered text on any beta route, excluding the
disclosure banner copy which may stay as-is.

Spec: `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md` §12.

### E4. UX-008 preview implies upload and extraction

`/beta/preview/capture` flow narrative says "The phone uploads the image
to your account." and includes an "Extracted features (fixture)" card.

**Fix.**

- Step 3 narrative: replace with research-only language.
  "In production, the phone would send the captured image to Cramapple
  for review. This preview does not."
- "Extracted features (fixture)" card: either remove or relabel as
  "Planned feature panel · fixture — Cramapple does not extract real
  graphs."
- Add the disclaimer `Capture accepted does not mean the graph is correct.`
  next to the `Looks ready` state once that state is added under G3.

Spec: `docs/product/HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md` §§10, 17.

### E5. Result-state route 404 message renders inline

Navigating to an unknown slug (e.g. `low_confidence_withheld` instead of
`low_confidence`) renders `Unknown result state. Jump to confident_partial.`
in the main canvas with no recovery affordance.

**Fix.** Either render a proper 404 component listing the eight valid
slugs as links, or redirect to `/beta/preview/result/confident_partial`
and surface a one-line `We couldn't find that state. Showing confident
partial.` notice.

---

## Section 2 - Gaps

### G1. UX-004 preview must be the five-stage walkthrough

`/beta/preview/byoq` is currently one screen showing a classifier-state
cycler. Expand to the five stages required by the spec, on subroutes:

- `/beta/preview/byoq/add` — Stage 1 Add question. Type-or-paste textarea,
  plus simulated `Photo or screenshot` and `Document` affordances rendered
  as visibly disabled mock buttons (see G6). Capture guidance copy from
  the spec §4.2.
- `/beta/preview/byoq/capture` — Stage 2 Confirm capture. Original
  submission preview alongside an editable extracted block. Include a
  personal-information-warning fixture with actions
  `Review and remove` / `Use another image` / `Cancel` and no
  `Continue anyway`. Include an extraction-failure fixture that preserves
  the original preview and offers retake or switch to typing.
- `/beta/preview/byoq/match` — Stage 3 Confirm match. Keep the existing
  five-state classifier cycler (high / moderate / low / unsupported /
  abstained). Surface the `Yes, continue` / `Choose a different topic` /
  `Add context` actions from §6.2.
- `/beta/preview/byoq/help` — Stage 4 Choose help. Four tiles:
  `Teach me`, `Give me a hint`, `Check my work`, `Walk me through a
  solution`. Each tile states its evidence consequence in one line.
  `Check my work` reveals a learner-answer field.
- `/beta/preview/byoq/review` — Stage 5 Review and begin. Summary card with
  input method, confirmed question text, proposed subject + confidence,
  selected mode, assessment-context choice, learner answer if any, and the
  data-and-publication explainer from §10. Primary action label changes
  by mode.

Add a stage stepper at the top of each subroute showing current and
completed stages.

Spec: `docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` §§3–9.

### G2. UX-007 preview must add taxonomy, `Why this?`, alternatives, history, and misconception card

Beyond E2:

- The recommended-next-action card adds a `Why this?` link that opens an
  inline factors drawer. The drawer lists the labeled factors that
  produced the recommendation: exam value, recent independent evidence,
  due review, recurring criterion gap, evidence confidence, demonstrated
  improvability, time cost, learner goal, available time. Plain language,
  no opaque score.
- The card adds a `Choose something else` link that opens an alternatives
  panel with: `same priority shorter`, `another due review`, `practice a
  chosen topic`, `bring or check a question`, `move on`.
- Add a "Recommendation history" tile with three sample rows: accepted,
  overridden, deferred. Each row shows the original recommendation, the
  learner's choice, and the later outcome. Preserve original reasoning
  even when overridden.
- Add a "A pattern to check" tile rendering one misconception-hypothesis
  fixture using exactly the phrase `A pattern to check`. Show evidence
  from multiple relevant attempts, where the pattern did not appear, a
  recommended discriminating question, and confidence in the
  interpretation. Do not label the learner globally.

Spec: `docs/product/PROGRESS_REVIEW_RECOMMENDATIONS_DESIGN.md` §§8, 10,
11, 12, 16.

### G3. UX-008 preview must add quality and accessibility states

`/beta/preview/capture` currently renders only the pair-and-frame flow.
Add a state selector at the top with: `QR ready`, `QR expired`,
`Permission explanation`, `Framing`, `Photo review`, `Looks ready`,
`Retake recommended`, `Cannot determine`, `Submitted`,
`Accessible alternative`.

Each state renders a fixture using the spec's `Looks ready` / `Retake
recommended` / `Cannot determine` copy patterns. The `Accessible
alternative` state shows a non-camera path: direct file upload affordance
(disabled), manual code instead of QR, keyboard-operable photo review
controls, and a coordinate-entry alternative when the construct allows.

Add the disclaimer `Capture accepted does not mean the graph is correct.`
to the `Looks ready` state.

Spec: `docs/product/HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md`
§§6–14.

### G4. Live cold composer prints answer-bearing hints

Per-criterion missed cards in the live attempt page still show
`To earn the next point: …` followed by `Add that …` (essentially the
answer in prose). Adopt the cleaner pattern the result-state previews
already use: keep `Missing: …` (what is absent) and `Try: …` (abstract
action). Drop the verbatim sentence completion.

Spec: `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md` §§6.1, 6.2, 9.

### G5. Self-prediction control in the live attempt is wrong shape

The live cold composer asks `How many rubric points do you think this
answer would earn? Optional. [0] / 4` with a stale `0` default. The
revision still shows only `Better (+1 pt) / Much better (+2 pts)`.

**Fix.** Replace both with a discrete control constrained to currently
unearned points: `+0 / +1 / +2 / …` with labels `+0 points / +1 point /
+2 points`. Default to no selection (not `0`). Do not render choices
above the maximum possible gain.

### G6. UX-004 preview affordances should be visibly disabled

The current `Upload image` and `Use camera` buttons appear pressable
with a sentence saying they are non-functional. Render them with the
`disabled` attribute and a tooltip `Non-functional in this preview` so
the affordance reads as a mock from a glance.

### G7. Result-state previews still use raw `n/n` instead of semantic state pills

Add the four UX-006 §6.2 criterion status pills on every result-state
fixture: `Earned` / `Not yet earned` / `Unable to determine` /
`Not applicable`. The `abstained` fixture must use `Unable to determine`
for every criterion and must not present `0/1` rows. The totals row on
that fixture must read `—` rather than a sum, since no criterion was
evaluated.

---

## Section 3 - Polish

### N1. Landing H1 contradicts new positioning

The H1 still reads `See exactly how an AP Biology answer could earn more
points.` Replace with copy that matches the post-preview reframe, e.g.
`Try Cramapple's FRQ feedback loop. Explore where the rest is headed.`

### N2. Page `<title>` is stale

Update from `Cramapple Beta — AP Biology score optimization` to
`Cramapple beta — FRQ feedback loop and product previews`.

### N3. Resume row contains a non-4-point total

One row reads `Enzyme kinetics and temperature — 23h ago · Complete ·
3 / 3`. Every Enzyme kinetics rubric is 4 points. Inspect the data layer
for stale rows with non-canonical rubric totals and either backfill or
filter from display.

### N4. Resume score for attempts with submitted revisions

Once E1 lands, the Resume summary score for an attempt that has a
submitted revision must use the merged total, not the pre-revision total.

### N5. Remove the `Edit with Lovable` corner badge

Before any external preview link goes out, replace or hide the bottom-right
Lovable badge.

### N6. Long-lived analytics keep `document_idle` from firing

Devtools and some click handlers were intermittently unresponsive during
the review. The likely cause is a long-lived `events.js` / `flock.js`
keep-alive that prevents `document_idle` from firing. Confirm the interval
and either lengthen it or move analytics to an event that fires after
first idle.

### N7. UX-007 persona tabs need one-line captions

The three persona tabs (`Ari (new student) / Jordan (mid-unit) / Sam
(exam-ready)`) render without explanation. Add a one-line
`What this shows` caption per persona so the demo is self-explanatory.

### N8. Comparison view labels are redundant

The new panel uses `TARGETED REPAIR COMPARISON` as a header AND
`COACHED REVISION` as a sub-label AND `ORIGINAL` / `REVISED` columns.
Drop the `COACHED REVISION` sub-label, or replace it with a status pill
like `Coached, single-criterion repair`. Pick one.

---

## Acceptance Checks

Run each of these on the current deployed build after the patch.

### A1. Revision earns the targeted point

Cold-submit a fresh Photosynthesis FRQ attempt with a deliberately partial
2/4 answer. Click `Fix this part` on the missed electron-path criterion.
Submit a revised paragraph that correctly traces
`PSII → ETC → DCPIP`. The comparison panel must render:

- `ORIGINAL 2 / 4`
- `REVISED 3 / 4`
- `Δ +1`
- `GAINED` bucket — one row, the electron-path criterion, with a
  `Targeted` chip and a `Missing` / `Try` evidence line specific to the
  revised text.
- `UNCHANGED — EARNED` bucket — two rows: `Identifies water as electron
  source` and `Predicts DCPIP stays blue with DCMU`, both at `1/1`.
- `STILL MISSING` bucket — one row: `Explains O₂ evolution`, at `0/1`,
  no `Targeted` chip.
- `TARGETED — NOT EARNED` bucket — empty in this scenario, therefore not
  rendered.

### A2. Revision does not earn the targeted point

Repeat the cold submission. Click `Fix this part` on the same criterion.
Submit a deliberately weak revision. The comparison panel must render:

- `ORIGINAL 2 / 4`
- `REVISED 2 / 4`
- `Δ +0`
- `GAINED` bucket — empty, not rendered.
- `TARGETED — NOT EARNED` bucket — one row, the electron-path criterion,
  with a `Targeted` chip and a `Missing` / `Try` evidence line specific
  to the revised text.
- `UNCHANGED — EARNED` bucket — two rows as in A1.
- `STILL MISSING` bucket — one row as in A1.

The revised total must never drop below the original.

### A3. No forbidden review-service language

Navigate every `/beta/preview/result/*` route and confirm no instance of
the words `Human review`, `Dispute`, `Recheck`, or `Regrade` in rendered
text. The disclosure banner is exempt.

### A4. No mastery framing on UX-007 preview

Navigate `/beta/preview/learner` and confirm no `%` symbols on
progress rows and no instance of the word `mastery` anywhere on the
page.

### A5. UX-004 five stages resolve

Navigate each of the five `/beta/preview/byoq/{add,capture,match,help,review}`
routes and confirm the stage stepper renders the correct current stage.

### A6. No upload or extraction language on UX-008 preview

Navigate `/beta/preview/capture` and confirm no instance of `upload`
or `extracted` outside fixture-disclosure copy. Confirm the
`Capture accepted does not mean the graph is correct.` disclaimer
appears on the `Looks ready` state.

---

## Reference Specs

- `docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` (UX-004)
  §§3–10
- `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md` (UX-006)
  §§4–14
- `docs/product/PROGRESS_REVIEW_RECOMMENDATIONS_DESIGN.md` (UX-007)
  §§5–16
- `docs/product/HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md` (UX-008)
  §§4–17
