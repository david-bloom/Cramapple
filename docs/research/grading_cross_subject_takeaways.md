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
  `bio_reference_layer_flywheel_volume_test_report.md`). A later AP
  Statistics few-shot exemplar pilot (`exemplar_grading_pilot_2026_08/REPORT.md`)
  did **not** independently confirm this — its result is inconclusive
  because the scoring harness's bootstrap clustered on responses (n=30)
  instead of the held-out items the design required (n=4), not because
  exemplars were shown to help or hurt. Do not cite it as a fifth
  confirmation of this lesson.
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

## Lesson 9 — Request architecture: parallel per-criterion beats single-call batching on latency, structurally

**Evidence 2026-07-28** (`grading_phase_c_calibration_2026_07_27/`, n=100 items /
433 criteria / 537 paid calls, cross-subject): a single structured call
returning all criteria ("Arm B") has latency **linear in criterion count**
(`≈610 ms + 637 ms × n_criteria`, measured at 267 tok/s generation, 610 ms
TTFB), whereas parallel per-criterion calls ("Arm A") are **near-flat** in
criterion count (p50 1,943 ms at a mean of 4.4 criteria/item). Arm B wins only
at `n_criteria = 1`; 88 of 100 corpus items have ≥2. No prompt or token-budget
setting changes the slope — the only lever is cutting per-criterion output
3–6×, which deletes the evidence-quote / minimum-fix / improved-answer fields
that are the product promise.

This **refines Lesson 10's** "parallel criterion calls amplify tail latency":
that risk is real but rare, not dominant. Arm A's max-of-N tail fired once in
437 calls (12,024 ms vs a 4,233 ms p99) — ~0.2%. Fan-out batching trades a
0.2% tail event for a 100% median penalty. Batch only if the tail, not the
median, is the binding constraint.

**Consequence in policy:** parallel per-criterion is the default request
architecture. Single-call batching is closed as a latency play and should not
be re-proposed without new evidence; revisit only for cost (it is ~2.4×
cheaper, immaterial at beta scale) or if the max-of-N tail becomes the
binding constraint.

## Lesson 11 — Equivalent-form under-credit is the dominant recoverable error class

**Evidence 2026-07-28** (same run, both arms, all nine subject SKUs):
under-credit outnumbered over-credit **3.3× (Arm A, 26 vs 8)** and **5× (Arm B,
20 vs 4)**. Localised, the worst mechanism is
`equivalent_noncanonical_wording` at **75.0% agreement with 6 under-credits and
0 over-credits**, and the worst archetype is `boundary_adjacent` at **80.9%**.
Perfect-scoring classes (`blank_off_topic`, 100%) confirm the graders are not
generally weak — they are specifically harsh on correct work phrased
differently from the canonical wording, concentrated in criteria whose
`accepted_variants` is empty or generic.

This is Lesson 1 and the FRQ-02 "equivalent forms must earn" rule reconfirmed
cross-subject at scale, and it is the largest single recoverable gap between
the measured 90.6% and the 95% launch bar. **The harm direction is withholding
points a student earned.**

**Consequence in policy:** authoring explicit `accepted_variants` /
equivalent-form boundary language is the highest-leverage pre-launch content
task, ahead of any model or architecture change. Prioritise the weakest
subjects — AP Statistics (82.0%) and AP Physics 1 (85.2%).

## Lesson 12 — The deterministic layer is nearly absent in practice

**Evidence 2026-07-28:** across 437 criterion calls on a 100-item
cross-subject corpus, the deterministic checker fired on **3 (0.7%)**. Only 5
`content_key`s corpus-wide carry a seeded verification profile — the same 5
wired to Production since 2026-07-12. **99.3% of criteria were graded with no
deterministic support.** Lesson 3 established that deterministic checks catch
what the model structurally cannot, at ~0 ms and ~$0; that benefit is
currently unrealised at any meaningful scale.

**CORRECTION 2026-07-28, REVISED after Codex review** (`ENGINE3_VERIFICATION_PROFILE_COVERAGE_2026_07_28.md`):
**Engine 3 has never been measured in a form reflecting production behaviour.**
The 0.7% figure came from a substring-match proxy written for the Stage 6 runner;
production uses symbolic parsing + a two-universe ECF machine over structured
`response_parts`, sharing no code path. Worse, **0 of 1,316 content_item_versions
are routed to `symbolic_ecf`**, so the production Engine 3 branch has never
executed for any item — and the two hardcoded profiles capable of firing sit on
items whose `rubric_type`/`evaluator_strategy` are NULL. Coverage is the *third*
of four independently fatal links (routing → structured input → profile keys →
authoritative output, which currently hard-codes `finalStatus="uncertain"`).
"Delivery, not authoring" was the wrong diagnosis. Superseded figure retained:
research-key coverage was 0.7% — the 5 profiles deployed in `math-verifier.ts`
are a different 5, none of which appear in the corpus, and **2 of those 5 can
never fire** (one has `ecf_parts: []`, one carries an unresolved `corpus_defect`).
Production Engine 3 is three items wide. This lesson was understated.

**Storage was NOT the blocker** — a further correction. `prompt_json` is
version-bound jsonb and `grading-router.ts:35` already reads
`record.verification_profile` from it (with a unit test). My original claim of
"no home in the schema" came from searching column *names*, which structurally
cannot find a nested jsonb key. What is missing is a *dedicated, validated,
governed* profile contract — not a storage option. That said,
`prompt_json.verification_profile` is populated on **0 of 1,316** versions, and
the checker still reads keys from a hardcoded TypeScript map, so 25 of 30
authored profiles remain undeployed as **migration candidates** (each needs
version re-resolution, criterion-key matching, TS-runtime formula parsing, and
post-repair ECF re-validation before it is deployable).

**Yield is badly mismatched to effort:** all existing profiles are AP Statistics,
the **lowest**-yield subject in the bank (24% of criteria plausibly keyable),
while AP Calculus AB (92%) and AP Precalculus (86%) have zero.

**Consequence in policy:** verification-profile coverage is a first-class
launch metric, not an implementation detail. Report deterministic-ownership
rate alongside agreement in every future grading run — and report it against
*deployed* profiles, never against a research file. Track **items fully
covered**, not just criteria covered: an item only returns fast if *all* its
criteria are deterministic.

## Lesson 13 — Grading actions promoted offline into boundaries: validated, and distinct from the refuted flywheel

**Evidence 2026-07-28** (`grading_phase_c_calibration_2026_07_27/B1_BOUNDARY_STRENGTHENING_RESULTS.md`,
630 paid calls, 21 items, 42 fresh blind-adjudicated answers): taking the
existing body of **grading actions** (grader verdict + stated reason + the
independent adjudication that overruled it) and promoting it **offline** into
sharpened criterion boundary contracts produced, on **fresh unseen answers to
the same questions**:

- **+6.5 pp** criterion agreement (81.5% → 88.0%), paired McNemar **p = 0.0004**
  (18 criteria fixed, 2 broken);
- **+28.2 pp** on the criteria that actually received a revision (63.3% → 91.5%),
  against **−0.4 pp** on untouched criteria — the effect is targeted, not diffuse;
- **under-credit down 41%** (39 → 23) with **over-credit flat** (7 → 7) — it stops
  the grader withholding earned points without making it lenient;
- **p50 latency flat** (2,088 → 2,006 ms), because the boundary is static rubric
  text inside the *existing* single call — no extra round-trip.

**This is the sharp distinction from Lesson 2.** What was refuted there was
building a *reference body of answers* and consulting it **at runtime** — the
failure mode was latency, paid on every call. What is validated here is a body
of *grading actions* compiled **offline** into the frozen boundary. Different raw
material, different timing, opposite latency sign. Do not let one be cited as
evidence against the other.

**Two honest limits.** (1) **p90 latency rose 3,055 → 3,974 ms (+30%)** — longer
contracts widen the tail even though the median is unaffected; consolidate
boundary text periodically rather than only appending. (2) The
**escalation/abstention-reduction** half of the thesis is **still unmeasured** —
the fresh gold contained zero ambiguous labels, so the revised abstention
policies had nothing to act on. Unproven, not disproven; needs a corpus
deliberately seeded with ambiguous responses.

**Consequence in policy:** every human adjudication should emit a candidate
boundary revision, reviewed and promoted offline, regression-tested against that
item's frozen answer set. With a stable question set this is the compounding
quality asset — and it never touches grading latency at the median.

## Lesson 14 — Component batteries test what the author imagined; corpus-derived fixtures test what the system will meet

**Evidence 2026-07-28** (`ENGINE3_HARNESS_RUN1_RESULTS_2026_07_28.md`): Engine 3's
components were on record as validated — formula checker 62/62, ECF engine 6/6,
Statistics templates 7/7. A harness whose fixtures were **generated from the real
verification-profile corpus** rather than hand-authored found **three production
bugs on its first run, at $0**:

1. **Reserved-name collision (HIGH).** The parser binds `e` and `pi` to Euler's
   number and π *even when supplied as givens*. `(a+b+c+d+e)/5` with
   a=12,b=15,c=18,d=21,e=24 returns **13.7437 instead of 18**. Three profiles
   affected — including `STATS-MOD1-E004`, which is **published and
   tutor-approved**. A correct student would be marked INCORRECT with fabricated
   arithmetic in the feedback.
2. **ECF credit with no dependency (HIGH).** A no-`deps` part with empty
   `shown_subs` and a plainly wrong answer receives `CORRECT_VIA_ECF` — full
   marks — with feedback citing an "earlier part" that does not exist. Applies
   structurally to every constant-answer or single-step keyed part.
3. **Parser missing `erf`/`factorial` (MEDIUM).** Two shipped profiles use them;
   the canonical formula fails to parse and the failure path emits
   `NAKED_ANSWER`, telling a fully-correct student "no work shown."

None of the prior batteries contained a variable named `e`, a wrong answer on an
independent part, or an `erf`/`factorial` formula. **The components passed the
tests that existed; the tests did not cover the shapes the real profiles use.**

**Two method points that made this work:** expectations were computed with SymPy,
deliberately *not* with the TypeScript parser under test — computing them with
the system under test would have baked the parser bug into both sides and hidden
it. And the first run's 19 extra mismatches turned out to be a **fixture bug, not
a checker bug**; a harness that cannot distinguish those is worthless, so each
mismatch class must be adjudicated, never assumed.

**Also measured, with a caveat that matters:** the deterministic *check itself*
runs at **p50 0.043 ms of CPU with zero model tokens**, against **1,428 ms** for a
model call (per-criterion) / 1,943 ms per item. These are **not the same
quantity** — the checker figure excludes HTTP, auth, DB reads/writes,
edge-function invocation, and render, all of which a real request still pays.
The defensible claim is that a deterministic verdict adds essentially nothing to
the request budget, **not** that requests return in microseconds. End-to-end
deterministic request latency remains unmeasured. (An earlier version of this
lesson claimed "~45,000x faster" by comparing the two directly; that was a
category error and is retracted.)

**Consequence in policy:** every deterministic component ships with a fixture
generator derived from the live content corpus, kept as a permanent regression
suite; and the profile validator must reject reserved-name variables and
unsupported functions at authoring time.

## Open questions carried forward

- Do Lessons 1-4 replicate on criteria beyond FRQ02-C2 and on a second subject?
  (Next-experiment #1 in the assessment.)
- Are the governance §12.3 numeric thresholds feasible against a real adjudicated
  gold set? (Unproven until one exists.)
- What is the launch decision on grading tail latency, given escalation's 8-11s
  outliers and the brand-critical exam-week window?

## Lesson 15 — The grader does not abstain, and prompt text cannot make it (β2-A, 2026-07-28)

Against 56 criterion labels that blind human-standard adjudication judged **genuinely
undecidable**, the grader returned a confident verdict on 54 — before *and* after 30
hand-authored `abstention_policy` fields were added. Paired McNemar: 1 fixed, 2 broken,
**p = 1.00**.

The base prompt already said "use unable_to_determine when the response is genuinely ambiguous
rather than clearly absent/wrong", and the schema always accepted the value. So this is not a
missing instruction. **Asking harder does not produce abstention.**

Two consequences:

1. **There is no escalation path out of Engine 1.** Undecidable work receives an arbitrary
   grade — the earned/not_earned split on ambiguous input was 24/30 in one condition and 30/24
   in the other, and the two conditions agreed with each other on only 75% of it. Nothing is
   flagged; nothing reaches a tutor.
2. **`confidence` is a constant.** It read `high` on 100% of gold-ambiguous input and on 100%
   of the grader's own errors. It cannot be used for triage or confidence-gated release.

**Escalation must be built outside the grading call** — structural detection of the ambiguity
shapes, or inter-run disagreement as a routing signal. Not by asking the model to introspect.

## Lesson 16 — Ambiguity comes from present content, never from absent content (β2-A, 2026-07-28)

Six seeded ambiguity classes; three produced genuine undecidability and three did not:

| works | fails |
|---|---|
| absent artifact reference (94%) | ambiguous notation (14%) |
| truncation mid-assertion (82%) | unresolvable referent (12%) |
| competing unresolved claims (82%) | **assertion absent (0%)** |

"Student describes the procedure but never asserts the conclusion" is **decidably `not_earned`**,
every time — not ambiguous. Adjudicators likewise resolved most referents and notation from
context rather than guessing.

> **Ambiguity arises from content that is present-but-competing or present-but-unreadable.
> Missing content is decidable.**

Practical effect: any `abstention_policy` clause telling the grader to abstain on *absence*
manufactures escalations instead of preventing them, and must be rewritten before those fields
are ever made load-bearing.

## Lesson 17 — A paid run must write incrementally before it writes anything else (2026-07-28)

The β2 run was first launched in the foreground, hit a 10-minute cap, and lost every completed
call because the script only serialised results at the end — money spent, zero data. Rewritten
to append each response-group to its output file and resume from that file on restart.
Any run costing real money gets checkpoint-and-resume before it is launched, not after it fails.

## Lesson 18 — Engine 1 is 99.4% self-consistent, and its instability is a usable ambiguity detector (β2-B, 2026-07-28)

Three identical replicates (same prompt, temp 0, thinking off) over 728 gold-labelled criteria:

| | agreement |
|---|---:|
| overall | 97.8% |
| on **decidable** content | **99.4%** |
| on **undecidable** content | 87.6% |

**Instability is 20.8x enriched on genuinely undecidable content** (18.5% vs 0.9%). The grader
is stable exactly where a stable answer exists. This is the reliability number the program
lacked, and it is good — cite 99.4% on decidable content, with the caveat below.

As an escalation trigger, "the replicates disagreed" gives **precision 62.5%** against a 7.4%
base rate, firing on 2.2% of labels. Inducing diversity with a paraphrased prompt trades
precision for a little recall (54.2% / 24.5%).

**But recall is only 18.5%** — four in five undecidable responses still get a silent confident
grade. Adding a deterministic detector for the absent-artifact shape lifts the union to ~37%.
Competing-claims (A1) and truncation (A3) hold the remaining recall and are detected by
neither mechanism. **Sampling harder does not help: the model commits to one side of a genuine
ambiguity reproducibly, so this is not noise.**

Ship disagreement-routing regardless — partial mitigation beats none, and at ~$0.0117/FRQ it
is inside the cost ceiling — but always report it with its recall number attached.

## Lesson 19 — Escalation triggers must be scored at the PRODUCTION base rate, not the corpus base rate (2026-07-28)

The β2 corpus is 44% ambiguous by construction. Natural ambiguity is **0.73%**. Precision
measured on the corpus is therefore inflated by ~60x, and ranking signals by corpus precision
picks the wrong ones.

| signal | recall | FPR | precision @44% | **precision @0.73%** | volume @0.73% |
|---|---:|---:|---:|---:|---:|
| 3x replicate disagreement | 18.5% | **0.9%** | 94% | **13.1%** | **1.0%** |
| induced-diversity disagreement | 24.5% | 1.8% | 91% | 9.1% | 2.0% |
| authored-artifact text rule | 39.3% | 15.7% | 66% | **1.8%** | 15.9% |
| authored OR spatial deixis | 55.4% | 49.2% | 47% | 0.8% | 49.2% |

Across ~65,000 beta criterion judgments (~474 genuinely undecidable):

- disagreement escalates **669** to catch 88
- the text rule escalates **10,326** to catch 186

**The higher-recall signal is unusable.** What makes a trigger viable is a low false-positive
rate, not high recall — at a 0.73% base rate an FPR above ~2% buries the true positives.
This reverses the intuitive ranking and invalidates an earlier recommendation in this program
to ship the structural text detector as a standalone escalation trigger.

**Corollary:** cheap high-recall text rules are still useful — as a **pre-filter feeding a
second stage**, never as the trigger itself. Score every candidate trigger at 0.73% before
believing it.

**Also corrected:** the absent-artifact shape was described as "close to a regex". A first-pass
regex gets **10.7%** recall; a tuned first-person-authored-artifact rule gets 39.3%. The
phrasings are varied ("the sticky note I put next to my graph", "I sketched it in the margin"),
and a bare "this table" legitimately refers to the *stimulus*. The discriminator is
**first-person authorship** ("I drew", "my sketch"), not the artifact noun.

## Lesson 20 — Production Engine 1 was 100% broken, and only the live API showed it (2026-07-28)

Verified against Production: `evaluate-attempt` was deployed and ACTIVE, but of the **10**
grading rows that exist, **5 were FRQ and none succeeded**. Two independent defects, either of
which alone rejects every request:

1. **`required` omitted `action_hint` and `repair_hint`.** OpenAI `strict: true` requires every
   key in `properties` to appear in `required`. The API names only the *first* offender, so a
   fix driven by the error text would have shipped a second identical outage.
2. **`reasoning.effort` sent unconditionally.** `buildGradingRequestBody` defaulted to
   `"high"` and `evaluate-attempt` never overrode it; `gpt-4.1-mini` rejects the parameter
   outright. Invisible until an actual request was made.

**Unit tests could not have caught either** — both are contract violations that only the
provider adjudicates. The verification that mattered was replaying the *unmodified* production
request body against the live API. Do that before believing any transport-layer fix.

**Also:** every Phase C number (Stage 5/6, β1, β2) was measured on `gemini-2.5-flash` via the
gateway, while Production runs `gpt-4.1-mini` via `OPENAI_MODEL`. Verify the deployed
configuration *before* spending on calibration, not after.

## Lesson 21 — A grounding check that is stricter than its purpose destroys credit (2026-07-28)

Evidence grounding used a raw `response.includes(quote)`. Measured over **2,973 real grader
outputs**:

| rule | flagged |
|---|---:|
| exact substring (shipped) | **10.19%** |
| + unicode/whitespace normalisation | 3.70% |
| + elision-aware (`"first ... last"`) | **2.66%** |

**~64% of flags were false alarms**, most caused by nothing worse than a quote spanning a line
break. And a flag is not advisory: it forces `unable_to_determine` **and zeroes the points**.
So the brittle matcher was silently converting correct gradings into withheld credit — the same
under-credit direction β1 was fixing at the rubric level, arriving from the code instead.

Deliberately not relaxed further: lowercasing recovered **zero** additional cases (so it would
only weaken the check), and no fuzzy matching was added. The residual 2.66% are genuine
paraphrases and invented quotes, which is what the check is for. **Calibrate a validator against
real model output before choosing its strictness** — and assert both directions in tests.

## Lesson 22 — A boundary experiment is only as good as the difficulty of its held-out set (β3, 2026-07-28)

β3 authored 25 second-generation contracts from 94 observed grading errors and measured
**+0.8 pp on fresh answers, p = 0.69**. Inconclusive — and it could not have been otherwise:

| | β1 | β3 |
|---|---:|---:|
| baseline accuracy | 81.5% | **95.2%** |
| errors available to fix | 46/249 | **13/269** |
| discordant pairs | 20 | **6** |
| result | +6.5 pp, p=0.0004 | +0.8 pp, **p=0.69** |

All power in a paired test lives in the discordant pairs. With 6, even a perfect 6–0 split only
reaches p=0.031; the observed 4–2 cannot reach significance **at any effect size**.

The cause: the fresh corpus was generated as "strong / mixed / near-boundary" rather than to
mirror the *specific mechanisms* of the observed errors, so the existing contracts already
graded it at 95.2%. **Before spending on any boundary experiment, count the baseline errors in
the held-out set. Target ≥15% baseline error.** A five-second check would have caught this.

**Corollary — the derivation set lies.** Same-corpus agreement went 95.7% → **99.0%**, which is
memorisation: those contracts were authored from those exact errors. The 99% is not an
achievement and must never be reported as one. Only the fresh number counts, and it was noise.

## Lesson 23 — Rubric authoring is an accuracy lever and a speed COST (β3, 2026-07-28)

| | before | after |
|---|---:|---:|
| prompt size / criterion | 7,162 chars | 8,281 (**+15.6%**) |
| p50 | 1,852 ms | 1,950 ms |
| p90 | 3,787 ms | 4,034 ms (**+6.5%**) |

β1 measured the same direction (+30% p90). Contracts now average >8 KB per criterion and grow
with every authoring pass. **No amount of rubric work makes grading faster.**

The real speed lever is architectural. Production issues ONE call per item covering all criteria
— measured at **≈0.58 s + 3.89 s × n_criteria** — which is the Arm B shape Phase C closed as a
dead end. Arm A (parallel per-criterion) is flat in criterion count. On a 4-criterion Biology
FRQ that is **~16 s → ~4 s**: two orders of magnitude more speed than any prompt tuning, and
completely independent of rubric work.

## Lesson 24 — Check for known label defects before interpreting a grader/gold disagreement (2026-07-28)

The FRQ02 boundary diagnostic first read as a perfect null on C2: **3 fixed / 3 broken,
p = 1.00**, reported as "compact boundary memory does not work." It was wrong.

The three "broken" responses were `S054`, `S062`, `S070` — **all three inside the label-noise
cluster `grader_speed_sp1_report.md` had already documented** as labelled `earned` while phrased
like the confirmed-`not_earned` `S068`. The three fixed were `S020`, `S021`, `S028` — **exactly
the confirmed hard cases the v2 boundary table was written for.**

| FRQ02-C2 | n | no memory | boundary memory | delta | fixed/broken |
|---|---:|---:|---:|---:|---:|
| as-labelled | 99 | 80.8% | 80.8% | +0.0 pp | 3/3 |
| **known label defects excluded** | 94 | 81.9% | **85.1%** | **+3.2 pp** | **3/0** |

Five bad labels turned a real +3.2 pp effect into exactly zero. **Rule: before interpreting any
grader/gold disagreement on a corpus with prior investigation, check whether that disagreement is
already a documented label defect.** This also confirms Lesson 5 twice over — SP-1 found these by
reading reviewer notes, a boundary table found the same responses blind.

**Act on it:** fix `S054`, `S058`, `S062`, `S070`, `S014` before any further C2 experiment.

## Lesson 25 — Boundary-memory value is model-dependent, so #1 and #2 are one experiment (2026-07-28)

FRQ02-C2 strict agreement across every arm measured to date:

| model | boundary | agreement |
|---|---|---:|
| `gpt-5.5` medium | none | 67.5% |
| `gpt-4o-mini` | v1 | 60.0% |
| `gpt-4o-mini` | **v2** | 77.5% |
| `gemini-2.5-flash` | **none** | **80.8%** |
| `gemini-2.5-flash` | v2 | 80.8% (85.1% clean labels) |

*Caveat: SP-1 used an enriched n=40 sample including all 5 ambiguity-cluster responses; the 2026-07-28
run used the full n=100. Suggestive, not directly comparable.*

The v2 rewrite was worth **+17.5 pp on `gpt-4o-mini`** and **~0 on `gemini-2.5-flash`** — because
gemini already reaches, unaided, roughly where gpt-4o-mini needed the table to get. **Boundary
tables encode calibration a stronger model may already carry, so their value decays as models
improve.**

Consequence: "does compact boundary memory help?" has no model-independent answer. The planning
memo's items #1 (memory vs no memory) and #2/#4 (model swaps) are **not separable** — the correct
experiment is the 2×2 of {model} × {boundary on/off} on one fixed sample, and no run so far is that.

## Lesson 26 — Output-schema leanness is a first-class speed lever (2026-07-28)

| | p50 | p90 | output tokens |
|---|---:|---:|---:|
| 4-field schema | **1,073 ms** | 1,442 ms | 100 |
| 9-field schema (Phase C Arm A) | 1,428 ms | 2,188 ms | — |

Same model, same provider, same architecture — only the output schema and prompt length differ.
Dropping `improved_answer`, `minimum_fix`, `error_classification`, and `gate_schema_status` puts
p50 at **~1,073 ms, essentially at the 1,000 ms aspiration**, before any model swap or
architecture change. `improved_answer` asks the model to compose prose no grading decision
depends on.

Ranked speed levers, largest first: **(1)** Arm B → Arm A in Production (≈0.58 s + 3.89 s ×
n_criteria → flat; ~16 s → ~4 s on a 4-criterion FRQ); **(2)** lean output schema (~355 ms p50);
**(3)** model choice. Rubric authoring is not on this list — it is a speed *cost* (Lesson 23).

> **Correction (2026-08-13) — item (1) above does not replicate on the production
> model.** This ranking's Arm A figures were measured on `gemini-2.5-flash`
> (a known handoff trap — Phase C never validated Arm A on `gpt-4.1-mini`,
> what Production actually runs). See Lesson 27 below for the re-measurement
> and the corrected ranking. Items (2) and (3) are unaffected — they were
> not re-tested and nothing here contradicts them.

## Lesson 27 — Arm A's speed claim was measured on the wrong model, and doesn't hold on the right one (2026-08-13)

Re-measured Lesson 26 item (1) — "Arm B → Arm A, ~16s → ~4s on a 4-criterion
FRQ" — on `gpt-4.1-mini`, the model Production actually runs (grading-engine
replan Run C, `exemplar_grading_pilot_2026_08/EXECUTION_LOG.md`). 24
authenticated calls, 4 real held-out items spanning 2–4 criteria:

| criteria | n | mean latency | median |
|---|---:|---:|---:|
| 2 | 6 | 30.8s | 31.7s |
| 3 | 6 | 29.9s | 31.3s |
| 4 | 12 | 22.0s | 23.7s |

Not flat, not ~4s on 4-criterion items, and most individual calls slower
than Arm B's typical single-call latency measured the same session
(~8–12s). The fan-out itself is genuinely parallel (confirmed in code —
`Promise.all`, wall time taken as the max of per-criterion elapsed times,
not summed) — the finding is that per-call latency on this model is high
and variable enough (5.8s–44.6s observed) that the parallelization doesn't
pay off the way it did on the model Phase C actually tested. Quality was
not clearly bad in this re-run (82.6% overall / 95% selective accuracy on
an 8-case gold subset, scored with the real harness) — this is a speed
correction, not a full reversal.

**Rule this generalizes to: an architectural speed claim is scoped to the
model it was measured on. Re-validate on the actual production model
before relying on it for a shipping decision, especially when the original
measurement is known to have used a substitute model (Phase C's own
handoff doc already flagged this as "trap 1" before Run C confirmed the
consequence).** Sample size caveat: n=6–12/bucket is enough to falsify
"flat and ~4s," not enough to fully characterize the real latency
distribution or rule out "genuinely faster on average, just noisy here" —
a confident ship/discard call needs a larger sample, not a re-run of this
exact size.

## Lesson 28 — Evidence-grounding false alarms, not model judgment or deterministic coverage, are the binding accuracy constraint (2026-08-13)

Two independent same-session checks converged on this: an authenticated O2
smoke test and Run A (13 previously-gated responses re-graded after the
`STATISTICS_TARGETS` fix). Both found **selective accuracy at or near
100%** — every criterion the grader committed a verdict on was correct —
while overall/coverage accuracy sat far lower (Run A: 61.3% overall vs
100% selective). The entire gap was abstention (`unable_to_determine`),
and the mechanism producing it was the sanitizer's evidence-grounding
check (`grading-feedback.ts`) rejecting a criterion the model judged
correct because its supplied quote wasn't an exact grounded substring —
the same false-alarm class `grading-feedback_test.ts`'s own header
documents (10.19% pre-fix, ~64% of those from formatting, not invention).

**This is now the highest-leverage lever on measured accuracy** — ahead
of further deterministic-key coverage, ahead of gold-set corpus volume,
ahead of a new model/arm evaluation. None of those move a number whose
gap is abstention, not wrong answers. **When a future accuracy report
shows overall accuracy well below selective accuracy, that is this
mechanism, not a new problem — check the grounding/integrity-issue
breakdown before proposing new grading work.**

