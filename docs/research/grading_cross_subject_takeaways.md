# Grading Cross-Subject Takeaways

**Status:** Durable lesson layer for the grading program
**Owner:** Product Owner with Learning Quality Owner
**Created:** 2026-07-08
**Related decision:** `../activity_log/DECISIONS_LOG.md` DECISION-0034
**Scope:** Lessons stable enough to influence production grading behavior across
subjects. This is the promotion target the canonical process
(`GRADING_RESEARCH_CANONICAL_PROCESS.md` step 6-7) points to. Per-run detail
stays in the individual reports cited below; only durable conclusions live here.

## Why this file exists

The most important grading lessons were being re-derived from scratch in run
after run because they lived only in individual experiment reports. This file is
the single place those lessons are recorded once and reused. Add to it only when
a lesson is stable across more than one run or subject; cite the evidence.

## Lesson 1 — Rubric-boundary precision is the dominant quality lever

Across every test where it was isolated, sharpening the criterion boundary beat
every architectural alternative — model size, escalation, routing, exemplar
retrieval, and online precedent volume.

- Rewriting one criterion's boundary table improved a plain fast-model arm by
  +5 percentage points in a single step — larger than any routing or escalation
  change in the same investigation (`grader_speed_sp1_report.md`).
- `gpt-4o-mini` with a correct boundary table beat `gpt-5.5` with no boundary
  memory by ~10pp on the same hard criterion (`grader_speed_sp1_report.md`).
- Reference-heavy context did not help and sometimes hurt
  (`bio_reference_layer_strict_context_v2_takeaways.md`).

**Consequence in policy:** the criterion-boundary contract is now a required,
authored artifact, not something the grader or a later calibration pass reverse-
engineers from errors. See `../architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`
§9.1 and `../architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §10.5.

## Lesson 2 — Escalation, ensembles, and reference layers are not the default

Every added-complexity arm tested failed to beat a single fast model with a
correct boundary contract, and several made quality, cost, or tail latency
worse.

- Primary-plus-fallback routing fixed 1 row and worsened 13 versus primary-only
  (`apbio_primary_fallback_comparison_report.md`).
- Exemplar retrieval, oracle-precedent injection, gated prompting, and the
  100-answer online flywheel all failed to beat the no-card baseline
  (`bio_reference_layer_exemplar_test_report.md`,
  `bio_reference_layer_oracle_boundary_test_report.md`,
  `bio_reference_layer_gated_prompt_test_report.md`,
  `bio_reference_layer_flywheel_volume_test_report.md`).
- Confidence-triggered escalation wrecked tail latency (8-11s on ~10% of cases)
  for a small, criterion-concentrated quality gain (`grader_speed_sp1_report.md`).

Multiple models remain valuable, but as **boundary auditors** — surfacing which
rubric language is genuinely fuzzy — not as a runtime scoring ensemble
(`apbio_nuanced_boundary_calibration_takeaways.md`).

**Consequence in policy:** the default grading runtime is a single fast primary
grader + boundary contract + deterministic checks, with direct routing of a
pre-identified hard criterion where needed. See
`../architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §7.2.

## Lesson 3 — Deterministic checks catch what the model structurally cannot

A zero-API-cost dependency-parse check caught both of the two hardest over-credit
errors in the FRQ02 investigation, at single-digit-millisecond cost
(`grader_speed_sp1_report.md`). This error class — over-credit by misattributing
qualifying language, and confidently-wrong-but-complete responses — cannot be
caught by a model's self-reported confidence, because a confidently wrong model
never self-flags.

**Consequence in policy:** every subject declares a required deterministic-check
layer via a verification profile. See
`../architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §7.1 and the
per-subject profiles (`AP_BIOLOGY_VERIFICATION_PROFILE.json`,
`AP_CHEMISTRY_VERIFICATION_PROFILE.json`,
`AP_PHYSICS_1_VERIFICATION_PROFILE.json`).

**Experimental confirmation 2026-07-08** (`deterministic_check_experiment_2026_07_08/`):
a per-item numeric checker run over 320 Chem+Stats responses hit **100%
specificity (0 false flags on 69 correct answers)** and caught the numeric-error
class at **$0**, correctly abstaining on conceptual items. Every caught error is
a confidently-wrong-but-complete numeric answer (the class self-reported
confidence cannot catch). Boundary: it catches numeric errors only; wrong
*reasoning with a right number* and the "wrong quadratic root shown alongside the
right one" edge belong to the LLM grader. Two extractor bugs were found and fixed
during the run — re-validate the extractor on any new corpus.

## Lesson 4 — Model self-reported confidence is not a usable trigger

On the FRQ02 corpus, `gpt-4o-mini` reported 0.8-1.0 confidence (median 0.95)
even on criteria it graded wrong; correct calls averaged 0.938 and wrong calls
0.880-0.908 — real separation, but compressed into a range no flat threshold can
exploit (`grader_speed_sp1_report.md`, `../tasks/TASK-0010-GRADER-CONFIDENCE-AND-CALIBRATION.md`).

**Consequence in policy:** confidence and abstention are calibrated against
observed criterion error, not self-report. Hard-criterion routing is decided per
criterion during calibration, not by a runtime confidence threshold.

## Lesson 5 — Some persistent "grader errors" are label or rubric defects

At least one FRQ02 response (`S020`) was graded the same "wrong" way by every
model, effort, and routing combination tried; five others carry labels
inconsistent with a near-identical confirmed case. No architecture change can fix
a bad label (`grader_speed_sp1_report.md`,
`../tasks/TASK-0010-GRADER-CONFIDENCE-AND-CALIBRATION.md`).

**Consequence in policy:** when boundary-sharpening does not resolve a recurring
disagreement, it is routed to Learning Quality adjudication as a label/rubric
question, not treated as "the grader needs to be smarter." This is the
adjudication queue TASK-0010 Phase 2 is designed to hold.

## Lesson 6 — The evaluation must measure feedback, not only the score decision

Cramapple's product promise is criterion-level feedback and "the minimum fix for
the next point." Research to date measured criterion agreement (the binary
earned/not-earned decision) and under-weighted whether the feedback is grounded
in the response, whether the minimum fix is actually sufficient, and whether the
error classification is correct. The governance thresholds already require these
(`../architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.3); the research
evaluation layer must report them too.

**Consequence in policy:** feedback grounding, minimum-fix sufficiency, and
error-classification accuracy are standard evaluation dimensions in the canonical
process, alongside criterion agreement.

## Lesson 7 — Depth of adjudicated evidence, not breadth of synthetic corpora,
gates launch

Every decision-grade result so far is a single question (AP Bio FRQ02, n≤100)
scored against a *provisional* corpus with known-suspect labels. Governance
requires 300+ dual-blind adjudicated held-out responses and 40 per archetype
(`../architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.2); none exist for a
production question. Synthetic breadth corpora (Statistics bootstrap, Chemistry
MCQ/FRQ) are explicitly development-tier and, in the Chemistry case, use
truncation-derived wrong answers that do not test the confidently-wrong-but-
complete failure mode.

**Consequence in policy:** research effort is redirected from breadth to one
fully-adjudicated AP Biology gold set (`grading_packet_backlog_2026_07_07.md`
revised priority; `GRADING_RESEARCH_CANONICAL_PROCESS.md` corpus tiers).

**Update 2026-07-08:** three `calibration`-tier gold-set-candidate packages were
built (`grading_gold_set_candidates_2026_07_08_report.md`). The build empirically
re-confirmed this lesson: the sampled AP Chemistry variants were
truncation-degenerate (`partially_correct` ≡ `borderline` byte-for-byte; zero
`partially_earned` labels), so that corpus could calibrate incompleteness
detection only. **The Chemistry corpus was then repaired the same day:** all 200
non-canonical responses across the full 100-item corpus were rewritten as
hand-authored genuinely-wrong-reasoning answers, each injecting one identifiable
misconception (`injected_error` field), with the v1 corpus preserved as a backup;
the regenerated candidate now carries `partially_earned` judgments and tests
wrong-reasoning detection. This is the concrete instance of the standing rule:
truncation/skewed variants are `development` tier and must be replaced with
genuine wrong-reasoning cases before a corpus supports quality claims. AP Biology
and AP Statistics variants were already genuinely differentiated. Human
adjudication (Biology first) is the remaining step to reach `adjudicated_gold`.

## Lesson 8 — Silver labels are internally robust, but independence is the gap

A label-robustness cross-check of the three silver label sets
(`label_robustness_crosscheck_2026_07_08/`) found **zero errors on the
automated/independent dimension** (canonical integrity, accidentally-right, and —
via the deterministic checker — over/under-credit on the 9 numeric criteria); the
one high-severity flag there was a checker artifact, not a label error. But a
**judgment-layer blind re-grade of the 45 debatable labels caught one real
conceptual under-credit** the automated checks structurally could not: a
`subtly_wrong` response marked `not_earned` that actually earns a sub-point
(correct efficiency calculations) per the rubric — corrected. Plus one genuine
boundary disagreement routed to humans, and a soft cluster contaminated by a
known item defect (AP Stats MOD8 has no dataset). Lesson: the deterministic layer
guarantees the numeric labels; only a judgment pass (ideally a different model,
then humans) catches conceptual sub-point errors.

**But the independence is partial:** only 9 of 224 judgments are checked against
a judgment-independent signal; the other 215 conceptual/judgment labels rest on
single-model (author) judgment. A same-model re-grade catches gross and
self-inconsistent errors, not subtle ones — a *different* model, then human
dual-blind adjudication, is still required before these labels back a quality
claim. The cheap next step is an independent conceptual pass by a different model.

## Open questions carried forward

- Do Lessons 1-4 replicate on criteria beyond FRQ02-C2 and on a second subject?
  (Next-experiment #1 in the assessment.)
- Are the governance §12.3 numeric thresholds feasible against a real adjudicated
  gold set? (Unproven until one exists.)
- What is the launch decision on grading tail latency, given escalation's 8-11s
  outliers and the brand-critical exam-week window?
