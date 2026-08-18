# Real-photo hand-drawn grading accuracy against genuine per-image gold — FAIL — 2026-08-18

**Trigger:** in-session follow-up to [SYMBOLIC_ECF_GOVERNED_PROFILE_NEVER_ACTIVATES_BUG_2026_08_18.md](SYMBOLIC_ECF_GOVERNED_PROFILE_NEVER_ACTIVATES_BUG_2026_08_18.md)
and the "open it up" / "TASK-0020 Program C" investigation earlier this
session. This document supersedes the scope note originally at the top of
`scripts/vercel-gateway-check/hand_drawn_graph_real_photo_benchmark_run.mjs`,
which assumed gold = all-criteria-"earned" for every real photo. That
assumption was wrong (user correction, 2026-08-18: "Again, that is not true.
some images are full credit, others are partial") and has been corrected in
the script and in this write-up.

## What changed since the earlier (invalid) run

The [2026-06-30 benchmark](hand_drawn_graph_benchmark_2026_06_30/README.md)
validated the production-candidate grading method (`VISION_FAST_ESC`:
`gpt-4o-mini` primary, escalates to `gpt-5.5` on any non-`earned` status or
low confidence) against **clean, computer-rendered trace-set pages** and
passed all four DR-1 thresholds (97-100% exact match). TASK-0020 Program C
never accepted that as sufficient evidence, because real capture conditions
(lighting, paper texture, phone-camera angle/blur, handwriting legibility)
were untested.

This session ran the same method against the **real photographed corpus**
in `docs/hand drawn samples/` — 200 unique real phone/scan photos of the
`HDG-2026-P1` AP Biology hand-drawn graph item set (deduped by sha256 from
372 raw files, across three physical drawer packets). Two things had to be
built first, since neither existed:

1. **Genuine per-image gold.** No prior gold data covered these specific
   photos — the only existing gold (`hand_drawn_graph_corpus_2026_06_29`) is
   keyed by item, not by photo, and encodes the canonical correct answer,
   not what a specific hand-drawn photo actually shows. Per the user's
   direct instruction ("Grade them yourself first"), 20 independent grading
   passes (one Agent-tool call per 10-photo batch) each visually inspected
   one photo at a time against that item's `display_table` /
   `expected_graph_spec` / `criterion_definitions`, and returned real
   per-criterion `earned` / `not_earned` / `unable_to_determine` labels with
   a rationale — not an assumption that the photo was correct. Merged
   result: `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/gold/real_photo_gold_labels_2026_08_18.json`
   (200 records, 0 malformed).
2. **A harness that uses that gold.** `hand_drawn_graph_real_photo_benchmark_run.mjs`
   previously hardcoded `goldStatuses()` to mark every criterion `earned`.
   It now loads the file above, keyed by absolute file path (all 200 real
   photos matched cleanly, 0 unmatched), and reports per-criterion
   correctness against genuine labels instead of a recall-only proxy.

## Result: fails all four DR-1 thresholds, by a wide margin

Full run: `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/runs/real_photo_benchmark_results.jsonl`
(200/200 photos, 0 API errors, 199/200 schema-valid, 144/200 = 72% escalated
to `gpt-5.5`).

| Metric | DR-1 threshold | Real-photo result | Pass? |
|---|---|---|---|
| Exact criterion-vector agreement | ≥ 95% | **23.0%** (46/200) | **FAIL** |
| Per-criterion F1 | ≥ 90% | **84.5%** (precision 90.2%, recall 79.5%; 944 TP / 103 FP / 243 FN / 233 TN, `unable_to_determine` excluded from either side) | **FAIL** |
| False-accept rate (gold `not_earned` → predicted `earned`) | ≤ 2% | **30.6%** (103/337) | **FAIL** |
| False-reject rate (gold `earned` → predicted `not_earned`) | ≤ 5% | **20.5%** (243/1187) | **FAIL** |

By archetype (exact match): `continuous_measured_series_supplied_uncertainty`
33.3% (23/69), `categorical_comparison_supplied_uncertainty` 18.8% (12/64),
`continuous_relationship_graph_derived_estimate` 16.4% (11/67).

**Read on the false-accept number specifically:** the 2026-06-30 trace-set
benchmark could not measure false-accept at all (no known-incorrect items in
that corpus). This is the first real measurement of it for this method, and
it is 15x over threshold — the model marks real drawing/data errors as
`earned` roughly 3 times in 10 when the answer genuinely doesn't meet the
criterion.

**Conclusion for TASK-0020 Program C / the "open it up" question paused
earlier this session:** this method is not close to qualifying for
authoritative automated grading of hand-drawn responses under real capture
conditions. The existing routing in `grading-router.ts`
(`rubric_type: spatial` → `evaluatorStrategy: human_shadow` → `shadow_review`,
never auto-graded authoritatively today) is directionally correct and should
stay in place; this result is evidence *against* changing it, not neutral.

## Checked: is this just a corpus-defect artifact? No.

Before drawing a harder conclusion, re-scored the run with both known defect
categories removed: the 7 likely-misfiled photos dropped entirely, and every
`*_UNIT*` criterion (185 judgments) stripped from the remaining 193 records
before computing metrics — the most generous plausible adjustment, since it
removes both a whole defective response class and every criterion the
missing-unit defect could have touched.

| Metric | Threshold | Raw (200 photos) | Defects excluded (193 photos, unit criteria dropped) |
|---|---|---|---|
| Exact match | ≥ 95% | 23.0% | 23.3% |
| Per-criterion F1 | ≥ 90% | 84.5% | 81.0% (precision 88.9%, recall 74.4%) |
| False-accept rate | ≤ 2% | 30.6% | 28.1% (80/285) |
| False-reject rate | ≤ 5% | 20.5% | 25.6% (221/862) |

The numbers do not improve — exact match is flat, F1 and false-reject both
get slightly *worse* once the (comparatively easy, low-noise) unit criteria
are removed from the denominator, and false-accept barely moves. The gap is
not explained by corpus defects: it's a real accuracy shortfall on the
harder core of the rubric — plotted values, scale reading, uncertainty-mark
interpretation on real photos — not axis-label/unit bookkeeping.

## Follow-up spike: is this a perception problem or a judgment problem? (2026-08-18)

Per a lean, staged follow-up plan (diagnose cheaply before committing to any
architecture change), ran an extraction-only probe: the model transcribes
axis tick range, plotted point values, and any annotated estimate — no
rubric judgment, no earned/not_earned classification — scored deterministically
against `display_table`. The question: are `Y_SCALE`/`PLOT_VALUES`/
`ESTIMATE_VALUE` failures caused by bad *perception* (can't read the numbers)
or bad *judgment* (reads fine, comparison/classification breaks)? If
perception, a two-stage decompose-then-deterministically-compare
architecture (mirroring Engine 3's existing transcription→symbolic-check
design) is a promising fix. If judgment, decomposition won't help.

Ran on a deterministic 42-photo stratified subsample (30 where the joint run
got one of these families wrong, 12 where it got them all right; misfiled
photos excluded) — not the full 200, to keep this a cheap spike rather than
a full re-run. Script: `scripts/vercel-gateway-check/hand_drawn_graph_extraction_probe_run.mjs`;
selection: `scripts/vercel-gateway-check/select_extraction_probe_subsample.mjs`;
output: `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/runs/extraction_probe_results.jsonl`.

**Result: extraction-only is not better than the joint call, and in some
cases worse** (average per-point match rate 20.2%, worse than joint-run
`PLOT_VALUES` at 73.8% on the same 42 photos, though the two aren't
perfectly comparable — joint `PLOT_VALUES` is one holistic per-photo
judgment, extraction point-match is a per-point average). More importantly,
manual review of raw extraction output showed genuine perceptual failures,
not just imprecision:
- `CAT-001`: true values (18, 26, 37, 42) are monotonically increasing; the
  model transcribed (0, 20, 40, 30) — it got the *relative ranking* wrong,
  not just the magnitudes.
- `SER-002`: true y-values (7.07–37.41) are unevenly spaced; the model
  transcribed a suspiciously clean, evenly-spaced ramp (10, 20, 30, 35, 40,
  45, 50) — consistent with pattern-completing a plausible-looking curve
  rather than reading the actual printed numbers.

**Conclusion: decomposition (an Engine-3-style two-stage pipeline) is not
a promising fix on its own and building it is not currently worth the
engineering investment.** Per the staged decision gate, the next cheapest
hypothesis to test before any bigger commitment is a resolution/crop
ablation on the same subsample.

## Follow-up spike 2: resolution/crop ablation (2026-08-18)

The real photos are already 12MP (4032×3024), well above any vision
provider's effective input budget, so raw upscaling of the same framing
doesn't change what the model actually receives — the likely bottleneck is
the provider's internal downsampling being spent on desk/binder/margin
background rather than the graph. Tested this directly: center-cropped each
of the same 42 subsample photos (removing the outer 10% margin per side,
a fixed conservative crop chosen to avoid clipping content) and upscaled the
crop 1.5x with a high-quality (lanczos3) filter, then re-ran the identical
extraction-only prompt/schema/scorer. Script:
`scripts/vercel-gateway-check/hand_drawn_graph_extraction_probe_crop_run.mjs`;
output: `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/runs/extraction_probe_crop_results.jsonl`.

| Metric | Baseline (full page) | Crop+upscale | Change |
|---|---|---|---|
| `axis_range_ok` | 67.9% | 75.0% | +7pp (n=28, likely mostly noise) |
| Avg point-match rate | 20.2% | 20.8% | flat |
| `estimate_ok` (EST items) | 28.6% | 57.1% | +28.6pp, roughly doubled |

Per-photo, point-match rate improved on 9 photos, got worse on 9, and was
unchanged on 24 — no systematic direction, consistent with noise.

**Result is nuanced, not a clean confirm/deny.** The dominant failure mode
(reading plotted point values, the criterion family most responsible for
the original DR-1 failure) does not improve with more effective resolution
— this is a second independent signal, alongside the extraction probe's
ranking/fabrication errors, that `PLOT_VALUES`/`Y_SCALE` reading is a
genuine model-capability ceiling, not a pixel-budget problem, and further
image-preprocessing investment won't close that gap. However, the
annotated numeric estimate — a single, spatially localized piece of
handwriting — roughly doubled in accuracy with tighter framing, a real,
narrow win worth keeping as an operational lever (e.g. capture guidance
telling students to frame the graph tightly) even though it doesn't move
the metric that matters most for DR-1.

**Where this leaves the two-experiment spike:** both diagnostics (extraction
probe, resolution/crop ablation) point the same direction — the failure on
real photos is closer to a genuine reading-capability limit on fine
hand-drawn numeric data than an engineering-fixable input or architecture
problem. Further engineering spend chasing raw accuracy (a full two-stage
pipeline, more preprocessing) is not well-supported by evidence so far. The
better-supported next moves are either (a) a cheap model-backbone swap on
the same cropped-image pipeline (already built) to check whether a
stronger model closes the gap before concluding it's model-family-agnostic,
or (b) pivoting from "improve raw accuracy" to the confidence-gated
selective-prediction framing raised earlier — since confidence was shown to
be a real, usable signal (53.3% vs 4.8% exact-match by confidence bucket in
the original 200-photo run) even though absolute accuracy is poor.

## Follow-up spike 3: model-backbone ablation (2026-08-18) — reverses the ceiling conclusion

Both prior spikes used `openai/gpt-4o-mini` exclusively (matching the
production candidate's primary arm), so "flat regardless of what changed"
could mean either a genuine cross-model ceiling or a `gpt-4o-mini`-specific
weakness. Tested directly: three models the owner flagged as known for
image-analysis proficiency, on the identical 42-photo cropped subsample and
extraction prompt/scorer used in spike 2. Slugs were confirmed live against
the Vercel AI Gateway's catalog (347 models) before running, since none of
the owner's shorthand names matched a slug exactly:
- **`google/gemini-3.1-pro-preview`** — the vision-*input* model matching
  "gemini-3-pro." Note `google/gemini-3-pro-image` also exists in the
  catalog but is an image-*generation* endpoint per this repo's own
  convention (`apbio_image_smoke_test.mjs`), not a vision-understanding
  model — picking it would have silently tested the wrong thing.
- **`openai/gpt-5.2`** — read "GPR 5.2" as GPT-5.2.
- **`alibaba/qwen3-vl-instruct`** — matches "Qwen3 VL" directly.

**`alibaba/qwen3-vl-instruct` was dropped before the scored run.** A
single-photo smoke test showed it can correctly describe the graph in free
text (right category count, right labels, one minor OCR slip) but returns
an empty result under schema-constrained structured output — tried both
streaming (`streamObject`) and non-streaming (`generateObject`), same
result both ways. That's a structured-output/tool-calling compatibility gap
via this route, not a vision failure. Not debugged further, to keep this a
cheap spike; flagged as a real, distinct finding in its own right — a model
can have adequate vision and still be unusable in a schema-constrained
production pipeline.

Scripts: `scripts/vercel-gateway-check/hand_drawn_graph_extraction_probe_multimodel_run.mjs`,
`scripts/vercel-gateway-check/hand_drawn_graph_extraction_probe_gemini_retry.mjs`.
Outputs: `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/runs/extraction_probe_model_google_gemini-3.1-pro-preview_results.jsonl`,
`.../extraction_probe_model_openai_gpt-5.2_results.jsonl`.

| Model | Reliability | `axis_range_ok` | Avg point-match rate | `estimate_ok` |
|---|---|---|---|---|
| `gpt-4o-mini` (spike 2 crop baseline) | 42/42 (100%) | 75.0% | 20.8% | 57.1% |
| `gpt-5.2` | 42/42 (100%) | 75.0% | **49.5%** | 35.7% |
| `gemini-3.1-pro-preview` | 22/42 (52%, even after a retry pass) | 90.9% (n=11) | **59.9%** (n=22) | 100.0% (n=4) |

`gemini-3.1-pro-preview` initially completed only 7/42 calls, consistently
failing with "No object generated: could not parse the response." A single
manual retry on one failed photo succeeded immediately, so a retry pass (up
to 2 additional attempts per failed row) was run rather than writing the
model off — it rescued 15 of 35 failures, leaving 22/42 usable. Even after
retrying, the failure rate stayed high (48%), so its per-metric numbers
above are on a meaningfully smaller and potentially non-representative
sample (whatever made those particular 20 calls fail twice in a row may
correlate with harder images) — treat them as promising, not confirmed.

**Verdict: this reverses the capability-ceiling conclusion from spikes 1-2.**
Point-match rate — flat at ~20% through two rounds of testing on
`gpt-4o-mini` — more than doubles to 49.5% on `gpt-5.2` alone, on the
identical images and prompt, with full reliability. `gemini-3.1-pro-preview`
scores higher still on every metric where it produced output, but isn't
usable as-is given its reliability gap. The earlier "genuine model-capability
ceiling" framing was really "a `gpt-4o-mini`-specific ceiling" — a materially
different, more actionable conclusion.

**Recommended next step:** `gpt-5.2` is immediately actionable — a real,
reliable accuracy gain on the metric that matters most, with no reliability
tax. Worth testing end-to-end on the full joint-judgment task (not just
extraction) against the real per-photo gold labels, the same way the
original `VISION_FAST_ESC` benchmark was run, to see whether this extraction-
level gain survives into full DR-1-relevant metrics (exact match, FAR, FRR).
`gemini-3.1-pro-preview`'s higher raw quality is worth revisiting once its
structured-output reliability is solved (larger token budget, schema
simplification, or provider-side investigation), but is not ready now.
`qwen3-vl-instruct` is blocked on the same class of problem and untested at
scale.

## Follow-up spike 4: full joint-judgment benchmark on gpt-5.2 (2026-08-18) — F1 clears DR-1 for the first time

Ran the extraction-level gain from spike 3 through the metric that actually
matters: the full 200-photo joint-judgment benchmark, single-variable swap
(same full-page images, same rubric-judgment prompt/output shape as the
original `VISION_FAST_ESC` run, only the model changed — no crop
preprocessing stacked on top, to keep this one variable). Script:
`scripts/vercel-gateway-check/hand_drawn_graph_real_photo_benchmark_gpt52_run.mjs`;
output: `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/runs/real_photo_benchmark_gpt52_results.jsonl`.

**A reliability bug had to be fixed before this could run at scale.** The
first attempt set `providerOptions: { openai: { reasoningEffort: 'medium' } }`
(mirroring how the original benchmark's escalation arm used `gpt-5.5`) and
failed on 2 of the first 3 photos with "No object generated: could not parse
the response" — consistent with reasoning tokens consuming the output-token
budget before valid JSON was emitted. Dropped `reasoningEffort` entirely and
raised `maxOutputTokens` to 600 (plain call, matching what already worked
reliably in spike 3's extraction probe); a 6-photo smoke test then passed
6/6 before running the full 200. Final run: 200/200 calls succeeded,
200/200 schema-valid — fully reliable, better than the original
`gpt-4o-mini` benchmark's 199/200.

| Metric | DR-1 threshold | `gpt-4o-mini` (original) | `gpt-5.2` (single-pass) |
|---|---|---|---|
| Exact match | ≥ 95% | 23.0% | **38.5%** (+15.5pp) |
| Per-criterion F1 | ≥ 90% | 84.5% | **93.3%** — **clears the threshold** |
| False-accept rate | ≤ 2% | 30.6% | **18.4%** (still fails, but well under half) |
| False-reject rate | ≤ 5% | 20.5% | **7.9%** (still fails, but now close) |

(F1 breakdown: precision 94.6%, recall 92.0%, vs the original's 90.2%/79.5%.)

**This is the first result in the whole investigation where a DR-1 metric
actually clears its threshold.** Every other metric improved substantially
without clearing: exact match nearly doubled but is still 56.5 points short;
FAR is cut nearly in half but is still 9x over its ceiling; FRR is cut by
more than half and is now within ~3 points of its ceiling, the closest any
metric has come. None of this was true after spikes 1-2 (`gpt-4o-mini`
flat through resolution/crop changes) — the model-backbone swap is a real,
substantial lever, not just extraction-level noise.

**Updated overall read:** the earlier "not close to qualifying, shadow-only
routing is directionally correct" conclusion from the original benchmark
still holds as a go/no-go verdict today — three of four thresholds still
fail, one (FAR) by a wide margin. But the trajectory changed materially: a
single-variable model swap, with no other engineering investment, moved
every metric in the right direction and cleared one of four thresholds.
That reframes the open question from "is this fundamentally achievable" to
"what combination of levers (better backbone, the crop preprocessing from
spike 2 which hasn't been stacked with gpt-5.2 yet, prompt refinement, or
`gemini-3.1-pro-preview` once its reliability is fixed) gets the remaining
three metrics — especially FAR, the furthest out — across the line."

## Follow-up spike 5: gpt-5.2 + crop, 20-photo smoke test — dropped (2026-08-18)

Tested whether stacking spike 2's crop preprocessing onto `gpt-5.2` improves
further, per the closing note above. Ran a 20-photo (10%) stratified
smoke test (script: `scripts/vercel-gateway-check/hand_drawn_graph_real_photo_benchmark_gpt52_crop_run.mjs`,
`--limit 20` selects roughly N/3 per archetype, deterministic) before
committing to the full 200, per this session's cost-conscious sequencing
practice.

| Metric | `gpt-5.2` no crop (same 20 photos) | `gpt-5.2` + crop |
|---|---|---|
| Exact match | 30.0% | 10.0% (worse) |
| F1 | 92.9% | 89.4% (slightly worse) |
| FAR | 33.3% | 19.0% (better) |
| FRR | 8.4% | 15.3% (worse) |

Both fully reliable (20/20 ok, 20/20 schema-valid). But the accuracy result
is a real trade-off, not a win: crop raises precision (96.2% vs 94.4%) at a
steep cost to recall (83.5% vs 91.5%) — the model gets more conservative
with tighter-cropped images, rejecting more legitimately-correct answers,
which drags exact match down hard. (This particular 20-photo subsample also
scores below the full-200 average even without crop -- 30.0% vs 38.5% --
likely because it includes `EST-002`, one of the corpus's confirmed
axis-tick-corrupted defect items, by virtue of low-item-number
stratification; a real but partial confound, not enough to explain the
crop-vs-no-crop gap on its own since both conditions share the same 20
photos.)

**Decision: dropped, not run at full scale.** Unlike spike 2 (crop was
cost-free and non-negative for `gpt-4o-mini` extraction), this is a genuine
trade-off for `gpt-5.2`'s full joint-judgment task, and n=20 is too small to
resolve it cheaply. Plain `gpt-5.2` (spike 4: 38.5% exact / 93.3% F1 / 18.4%
FAR / 7.9% FRR) stands as the current best result.

## Follow-up free re-analysis of the gpt-5.2 full-200 run (2026-08-18)

No new API calls -- pure re-analysis of data already collected in spike 4,
following this session's practice of exhausting free diagnostics before
spending on the next paid experiment.

### Criterion-level selective-prediction policy -- the best result so far

The per-`(confidence bucket × criterion family)` error breakdown showed
reliability varies far more by criterion than by the model's own stated
confidence: structural/classification families (`REPRESENTATION_TYPE`,
`CATEGORY_IDENTITY`, `X_UNIT`, `Y_UNIT`, `PLATEAU_ANNOTATION`,
`POINT_CONNECTION`) are near-0% error even on "medium confidence"
responses, while `ZERO_INTERCEPT_ANNOTATION` stays bad (35.7% wrong) even
on "high confidence" ones -- the model's confidence signal doesn't track
that criterion's difficulty at all. A criterion-level (not whole-response)
gating policy was simulated against the existing 200-photo results: always
auto-accept the always-safe structural families; auto-accept the remaining
quantitative families (`Y_SCALE`, `X_SCALE`, `PLOT_VALUES`,
`UNCERTAINTY_MARKS`, `ESTIMATE_VALUE`, `BEST_FIT_RELATIONSHIP`) only when
the response's overall confidence is "high"; always route
`ZERO_INTERCEPT_ANNOTATION` to review regardless of confidence.

| | Whole-response gate (high-confidence only) | Criterion-level gate |
|---|---|---|
| Coverage | 48% (95/200 responses) | **70%** (1078/1539 criterion-judgments) |
| F1 | 96.2% | **97.4%** |
| FAR | 11.9% | 10.9% |
| FRR | 4.1% | **2.8%** |

The criterion-level policy beats the whole-response gate on every metric
*and* covers far more of the corpus -- both F1 and FRR clear DR-1 on 70% of
all criterion-judgments, not just 48% of responses. FAR is still the one
metric that doesn't clear (10.9% vs. the 2% ceiling), even under this
policy -- the remaining gap is concentrated in the quantitative criteria
even when the model says it's confident about them, which is consistent
with spikes 1-3's finding that fine numeric reading is the harder core
problem.

### `ZERO_INTERCEPT_ANNOTATION` diagnosis -- two distinct, separable causes

This was the one criterion that got *worse* in absolute terms with the
stronger model (9→13 wrong vs. the `gpt-4o-mini` baseline). Read all 12
false-reject (`gold=earned`, `predicted=not_earned`) cases directly rather
than trust a keyword-matched classification (an initial regex-based split
against the corpus-defect list undercounted -- e.g. `EST-004`'s rationale
plainly describes an axis-value swap without using the literal words
"corrupt/swap/scrambl", so it was manually reclassified). Two genuinely
different patterns, roughly half and half:

1. **On clean, correctly-scaled items** (e.g. `EST-001`, `EST-005`,
   `EST-010`, `EST-016`): gold explicitly credits the annotation because the
   written numeric estimate is correct and near the right x-position. The
   model's own rationale shows it also reads the correct axes, correct
   points, and the correct written estimate number -- but declines credit
   because it doesn't see an explicit visual link (e.g. a drop-line) from
   the annotation to a marked y=0 intersection point. This is a **rubric-
   strictness mismatch, not a reading failure** -- the model is applying a
   pickier definition of "annotated" than gold's met_rule requires, and
   is a plausible **prompt-clarification target**: explicitly tell the
   model that a numeric estimate written near a correctly-positioned
   vertical line counts, even without a drawn drop-line to y=0.
2. **On items with corrupted/mismatched axis data** (e.g. `EST-002`,
   `EST-004`, `EST-007`): the model declines to credit the zero-crossing
   annotation because it can't verify anything against a scrambled axis --
   its own rationale explicitly says so ("because of this swap/mismatch,
   the plotted points are not recoverable"). Gold, in these same cases,
   still credited the annotation despite the axis corruption. **Per this
   session's own correction (2026-08-18): a model declining to certify
   something it cannot verify against defective source material is
   principled, not a flaw** -- if anything, this pattern suggests gold may
   be inconsistently lenient on corrupted-axis items for this specific
   criterion, which is a gold-labeling question worth a second look, not
   evidence the model needs fixing.

**Next step implied by this split:** a prompt-clarification retest on
pattern 1 only (the genuine strictness gap) is a cheap, targeted next
experiment; pattern 2 doesn't need a model-side fix and may instead warrant
revisiting how gold was labeled for `ZERO_INTERCEPT_ANNOTATION` specifically
on the known-corrupted-axis items.

### Second look at gold labeling on corrupted-axis items -- open question, not corrected (2026-08-18)

Read all 8 affected records in full (`EST-002`, `EST-004`, `EST-007`,
`EST-014`, 2 responses each) to check whether gold's `earned` call on
`ZERO_INTERCEPT_ANNOTATION` holds up given the axis corruption. **Did not
change the gold file** -- this turned out to be a genuine, defensible
grading-policy question, not a clear error to correct:

- Every one of the 8 rationales documents the SAME pattern: the axis
  corruption is a shared template/printing defect (identical corrupted tick
  values recur across independent photos of the same item, so it predates
  and is independent of the individual drawer), and the written zero-
  crossing estimate is numerically correct with a properly-placed
  annotation.
- Two legitimate but conflicting standards apply: a **strict-verification**
  reading (the printed axis can't be trusted, so literal verification is
  impossible -> `unable_to_determine`) versus a **fair-to-the-student**
  reading (the defect is the corpus's fault, not the drawer's; they
  correctly computed and marked the zero-crossing given what they were
  handed, and the other affected criteria -- `X_SCALE`, `Y_SCALE`,
  `PLOT_VALUES` -- already correctly fail to capture the defect's real
  impact elsewhere on the same response -> `earned` stands).

Which standard is correct is a values question about grading fairness under
corpus-defect conditions, not something to decide unilaterally from a
single AI grading pass -- it's exactly the kind of call this repo's own
governance convention reserves for adjudicated review (2 qualified
validators + lead adjudication per `ap_biology_gold_set_candidate_2026_07_08`),
not a single-pass `ai_provisional`-tier correction. Flagged here as an open
question for owner/adjudicator decision; gold is unchanged pending that
call.

### Prompt-clarification retest on the genuine strictness gap (pattern 1)

Before writing a prompt fix, checked the actual rubric text and two of the
underlying photos directly, since the initial hypothesis ("the model wants
an explicit drop-line to y=0 that gold doesn't require") turned out to be
backwards on closer reading. `ZERO_INTERCEPT_ANNOTATION`'s met_rule literally
reads *"Annotation visibly links the zero crossing to the x-axis"* -- which
could mean the model's stricter reading was the rubric-correct one, not
gold's. Visually inspected `EST-010` and `EST-016` (both non-corrupted
items in the false-reject list) directly: both show a clearly-drawn
vertical line running from the x-axis up to the fitted line, labeled with
the estimate -- a real, valid link to the x-axis, exactly as gold credited.
The model's stated rejection reason in both cases was that the *y-axis*
doesn't show a printed "0" tick -- which is `Y_SCALE`'s concern ("Y-axis
includes zero and all observations"), a separate criterion, not
`ZERO_INTERCEPT_ANNOTATION`'s. The model was conflating the two.

The actual fix: one clarifying paragraph, scoped narrowly to this exact
conflation, telling the model `ZERO_INTERCEPT_ANNOTATION` and `Y_SCALE` are
independent criteria and a missing y=0 tick label doesn't affect
`ZERO_INTERCEPT_ANNOTATION` if the line visibly links the estimate to the
x-axis. Ran on all 67 EST-archetype photos (the full natural population for
this criterion, not a further subsample) -- everything else (model, other
criteria instructions, scoring) held fixed, scored against the ORIGINAL
(unchanged) gold so the prompt effect is isolated cleanly from the open
gold-labeling question above. Script:
`scripts/vercel-gateway-check/hand_drawn_graph_real_photo_benchmark_gpt52_zia_prompt_run.mjs`;
output: `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/runs/real_photo_benchmark_gpt52_zia_prompt_results.jsonl`.

| | Original prompt (n=67) | Clarified prompt (n=67) |
|---|---|---|
| `ZERO_INTERCEPT_ANNOTATION` wrong | 13/32 (40.6%) | **5/32 (15.6%)** |
| — false-rejects specifically | 12 | **2** |
| — false-accepts specifically | 0 | 3 |
| EST-subset exact match | 28.4% (19/67) | **34.3%** (23/67) |

**The targeted fix worked.** `ZERO_INTERCEPT_ANNOTATION`'s error rate
dropped by more than 60% relative (40.6% -> 15.6%), and the specific false-
reject pattern this whole investigation traced (correct annotations
wrongly rejected) fell from 12 to 2. A small number of new false-accepts
appeared (0 -> 3) -- worth watching, but a net reduction from 13 wrong to 5
wrong either way. EST-subset exact match improved 5.9 points from one
precisely-scoped clarifying paragraph, no other changes.

**Regression check on the other 8 EST criteria -- clean.** Every other
criterion stayed flat or improved: `REPRESENTATION_TYPE` (1/67 both),
`Y_UNIT` (5/67 both), `X_SCALE` (5/67 both), `ESTIMATE_VALUE` (8/67 both),
`PLOT_VALUES` (14->13), `BEST_FIT_RELATIONSHIP` (8->7). Two small upticks --
`X_UNIT` (2->4) and `Y_SCALE` (20->22) -- are single-digit changes on n=67,
consistent with normal run-to-run LLM variance rather than a systematic
regression, and neither criterion's instructions were touched by the
clarification. No evidence the fix caused collateral damage elsewhere.

## Corpus-quality defects found during gold-labeling (separate, actionable finding)

These surfaced as a byproduct of manually grading all 200 photos and are
real, independent of whatever the automated grader's accuracy turns out to
be:

1. **Systematic axis-tick-value corruption, `EST`-archetype items.**
   Confirmed on 11 distinct items so far (`EST-002, 007, 009, 012, 014, 034,
   035, 045, 046, 049, 050`) — axis *titles* are correct, but the printed
   tick *numbers* are swapped for the other axis's data range (e.g. an
   x-axis titled "sucrose concentration (M)" ticked 0–0.9 instead shows
   percent-mass-change values like -21.71 to 16.90). This is a
   source/template defect, not a drawer error: duplicate independent photos
   of the same item (`EST-002` response-01 vs response-02, `EST-012`
   response-01 vs response-02, `EST-014` response-01 vs response-02,
   `EST-035` packet-2 vs packet-3 copies) share the *identical* corrupted
   tick values, which a human drawer would not coincidentally reproduce
   twice. Grep evidence: 17 gold rationales across these 11 items
   explicitly describe an axis swap/corruption/scramble.
2. **Near-universal missing axis unit on `EST` estimate values.** 29 of 200
   photos have a gold `not_earned` on a `Y_UNIT`/`X_UNIT`-type criterion.
3. **At least 7 likely-misfiled photos** — filename/item_id header on the
   page doesn't match the drawn content: `CAT-038`'s photo shows an
   `EST-037` uptake-rate curve; several `EST`/`SER` items show swapped
   archetype content between their expected item and a neighboring one
   (`EST-036`, `EST-039`, `EST-050`, `SER-002`, `SER-005`, `SER-049`).
4. **Packet 2 (floral-background scans) is systematically lower quality**
   than the clean root/Packet-3 scans — more frequent missing/ambiguous
   error bars and lower overall legibility, observed repeatedly across
   gold-grading rationales without being formally tallied here.

None of these were introduced by this session — they're pre-existing
defects in the `HDG-2026-P1` real-photo corpus, most likely dating to
whatever authored/photographed it originally. They should be triaged (fix
the source axis-tick generation defect for `EST` items; re-shoot or drop the
misfiled photos; decide whether Packet 2's lower-quality scans should be
excluded from any future benchmark corpus) before this corpus is reused for
another grading-accuracy measurement — otherwise a chunk of any future
false-reject number will keep being "correctly reported by the model, wrong
because of the source material," which is not the signal DR-1 wants.

## Artifacts

- Gold labels: `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/gold/real_photo_gold_labels_2026_08_18.json`
- Run script (patched to use real gold): `scripts/vercel-gateway-check/hand_drawn_graph_real_photo_benchmark_run.mjs`
- Run output: `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/runs/real_photo_benchmark_results.jsonl`

## Follow-up not actioned

- No defect-filtered re-run (see confound note above).
- No fix attempted for the axis-tick-corruption source defect, the missing
  units, or the misfiled photos — flagged, not fixed, consistent with this
  session's scope discipline on unrelated/out-of-band findings.
- Gold labels were produced by 20 independent single-pass agent graders, not
  cross-validated by a second independent pass or adjudicated per this
  repo's `adjudicated_gold` convention (2 qualified validators + lead
  adjudication, per `ap_biology_gold_set_candidate_2026_07_08`). Treat this
  gold as `ai_provisional`-tier, sufficient to establish that the production
  candidate is far from DR-1 thresholds, but not to a governance-grade
  `adjudicated_gold` standard.
