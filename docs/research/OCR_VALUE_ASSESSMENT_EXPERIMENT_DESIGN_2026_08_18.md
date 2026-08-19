# Assessing OCR's Value for Engine 4 — Experiment Design

**Written:** 2026-08-18
**Status:** Proposed experiment design, not yet run beyond the free/local pieces explicitly
marked DONE below. No DECISION/APPROVAL exists for anything here.

**Why this doc exists:** the standalone OCR axis probe (see
`docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md`, "Dedicated-OCR probe"
and its full-scale follow-up) measured whether OCR reads axis tick numbers accurately. It
never measured OCR's *value in the grading pipeline* — no `gpt-5.2`+OCR or
`gpt-5.2-pro`+OCR joint result has ever been produced. This is that experiment design,
covering three configurations: OCR alone, OCR as an escalation signal for `gpt-5.2`, and OCR
as primary with `gpt-5.2` as its escalation.

---

## 0. The framing correction this design has to make first

**"OCR alone" cannot mean full-response grading.** OCR (macOS Vision framework,
`VNRecognizeTextRequest`) reads printed/handwritten text. It has no point/marker-detection
step and cannot judge drawing type, category identity, or mark presence. Any experiment that
scores "OCR alone" against a full response's criterion set will trivially fail on the
majority of criteria — that isn't a finding about OCR, it's a category error in the test
design. **Every experiment below is scoped at the criterion level**, split into what OCR can
plausibly ever decide vs. what always needs a vision model, using the actual criterion sets
from the corpus (`docs/research/hand_drawn_graph_corpus_2026_06_29/hand_drawn_graph_questions_2026_06_29.jsonl`):

| Archetype | OCR-answerable criteria (numeric/text reading) | Always-vision criteria (shape/mark/semantic judgment) |
|---|---|---|
| `CAT` (categorical, 6 criteria) | `Y_UNIT`, `Y_SCALE` (2/6) | `REPRESENTATION_TYPE`, `CATEGORY_IDENTITY`, `PLOT_VALUES`, `UNCERTAINTY_MARKS` (4/6) |
| `SER` (continuous series, 8 criteria) | `X_UNIT`, `Y_UNIT`, `X_SCALE`, `Y_SCALE` (4/8) | `REPRESENTATION_TYPE`, `PLOT_VALUES`, `POINT_CONNECTION`, `UNCERTAINTY_MARKS` (4/8) |
| `EST` (relationship+estimate, 9 criteria) | `X_UNIT`, `Y_UNIT`, `X_SCALE`, `Y_SCALE` (partial — see below), `ESTIMATE_VALUE` (~4.5/9) | `REPRESENTATION_TYPE`, `PLOT_VALUES`, `BEST_FIT_RELATIONSHIP`, `ZERO_INTERCEPT_ANNOTATION` (4/9) |

`EST`'s `Y_SCALE` ("Y-axis includes zero and all observations") is only *partially*
OCR-answerable — OCR can check whether 0 appears among the detected y-axis ticks, but "all
observations" requires knowing the plotted points, which needs vision. Score it as
OCR-answerable only for the zero-inclusion half; route the rest to vision or mark
`unable_to_determine`.

**Consequence for all three configurations below:** even a maximally successful OCR program
only ever touches 2-5 of 6-9 criteria per archetype. Frame every result as "cost/latency
reduction and/or accuracy improvement on the subset OCR can reach," never as "OCR replacing
the vision model." A response-level exact-match number is still worth reporting (it's the
number that actually matters to a student's grade), but interpret it knowing OCR structurally
cannot move it past the ceiling set by the always-vision criteria.

`Y_UNIT`/`X_UNIT` detection is a new capability, not yet built — the existing OCR probe only
scores numeric tokens (`axis_range_ok`, `estimate_ok`). The corpus's `expected_graph_spec.x_axis`/
`y_axis` fields carry the expected unit substring in parentheses (e.g. `"(a.u.)"`,
`"(deg C)"`, `"(umol/min)"`, `"(M)"`, `"(%)"`) — Vision OCR already reads this text (the
probe currently discards it via `normalizeNumericText`'s numeric-only filter), so detecting
unit presence is a small addition, not new infrastructure.

---

## 1. Prerequisite (Experiment 0): orientation-invariant axis-role assignment

**Blocking everything below.** The current heuristic (`t.x < 0.30` = y-axis, `t.x >= 0.30 &&
t.y < 0.45` = x-axis) assumes a fixed left/bottom layout and is confirmed broken on photos
where axes run along other edges (diagnosed on `SER-001`; reproduced structurally at full
200-photo scale, 18.4% `axis_range_ok`, see the research doc's full-scale OCR section).

**Proposed fix (local, free, no model calls):** replace the fixed-position rule with
geometric clustering on the OCR tokens' bounding-box positions:
1. Take all numeric tokens' `(x, y)` centers (Vision's normalized coordinate space).
2. Two axes are two roughly-perpendicular lines of collinear points. Fit a line to
   candidate token clusters (e.g. via a simple 1D-variance split: partition tokens into two
   groups by which coordinate — x or y — has near-zero variance within the group, since an
   axis's tick labels share one coordinate closely) rather than assuming which edge each
   axis is on.
3. Fall back to the current left/bottom heuristic only if clustering is ambiguous (fewer than
   4 numeric tokens total, or no clean two-group split) — and mark that response
   `unable_to_determine` for scale criteria rather than guessing, which the current script
   does not do (it currently forces `axis_range_ok: false` on low-token cases instead of
   abstaining — this conflates "OCR failed to find enough text" with "OCR read the axis
   wrong," and Experiment 3 below needs that distinction to trigger escalation correctly).

**Deliverable:** `scripts/vercel-gateway-check/ocr_criterion_decider.mjs` — takes raw OCR
output for one photo + the corpus's `criterion_definitions`/`expected_graph_spec`, returns a
per-OCR-answerable-criterion verdict (`earned`/`not_earned`/`unable_to_determine`) plus a
coverage flag distinguishing "OCR decided" from "OCR abstained." This is the shared building
block all three experiments below consume — build it once, not per-experiment.

**Gate before proceeding:** hand-verify the fix on the same photos already used for hand
verification (`EST-016`, `SER-001`, `SER-002`) plus 5-10 more spanning both `CAT`/`SER`/`EST`
and both packet-quality tiers, the same way the original 3-photo check worked. If the fix
doesn't visibly resolve the axis-role misassignment on these cases, don't proceed to
Experiment 1 on a still-broken decider — that just produces a new misleading number instead
of the old one.

---

## 2. Experiment 1 — OCR alone (criterion-subset ceiling, free/local)

**Question:** on exactly the criteria OCR can plausibly ever decide, how accurate is it —
and how does that compare to `gpt-5.2` on the *same* criteria?

**Method:** run the fixed decider (§1) on all 200 photos, score against gold on the
OCR-answerable criterion subset only (§0's table). Zero API cost, ~1 minute wall time — same
scale as the free full-corpus probe already run. Compute per-criterion-type F1/FAR/FRR (unit-
presence criteria, scale-range criteria, and `EST`'s `ESTIMATE_VALUE` as three separate
buckets, since they're answered by different logic and may have very different accuracy) plus
a coverage rate (% of cases OCR could decide vs. abstained for insufficient tokens/ambiguous
clustering).

**Comparison, at zero additional cost:** `gpt-5.2`'s existing full-corpus run
(`runs/real_photo_benchmark_gpt52_results.jsonl`) already has per-criterion predictions for
every one of these same criteria on the same 200 photos — pull `gpt-5.2`'s F1/FAR/FRR on
exactly the OCR-answerable criterion subset for a direct, no-new-spend comparison table.

**Decision gate:** if OCR's F1 on its answerable subset doesn't clear `gpt-5.2`'s F1 on that
same subset by a real margin (not noise — check n and confidence the same way the escalation
work now knows to), OCR isn't worth building into the pipeline as a decision-maker, only
(at most) worth keeping as the grounding-injection idea in §5. Don't proceed to Experiments
2-3 on a negative Experiment 1 result without first checking whether coverage (not just
raw accuracy on decided cases) is the actual value driver — a criterion decider can be
low-recall/high-precision and still be useful as a *narrow, confident* signal even if its
raw F1 doesn't beat `gpt-5.2`'s.

---

## 3. Experiment 2 — OCR as an escalation *trigger* for `gpt-5.2` (verification/disagreement routing)

**Question:** does independent OCR disagreement with `gpt-5.2`'s judgment predict `gpt-5.2`
error, the same way inter-run disagreement already does for Engine 1 (handoff doc §5: 20.8x
enrichment, 62.5% precision / 18.5% recall as a trigger)?

**Stage 2a (free, zero new spend, do this first):** `gpt-5.2`'s existing run already has a
per-criterion verdict for every OCR-answerable criterion. Compare OCR's decided verdict
(where it didn't abstain) against `gpt-5.2`'s verdict on the same criterion. Where they
disagree, check against gold: how often is `gpt-5.2` the one that's wrong? This gives a
precision/recall read on "OCR disagreement" as an error-detection signal, entirely from data
that already exists — no new model calls, no new photos, just a join across two files
already on disk.

**Sizing rule (apply before trusting the result):** per the handoff doc's own trap #5 and
Lesson 19, score this at realistic volumes, not the corpus's inflated error rate — if
disagreement only fires on a handful of cases in a 200-photo corpus, the same "high recall
rule that's unusable at production base rate" trap that hit Engine 1's text-based trigger
could apply here too. Report the raw disagreement count before citing a percentage.

**Stage 2b (small paid confirmatory run, only if 2a is promising):** on a deterministic
sample of cases where OCR and `gpt-5.2` disagree (start at ~20-30, not the full set — this
investigation has already learned twice this session that small-n first, full-scale second is
the right order, not the reverse), escalate just the disagreeing criterion to `gpt-5.2-pro`
and check whether the escalated verdict resolves toward gold. This is structurally identical
to the already-run escalation controlled test, just gated on OCR disagreement instead of
`gpt-5.2`'s own confidence field — reuse
`scripts/vercel-gateway-check/hand_drawn_graph_escalation_gemini_run.mjs`'s harness shape,
swap the subsample-selection criterion.

**Note the architectural difference from §4:** here `gpt-5.2` stays authoritative on
everything by default; OCR only ever *flags* a criterion for a second look. This is a purely
additive safety layer — it cannot make `gpt-5.2`'s baseline numbers worse, only trigger more
(possibly expensive) escalation calls. The question is whether the trigger is precise enough
to be worth its escalation volume, exactly as already learned from Engine 1's disagreement
trigger.

---

## 4. Experiment 3 — OCR as primary, `gpt-5.2` as escalation (reversed roles)

**Question:** for the OCR-answerable criterion subset, can OCR decide directly — with
`gpt-5.2` only called when OCR itself abstains (low token coverage / ambiguous clustering) —
without a real accuracy cost, while cutting the number of model calls needed?

**This is the one configuration with a real cost/latency upside independent of accuracy**:
OCR is free and near-instant; every criterion OCR can confidently decide is a criterion that
never needs to consume a `gpt-5.2` (let alone `gpt-5.2-pro`) call at all. If Experiment 1
shows OCR's accuracy on its answerable subset is competitive, this could reduce both $ and the
escalation-tier call volume that currently drives Engine 4's worst latency problem (§3 of the
Engine 4 design doc — 23-36s per `gpt-5.2-pro` call, no async architecture exists yet).

**Method:**
1. For each response, run the OCR decider (§1) on its answerable criteria first.
2. Where OCR decided (didn't abstain): use OCR's verdict directly as primary.
3. Where OCR abstained: call `gpt-5.2` for that criterion (this is the actual "escalation" —
   OCR punting, not OCR being overridden).
4. For always-vision criteria (§0's right-hand column): always call `gpt-5.2` as today — this
   is a fixed division of labor, not escalation, and must be reported as such so a result
   isn't misread as "OCR handles most of the response." It doesn't, structurally can't, and
   framing it as escalation would overstate OCR's coverage.
5. Compute response-level exact match / F1 / FAR / FRR for this hybrid, same definitions as
   the rest of this investigation, and compare against the two existing full-corpus numbers:

   | | Exact match | F1 | FAR | FRR |
   |---|---:|---:|---:|---:|
   | `gpt-5.2` alone (baseline) | 38.5% | 93.3% | 19.0% | 8.0% |
   | `gpt-5.2` + `gpt-5.2-pro` EST-gated escalation (current best) | 41.5% | 93.4% | 13.6% | 9.0% |
   | OCR-primary hybrid (this experiment) | ? | ? | ? | ? |

6. **Also report, separately from accuracy:** how many `gpt-5.2` calls were avoided entirely
   (OCR decided instead), and the resulting $ and wall-clock savings. This is a real,
   independent axis of value even if accuracy comes out roughly flat — cheaper and faster at
   equal quality is still a win, and should not be buried under the accuracy table.

**Staging (apply the lesson this investigation already learned twice this session):** pilot
on a deterministic ~20-30 photo subsample first (covering all three archetypes), confirm the
hybrid isn't silently worse in a way a small sample would catch, *then* run full 200-scale.
Don't jump straight to full scale on an unvalidated new pipeline shape — that's exactly how
the blanket-escalation result surprised this investigation once already.

---

## 4b. Trace-overlay spike (2026-08-18, same day) -- promising premise, unresolved calibration, parked

A different idea, tried live this session, not originally in this doc: since OCR gives tick
LABEL text plus approximate pixel position, fit a pixel<->data-value transform per axis from
the known-correct `display_table`, then render the EXPECTED (correct) data points onto the
actual photo. If they land near the student's real drawn points, that's a much more direct
`PLOT_VALUES` check than asking a VLM to find-and-read points cold ("is there ink near this
specific expected pixel" instead of open-ended point detection).

**What worked:** the clustering approach (§1) correctly finds both axis tick sequences even
on `SER-001`, the known non-standard-orientation photo. Using axis-LABEL-text proximity
(not shape orientation) to determine which cluster is the graph's x-axis vs y-axis fixed a
real bug the exercise surfaced -- the orientation-based guess was silently swapping axes on
this photo, masked by the coarse `axis_range_ok` check's generous tolerance. Once axes were
correctly assigned, the value<->pixel-coordinate linear fits were excellent (R^2 > 0.98 on
both axes), confirming OCR's tick-value reading is precise enough in principle to support a
real geometric calibration.

**What didn't work: a systematic offset between the expected point overlay and the true
drawn points**, confirmed visually on `SER-001` (markers parallel to but offset from the real
curve). Tried twice: (1) tick label bounding-box CENTER as the tick position -- offset. (2)
nearest bounding-box CORNER toward the plot area -- offset persisted at similar magnitude.
**Conclusion: the offset isn't a label-anchor-point heuristic problem, it's that OCR text
bounding boxes are fundamentally the wrong signal for tick-MARK position** -- a tick mark
is a short line on the axis, not part of the label text, and no text-box heuristic reliably
recovers it. Real fix needs actual tick-mark/gridline detection (edge detection on the axis
line itself, e.g. via classical CV rather than OCR text geometry) -- meaningfully more
engineering than this session's remaining budget, not a quick patch.

**Status: parked as a documented, real, unresolved lever** -- worth returning to with
dedicated time, not further ad-hoc live debugging. Scripts:
`scripts/vercel-gateway-check/ocr_expected_trace_overlay_spike.mjs` (both calibration
attempts are in its git history / this doc's description, not preserved as separate files).
Output images: `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/overlay_spike/`.

## 5. A fourth option worth naming, not yet scoped as a full experiment: grounding injection

Simpler than criterion-level routing: feed OCR's raw extracted text (axis ticks + any
"estimate" line) into `gpt-5.2`'s existing joint prompt as additional context, without OCR
making any decision itself — one call, same architecture as today, just richer grounding.
This sidesteps the criterion-routing complexity of Experiments 2-3 entirely. Cheap to try
once the axis-role fix (§1) exists (feed the corrected reading, not the current broken one)
but genuinely different in kind from the other three — it's an input to the VLM's judgment,
not an independent decision source — so score it as its own configuration, not folded into
Experiment 3's hybrid-routing number. Worth a small pilot (~20 photos) alongside Experiment 3
if time allows, but not a blocking prerequisite for anything above.

---

## 6. Order of operations and cost

| Step | Cost | Blocking? |
|---|---|---|
| §1 axis-role fix + hand-verify | Free, local | Blocks everything below |
| §2 Experiment 1 (OCR-alone ceiling) | Free, local, reuses existing `gpt-5.2` data | Gates whether §3/§4 are worth running at all |
| §3 Stage 2a (disagreement read) | Free, reuses existing data | Gates §3 Stage 2b |
| §3 Stage 2b (confirmatory escalation) | Small paid run, ~20-30 `gpt-5.2-pro` calls | Optional, only if 2a is promising |
| §4 Experiment 3 pilot (~20-30 photos) | Small paid run, `gpt-5.2` calls only where OCR abstains | Gates full-scale run |
| §4 Experiment 3 full scale (200 photos) | Paid, `gpt-5.2` calls only where OCR abstains — likely well under the $4.85 the full `gpt-5.2-pro` escalation run cost, since OCR should resolve most in-scope criteria for free | Final number |
| §5 grounding injection pilot | Small paid run (~20 photos) | Optional, parallel track |

**Do not run any paid step before §1's hand-verification gate passes.** A still-broken axis
decider feeding Experiments 2-3 would produce the same kind of misleading number the
automated `axis_range_ok` score already produced once this session — the entire point of §1
is to not repeat that.

---

**See also:** `docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md` (source
OCR probe + full-scale reproduction), `docs/research/ENGINE4_PRODUCTION_DESIGN_2026_08_18.md`
§3 (the async-escalation latency problem this experiment's cost/latency angle is aimed at),
`docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` §5 (the inter-run-disagreement trigger this
design's Experiment 2 generalizes).
