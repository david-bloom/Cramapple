# Claude Execution Prompt — TASK-0016 Phase C Cross-Subject Calibration

Repo: `Cramapple`. Work on the current canonical grading branch. Preserve all
unrelated working-tree changes and stage only files created or intentionally
modified by this task.

## Objective

Execute Phase C: measure whether Cramapple's fast, boundary-contract grading
architecture generalizes across tutor-reviewed MCQ and FRQ content while
meeting the quality, speed, cost, reliability, and feedback requirements.

This is a **cross-subject calibration run**, not more content authoring.
Production verification on 2026-07-27 found 309 tutor-approved FRQs and 351
tutor-approved MCQs across the reviewed bank, so the content inventory is not
the blocker.

## Read first

Read these files completely:

1. `docs/GRADING_PROGRAM.md`
2. `docs/research/GRADING_PROGRAM_LEDGER_2026_07_27.md`
3. `docs/research/GRADING_RESEARCH_CANONICAL_PROCESS.md`
4. `docs/research/grading_cross_subject_takeaways.md`
5. `docs/research/grading_generalization_and_feedback_protocol_2026_07_08.md`
6. `docs/research/frq02_label_audit_2026_07_27/RESULTS_REPEAT2_FINAL_GOLD_2026_07_27.md`
7. `docs/research/grading_repair_pilot_2026_07_27/RESULTS_2026_07_27.md`
8. `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md`

Do not rely on chat history as evidence. The reconciled ledger controls phase
status when an older plan conflicts.

## Questions this run must answer

1. Does the precise criterion-contract approach generalize beyond AP Biology
   FRQ-02?
2. Can one structured multi-criterion call reduce the max-of-N latency penalty
   without losing criterion accuracy or feedback quality?
3. Which error classes recur across subjects: semantic attachment,
   contradiction leakage, equivalent-form rejection, arithmetic, units,
   temporal scope, or ECF?
4. Is the current architecture ready for a larger n=100 decision run, or does a
   specific boundary/architecture issue need repair first?

## Targets

Report against both bars:

- **Experimental aspiration:** at least 90% strict criterion agreement.
- **Formal TASK-0016 launch bar:** at least 95% criterion agreement.
- **Speed:** end-to-end p50 at or below 1,000 ms; report p90, p95, p99, and max.
- **Cost:** at or below $0.01 per FRQ.
- **Schema validity:** target 100%; every invalid result counts as incorrect.

Quality is evaluated first, then speed, then cost. Do not trade a higher-priority
metric for a lower-priority one.

## Important distinctions

- Tutor approval establishes that the **item, answer, and rubric** were
  reviewed. It does not label a newly generated student response.
- Generated answer tiers are not gold.
- Structurally valid JSON is not semantically correct gold.
- MCQs use deterministic exact-choice matching; do not spend model calls
  grading them.
- Only 43 FRQs and 64 MCQs are currently both tutor-approved and published
  across Production. Therefore run this calibration through a read-only
  corpus/gateway harness, not by creating 100 Production attempts.

Do not write test attempts, users, responses, grades, or review decisions to
Production. Production access for this task is read-only.

## Stage 1 — Freeze the tutor-reviewed item manifest

Query Production `pcntajvbdfqhbeewmdry` read-only.

Select only the exact content-item version attached to a latest,
non-superseded tutor decision of `approve` or `approve_with_edits`. Exclude:

- items currently reopened/pending re-review;
- missing canonical answers;
- incomplete rubrics;
- unresolved missing stimuli/images/data;
- superseded versions;
- explicit tutor disapprovals;
- rights or provenance failures.

Freeze:

- 100 MCQs;
- 100 FRQs, including at least 10 long/investigative or multi-part items when
  the eligible inventory supports it.

Stratify across these subject families:

- Biology;
- Chemistry;
- Statistics;
- Physics, including multiple Physics SKUs;
- Calculus/Precalculus.

Use a deterministic selector and record its seed and SQL. Do not silently
replace excluded items after output review. If a family lacks its planned
quota, redistribute deterministically and report the shortfall.

Create:

`docs/research/grading_phase_c_calibration_2026_07_27/FROZEN_ITEM_MANIFEST.json`

Include content/version/rubric IDs, content key, subject, item type, FRQ form,
criterion count, tutor-decision provenance, selector rank, and exclusion
reason where applicable. Do not include reviewer PII.

## Stage 2 — MCQ integrity calibration

For each frozen MCQ:

1. verify exactly one approved correct choice;
2. run the same local deterministic choice-match function used by the grading
   router against the correct choice and at least one incorrect choice;
3. record exact-match correctness, schema/result integrity, and local latency;
4. report content defects separately.

Expected model cost is $0. Any model call for MCQ grading is a protocol failure.

## Stage 3 — Build and adjudicate the FRQ response corpus

Create one primary synthetic response per frozen FRQ, balanced deterministically
across these response archetypes:

- fully correct;
- partially correct;
- plausible but boundary-adjacent;
- confidently wrong but complete;
- blank/off-topic or unable-to-determine.

For multi-part items, ensure the corpus contains:

- correct downstream work from an earlier wrong value (ECF);
- correct conclusion with wrong reasoning;
- correct method with arithmetic error;
- equivalent but non-canonical wording/form;
- explicit contradiction or self-correction;
- negation/hedging and scope/temporal near-misses.

### Independence

Generate the student responses with a provider/model that will **not** be used
as either grading arm, blind to canonical answers and criterion labels. The
generation prompt may see the student-facing stem and a target error archetype,
but not the scoring rubric.

After generation is frozen, Claude independently adjudicates every criterion
against the tutor-reviewed rubric, canonical answer, verification profile, and
criterion contract. Record:

- `earned | not_earned | unable_to_determine`;
- evidence quote;
- adjudication rationale;
- accepted equivalent;
- contradiction/ECF policy applied;
- confidence;
- unresolved human-review flag.

Audit all labels for internal invariants:

- total points equal earned criterion weights;
- negated mentions do not count as affirmative evidence;
- cause/operation/outcome criteria remain distinct;
- one wrong criterion does not contaminate an independent criterion;
- deterministic results and ECF labels agree;
- reviewer notes do not contradict labels.

Unresolved labels must be excluded from the primary accuracy denominator and
listed—not guessed. Save original generation tiers separately; never use them
as truth.

Create:

- `candidate_responses.jsonl`
- `adjudicated_labels.jsonl`
- `label_audit_report.md`

These are calibration labels produced under this protocol. Do not call them
dual-human launch gold.

## Stage 4 — Freeze the two FRQ grading arms

Use the same fast model for both arms, initially
`google/gemini-2.5-flash` with thinking disabled.

### Arm A — Parallel criterion baseline

- one model call per criterion;
- criteria run in parallel;
- subject criterion contract included;
- deterministic checks run first and own only checks they can safely decide;
- no confidence escalation, ensemble, retrieval, or post-hoc audit.

### Arm B — Single structured multi-criterion challenger

- one model call per response;
- returns all criterion verdicts and feedback in one schema;
- identical criterion contracts and deterministic-check results;
- no escalation, ensemble, retrieval, or post-hoc audit.

The only intended difference is request architecture. Freeze model IDs,
provider settings, prompts, JSON schemas, token caps, concurrency, timeouts,
pricing table, and prompt hashes before scoring.

Required output per criterion:

- status;
- confidence for logging only;
- evidence quote;
- withheld-point reason;
- minimum fix;
- concise improved answer;
- error classification;
- gate/schema status.

## Stage 5 — Low-number paid gate

Before running all 100 FRQs, run a paired deterministic slice of 20 responses:
four per subject family, covering all archetypes and the hardest
contradiction/ECF cases.

Set a hard paid cost ceiling of **$1.00** for this gate.

Proceed to the remaining 80 only if:

- both arms produce at least 95% schema-valid rows;
- no corpus/ID mismatch occurs;
- labels and prompt hashes remain frozen;
- no systemic parsing, timeout, or harness defect appears;
- projected total spend remains within the declared full-run cap.

If criterion agreement is below 85% or p50 exceeds 3 seconds, stop before the
remaining 80 and report the failed low-number gate. Do not tune prompts after
viewing accuracy and then reuse the same test set.

Mechanical harness fixes are allowed only with a versioned burned-run record
and a fresh output file.

## Stage 6 — Full paired calibration

If the low-number gate passes, run both arms on all 100 frozen FRQ responses.
Use a hard total paid ceiling of **$5.00**, including the low-number gate and
answer-generation calls, failed/retried provider calls with known cost, and all
grading arms.

Keep response order and concurrency identical across arms. Runs must be
resumable without duplicating completed paid units.

Measure end-to-end wall time around the complete grading unit. For Arm A, FRQ
latency is the maximum completion time across its criterion calls, not the
average criterion latency.

## Metrics

Report pooled, per-subject, per-archetype, and per-criterion:

- strict criterion agreement;
- total-score exact agreement;
- over-credit and under-credit;
- schema validity and retry/timeout rate;
- paired verdict stability/disagreement;
- p50, p90, p95, p99, max, and mean end-to-end latency;
- average and total cost per FRQ;
- deterministic ownership/abstention rate;
- ECF agreement;
- error clusters.

For every missed criterion, independently score feedback:

- reason match;
- minimum-fix sufficiency;
- grounding in the student's response;
- improved-answer correctness;
- error-class accuracy.

Use `match | partial | mismatch | unable_to_determine`.

Do not pool unresolved labels, known corpus defects, or operational failures
into a flattering accuracy claim. Operational/schema failures count as wrong in
strict end-to-end success.

## Cross-subject analysis

The report must distinguish:

- subject-specific knowledge gaps;
- reusable contract defects;
- deterministic-check opportunities;
- criterion leakage;
- request-architecture latency;
- provider variability.

For every durable lesson, state how it applies to at least three subject
families. Feed stable lessons into
`docs/research/grading_cross_subject_takeaways.md`; keep single-run observations
in the dated report.

## Required outputs

Create under:

`docs/research/grading_phase_c_calibration_2026_07_27/`

- `README.md`
- `FROZEN_ITEM_MANIFEST.json`
- `EXCLUSIONS.json`
- `candidate_responses.jsonl`
- `adjudicated_labels.jsonl`
- `label_audit_report.md`
- `frozen_arm_manifest.json`
- `raw/<arm>.jsonl`
- `summary.json`
- `RESULTS.md`
- `EXECUTION_LOG.md`

The execution log must include:

- Production SQL used and returned aggregate counts;
- confirmation that Production access was read-only;
- selected IDs and hashes;
- paid-call counts and cost;
- retries/failures;
- whether the n=20 gate advanced or stopped;
- validation commands and results.

Update `docs/research/GRADING_PROGRAM_LEDGER_2026_07_27.md` with the measured
Phase C result and next action. Do not rewrite historical reports.

## Completion and decision

Recommend exactly one:

- advance the winning architecture to a larger adjudicated/launch-gate run;
- repair one named cross-subject boundary or architecture defect and rerun a
  fresh held-out slice;
- retain the current architecture because the challenger does not improve the
  quality/speed tradeoff;
- stop because labels or corpus integrity are not decision-grade.

Do not make a learner-facing launch decision. Phase F owns that decision.

## Guardrails

- Production is read-only; no test identities or application rows.
- No credentials, reviewer PII, or raw secrets in artifacts.
- No model calls for MCQs.
- No prompt/rubric tuning on the scored set.
- No generated tier treated as gold.
- No same-model answer generation and grading.
- No synthetic breadth beyond the frozen 100-item execution.
- Cost ceilings enforced before calls.
- Only task-scoped files staged/committed.
