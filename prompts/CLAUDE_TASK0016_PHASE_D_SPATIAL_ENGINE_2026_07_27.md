# Claude Execution Prompt — TASK-0016 Phase D Spatial Engine

Repo: `Cramapple`. Work on the current canonical grading branch. Preserve all
unrelated working-tree changes and stage only files created or intentionally
modified by this task.

## Ownership

You are the accountable execution owner for **TASK-0016 Phase D / Engine 4
Spatial Multi-Modal**. Carry the work from recovered state through the planned
sequence:

```text
QR capture prototype
  → visual-observation bake-off
  → dual-human adjudicated spatial gold
  → calibrated abstention
  → 100%-human-reviewed shadow operation
  → owner decision packet
```

Do not replace this sequence with a new plan. Do not declare Phase D complete
until the shadow gate and decision packet are complete. Human, Learning
Quality, security/privacy, accessibility, and Product Owner approvals remain
human responsibilities; Claude owns preparing, executing, measuring, and
documenting everything that can be done without fabricating those approvals.

## Objective

Deliver the smallest safe, working spatial-grading path for paper graphs:

1. a secure QR-handoff capture MVP;
2. a versioned observation-first grading contract;
3. measured comparison of deterministic geometry/OCR, multimodal observation,
   and hybrid reconciliation;
4. empirically calibrated retake, abstention, and human-review rules;
5. an AP Statistics shadow workflow with 100% human review and no authoritative
   automated learner score; and
6. reusable spatial contracts that can extend to Biology, Chemistry,
   Economics, and Physics without encoding one subject's vocabulary as the
   architecture.

The launch subject is AP Statistics. Reuse the existing AP Biology quantitative
graph artifacts as development evidence for the shared graph grammar; do not
mistake Biology development artifacts for Statistics launch validation.

## Read first

Read these files completely before changing code or running a model:

1. `docs/GRADING_PROGRAM.md`
2. `docs/research/GRADING_PROGRAM_LEDGER_2026_07_27.md`
3. `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md`
4. `docs/tasks/TASK-0011-HANDWRITTEN-GRAPH-CAPTURE.md`
5. `docs/research/DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`
6. `docs/research/TASK-0011_PHASE_1_EXECUTION_SPEC.md`
7. `docs/product/HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md`
8. `docs/research/ORLY_DRAWN_RESPONSE_PILOT_PROTOCOL.md`
9. `docs/research/DRAWN_RESPONSE_PILOT_V0_REVIEW.md`
10. `docs/research/grading_engine_rollout_plan_2026_07_08.md`
11. `docs/research/GRADING_RESEARCH_CANONICAL_PROCESS.md`
12. `docs/research/grading_cross_subject_takeaways.md`

Also inventory, rather than recreate:

- `docs/research/hand_drawn_graph_corpus_2026_06_29/`
- `docs/research/hand_drawn_graph_corpus_2026_06_30/`
- `docs/research/hand_drawn_graph_benchmark_2026_06_30/`
- `docs/research/hand_drawn_graph_batch_50_grading_test_2026_06_29/`
- `docs/research/hand_drawn_sample_grading_experiment_2026-06-29.md`
- `scripts/generate_hand_drawn_graph_corpus.py`
- `scripts/generate_hand_drawn_trace_sets.py`
- `scripts/vercel-gateway-check/hand_drawn_graph_benchmark_run 2.mjs`
- `scripts/drawn_response/`

The reconciled ledger controls phase status when older documents conflict.

## Recovered state that must not be lost

Treat these as prior results, subject to verification against the artifacts:

- The spatial architecture and three initial quantitative-graph archetypes are
  already specified.
- The reproducible v0.2 research seed contains 150 draw-ready Biology graph
  items, 50 per archetype.
- Synthetic/traced development images and benchmark scaffolding already exist.
- The historical all-positive trace-image benchmark reported 97.3%
  response-vector exact match and 99.48% criterion accuracy for its
  `VISION_FAST_ESC` arm at n=150, with p50 about 3.39 seconds and average cost
  about $0.0039.
- That result is a pipeline smoke test on an all-earned, non-independent trace
  set. It does **not** establish real-handwriting accuracy, false-accept
  behavior, safe abstention, cross-subject generalization, or launch readiness.
- A preliminary 23-image local sample reported 87.0% coarse agreement, but its
  visible labels were provisional and capture quality was entangled with graph
  correctness.
- A 50-image local trace smoke test found all 50 captures reviewable and all 50
  expected full-credit graphs complete. It is not independent gold.

Do not rerun the same synthetic all-positive benchmark merely to reproduce
those numbers. Use it only as a regression fixture. The missing evidence is
real, varied handwriting with independently adjudicated criterion labels.

## Non-negotiable architecture

Keep these records separate and versioned:

```text
capture_quality_result
visual_observation_result
criterion_decision_result
confidence_and_abstention_result
feedback_result
```

The image pipeline observes evidence. It does not directly award points.
Criterion decisions cite locked observation IDs and the applicable rubric
contract. Feedback cites locked criterion decisions. Model self-reported
confidence is diagnostic metadata, never a release control.

Use item- and archetype-specific contracts over subject prose. The reusable
observation vocabulary should cover, where applicable:

- representation type;
- x/y variable assignment;
- labels and units;
- tick and scale interpretability;
- category or series identity;
- plotted marks and values;
- uncertainty marks;
- lines, curves, bars, and point connections;
- intercept, plateau, equilibrium, or other relationship annotations;
- contradictions and multiple competing final graphs; and
- capture defects versus response defects.

Subject adapters may map these observations to different rubrics. They must not
change what the observation layer claims to see.

## Experimental and launch targets

Report all results against the controlling Phase D gates in
`TASK-0011_PHASE_1_EXECUTION_SPEC.md`, including:

- at least 95% criterion exact agreement overall and at least 90% for every
  criterion;
- at least 0.93 precision and recall per criterion and 0.95 macro averages;
- zero severe errors;
- at most 5% over-scoring and 5% under-scoring;
- at least 90% ambiguity/escalation recall;
- at most 10% false abstention on scorable responses;
- capture sensitivity/specificity and zero accepted captures with confirmed
  cutoff of point-bearing evidence.

Also report against the TASK-0016 product aspiration:

- end-to-end p50 at or below 1,000 ms, with p90, p95, p99, and max;
- cost at or below $0.01 per graded item;
- feedback grounding and minimum-fix correctness.

For spatial/photo work, segment latency into QR pairing, upload, validation,
preprocessing, observation, criterion decision, persistence, and render.
Quality comes first, then speed, then cost. A fast wrong spatial judgment is
not progress.

## Stage D0 — Recover and freeze actual state

Before implementation:

1. inventory every existing spatial corpus, image set, manifest, runner,
   report, schema, database object, storage bucket, route, and UI fixture;
2. identify duplicate files with `" 2"` suffixes and determine which copy is
   canonical without deleting user files;
3. verify prior report claims from raw result rows where available;
4. classify each artifact as:
   `REGRESSION_FIXTURE`, `DEVELOPMENT_ONLY`, `CALIBRATION_ELIGIBLE`,
   `HOLDOUT_ELIGIBLE`, `SHADOW_ELIGIBLE`, or `RETIRED`;
5. explicitly identify whether real handwritten captures, dual-human labels,
   provider-transfer approval, retention rules, and reviewer tooling exist;
6. reconcile AP Biology research assets with AP Statistics launch scope; and
7. freeze supported V1 graph archetypes at no more than three.

Create:

```text
docs/research/grading_phase_d_spatial_2026_07_27/
  CURRENT_STATE.md
  ARTIFACT_INVENTORY.json
  DECISIONS_AND_BLOCKERS.md
```

Do not infer that a file is gold because it contains a `gold`, `approved`, or
`expected` field. Record label provenance.

## Stage D1 — Freeze the spatial contracts

Create versioned, schema-validated contracts for:

- pairing and submission provenance;
- raw and derived image identity/checksums;
- capture-quality labels and disposition;
- visual observations;
- criterion decisions with cited observation IDs;
- calibrated abstention/retake/human-review signals;
- feedback; and
- experiment telemetry.

Preserve the label states and reason codes already defined in TASK-0011 unless
measured evidence requires a versioned amendment. Add cross-subject mappings
showing how the same spatial primitive applies to at least:

- Statistics quantitative graphs;
- Biology quantitative graphs;
- Chemistry titration/experimental graphs;
- Economics multi-curve/equilibrium graphs; and
- Physics diagrams or plotted relationships.

These mappings are extensibility evidence, not authorization to grade every
listed form in V1. Unsupported forms must abstain.

Create:

```text
SPATIAL_CONTRACT.md
schemas/*.json
CROSS_SUBJECT_MAPPING.md
```

Add schema tests, citation-integrity tests, and adversarial fixtures. A criterion
decision that cites a missing observation must fail closed.

## Stage D2 — Implement and verify the QR capture MVP

Implement the QR-handoff flow defined in TASK-0011 and the capture-experience
design:

1. primary device requests one submission slot;
2. server issues a short-lived, single-use, purpose-bound capability;
3. phone opens the capture page;
4. learner sees camera/privacy guidance and a non-QR fallback;
5. learner captures or selects an image, reviews, rotates/crops as a derivative,
   and explicitly submits;
6. server validates and stores the immutable original privately;
7. the primary device receives status updates;
8. quality disposition becomes `ACCEPT`, `RETAKE`, or `HUMAN_REVIEW`;
9. accepted research submissions enter the observation queue; and
10. expiration, cancellation, replay, and cleanup are tested.

Security requirements:

- no service-role credential in a client;
- capability contains no readable learner PII and cannot access other records;
- bind capability to user/session, item version, attempt, and submission slot;
- HTTPS, private storage, RLS/policy enforcement, signed short-lived retrieval;
- MIME/signature/decode, size, dimension, and page-count validation;
- EXIF/metadata stripping on derived/downstream images while retaining
  controlled audit provenance;
- incidental-identifier handling;
- malware/malformed-image failure behavior;
- replay prevention, rate limiting, audit trail, retention, and deletion;
- no public bucket and no model-training use without separate approval.

Test cross-device binding, expiry, reuse, wrong-user access, wrong-slot access,
cutoff, blur, glare, perspective, malformed files, oversized files, and cleanup.
Preserve raw uploads; derived images never overwrite them.

Build locally or in an approved isolated environment first. Do not deploy to
Production or create Production test data without explicit approval in the
execution task. If an approved Production shadow test is later run, use one
isolated test identity, tag every row/object, and verify cleanup with before/after
queries and storage listing.

Create:

```text
QR_MVP_IMPLEMENTATION.md
SECURITY_PRIVACY_ACCESSIBILITY_REVIEW.md
QR_MVP_TEST_RESULTS.md
```

## Stage D3 — Assemble real handwritten evidence and lock gold

Do not generate more synthetic breadth. Use the existing seed and authoring
work to select a small rights-clean, Learning-Quality-approved set.

For every eligible underlying response:

- collect at least two raw phone captures under declared capture conditions;
- keep all captures and derived variants from the same response in one
  partition;
- record writer, item, consent/provenance, instrument, device/capture condition,
  and checksum without reviewer PII in result files;
- include correct, partial, incorrect, contradictory, ambiguous, ungradeable,
  and unsupported cases;
- blind observation and criterion reviewers to all model output;
- obtain two independent qualified labels;
- adjudicate every disagreement with a lead reviewer;
- version rubric repairs and relabel affected cases; and
- partition by underlying response/writer before any model sees the holdout.

Claude must not impersonate two independent human reviewers or silently convert
AI/provisional labels into gold. If the captures or reviewers are unavailable,
prepare the exact collection packets, annotation interface/files, assignments,
and adjudication checklist, record the gate as blocked, and continue only on
work that does not contaminate future evaluation.

Use the release-grade corpus target in TASK-0011: 300 eligible underlying
responses, including 100 per archetype, with 90 development, 60 calibration,
120 locked holdout, and 30 challenge responses. The first paid gate below uses
a smaller subset to validate the machinery; it does not waive the release
corpus requirement.

Create:

```text
REAL_CAPTURE_PROTOCOL.md
PARTITION_MANIFEST.json
annotations/blind_A.jsonl
annotations/blind_B.jsonl
annotations/adjudicated.jsonl
LABEL_AUDIT.md
```

Keep the locked holdout inaccessible to prompt/pipeline development.

## Stage D4 — Run the observation bake-off in gates

Compare the same frozen inputs across:

1. direct multimodal criterion grading, retained as a challenger/control;
2. multimodal observation followed by separate criterion grading;
3. deterministic geometry/OCR followed by separate criterion grading; and
4. hybrid observation reconciliation followed by separate criterion grading.

Freeze model/provider IDs, prompts, schemas, preprocessing path, token limits,
timeouts, retries, concurrency, pricing, and hashes before viewing output.
Evaluate immutable original, lossless orientation/crop, and document-normalized
variants. Treat task-specific enhancement as a separate arm and detect erased
thin marks, pencil lines, error bars, dashed lines, and labels.

### D4a — No-cost regression

Run schema, scorer, deterministic, and historical regression fixtures first.
Do not count these results as real-handwriting validation.

### D4b — Small paid confirmation

Once at least 12 real underlying responses—four per archetype—have locked
dual-human labels, run all four arms on that paired slice. Include positive,
negative, ambiguous, and capture-defect cases.

Before the first call:

- confirm external-provider transfer, retention, training-use, and deletion
  approval in a repository record;
- print model, sample IDs, call count, projected cost, and hard stop;
- cap this gate at **$2.00 total** unless the Product Owner explicitly approves
  more; and
- validate one call and one scored row before launching the rest.

Stop and repair rather than scale if:

- schema validity is below 100%;
- observation IDs/evidence citations are missing;
- any severe or silently confident error occurs;
- a method cannot distinguish capture failure from graph failure;
- preprocessing alters point-bearing evidence; or
- projected cost exceeds the cap.

### D4c — Calibration expansion

Only after D4b's error audit is complete, run the 60-response calibration
partition. Use it to choose criterion/archetype-specific reconciliation and
abstention thresholds. Do not tune on the locked holdout. Before calling any
paid provider, write the projected call count and cost and obtain explicit
Product Owner approval for that stage's hard cost cap.

### D4d — One-time locked holdout

Open the 120-response holdout once, after prompts, preprocessing, method
selection, and thresholds are frozen. If the holdout fails, report the failure;
do not tune and re-label it as a fresh holdout. This is a separate paid gate:
record the projected call count/cost and obtain explicit Product Owner approval
for its hard cap before opening the partition.

Store append-only raw results and resumable state. Never overwrite a prior run.

Create:

```text
FROZEN_EXPERIMENT_SPEC.md
FROZEN_RUN_MANIFEST.json
runs/<run_id>/raw_results.jsonl
runs/<run_id>/score_summary.json
runs/<run_id>/error_audit.md
BAKEOFF_RESULTS.md
```

## Stage D5 — Calibrate abstention

Build thresholds from observed calibration errors, not model confidence.
Candidate signals include:

- capture-quality measures;
- observation completeness;
- OCR/geometry/multimodal disagreement;
- criterion- and archetype-specific historical error;
- preprocessing sensitivity;
- unsupported representation/OOD detection; and
- conflicting or multiple final answers.

Report coverage-versus-error curves overall and by criterion/archetype. Include
false abstention on scorable work, failure to escalate ambiguous work,
over-scoring, under-scoring, and severe-error counts.

The system must withhold the total whenever any point-bearing criterion
abstains. A new photo should be requested only for fixable capture defects;
otherwise route to human review.

Create:

```text
ABSTENTION_CALIBRATION.md
abstention_thresholds.json
```

## Stage D6 — Run 100%-human-reviewed shadow operation

Enter shadow only if the locked offline gate supports it and required human
approvals are recorded.

During shadow:

- automated spatial output is non-authoritative and hidden from learners;
- every response receives qualified human review;
- reviewer sees the original evidence and item/rubric version;
- log agreement, overrides, silent errors, abstentions, retakes, capture
  failures, reviewer minutes, latency, cost, and feedback grounding;
- prevent automated results from updating mastery or other learner state; and
- provide complete deletion/retention and incident handling.

Use isolated test identities for any pre-shadow Production verification and
clean them up. Do not clean up legitimate consented shadow evidence unless its
retention policy requires it.

Create:

```text
SHADOW_PROTOCOL.md
SHADOW_RESULTS.md
PRODUCTION_TEST_AND_CLEANUP_LOG.md
```

## Stage D7 — Decision packet and durable status update

Create `DECISION_PACKET.md` with:

- exact completed scope and unresolved gates;
- evidence tier of every reported result;
- best method by criterion and archetype;
- capture and preprocessing failure modes;
- criterion agreement, precision/recall, score metrics, severe errors;
- abstention coverage/error tradeoff;
- end-to-end and per-stage latency percentiles;
- cost per attempted, accepted, and human-reviewed result;
- reviewer burden and usability/accessibility findings;
- cross-subject portability findings;
- security/privacy/retention status;
- classification of every criterion as
  `AUTOMATION_CANDIDATE`, `HUMAN_REVIEW_REQUIRED`, `UNSUPPORTED`, or
  `MORE_EVIDENCE_REQUIRED`; and
- a `PROCEED`, `REVISE`, `NARROW`, or `STOP` recommendation.

Update:

- `docs/GRADING_PROGRAM.md`;
- `docs/research/GRADING_PROGRAM_LEDGER_2026_07_27.md`;
- `docs/tasks/TASK-0011-HANDWRITTEN-GRAPH-CAPTURE.md`; and
- `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md`.

Record actual phase state precisely. “QR prototype complete,” “small paid gate
complete,” “offline holdout passed,” and “shadow complete” are different states.
Do not collapse them into “Phase D complete.”

## Required execution log

Maintain:

`docs/research/grading_phase_d_spatial_2026_07_27/EXECUTION_LOG.md`

For every material action, record:

- UTC timestamp;
- command or operation;
- input manifest/hash;
- environment;
- output path;
- result;
- model/provider and cost when applicable;
- approval dependency;
- cleanup action; and
- whether the step changed the evidence tier.

Never log secrets, access tokens, signed URLs, raw learner identifiers, or
reviewer PII.

## Stop conditions

Stop the affected stage and document the blocker if:

- required human labels, consent, rights, provider-transfer approval, or
  accessibility/security approval are absent;
- the corpus cannot be partitioned without leakage;
- a paid run would use provisional or AI-authored truth;
- a severe or silently confident error appears;
- preprocessing alters point-bearing evidence;
- safe coverage is impractically low;
- capture or human-review burden removes the product benefit;
- a Production mutation or deployment lacks explicit authorization; or
- cleanup cannot be fully verified.

Continue other safe in-scope work when one stage is blocked. Do not fabricate
completion.

## Final response

Return a concise execution summary containing:

1. current Phase D state;
2. what was implemented and verified;
3. sample sizes and evidence tiers;
4. quality, latency, cost, abstention, and reviewer-burden results;
5. paid spend;
6. Production mutations and cleanup status;
7. blockers requiring humans or the Product Owner;
8. recommendation and exact next gate; and
9. links to `DECISION_PACKET.md`, `BAKEOFF_RESULTS.md`,
   `ABSTENTION_CALIBRATION.md`, `SHADOW_RESULTS.md`, and `EXECUTION_LOG.md`.

Do not report success from aggregate accuracy alone. The task is complete only
when the evidence, safety controls, extensibility record, and shadow outcome
support the claim.
