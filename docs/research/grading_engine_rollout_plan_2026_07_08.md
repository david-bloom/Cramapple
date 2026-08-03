# Grading & Feedback Engine Rollout Plan — 2026-07-08

**Status:** Planning assessment for Product Owner; not implementation approval
**Owner:** Product Owner (David) with Learning Quality Owner
**Scope:** Readiness, partial-solution gaps, and missing-capability plans for the
four rubric-type engines needed to roll out any exam that relies on them.
**Related:** DECISION-0034 & `grading_cross_subject_takeaways.md` (the binding
lessons); `math_formula_grading_experiment_2026_07_08/` (symbolic checker +
hand-drawn assessment); `DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md` +
`../tasks/TASK-0011` (spatial); `deterministic_check_experiment_2026_07_08/`
(numeric checker); production functions `supabase/functions/evaluate-attempt/`,
`grade-frq/`.

## The four engines, mapped to the rubric taxonomy

The determinism-of-rubric taxonomy (from the offline research, adopted here) is a
better organizing axis than question length:

| # | Engine | Rubric type | Primary modality | Subjects that need it |
| --- | --- | --- | --- | --- |
| 1 | **Discrete/Analytical Text** | point-by-point analytic | text LLM + deterministic checks | Bio, Chem SAQ/FRQ, Stats, Physics/Econ written parts, (History SAQ) |
| 2 | **Holistic/Evaluative Text** | rubric-matrix, holistic | long-context LLM | **AP English Lang/Lit, AP History DBQ/LEQ only** |
| 3 | **Structured Multi-Modal** | multi-step, ECF/consistency | vision→symbolic + SymPy | Calc AB/BC, Physics 1/2/C, Chem calc, Stats/Econ formula setup |
| 4 | **Spatial Multi-Modal** | geometric/spatial markers | vision geometry/OCR | Econ curves, Chem titration/graphs, Bio pedigrees, Stats graphs, Physics diagrams |

### Scoping consequence (read this first)

**The four subject families you are prioritizing — Calculus, Physics,
Economics, Statistics — need only engines 1, 3, and 4.** Engine 2 (Holistic) is
required only by AP English and AP History, which are not in the launch set, and
the platform has a deliberate, evidence-backed stance *against* holistic scoring
for the subjects it does serve (criterion-by-criterion is the product thesis;
`LEARNING_SYSTEM.md` cites Tate et al. 2024 that AI holistic essay scoring is
low-stakes-formative only, human agreement κ≈.58 vs human-human ≈.79).

**Therefore engine 2 is explicitly out of scope for this rollout** and is filed
as a future-subject capability. This concentrates the work on three engines, not
four.

## Two universal gates (apply to every engine, no exceptions)

Independent of engine, two things gate any learner-facing launch, per the
binding lessons:

- **G1 — Adjudicated gold set** (`takeaways` Lesson 7; governance §12.2: 300+
  dual-blind adjudicated held-out responses, 40/archetype). **None exists for any
  production question in any engine today.** This is the true launch gate; no
  engine ships without it. It is people/adjudication work and can start now in
  parallel with engineering.
- **G2 — Deterministic-before-model + boundary contracts wired to production**
  (Lessons 1, 3). Proven in research at 100% specificity; **not yet wired into
  the production grader** (confirmed: zero references to `verification_profile` /
  deterministic / ECF in `supabase/functions/`).

## Cross-cutting missing capability: the evaluator-strategy router

To "roll out any exam relying on these rubric types," the platform needs one
piece of connective tissue that does not exist yet: a **`rubric_type` /
`evaluator_strategy` field on each question** and a **router** in the grading
path that dispatches to the correct engine. Today `evaluate-attempt` is a single
text-grading path. This router is the highest-leverage single build — it unlocks
all three engines behind one contract and matches the multi-subject grading
strategy already recorded. Build the core pipeline once; inject a per-question
config object; keep each engine a replaceable strategy behind the router.

---

## Engine 1 — Discrete/Analytical Text

**Readiness: closest to launch; gated by G1 + G2.**

- **In production:** `evaluate-attempt` (1,445 LOC) + `grade-frq` (634 LOC) —
  single-model, criterion-by-criterion LLM grader, structured output
  (`earned`/`not_earned`/`unable_to_determine` + `evidence_quote` +
  `explanation` + `minimum_fix`). This is the 9-element criterion feedback and it
  is live for Bio/Stats/Chem/Physics-written.
- **Proven in research, not wired:** the deterministic numeric checker (100%
  specificity), the misattribution dependency-parse check, and the
  criterion-boundary contract discipline (Lesson 1's dominant lever).
- **Gaps:** (a) G2 — deterministic layer + boundary contracts not integrated into
  the production function; (b) G1 — no adjudicated gold set; (c) boundary
  contracts authored for only a few criteria; (d) the URGENT AP Bio publish gap
  (all 242 items `draft`) means live grading is likely broken regardless.

**Gap-closure plan (E1):**
1. E1.1 — Wire the deterministic checker to run *before* the LLM grader; let it
   own the mechanical criteria it can decide and abstain otherwise (Codex,
   backend). Version-pin checker + boundary contract to the grading result.
2. E1.2 — Author boundary contracts for the launch subject's hard criteria
   (Learning Quality). Lesson 1: this is the biggest quality lever.
3. E1.3 — Resolve the Bio publish gap (separate URGENT track) so real grading
   runs.
4. E1.4 — Build one adjudicated gold set (G1) for the launch subject; this is
   the gate, not more synthetic breadth.

---

## Engine 3 — Structured Multi-Modal (equations & formulas)

**Readiness: strong deterministic core for TYPED formulas (built this session);
hand-drawn path is research-stage; ECF is the missing headline feature.**

- **Built this session:** SymPy equivalence checker — expression /
  antiderivative(+C) / numeric / conceptual-ABSTAIN; 62/62 development battery,
  100% specificity & detection, $0, seeded. Handles any-correct-form equivalence
  and rejects single-point coincidences.
- **Gaps:**
  - **ECF / consistency points — not built.** The offline research's best
    contribution. Today's checker only judges the final line; AP awards
    downstream steps computed correctly on a wrong upstream value. Needs the
    two-universe state machine (canonical vs. student state, re-substitute the
    student's own upstream values) + the two guardrails (coincidental-canonical;
    naked-answer/no-chain-of-custody). Verified feasible on the current SymPy
    layer.
  - **Hand-drawn transcription — the dominant risk, unbuilt and unmeasured.**
    Perception must transcribe handwriting → parseable expression per line; a
    misread symbol makes the checker confidently flag correct work, and ECF
    *amplifies* this (one bad value propagates down the student universe). See
    `math_formula_grading_experiment_2026_07_08/hand_drawn_formula_assessment.md`.
  - **Unit handling — unbuilt** (Physics/Chem numerics award/withhold on units).
  - **Verification-profile key schema — on paper, not authored per item.**
  - Not wired to production; no gold set (G1).

**Gap-closure plan (E3):**
1. E3.1 — Build the **ECF state machine** on today's checker: parallel
   canonical/student execution, per-part audit trail ("lost the point in A;
   B is fully correct on your value"), both guardrails, a multi-part dev battery
   (F=ma cascade, related-rates chain). Cheap; on top of existing code.
2. E3.2 — Run the **transcription-fidelity bake-off** (hard case: Physics C /
   Calc BC derivations; easy case: econ/stats setup). Gate: how often does
   perception transcribe to a parseable expression, and how often does it
   silently corrupt correct work? Arms per architecture-review §6: direct-to-
   expression vs. transcription→checker. Needs gateway creds + minor-data
   approval (see blockers).
   - If reliable → hand-drawn viable with read-back confirmation.
   - If not → **ABSTAIN-to-human is V1**; structured equation input is the
     Lovable frontend ask.
3. E3.3 — Author `verification_profile` symbolic keys + ECF templates for one
   math-subject pilot; independently validate the keys.
4. E3.4 — Wire the symbolic+ECF checker into the router (typed path first; it
   carries **zero perception risk** and can ship for born-digital practice now).
5. E3.5 — Build a Structured gold set (G1) once a pilot batch exists.

**Ship-now opportunity:** born-digital *typed* formula practice can use the
checker (+ECF once E3.1 lands) immediately with no perception risk. Reserve the
photo path for exam-simulation mode pending E3.2.

---

## Engine 4 — Spatial Multi-Modal (graphs, curves, diagrams)

**Readiness: furthest from launch of the three needed engines; research-stage,
already specced under TASK-0011.**

- **Done:** architecture review; hand-drawn graph corpus v0.2 (reproducible
  generator); AP Stats HDR photo set (45/48 proposed labels); coarse full/partial
  classification ~87% on a smoke test.
- **Gaps (all from TASK-0011 / architecture review, not yet executed):**
  (a) capture flow (QR/upload) not prototyped; (b) observation bake-off not run
  (deterministic geometry/OCR vs. multimodal vs. hybrid, §6 Priority 3);
  (c) adjudicated dual-human gold set not built (TASK-0010: 300+, 40/archetype);
  (d) abstention not calibrated from observed error; (e) upload security /
  minor-data controls; (f) external-provider data-transfer approval open.

**Gap-closure plan (E4):** execute TASK-0011 in its existing phase order —
capture prototype → observation bake-off → dual-human gold → calibrated
abstention → shadow operation (100% human review) → owner decision packet. Do
not shortcut to a single-pass learner-facing score (§4.5). This is the longest
pole; start it in parallel but plan for it to trail engines 1 and 3.

---

## Engine 2 — Holistic/Evaluative Text — CONFIRMED GOAL, SEQUENCED LAST

Confirmed as a real goal (Product Owner, 2026-07-08), sequenced after engines
1/3/4 because no launch-set subject needs it yet (it serves AP English and
History). Design note that lowers its cost: AP "holistic" rubrics (DBQ/LEQ:
thesis, evidence, sophistication) are actually **multi-row analytic scales**, so
this engine reuses Engine 1's criterion decomposition more than it needs true
impression scoring. When it enters scope, treat the offline research's
multi-agent rubric-row decomposition as a **challenger to a single
boundary-contract grader, not the default** — Lesson 2's evidence applies until
re-tested on long essays, a domain we have not measured. No build in this phase.

---

## Sequenced rollout (by leverage, not by engine number)

| Phase | Work | Engines unlocked | Delegate | Blockers |
| --- | --- | --- | --- | --- |
| **A. Connective tissue + wire the proven** | Router (`rubric_type` dispatch); wire deterministic checker + boundary contracts to prod (E1.1–E1.2); ECF state machine (E3.1); wire typed symbolic+ECF path (E3.4) | 1, 3 (typed) | Codex + Learning Quality | none — mostly in-repo |
| **B. Close the formula hand-drawn gap** | Transcription bake-off (E3.2); author profile keys + ECF templates (E3.3) | 3 (hand-drawn) | Codex + QA | gateway creds, minor-data approval |
| **C. Gold-set gate (parallel, the real bottleneck)** | Adjudicated gold sets per engine/subject, depth over breadth (G1 = E1.4, E3.5) | all | Learning Quality + tutors | adjudication capacity (memory: not a bottleneck — tutors hireable) |
| **D. Spatial engine** | Execute TASK-0011 end to end (E4) | 4 | Product/Tech/LQ owners | minor-data approval, capture build |
| **Deferred** | Holistic engine | 2 | — | out of scope until English/History |

## Blockers to clear (owner actions)

1. **Gateway credentials** — absent this session; gate any live model bake-off
   (E3.2) and the pending generalization/feedback run.
2. **External-provider data-transfer approval for minors' images** — gates all
   hand-drawn paths (E3.2, E4). Open since the 2026-06-29 experiment.
3. **AP Bio publish gap (URGENT)** — orthogonal but means live grading is likely
   broken today regardless of engine work.
4. **Adjudication authority to freeze gold labels** — G1 needs someone with
   approval authority to freeze rubrics/labels (flagged in the AP Stats HDR prep).

## Decisions the Product Owner must answer before build + deploy (engines 1, 3, 4)

These are the owner-only, build/deploy-blocking decisions. Engineering defaults
(schemas, checker internals, prompt structure) are Codex's to make and are not
listed. Recommendations are given; the decision is yours.

### Tier 1 — Hard blockers (work cannot complete without these)

1. **First end-to-end launch subject.** Which single subject drives all the way
   to a live grade first (depth over breadth, Lesson 7)? Everything downstream —
   which gold set, whose boundary contracts, which formula/graph pilot — keys off
   this. *Recommendation: AP Statistics — it exercises all three engines (text +
   formula setup + graphs), has the most existing corpus/HDR work, and is furthest
   along after Bio. Confirm whether the Aug-2026 AP Bio beta is a separate,
   earlier commitment.*
2. **Launch bar.** Is the governance §12.3 threshold (300+ dual-blind adjudicated
   held-out, 40/archetype, the agreement + feedback-quality numbers) the deploy
   gate, or is there a lighter beta gate for a first cohort? Defines "done."
3. **Minors' image-data policy (counsel).** May student-submitted handwriting and
   graph photos be sent to external model APIs? With what retention, training-
   exclusion, deletion, regional-processing, and consent model? **Hard blocker for
   the Engine 3 hand-drawn path and all of Engine 4** — the bake-offs cannot run
   on real images without it. Open since 2026-06-29.
4. **Rollout mode.** Accept shadow-first operation (100% human review,
   non-authoritative automated output) as the first deploy of any engine, and
   define the criteria to graduate to limited release then GA (§4.5, §4.11).
5. **Provider keys + cost ceiling.** Whose BYOK account funds production grading,
   and confirm per-grade cost ceilings — especially vision calls (Engines 3-photo,
   4), which are pricier than the ~$0.03/FRQ text ceiling. Gates any live run.
6. **Abstention / coverage target.** What human-review rate is economically
   acceptable per engine? This sets where the deterministic layer and the model
   abstain to a human, and defines "deployable" coverage (memory: adjudication is
   not the bottleneck; exam-week tail latency is brand-critical).

### Tier 2 — Scope decisions that shape what "fully build" means

7. **Engine 3 input modality.** Ship born-digital typed/equation-editor input
   first (zero perception risk, buildable now), the paper-photo path first, or
   both? *Recommendation: typed first now; photo for exam-simulation mode after
   the transcription bake-off.*
8. **Engine 3 units.** Are unit-correctness criteria in scope for launch (AP
   withholds for wrong/missing units)? Build unit checking or defer? *Recommendation:
   defer to a fast-follow; keep unit criteria model-owned at launch.*
9. **Engine 3 ECF strictness (Learning Quality).** Confirm the consistency-point
   interpretation, especially "naked answer / no work shown → no ECF" and where a
   wrong-formula conceptual collapse breaks the chain. Affects fairness.
10. **Engine 4 scope.** Capture flow (QR handoff vs. direct upload on primary
    device); the ≤3 first-supported graph archetypes and which subject's graphs
    first; the required accessibility alternative for students who cannot
    handwrite/photograph; and whether to overlay marks on the student image
    (high-risk, §4.6) or stay text-only. *Recommendation: direct upload first,
    Statistics graphs, text-only feedback (no overlays) at launch.*
11. **Engine 1.** Confirm boundary-contract authoring capacity (Learning
    Quality — the dominant quality lever, Lesson 1), and whether resolving the
    URGENT AP Bio publish gap is in-scope here or a separate track.

### Tier 3 — Process / approval

12. **Approve this plan as a hard-gate TASK** and confirm delegates (Codex
    backend, Lovable frontend, Learning Quality content, QA calibration).
13. **Rights confirmation** that the no-College-Board-material policy covers newly
    authored Calculus, Physics, and Economics questions (already resolved for
    Statistics).

## Decisions RESOLVED (Product Owner, 2026-07-08)

1. **First launch subject: AP Statistics.** Drives all three engines end to end.
2. **Launch bar (AP Statistics beta gate)** — *targets are ceilings ("stay
   under"), confirmed 2026-07-08:*
   - **Validation corpus:** 100 MCQ + 100 FRQ + 10 Investigative-Task items.
   - **Accuracy: ≥95%** criterion-level agreement with adjudicated labels;
     feedback-quality metrics reported separately (Lesson 6).
   - **Latency: measured END-TO-END (student experience: submit → feedback
     rendered), at p50 / p90 / p99, segmented per engine / input modality.**
     p50 ≤ 1000 ms is the confirmed ceiling. p90/p99 are measure-and-report first
     (p90 = when most are done; p99 = long-tail length); hard p90/p99 gates set
     after the first observed distribution. Per-stage breakdown captured to
     attribute the tail (upload, extraction, deterministic checks, model call,
     render).
   - **Cost: ≤ $0.01 / graded item** (report target, not a hard billing gate;
     BYOK is a CAC). Tightens the prior $0.03/FRQ tolerance.
   - This is a **beta gate**, lighter than governance §12.2 (300+/40-per-archetype)
     — an explicit owner decision.
3. **Minors' images: approved.** Ts&Cs cover PII; handwriting content is not PII.
   Unblocks Engine 3 photo path and Engine 4. *Operational note for Codex:* an
   image can still incidentally capture identifying marks (a name on the page) —
   keep EXIF/metadata stripping and add name-region handling / a "don't write
   identifying info" capture instruction.
4. **Rollout mode: shadow-first accepted.** Shadow = 100% human review,
   non-authoritative. **Limited release may run semi- or no human review.**
5. **Provider funding:** BYOK is a CAC; ceiling TBD; not needed before launch.
6. **Human-review rate:** TBD — deferrable; shadow is 100% regardless; tune at
   limited release from shadow data.
7. **Engine 3 input:** typed submissions supported — see the answer below;
   plain-text field + parser is the Stats MVP (near-zero new frontend), structured
   equation editor is post-MVP for heavier math subjects.
8. **Engine 3 units:** (deferred per recommendation unless owner says otherwise.)
9. **Engine 3 ECF:** **naked answer (no work shown) → do NOT apply ECF AND trigger
   the "help" / scaffolding feature** rather than silently scoring 0.
10. **Engine 4 MVP: QR handoff capture.** Direct upload and other capture options
    are post-MVP.
11. **Engine 1: AP Bio publishing authorized under the same rules as Statistics**
    (policy unblock for the 242 draft items; technical publish action can proceed).
12. **Delegates confirmed:** Codex (backend), Lovable (frontend), David supervising
    Orly (content), QA (calibration).
13. **Rights confirmed:** no direct use of College Board content; permitted use is
    only to understand the exams and inform the grading approach.

## What this plan deliberately does NOT do

- Build engine 2, or adopt multi-agent decomposition as a default (Lesson 2).
- Add escalation/ensemble/reference layers as defaults (Lesson 2).
- Select a vision or grading vendor before the held-out bake-off (§4.2).
- Create more synthetic breadth corpora in place of one adjudicated gold set
  (Lesson 7).
- Ship any single-pass learner-facing automated score (§4.5).
