# Course Mode — Learning Model Reference

STATUS: canonical decision capture | DATE: 2026-08-22 | VERSION: v0.2 (revised per Fable review 2026-08-22)
AUDIENCE: LLM-first. Optimized for machine consumption: self-contained statements, explicit status tags, stable IDs, minimal narrative. A human can read it; an LLM should be able to act on it without re-deriving anything.

CHANGELOG v0.2: corrected the AP Stats procedure toolkit to the 2026-27 CED (removed content struck); cell seeding is per-Learning-Objective (~130 CED-anchored cells), not one-per-topic; corpus is 330 items not 380; added current-state facts that generated-instance→DB plumbing (taxonomy tags, deterministic checks, skill/cell tags, per-instance review/serving gates) does not exist today; misconceptions are CED prose, not structured lists.

## 0. How to use this document

- Every design commitment is a numbered decision `CM-Dxx` with STATUS ∈ {DECIDED, OPEN, DEFERRED, PROPOSED}. PROPOSED = recommended resolution awaiting David's sign-off.
- Terms are defined once in §2 (Glossary) and used verbatim thereafter.
- §3 (Invariants) lists rules that MUST hold in any implementation. Do not violate them without a new DECIDED decision that supersedes them.
- Facts about the current codebase are in §9 and are tagged `[verified 2026-08-22]`. Re-verify before relying on them; code changes.
- EXECUTION STATUS (2026-08-23): F1 registry + the 4-table Dev↔Prod schema convergence are applied and verified; the computational generator + one 4.B slot-frame are built and Fable-QA'd (GO). scipy is APPROVED as an authoring dependency (t/χ² procedures not yet built). The student experience, the F2/F3 learner-state runtime, and the F4 servable-content path are NOT built. For the live map and the next workstreams (UX + content), read `COURSE_MODE_STATUS_AND_HANDOFF.md` first.
- This document governs the *course-mode* evolution of the learning system. It EXTENDS, and where noted supersedes, the three prior drafts (`LEARNING_SYSTEM.md`, `LEARNING_SYSTEM_STUCK.md`, `TEACHING_AND_PEDAGOGY_DESIGN.md`). Those remain authoritative for the cram-horizon loop, grading pipeline, student-supplied questions, and data posture.

## 1. Premise and reframe

CM-D01 — Target user shift. STATUS: DECIDED.
The target user shifts from "student ~10 days before an AP exam" (cram) to "motivated, time-scarce student maximizing points *throughout the course*." These students chase grades and 5s, take hard classes plus sports, and are defined by scarcity of study time. Efficiency is their core value. Personas: Micah (not highly ambitious, wants efficient results) and Orly (ambitious, wants to lock in her grades). Both are served by the same engine at different intensity.

CM-D02 — One engine, two horizon settings. STATUS: DECIDED.
Course mode and the existing cram product are ONE engine, not two. Cram = the compressed final phase of the year-long system (clock collapsed, efficiency constraint maxed). Build by EXTENDING the existing product ("efficient prep") with year-long "efficient learn"; do not build a second parallel product.

CM-D03 — Points vs. teaching tension is resolved by horizon. STATUS: DECIDED (framing).
Short-horizon (single quiz) point-maximization can favor shallow cramming; long-horizon (whole course + AP exam) point-maximization favors durable learning, because assessments spiral (teacher tests derive from the same College Board CED; later units and the May exam re-test earlier material). Evidence: students who space study earn higher course grades; cramming correlates with lower GPA. Therefore deep teaching IS the efficient point-maximizing strategy at the course horizon. The residual problem is BEHAVIORAL, not analytical: the fluency illusion (cramming feels effective) and future-discounting. The product's job is to make the long-horizon-optimal path feel rewarding now and to show the student their own evidence.

CM-D04 — Brand frame: "lock in learning," defended against decay. STATUS: DECIDED (framing).
Promise = lock in *learning* (the controllable part of the grade), NOT grades directly. Lock-in is a fortress the student maintains against knowledge decay (loss-aversion framing: "don't leak a point you already earned"), NOT a one-time badge. The recurring reason to open the app is that locks slip.

## 2. Glossary (definitions used verbatim elsewhere)

- **Cell** — the atomic unit of mastery = (topic × skill). See CM-D05.
- **Topic** — a CED teachable segment, coded `unit.topic` (e.g. `1.7`).
- **Skill** — a lettered CED sub-skill under a practice (e.g. `4.B`). The finest diagnostic atom.
- **Practice** — a numbered CED science/statistical practice (e.g. Practice 4). A roll-up parent of skills.
- **Learning Objective (LO)** — a CED content statement; the CED anchors a specific skill to each LO. LO→skill pairings aggregate up to (topic × skill) cells.
- **CED-anchored pairing** — the CED's per-LO (LO → skill) anchoring. It is a *teaching scaffold suggestion*, not a constraint: the exam may pair any content with any skill. Used as the seed matrix for cells (CM-D05).
- **Tier** — the discrete proficiency state of a cell. See CM-D06.
- **Weighted evidence** — accumulated success/failure signal for a cell, weighted by how informative each attempt was. See CM-D07.
- **Staleness / decay** — the freshness of a cell's last independent success, decaying over time at a tier-dependent rate. See CM-D08.
- **Trigger** — an event or schedule condition that marks a cell due for retrieval. See CM-D10.
- **Due-queue** — the single priority queue of cells due for retrieval; one row per cell with `next_due_at` + `reason`. See CM-D11.
- **Procedure library** — the reusable set of parametrized computational routines used to generate quantitative items. See CM-D15.
- **Slot-frame** — an authored conceptual-item template with validated slot pools. See CM-D16.

## 3. Invariants (MUST hold)

- INV-1 — Store fine, present coarse. Mastery is stored at skill grain (cell = topic × skill). It is presented to students and used in recommendations at practice/topic roll-up grain. Never surface letter codes (e.g. "4.B") to students.
- INV-2 — Threading never pools evidence. A thread (same skill in a different topic, or a prerequisite relation) may RESURFACE a related cell for a check, but must never transfer proficiency evidence between cells. Only a cell's own attempts update its tier.
- INV-3 — Correctness must be independently checkable. Content generalizes only as far as its correctness can be independently verified (computation: recompute; conceptual: authored keys/rubrics). General LLM item generation (question + claimed answer with no independent check) is PROHIBITED. See CM-D14. NOTE: honoring INV-3 in practice requires a persisted per-instance check + a data-driven verifier at grading time — which does not exist today (CM-FACT-20); building it is a plan prerequisite.
- INV-4 — Determinism over judgment for state transitions. Tier transitions, due-time computation, AND evidence-weight classification are deterministic rules over attempt history + time, exhaustively unit-testable. No model inference decides a tier or a weight.
- INV-5 — Supported success is provisional. A success achieved with answer-bearing help does not equal mastery; it requires a later cold, independent, changed-surface retry to advance the tier.
- INV-6 — Honest uncertainty. A later failure reopens a cell's estimate (marks fragile) without erasing prior observations. No cell is reset to zero by one miss.

## 4. Mastery model

CM-D05 — Mastery unit = cell = (topic × skill); practice is a roll-up parent. STATUS: DECIDED.
Rationale: the same topic hosts different skills (e.g. compute a statistic vs. justify a claim) that must be diagnosed separately; a broad practice (e.g. AP Chemistry Practice 2 = 6 skills) is too coarse to repair against. The cell is simultaneously the mastery unit, diagnosis unit, decay unit, and thread node. The CED validates this grain: "every exam question is aligned to a learning objective and a skill" = (content × skill). This equals the "assessable skill target" specified but never built in the prior docs.
Coverage rule (corrected v0.2): seed cells from the CED's per-skill anchoring — for AP Stats this is the topic × skill table in `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md` §3 (55 topics, ~131 unique (topic × skill) cells — U1:28, U2:21, U3:42, U4:30, U5:10 — 1–4 skills per topic). This supersedes the earlier "one-cell-per-topic spine," which undercounted the seed matrix ~2.4×. Expand toward the any-content × any-skill matrix as exam-realistic items are authored. Supersedes the interim "topic × practice" framing considered earlier the same day.
Roll-up hierarchy: skill → practice → subject; and topic → unit → subject.
Versioning: a cell's identity is scoped to a `taxonomy_source_version` (CED revisions change topic/skill codes; legacy content uses older namespaces — see CM-FACT-20).

CM-D06 — Proficiency is a discrete tier, not a percentage. STATUS: DECIDED.
Tier ladder (ordered):
1. `unseen` — no exposure recorded.
2. `exposed_unverified` — student has encountered the material (e.g. class taught it), Cramapple has not yet verified it. Course-mode-specific; the default state after a new class lesson.
3. `supported` — correct only with answer-bearing help (hints, worked example, decomposition, visible rubric cues). Provisional (INV-5).
4. `independent` — correct on a fresh, structurally-related item with a changed surface and no answer-bearing help. Provisional progress.
5. `confirmed` — independent success again after a delay and preferably a changed surface. Strong evidence of retained, transferable performance.
A cell also carries a `fragile` flag (set when a prior success later fails; INV-6).

CM-D07 — Evidence strength is weighted by attempt informativeness. STATUS: DECIDED. Constants: OPEN (tunable).
Reuse the prior failure/success weighting: independent varied attempt after delay = 1.00; independent varied same-session = 0.65; same/near-identical item = 0.35; heavily assisted/off-task = 0.00; content/grading uncertainty = 0.00 (route to `content_uncertain`). Cells accumulate weighted evidence, not raw counts. Classifying an attempt's weight requires prior-attempt history per cell, item/template+params identity (to judge "changed surface"), session identity, and assistance state; this classifier is itself a deterministic component (INV-4) and must be specced alongside the tier rule table (CM-D13).

CM-D08 — Staleness decays; decay rate depends on tier. STATUS: DECIDED. Constants: OPEN (tunable).
Each cell stores `last_independent_success_at`. Freshness decays over time. Decay rate is tier-dependent: `supported` decays fast, `independent` medium, `confirmed` slow. When freshness crosses a threshold the cell becomes a decay trigger (CM-D10). Intervals stretch to the course horizon (weeks/months) and compress as the exam nears; reuse the schedule-aware formula shape from the prior docs, re-horizoned. Constants are tunable, not correctness-critical.

CM-D09 — Derived priority scalar. STATUS: DECIDED (shape). Formula: OPEN.
The next-best-action engine sorts due cells by a single derived scalar ≈ (exam value × current deficit × improvability × staleness) ÷ time cost. The discrete tier is retained for honesty and repair routing; the scalar is derived from cell state for ranking only.

## 5. Resurfacing / trigger model

CM-D10 — Two trigger families; five Phase-1 trigger types. STATUS: DECIDED (model). Phase split: DECIDED.
Family A — scheduled (decay-driven): freshness < threshold → due (CM-D08). `next_due_at` is dynamic per tier × exam-proximity × exam-value; not a fixed N.
Family B — event-driven. "Failure" is three distinct things and each is handled differently:
- Direct miss (this cell's own topic × skill): mark `fragile`, reopen estimate, re-enter active queue. Does NOT reset the tier (INV-6).
- Prerequisite miss (a cell this one depends on; vertical edge): discount confidence in dependents, flag for re-check; do not silently downgrade the demonstrated skill; the re-check's outcome moves the tier. DEFERRED to Phase 2 (needs graph).
- Thread-sibling miss (same skill, different topic; lateral edge): RESURFACE the sibling for a check only; never downgrade it (INV-2). The re-check's own outcome updates it. DEFERRED to Phase 2 (needs graph).
Plus two non-failure resurfacing triggers:
- Provisional-success confirm: a `supported` success self-schedules a short-interval cold re-test to attempt advancement to `independent`.
- New-exposure consolidation: when `student_course_positions` advances, the new unit's cells flip to `exposed_unverified` and enter the consolidation queue.

CM-D11 — One queue, five writers. STATUS: DECIDED.
All triggers reduce to one operation: stamp a cell with `next_due_at` + `reason`. The system is ONE per-cell due-queue plus ONE selection query ("cells due now, ordered by priority scalar"). Triggers are just code paths that write a due-time. Apparent complexity = five writers, not five subsystems.

CM-D12 — Phase 1 scope (no graph). STATUS: DECIDED.
Phase 1 triggers: decay clock + direct miss + provisional-success confirm + new-exposure consolidation. These need only the cell's own state + the class-position hook. Reliable, well-trodden (spaced retrieval + consolidation), and most of the value.
Phase 2 (DEFERRED): prerequisite miss + thread-sibling miss. These require CED-extracted vertical/lateral edges (the "principle graph"), which do not exist in the data yet. Deferral is SAFE: a missing edge only means a cell isn't resurfaced early by a relative; its own decay clock and direct misses still catch it. The thread-sibling trigger's safe fallback (do nothing across the thread) is exactly INV-2.

CM-D13 — Reliability model. STATUS: DECIDED.
Reliability = (a) collapse to one queue (CM-D11); (b) a deterministic evidence-weight classifier + tier-transition rule table `(current tier, event, evidence weight) → (new tier, next_due_at, reason)`, exhaustively unit-testable (INV-4); (c) stage the graph triggers (CM-D12). Constants (weights, intervals, thresholds) are tunable and instrument-driven, NOT correctness-critical — ship bounded, explainable defaults and calibrate on outcomes.

## 6. Content supply model

CM-D14 — Verifiable coverage, not "unlimited"; no general LLM generation. STATUS: DECIDED.
The goal is a *verifiable generator for every cell* with enough fresh valid instances to beat memorization and feed spaced retrieval (order of dozens per cell over a year), NOT infinite volume. Content generalizes exactly as far as correctness is independently checkable (INV-3). General LLM generation is rejected.

CM-D15 — Computational generator = procedure library × scenario layer × question-form layer. STATUS: DECIDED. Toolkit corrected v0.2.
Quantitative content is generated by composing three layers:
- Procedure library: the closed toolkit of statistical routines VALID FOR THE 2026-27 CED (~10–12 for AP Stats: z procedures for PROPORTIONS and t procedures for MEANS — CED convention is z-for-proportions, t-for-means; χ² tests for **independence/homogeneity only**; CI / significance-test / p-value machinery; sampling distributions; normal-distribution and probability calculations; descriptive regression — r, slope, intercept are computed BY TECHNOLOGY per the CED, so generate predict/residual/interpret tasks, not hand-computed r). Each procedure is a deterministic function: `params → (stimulus, question, correct answer, worked solution, deterministic_checks)`.
  EXCLUDED — removed from the 2026-27 CED per `AP_STATISTICS_2027_CED_FACT_PACK.md` §8; do NOT author: χ² goodness-of-fit; inference for slopes / regression inference (entire old Unit 9 — 2026-27 regression is DESCRIPTIVE only); geometric distribution; combining random variables; departures-from-linearity framing (residual analysis itself is retained as Topic 5.4).
- Scenario layer: curated, realistic context banks per procedure (prevents nonsense contexts).
- Question-form layer: MCQ, numeric-entry, short-response forms.
Validation moves from item to template: validate a procedure once (human review + property tests over the parameter space), then trust every instance by construction. Distractors are generated by misconception transforms (e.g. n vs n−1, z vs t, one-tail vs two-tail, random selection vs random assignment), so each MCQ is also a diagnostic probe; misconception sources are the CED's per-unit "Preparing for the AP Exam" prose (must be manually extracted — not structured lists).
Hard part (real authoring work): per-procedure PARAMETER GUARDRAILS ensuring every instance is statistically valid (e.g. expected counts ≥ 5 for χ², sufficient n for normal approximation, clean-or-intentionally-messy numbers, sensible rounding) via constraint/rejection sampling. "Conditions deliberately violated" is itself a generatable item type for check-conditions skills (covers much of Stats skill 4.E).

CM-D16 — Conceptual generator = authored slot-frames (bounded, validated). STATUS: DECIDED.
Conceptual skills (not number-parametrizable) are generated from authored frames with validated slot pools (swap context / variable / injected flaw). Correctness is guaranteed by validated slot-pairings, not by generation. Instances generalize within a frame; FRAMES STAY AUTHORED and validated. Misconception-taxonomy MCQs (correct answer + distractors both rule-determined from a taxonomy) are a preferred conceptual form because they remain checkable.

CM-D17 — Generator validation reuses the gold-set machinery. STATUS: DECIDED (approach). Details: OPEN.
A template/frame is trusted via: human review of the template + a sample of instances; property-based tests over the parameter/slot space; regression against the existing Stats gold-set/calibration corpus. CAVEAT: the Stats gold corpus is old-namespace (module-keyed) — valid for grader-BEHAVIOR regression, NOT for coverage claims against 2026-27 cells. Generated items enter the same review/release gates as authored content — but see CM-D19/CM-FACT-20: those gates today require per-instance human validation, so a template-level release mechanism is a prerequisite.

CM-D19 — Template-level release mechanism. STATUS: APPROVED 2026-08-23 (David); the sampled spot-audit mitigation is adopted.
For generated content to be servable at all, an approved *template* must be able to machine-stamp its *instances'* review status and serving/cell labels, rather than requiring a human on every instance. Proposed: human approves the template + a validation sample (CM-D17); the pipeline then machine-stamps each conforming instance as review-approved and serving-labeled, recording the template id + params as provenance. This CHANGES the current review invariant (per-instance human approval; today no MCQ can even reach approved status via code — CM-FACT-20). Final approval is David's; recorded here so it can be reviewed, not to pre-empt it.

## 7. Grounded dynamic content (cross-cutting)

CM-D20 — Homework Mode inherits INV-3/CM-D14 as a mission law, not a feature
guardrail. STATUS: DECIDED (David, 2026-08-28).
Homework Mode (a student brings an outside question via free text, photo, or
uploaded worksheet and asks for help) must remain true to Cramapple's mission —
helping students earn the most points from the time they have. What Cramapple
teaches, and how it responds, must rely on principles already codified and
content already created, or a version of that content parametrized to the
specifics of the student's session — never freelanced pedagogy, explanations, or
worked reasoning at response time. Concretely: a "version of it" means a new
parametrized instance of an existing validated template (CM-D15/CM-D16), exactly
as the generator already does for Course Mode — not an LLM composing a new
explanation live. The model's only live-generated role is routing, classifying,
and confirming. This is INV-3/CM-D14 applied to a conversational surface, not a
new rule; it does not relax for Homework Mode because the input is
unstructured/outside-content. Unlike CM-D01–D19, this decision is NOT scoped to
the AP Statistics pilot — it applies to Homework Mode across every subject,
since coverage (not the rule) is what varies by subject. Full design record:
`docs/teaching/HOMEWORK_MODE_DESIGN_2026_08_28.md`.

CM-D21 — Grounded dynamic content is the general form of CM-D20; FRQ grading
already implements it. STATUS: DECIDED (recognized, not newly invented —
2026-08-28).
CM-D20's rule is not Homework-Mode-specific — it is the general shape every
AI-generated response must take, anywhere in the product. Two kinds of content,
held to different standards:
- STRUCTURAL/GRADED content (an item, an answer key, a rubric, a criterion set,
  a correctness verdict) stays fully scripted — sourced from an already-vetted
  template, rubric, or check (CM-D14/INV-3). Never generated live.
- DYNAMIC content (elaboration, evidence citation, a synthesized summary, a
  targeted correction) MAY be generated live, but only when every substantive
  claim is GROUNDED: traceable to real, cited evidence, never asserting a new
  fact, a new criterion, or a verdict the evidence doesn't support.

FRQ grading already implements exactly this, and is the reference pattern —
not to be reinvented for Homework Mode or any future surface. In
`supabase/functions/_shared/grading-feedback.ts` (`sanitizeModelResult`,
confirmed wired into both grading paths in
`supabase/functions/evaluate-attempt/index.ts` with a real
`{responseText, responseParts}` context, not a flag left disabled), three
server-side checks run on every model output, independent of what the model
claims about itself:
1. `earned_without_evidence` — a criterion claiming credit with no cited
   evidence is forced to `unable_to_determine`, 0 points.
2. `evidence_not_found` — a cited quote is checked against the actual response
   text via `evidenceIsGrounded` (unicode/whitespace-normalized, elision-aware
   fuzzy match, tuned against a 2,973-output corpus to cut false-positive
   rejections from ~10% to ~3.7% while still catching fabricated quotes); an
   ungrounded quote gets the same forced downgrade.
3. `earned_points_mismatch` — credit claimed with real evidence still fails if
   points and status are internally inconsistent.
"Do not invent evidence" also appears in the prompt (`buildCriterionSystemPrompt`
/ `buildSystemPrompt`) — but the prompt is a courtesy, not the enforcement; the
post-hoc deterministic sanitizer is. This is INV-4 (determinism over judgment)
applied to a grounding decision, not just a tier transition.
Note vs. `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md` (UX-006) §6.3: the
spec describes a separate "decision gate" field (`pass`/`fail`/
`unable_to_determine`); no such field exists in code — it is folded directly
into the `status` enum. Functionally equivalent; a naming drift, not a gap.

The boundary on WHICH content a dynamic response may touch is
CONTEXT-DEPENDENT, not universal — this is a stated exception to CM-D20's
framing, not a contradiction of it:
- Pre-independent-demonstration (Homework Mode's teaching phase, before the cold
  prove-it attempt): dynamic content must NEVER engage with the student's own
  stated problem's specific content — absolute (§5 of
  `HOMEWORK_MODE_DESIGN_2026_08_28.md`).
- Post-independent-attempt feedback (FRQ grading now; Check My Work once it is
  genuinely built): direct engagement with the student's own specific response
  is not just permitted, it is the job — an FRQ's minimum-fix is supposed to
  quote and repair the student's own sentence. The rule was never "never touch
  their own work"; it is "never do their independent thinking for them before
  they've done it themselves."

Practical consequence — the gap this generalization exposes for MCQ: the Graded
Feedback design (`GradedFeedback.dc.html` in the Homework Mode canvas) assumes
the misconception catalog stores authored, per-distractor feedback text (a
"Missing Concept" explanation, a "Next Fix" rule) that can be looked up, not
generated. Whether that text exists in the catalog today is UNVERIFIED. The
FRQ pattern argues for building this as a grounded lookup keyed to the picked
distractor's tagged misconception, not a fresh composition per attempt —
matching how the "why" line is already specified to source from the topic's
stored "common point loss" field rather than being invented.

## 8. Pilot scope and the Stats reality check

CM-D18 — Pilot = AP Statistics, supply-engine first. STATUS: DECIDED.
Build ONE subject first, extend with confidence. Subject = AP Statistics. First build = the content supply engine (generator), NOT the loop/experience, because per-cell retrieval-item inventory is the binding constraint. Stats chosen for best-reviewed teaching content (topic guides at 100%), deepest gold-set/calibration research, and full parametrizability — accepting that step 1 is generating items from near-scratch on that strong validation substrate.

CM-FACT-19 — Stats computation is the minority of the subject. STATUS: DECIDED (reality check). `[verified 2026-08-22 from ap-statistics CED]`.
AP Stats = 4 practices, 18 skills: Practice 1 Formulate (1 skill: 1.A), Practice 2 Collect Data (5: 2.A–2.E), Practice 3 Analyze Data (5: 3.A–3.E), Practice 4 Interpret Results (7: 4.A–4.G). Cleanly-computational skills ≈ 4–5 of 18 (~a quarter; ~4 if 3.A "construct representations" is treated as partly conceptual). The plurality — Practice 4 interpretation/justification, 7/18 — is conceptual and is where AP Stats points are most differentiated. Consequence: the computational generator (near-unlimited, reliable) covers the minority; authored slot-frames carry the majority. The pilot's real risk is whether slot-frames can cover Practice 4 at quality and volume — that is the load-bearing, unproven engine.

## 9. Current-state facts (existing codebase) `[verified 2026-08-22]`

- Learner state EXISTS and is live (schema `app.*`; a legacy `public.*` schema is unused by edge functions). Mastery is persisted at SUBJECT grain only: `app.student_memory_snapshots.memory_state jsonb` keyed by `subject_id` — a flat blob (last result, `latest_gap_criteria` = item-local criterion keys, preferred help style). It is a session/coaching memory, NOT a proficiency map. → must be re-founded at cell grain.
- Post-grade write path (`_shared/grading-memory.ts` `persistGradingMemory`; `_shared/student-memory.ts`) returns EARLY when `sessionId` is null and is not passed `content_item_version_id`; three call sites (`evaluate-attempt/index.ts:1142,1644`; `attempt-response/index.ts:997`). Cell writes must route on attempt/item identity, NOT session presence, or manual/sessionless grades silently skip cell updates.
- Attempts key to an item version (`app.attempts.content_item_version_id`); grading keys to rubric `criterion_key` (item-local, e.g. `part-a-criterion-1`) via `app.attempt_criterion_results` / `app.grading_results`. Fine-grained evidence flows through the pipeline; only the persisted mastery layer is coarse.
- CM-FACT-20 — Generated-instance → DB plumbing DOES NOT EXIST today (the plan must build it):
  - `taxonomy_refs` and `deterministic_checks` live in item-package JSON but are DROPPED at DB load (load SQL inserts `app.frq_criteria` without a checks column; `grep taxonomy_refs supabase/` returns nothing).
  - Production Stats deterministic grading is a HARDCODED per-`content_key` TypeScript map (`_shared/statistics-verifier.ts`), which cannot scale to generated instances. `evaluator_strategy` allowlist = `rule_based_mcq | llm_discrete_text | python_symbolic_ecf | human_shadow` — a generic data-driven verifier is a new strategy to add.
  - There is NO skill/cell tag anywhere in the DB. `app.content_taxonomy_labels` carries units (serving scope) and topics (coverage scope) only, and a scope constraint forbids mixing; no skills. An item→cell mapping must be created (new label scope `cell` or a `content_item_cells` table).
  - Publishing requires `review_status='question_review_approved'` per content_item_version; unit-gated serving requires a human-`validated` serving label per item; the publish-gate migration notes NO MCQ can currently reach approved status via code. → a template-level release mechanism (CM-D19) is required.
- Content items (`content/item-packages/`, **330 files**, 8 subjects: calc AB/BC, chem, physics 1/2/C-EM/C-mech, precalc — no stats/bio IN THE REPO FILES) are tagged via `taxonomy_refs[]` with: unit (all), topic (math subjects only), numbered practice (all). ALL 330 items are single-practice (0 multi-practice). No lettered skills/LOs/EK/big ideas captured in structured fields. `app.taxonomy_topics.topic_code` CHECK `^[0-9]+\.[0-9]+$` forbids letter codes (skills live in a NEW column/table, not `topic_code`).
- Legacy Stats content EXISTS in the DB (repo-files "no stats" is misleading): 90+ APSTAT/APSTATS/STATS items, some published, plus a live Home release manifest for units 1–5, using older/module namespaces (`APSTAT-MOD3-…`). The AP Statistics `app.taxonomy_topics` registry is ALREADY seeded (55 topics; `20260821090000_ap_statistics_taxonomy_topics_seed.sql`). Cells must be scoped to a taxonomy version; legacy items likely excluded from cells (explicit decision needed).
- Item inventory is cram-sized, not retrieval-sized: median ~1 item/topic (calc AB: 34 topics, median 1, max 3). Cells (topic × skill ⊆ topic) therefore have ~1 or 0 items each. Spaced retrieval is impossible at current inventory → generators required.
- Item-package schema fields: `parts[].criteria[]` carry `description`, `points`, `required_evidence`, `accepted_variants`, `minimum_fix`, `deterministic_checks`. Criteria carry NO practice/skill tag (attribution to skill needed only for future multi-skill integrative items; not the pilot).
- `assessable_skill_target` is referenced (`app.authoring_briefs.assessable_skill_target_ids uuid[]`; a deprecated `'skill'` label type) but has NO backing table.
- `app.student_course_positions(unit_id, source ∈ {confirmed, estimated, unknown})` EXISTS — the "borrow the class calendar" hook for CM-D10 new-exposure and CM-D04 horizon.
- Subject-key namespace gotcha: `app.subjects.subject_key` uses hyphens (`ap-calculus-ab`); `taxonomy_source_versions` / `topic_point_briefs` / `exam_packs.exam_code` use underscores (`ap_statistics`). Join by UUID (`subject_id`, `taxonomy_source_version`), never raw subject_key text, or RLS/joins match 0 rows.
- Official CED PDFs are in-repo at `docs/teaching/ap-*-course-and-exam-description.pdf`; per-topic skill anchoring for Stats is pre-extracted in `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md` §3 (SME sign-off deferred — see CM-D18 pilot risks and the plan §7).

## 10. CED structural facts (source authority) `[verified 2026-08-22]`

- The CED assessment atom = (learning objective / content) × (skill). This is the cell (CM-D05).
- The per-LO (LO → skill) anchoring is a *teaching suggestion*; the exam "can pair the content with any of the skills." So the mastery space is a matrix, and the anchoring is the seed spine (~130 cells for Stats).
- Practices decompose into a variable number of lettered skills (e.g. AP Chemistry Practice 1 = 2 skills, Practice 2 = 6 skills; AP Stats Practice 4 = 7 skills).
- Each CED unit opener carries CB-authored "common student misunderstandings" as PROSE inside a "Preparing for the AP Exam" / "Building the Practices" section (not structured lists) — usable for distractor generation and diagnosis after manual extraction.
- AP Statistics 2026-27 is a 5-unit course (Regression = Unit 5, descriptive only). Removed vs. the retired 9-unit version: see CM-D15 EXCLUDED list.

## 11. Open questions and deferred work

OPEN:
- Constant calibration: evidence weights (CM-D07), decay intervals + thresholds (CM-D08), priority scalar formula (CM-D09), tier-advancement requirements (how many independent attempts / how much surface variation / what delay for `confirmed`).
- Generator validation details (CM-D17): sample sizes, property-test coverage bar, gold-set regression thresholds.
- Sequencing within the pilot: computational-first for momentum vs. prototype a Practice-4 slot-frame early to de-risk the load-bearing conceptual engine (decision: build computational spine AND prototype one Practice-4 slot-frame in parallel).
- The student EXPERIENCE layer is NOT yet designed: per-cell micro-experience flavored by trigger `reason` (maintenance / consolidation / reopened-miss / confirm); session assembly ("your 20 minutes"); the fortress/progress surface. Deferred until supply is proven.

RESOLVED 2026-08-23 (David):
- CM-D19 template-level release mechanism — APPROVED (with sampled spot-audit). **BUILT 2026-08-23** as `app.cm_d19_release_template()` / `app.cm_d19_revoke_template_release()` (migration `20260823160000`), fail-closed on the D8 bars and reversible per template. See `COURSE_MODE_RELEASE_PATH_DECISION_BRIEF.md`.
- **D8 release bars — APPROVED 2026-08-23 (David), `bars_version='cm-d19-phase1-2026-08-23'`:** SME validation sample **20** instances/template with **0** defects; property-test coverage **≥100** instances/template with **0** rejects; gold-behavior regression **0** verifier disagreements; ongoing spot-audit **5** served instances/template/month. Phase-1 defaults, tunable; recorded in `app.template_release_bars`. Resolves the CM-D17 "sample sizes / gold-set regression thresholds" OPEN item for the pilot and the pilot plan's D8.
- SME gate on §3 skill anchoring — David is the reviewer/SME of record for the pilot and will consult Jill as necessary. He consciously makes the fact-pack §3/§9 amendment: bulk authoring proceeds keyed off these tags; §10 is usable as a candidate under his review. Student-facing serving is under David's review authority.
- **Distractor realism is a release-blocking quality bar (2026-08-23):** every generated MCQ distractor must be a *distinct, plausible, on-scale* error (per `CONTENT_AUTHORING_AND_QA_PROTOCOL` / `TASK-0008`), not merely a mechanically-derived wrong value. The computational generator enforces this with per-procedure plausibility guardrails + property tests (added for `lsrl_predict` after David's SME review; other computational templates spot-checked on-scale).

DEFERRED (post-pilot / later phase):
- Phase 2 graph triggers (prereq, thread-sibling) and the CED-extracted principle graph (vertical + lateral edges).
- Science-subject item→topic backfill; lettered-skill extraction/tagging for non-Stats subjects.
- Conceptual generalization beyond authored frames.
- Extension to subjects beyond Stats.

## 12. Source anchors

- Prior design: `docs/teaching/LEARNING_SYSTEM.md`, `docs/teaching/LEARNING_SYSTEM_STUCK.md`, `docs/teaching/TEACHING_AND_PEDAGOGY_DESIGN.md`.
- Stats CED extraction + removals: `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md` (§3 anchoring, §8 removals, §9 open items/SME gate).
- CED PDFs: `docs/teaching/ap-*-course-and-exam-description.pdf`.
- Schema: `supabase/migrations/` (see §9 for tables); grading: `supabase/functions/` (`evaluate-attempt`, `_shared/statistics-verifier.ts`, `_shared/grading-memory.ts`, `_shared/student-memory.ts`).
- Content: `content/item-packages/`, `content/subject-packages/`; Stats research assets under `docs/research/` and `docs/product/`.
