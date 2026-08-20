# Decisions Log

This log records product, architecture, operating, security, design, and workflow decisions.

## Index

Most recent entries (full chronological list follows below):

- DECISION-0051 — Confirm QR Handoff (System A) as Engine 4's Sole Capture Path, No Direct-Upload Fallback; Define Capture-Failure Handling (Generic Retake Guidance vs. Bug Logging)
- DECISION-0050 — Retire the Dual-Human-Adjudicated Gold-Set Requirement for Engine 4 (Spatial); Adopt the DECISION-0045 AI-Generation + Multi-Model-Verification + Reader-Certification Model Instead
- DECISION-0049 — Hand-Drawn Capture Becomes an Added Submission Option for Typed-Math FRQs (Retroactive to All 36 Published Calculus FRQs), Graded via the Same Criteria as Typed Answers Through an OCR-Transcription Step
- DECISION-0048 — AP Statistics Hand-Drawn Practice Stays Supplemental (Simulating Desmos Construction, Not the Real Exam); Chemistry/Physics/Calculus Get New Genuine Hand-Drawn-Capture Items
- DECISION-0047 — Replace Activation-Limited Free Score Check with a 7-Day Full-Access Trial (TASK-0026)
- DECISION-0046 — Retire the ≤1000ms p50 Grading Latency Hard Gate; Launch Engines 1/3 Now and Iterate in Production Rather Than Wait for the Full Gold-Set Certification Gate
- DECISION-0045 — Gold Sets Are Built by AI Generation + Multi-Model Verification + Reader Certification, and Partitioned by Grading Engine × Criterion Structure
- DECISION-0044 — Universal Publication Rule (Double-Approve + AI QA, or Edit-Request Fixed by AI)
- DECISION-0043 — Operationalize Branch Hygiene R1–R7 (Trunk Protection, CI, Auto-Delete)
- DECISION-0039 — Adopt Branch Hygiene Rules (R1–R7) to Resolve and Prevent Branch Sprawl
- DECISION-0035 — Resolve Phase 0 of the Backend Consolidation Migration (Schema Reconciliation, Option A/A2)
- DECISION-0031 — Launch AP Statistics as Subject 2, Reusing the Tutor-Authored Content Model
- DECISION-0030 — Failed/Rejected Grading Burns the Daily Budget Cap When Cost Is Known
- DECISION-0029 — ALLOWED_ORIGINS Required in All Environments; No Wildcard CORS Fallback
- DECISION-0028 — Auto-Trigger QA and Model Routing (Codex Proposal Folded In)
- DECISION-0027 — Adopt Charter Simplification and Tiering (Pilot: Cramapple Only)
- DECISION-0026 — Separate Authoring, Revision, and Independent Review
- DECISION-0025 — Use a Verified Five-Stage Outside-Question Intake
- DECISION-0024 — Use Staged Tutor and AP Reader Candidate Review
- DECISION-0023 — Resolve Official Exam Dates from the Exam Specification

**Rotation rule:** once this log exceeds ~600 lines, archive the older entries to `docs/activity_log/archive/DECISIONS_LOG-<range>.md` and update this index to point at the archive. Keep the index itself to the last ~10 entries. (This log is already well over that threshold — the first archive pass is overdue, not optional.)

(Note: the TASK-0012 branch independently logged its own DECISION-0027/0028 — CORS/ALLOWED_ORIGINS and budget-burn semantics — under different numbers on its own branch. Those land separately when that work merges to `main`; this charter-adoption decision claimed 0027/0028 here because `main` had not yet recorded entries past DECISION-0026 at merge time. If both branches' numbering collides on merge, renumber on whichever side merges second and update this index.)

## DECISION-0051 — Confirm QR Handoff (System A) as Engine 4's Sole Capture Path, No Direct-Upload Fallback; Define Capture-Failure Handling (Generic Retake Guidance vs. Bug Logging)

**Date:** 2026-08-19
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0016 Phase D, TASK-0025
**Related Docs:** `docs/research/HAND_DRAWN_CAPTURE_PATH_RECONCILIATION_2026_08_19.md` (the
options this resolves), `docs/research/grading_phase_d_spatial_2026_07_27/DECISIONS_AND_BLOCKERS.md`
items 1-2 (the blockers this closes)
**Area:** Product / Grading Engineering

### Context

TASK-0016's decision #10 (`APPROVAL-0033`, 2026-07-08) already named QR handoff as Engine 4's MVP
capture method, direct upload post-MVP. TASK-0025 (2026-08-15) built and deployed a same-device
direct-upload pilot (`SameDeviceCapture.tsx`) without amending that decision — a real deviation
from the approved plan, flagged during Stage D0 execution
(`docs/research/grading_phase_d_spatial_2026_07_27/`). The two systems otherwise split
capabilities: System A (QR/`CaptureItem.tsx`) has the only working cross-device UX and capture-
quality check but is currently non-functional against live Production (its backing table/bucket
don't exist) and, even working, deleted the photo instead of saving it; System B has the only
working image-preservation backend (`attach_capture`/`app.response_attachments`) but no QR/
quality-check UX and is admin-gated/unlinked.

### Decision

1. **QR handoff (System A) is confirmed as Engine 4's sole capture path.** This reaffirms
   TASK-0016 decision #10 rather than reversing it. Reasoning given: QR is a familiar interaction
   pattern; using a laptop's own camera for this task is awkward compared to a phone.
2. **No direct-upload fallback.** System B's same-device upload does not become a general,
   non-pilot capture option. Its frontend (`SameDeviceCapture.tsx`, the `/hand-drawn-pilot` route)
   stays pilot-scoped/superseded, not promoted — consistent with option (a) in the reconciliation
   note. Its backend (`attach_capture`/`app.response_attachments`) is real, working,
   already-deployed infrastructure and should be reused as System A's storage/validation layer
   rather than recreating the broken `capture_sessions`/`capture-research` system from scratch.
3. **Capture-failure handling, split by cause:**
   - **Image-quality failure** (blur, glare, cutoff, poor framing — the domain of a capture-quality
     check): show the student a **graceful, generic** suggestion for improving the photo. Not a
     itemized/diagnostic defect callout as a hard requirement — generic retake guidance is the
     baseline; more specific messaging (e.g. naming the exact defect) is a UX refinement, not a
     requirement of this decision.
   - **Technical failure** (API error, missing infrastructure, timeout, upload failure, any
     failure that isn't about the photo itself): **log a bug** — this must be captured as an
     error/telemetry event for engineering triage, not silently retried or shown to the student as
     if it were their fault.

### Consequences / Follow-ups

- Resolves `docs/research/grading_phase_d_spatial_2026_07_27/DECISIONS_AND_BLOCKERS.md` items 1
  and 2 (System A vs. B, and the missing `capture_sessions`/`capture-research` DB objects) —
  updated in place.
- Concrete engineering implication: Stage D2 (QR capture MVP) resumes by rewiring System A's
  frontend to call `attach_capture` (which today only accepts authenticated calls — the phone
  leg's token-pairing model needs a bridge into that authenticated path) rather than recreating
  `capture_sessions`/`capture-research`.
- Error-handling split (image-quality vs. technical failure) is new design guidance not previously
  specified anywhere in the Phase D prompt or `HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md` —
  should be folded into those documents' capture-failure sections when Stage D2 engineering
  actually implements this.
- Does not resolve the still-open `capture_quality_state`/`capture_retake_reason` frontend/backend
  contract mismatch (`project_idea1_capture_quality_check_status`) — that's a separate, smaller
  fix needed regardless of which capture system wins.
- See `APPROVAL-0046` for the corresponding approval entry.

## DECISION-0050 — Retire the Dual-Human-Adjudicated Gold-Set Requirement for Engine 4 (Spatial); Adopt the DECISION-0045 AI-Generation + Multi-Model-Verification + Reader-Certification Model Instead

**Date:** 2026-08-19
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0016 Phase D, TASK-0011
**Related Docs:** `DECISION-0045` (the model this decision extends to Engine 4),
`docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.2 (the requirement being retired
for Engine 4 specifically), `prompts/CLAUDE_TASK0016_PHASE_D_SPATIAL_ENGINE_2026_07_27.md`
(Stage D3, whose "dual-human-adjudicated" language is superseded by this decision),
`docs/research/grading_phase_d_spatial_2026_07_27/` (Stage D0, executed same day, which
surfaced this as the largest blocker to Engine 4 progress)
**Area:** Grading / Governance

### Context

TASK-0011/TASK-0016 Phase D's Stage D3 requires ≥300 dual-human-adjudicated responses (≥40 per
archetype, per governance §12.2) before any Engine 4 gold-backed accuracy claim. `DECISION-0045`
(2026-08-03) already replaced all-human gold authoring program-wide with an AI-generation +
multi-model-verification + reader-certification model — but explicitly deferred applying it to
Engine 4 ("Set C — spatial/`human_shadow` — deferred until Engine 4 leaves shadow"), leaving
Phase D's older dual-human-adjudicated language as the operative Engine 4-specific standard.
Stage D0 (executed 2026-08-19, same session) found this is currently Engine 4's single largest
blocker: no corpus in the repo meets it, and the one human-pilot attempt aimed at building
one (Orly Bloom, 2026-06-13) stalled on data-reproducibility defects and was never resumed.

### Decision

1. The dual-human-adjudicated gold-set requirement is **retired as a hard gate specifically for
   Engine 4** — not merely deferred again.
2. **`DECISION-0045`'s Set C deferral is lifted.** Engine 4 gold-set construction follows the
   same protocol as every other engine: answers/labels generated or graded by AI, checked by two
   independent non-OpenAI model families, with reader effort spent certifying the pipeline (cold
   verification of rubric-element presence on an audit sample, a pre-registered false-accept-rate
   gate) rather than dual-blind adjudicating every response. `DECISION-0045`'s independence
   constraints (no OpenAI model may write or verify; three non-OpenAI families required since the
   writer consumes one) apply identically here — this is the same standard already load-bearing
   for Engines 1/3, not a weaker one invented for Engine 4.
3. **This does not waive real-photo corpus-readiness requirements.** The existing photo corpus
   still needs the fixes its own 2026-08-03 readiness audit found (consent/provenance manifest,
   deduplication, metadata stripping) before it's an eligible input — this decision changes what
   "gold" means for the labels attached to that corpus, not the corpus-collection bar itself.
4. **The existing 200-photo real-Biology corpus's single-pass-AI gold does not automatically
   become certified gold under this decision.** It still needs an actual `DECISION-0045`-protocol
   pass — two independent non-OpenAI model families checking it, plus a reader-certified
   false-accept-rate sample — before it counts as launch-qualifying evidence. This decision
   changes the target standard going forward; it does not retroactively certify work already
   done under the old, unmet standard.
5. Applies to both AP Biology (development evidence under Phase D) and AP Statistics (the actual
   TASK-0016 launch subject).

### Rationale

Requiring literal dual-human adjudication for Engine 4 while every other engine moved to the
DECISION-0045 model in 2026-08-03 left Engine 4 held to a standard nothing else in the program
meets either — and one whose only concrete attempt to satisfy it (the Orly pilot) failed for
reasons unrelated to whether dual-human adjudication itself is the right bar (data errors, a
rights-claim overstatement), not for lack of trying. Un-deferring Set C removes a blocker that
was never really a deliberate Engine-4-specific safety decision, just an unresolved carry-over
from before DECISION-0045 existed.

### Consequences / Follow-ups

- `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md`, `docs/tasks/TASK-0011-HANDWRITTEN-GRAPH-CAPTURE.md`,
  and the Phase D execution prompt's Stage D3 language should be read as amended by this decision
  going forward — a future session should not refuse to proceed by citing their literal
  "dual-human-adjudicated" wording.
- `docs/research/grading_phase_d_spatial_2026_07_27/DECISIONS_AND_BLOCKERS.md` items 3 and 6 are
  updated in place to reflect this decision.
- Someone still needs to actually run the DECISION-0045 protocol against Engine 4's corpus — this
  decision removes the blocker, it does not itself certify any existing corpus as gold.
- See `APPROVAL-0045` for the corresponding approval entry.

## DECISION-0049 — Hand-Drawn Capture Becomes an Added Submission Option for Typed-Math FRQs, Retroactive to All 36 Published Calculus FRQs

**Date:** 2026-08-18
**Decision Owner:** David Bloom
**Status:** Approved (product direction); grading capability not yet built
**Related Docs:** `DECISION-0048` (above/below), `docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md`
(same-day, uncommitted-as-of-this-decision OCR probe finding),
`docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md` (Engine 3's existing
"real human-handwriting transcription gating run" requirement)
**Area:** Content / Product / Grading Engineering

### Context

Same-day follow-up to `DECISION-0048`. Working through Calculus's typed-math
response modality surfaced that there is no equation editor
("structured equation editor is post-MVP" per `TASK-0016-GRADING-ENGINE-
ROLLOUT.md`) — `typed-text`/`typed-math` today means raw keyboard entry of
math notation (e.g. `a(t) = v′(t) = 3t²−10t+4`), with no confirmed frontend
guidance on notation and no dedicated math-notation-normalization layer on
the production grading path Calculus actually uses (`discrete_text` →
`llm_discrete_text`, not the not-yet-live `structured_formula`/`symbolic_ecf`
path). The Owner's read: keyboard math entry is too complicated for student
practice.

### Decision

1. **Hand-drawn capture becomes an added submission option, not a
   replacement,** for FRQs currently requiring typed equation/derivation
   work. Students write on paper and submit via photo capture, same
   mechanism as the existing hand-drawn graph items.
2. **Applies retroactively to all 36 already-published Calculus FRQs**
   (`apcalcab-*`, `apcalcbc-*`), not just new content — the same keyboard-
   complexity problem applies equally to existing items; there's no
   principled reason to treat them differently.
3. **Grading target: reuse the existing typed-answer criteria**, not build a
   separate rubric. The Owner's framing — "we will grade and offer repair
   just like FRQs with typed answers" — means the intended architecture is
   capture → OCR-transcribe the handwriting to text → run the *same*
   `criterion_definitions`/`required_evidence` grading each item already has
   for its typed-math form, not a new spatial/graph-shape-style rubric.
4. **UI enhancement to make hand-drawn submission more obvious** is a
   separate, Lovable-frontend-side task, not addressed here.

### Why this is more buildable than it first looked

A same-day (uncommitted at the time of this decision) OCR probe using
macOS's built-in Vision framework was tested against real handwritten
Calculus/Chemistry equation samples (`docs/hand drawn samples/Calc AB HDR/`,
`Chem HDR/`) and found "strong core-content transcription with one specific,
recurring weakness (exponent/superscript notation inconsistently
preserved)" — flagged in `GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` as
"a better-fitting problem for OCR than graphs are (pure symbolic
recognition, no point-detection needed)." This is real, positive signal for
exactly the architecture in point 3 above — but it is explicitly a probe,
not a qualified pilot: "needs its own gold data and benchmark; not a
continuation of Engine 4's graph work, don't conflate the two scopes."

### What is NOT true yet — read before assuming this is close to shipping

- **No real student has ever been graded by any engine in Production**
  (0 `attempts`, 0 `attempt_responses`, per the same handoff doc) — this is
  true of the existing typed-math grading path too, not just hand-drawn.
  "Grade just like typed FRQs" is a reasonable target; it is not yet a
  proven, live baseline to match.
- The OCR-for-equations finding is a probe result on a small out-of-scope
  sample, not a benchmarked, gold-verified capability.
- Per the standing policy (`ACTIVITY_LOG.md`, 2026-08-14; also see
  [[feedback_no_human_grading_in_production]]), there is no human-graded
  fallback if this isn't ready — these items stay ungradable for real
  students, not "gradable by a person," until it's built and qualified.
- No schema/migration work to add a hand-drawn submission option to the 36
  existing item packages has been done — this decision records the product
  direction; the retroactive content/schema change is separate follow-up
  work.

**Next Owner:** David Bloom.
**Next Required Action:** Scope the OCR-transcription-to-existing-criteria
pilot as its own tracked effort (natural home: Engine 3's outstanding "real
human-handwriting transcription gating run" requirement in
`TASK-0016-GRADING-ENGINE-ROLLOUT.md`) with its own gold data and benchmark;
separately, scope the schema/migration work to add a hand-drawn submission
option to the 36 existing Calculus FRQ items; separately, brief the Lovable
frontend work for the UI prominence change.

### Follow-up, same day: submission path already universal, no schema change needed there

Owner direction refined the rollout shape: every question should carry the
image-capture/submission option by default (not curated per item), with a
per-item **suppression** override added later once specific items are known
non-viable for hand-drawn capture — explicitly to avoid having to label
every FRQ up front. Checked the actual backend before assuming this needed
schema work:

- `attempt-response/index.ts`'s `attach_capture` operation has **zero
  gating on item type, rubric type, or `response_modalities`** — it only
  checks attempt ownership/status, response-version match, storage-path
  validity, and capture-object validation. It already accepts a photo
  capture for any attempt on any item today.
- No migration, function, or content record anywhere currently gates or
  allowlists capture eligibility per item. Every published item's
  `response_modalities` has only ever contained `typed-text`, `typed-math`,
  or `choice` — nothing capture-related has ever been set on any item, and
  nothing reads such a value to decide whether to allow a capture.

**Conclusion:** the default-everywhere posture requires no backend or
schema change — it's already true at the database level. The only place it
could still be missing is the Lovable frontend not rendering the capture
option on every FRQ, which is outside this repo/session's visibility. The
**suppression** mechanism the Owner described for later is genuinely new —
nothing today can suppress capture on a specific item — and is deferred,
correctly, as a small follow-up (e.g. a `capture_suppressed`-style flag on
`content_item_versions` or in `prompt_json`) rather than something needed
now.

**Engine 4/OCR-at-scale testing is being run on a separate thread** — this
decision and its content-authoring follow-ups stay out of that work's way;
nothing here duplicates it.

**Next Owner:** David Bloom.
**Next Required Action (revised):** confirm the Lovable frontend renders the
capture option unconditionally across FRQs (no repository access to verify
this session); build the per-item suppression flag when the first
known-non-viable item is identified, not before.

## DECISION-0048 — AP Statistics Hand-Drawn Practice Stays Supplemental; Chemistry/Physics/Calculus Get New Genuine Hand-Drawn-Capture Items

**Date:** 2026-08-18
**Decision Owner:** David Bloom
**Status:** Approved
**Related Docs:** `docs/research/HAND_DRAWN_RESPONSE_MIX_AUDIT_2026_08_18.md`, `scripts/content-seed/hand_drawn_expansion_chem_physics_calc_2026_08_18/`
**Area:** Content / Learning Quality

### Context

The same-day mix audit found AP Statistics' published hand-drawn item share
(57% of FRQs) far exceeds its real-exam exposure (the real exam is fully
digital with a built-in Desmos grapher, zero hand-drawn graphing), while
Chemistry (2.4%), Physics (~11% by a looser count, effectively 0% by genuine
capture-item count), and Calculus (0%) sit well under CED-documented weight
on graph/diagram-construction skills (Chemistry Practice 3, 8-16% FRQ weight;
Physics Translation-Between-Representations archetype, ~25% of FRQs, plus
every Physics FRQ being handwritten on the real exam; Calculus Practice 2,
10-20% FRQ weight).

### Decision

1. **AP Statistics' hand-drawn volume is not a defect and is not being
   reduced.** The Owner's framing: Cramapple's hand-drawn capture pipeline is
   being used deliberately as a stand-in for the real exam's digital Desmos
   graph-construction skill, since Cramapple has no Desmos-equivalent tool.
   The existing `supplemental_hand_drawn` tagging (documented in
   `AP_STATISTICS_2027_CED_FACT_PACK.md` §7) already captures this correctly
   — no change needed there.
2. **Chemistry, Physics, and Calculus need more hand-drawn-component
   questions.** Six new items authored this session (two per subject,
   `scripts/content-seed/hand_drawn_expansion_chem_physics_calc_2026_08_18/`)
   as a first, targeted batch — draft/unreviewed, not applied to any
   database (no live Supabase access this session).

### Scope note surfaced during authoring

The mix audit's Physics/Chemistry "hand-drawn" counts had conflated two
different things: genuine photograph-and-grade capture items
(`HDG-2026-*`, `expected_graph_spec`/vision-graded, the AP Biology/Statistics
pattern) versus older typed-text "describe or sketch the construct" items
(`apchem-sfrq-032`, several Physics `no_constructs` items) that accept a
typed derivation instead of a photo. Only Biology and Statistics had any
genuine capture items before this decision — this batch is the first
genuine hand-drawn capture content in Chemistry, Physics, or Calculus, not
an expansion of an existing capture pool in those subjects.

### Still open

Authoring ahead of the grading fix is accepted as fine; making these items
reachable by real students is not, per two combined findings: (1) the
same-day finding that the production-candidate grading method fails all four
DR-1 accuracy thresholds on real photos
(`HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md`), and (2) the firm,
standing policy that real student grading is always automated end-to-end —
there is no human-graded interim path. Humans are in the loop only for
engine development and calibration (audit, gold labeling, QA), never in the
live path, at any production authority stage (`ACTIVITY_LOG.md`, 2026-08-14).
`rubric_type: spatial` routing to `evaluator_strategy: human_shadow` in
`grading-router.ts` is a development/calibration shadow path despite its
name, not a way of serving real students. These six items therefore stay
fully unreachable by any student-facing selector until Engine 4 (automated
spatial grading) passes its accuracy bar — there is no safer intermediate
state to route them to instead.

**Next Owner:** David Bloom.
**Next Required Action:** Route the six draft items through Learning
Quality/subject-matter review, then apply via a proper migration once
approved; decide `practice_format`/taxonomy tagging, keeping them excluded
from any student-facing selector until Engine 4's automated spatial grading
is qualified.

## DECISION-0047 — Replace Activation-Limited Free Score Check with a 7-Day Full-Access Trial (TASK-0026)

**Date:** 2026-08-15
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0026 (supersedes TASK-0024)
**Area:** Product / Growth

### Context

The Free Score Check strategy doc
(`docs/strategy/CRAMAPPLE_FREE_SCORE_CHECK_IMPLEMENTATION_2026.md`,
2026-07-20) designed an activation-limited public offer (one FRQ, one
guided repair, one report, then paywall) around a student with roughly ten
days before an exam -- deliberately usage-limited rather than time-limited
("the offer does not expire after a number of days"). TASK-0024's
implementation of that offer never reached production
(`growth.free_score_check.v1.enabled` stayed `false` throughout its
build). By mid-August, with the school year just starting, that urgency
premise no longer held: there is no cramming scarcity to gate against, so
an activation-limited offer mostly added friction against a purchase
decision that has not become urgent yet.

### Decision

1. Replace the activation-limited Free Score Check with a 7-day,
   full-catalog (all 10 launch subjects), no-usage-cap trial, implemented
   as a new `access_tier='trial'` row on the existing
   `app.subject_entitlements` table / `app.authorize_grading_access` gate
   rather than a bespoke one-FRQ state machine.
2. Retire the FSC-specific machinery it replaces (`app.free_score_checks`
   table, `start_free_score_check` / `record_free_score_grade` RPCs, the
   `free-score-check` Edge Function and frontend routes) rather than run
   both models in parallel. Code preserved on
   `archive/free-score-check-2026-08-15` (both the Cramapple and
   exam-buddy-wireframe repos) for a future revival closer to exam season,
   not deleted outright.
3. Post-trial-expiry access is grace/read-only by design, not a new build:
   `attempts` / `response_versions` / `grading_results` SELECT policies are
   owner-scoped only (no entitlement check), so past work stays visible
   while new attempt creation is blocked by the existing entitlement-gated
   INSERT policy -- confirmed via production read-only verification before
   relying on it.
4. Lifecycle email (Loops) triggers off this event and its `ends_at`
   property, so trial-length changes do not require server-side timing
   logic to change in lockstep.

### Rationale

The report's original design already flagged the "unlimited trial could
satisfy the whole urgent use case before payment" risk as the reason to
avoid a time-only trial -- that risk is genuinely lower right now (low
urgency, early season) than it will be in spring, which is exactly why the
trade is being made now rather than as a permanent design. Reusing
`subject_entitlements` / `authorize_grading_access` unchanged (rather than
building new gating logic) meant the entire cutover required zero changes
to the actual grading-access gate -- verified directly against a real
production attempt from an existing `beta` account both before and after
the retirement migration.

### Consequences / Follow-ups

- `GRADING_ENTITLEMENTS_ENABLED` flipped to `true` in Production as part of
  this change -- see `APPROVAL-0044` for the corresponding approval and its
  relationship to `APPROVAL-0043`'s prior note on this flag.
- `docs/tasks/TASK-0024-FREE-SCORE-CHECK-LAUNCH-READINESS.md`, its
  cutover-evidence doc, and the FSC strategy doc are marked superseded, not
  deleted.
- The `returned_day_2` / `returned_day_7` PostHog cohort events (distinct
  from Loops' own journey timing) remain unimplemented, blocked on a
  `pg_net` enablement decision -- tracked in TASK-0026, not blocking trial
  launch.
- Full implementation detail, evidence, and open items in
  `docs/tasks/TASK-0026-SEVEN-DAY-TRIAL-AND-ENGAGEMENT-PROGRAM.md`.

## DECISION-0046 — Retire the ≤1000ms p50 Grading Latency Hard Gate; Launch Engines 1/3 Now and Iterate in Production Rather Than Wait for the Full Gold-Set Certification Gate

**Date:** 2026-08-14
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0016
**Area:** Product / Architecture

### Context

TASK-0016's original launch bar (owner-approved 2026-07-08, `APPROVAL-0033`)
set two hard numeric gates before any grading engine could go authoritative:
end-to-end latency ≤1000ms p50, and a 300+ dual-adjudicated gold-set
accuracy certification (per `CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.2).
Neither has been met, and by 2026-08-13 there was direct measured evidence
that the latency target specifically is not reachable with the current
architecture and model: non-model request overhead alone measures ~691ms
p50 (auth/DB/render, before any model call), and Arm A — the
per-criterion-parallel architecture expected to bring a 4-criterion FRQ from
~16s to ~4s — measured 22–31s medians on the actual production model
(`gpt-4.1-mini`) once tested on it directly (the original ~4s figure was
validated only on `gemini-2.5-flash`, a substitute model, per the handoff
doc's own "trap 1").

A second-opinion review (codex,
`prompts/SECOND_OPINION_ENGINE1_ENGINE3_GO_LIVE_PLAN_2026_08_13.md`)
identified this and four other structural problems with continuing to plan
around the original launch bar, and the owner reviewed that critique
directly in this session.

### Decision

1. **The ≤1000ms p50 hard gate is retired**, not merely deferred. Replaced
   with a two-SLA framing: time-to-acknowledgement (student sees a progress
   state immediately) and time-to-complete-feedback (full graded result
   rendered). Quality > Speed > Cost (owner decision, 2026-07-29) remains the
   governing priority order — this does not reopen that ordering, it
   accepts that the specific numeric latency target under that ordering was
   wrong given the actual model/architecture combination in use.
2. **Engine 1 and Engine 3 go live now** (Engine 1 authoritative once its
   evidence-grounding P0 fix ships; Engine 3 shadow-only, per its own
   structural ceiling — see TASK-0016's 2026-08-13 addendum) rather than
   waiting for the full 300+ dual-adjudicated gold-set certification. That
   certification continues in parallel as a dependency for later authority
   stages (per the addendum's five-stage production model), not as a
   pacing item blocking initial launch.
3. Recorded here, rather than only inside `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md`'s
   addendum, because item 1 reverses a numeric target from an original Hard
   Gate approval (`APPROVAL-0033`) — a durable, independently-findable
   decision record, not only a task-file edit. See `APPROVAL-0043` for the
   corresponding approval entry.

### Rationale

Continuing to plan around a latency target the system's own measurements
show is unreachable wastes engineering effort chasing a number rather than
the thing that number was a proxy for (a good student experience). The
two-SLA framing keeps the actual product concern (does the student know
something is happening; do they get their grade in a reasonable time)
without pretending a number invalidated by direct measurement is still the
bar. Waiting for full gold-set certification before any real-world signal
exists is also self-defeating on the current evidence: the two most
consequential accuracy findings this program has had (the `SFRQ-008` keyed
value defect, the evidence-grounding false-abstention pattern) were both
found through targeted live testing, not through gold-set volume — more
volume was not what moved either number.

### Consequences / Follow-ups

- `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md` amended in place
  (2026-08-13 addendum) with acceptance criteria struck/annotated
  accordingly.
- Non-model latency overhead (~691ms p50) becomes a Stage C/D-adjacent
  optimization workstream, not a launch blocker.
- The formal gold-set gate's cadence and what specifically unblocks each
  later authority stage is tracked in the addendum's five-stage model, not
  restated here.

## DECISION-0045 — Gold Sets Are Built by AI Generation + Multi-Model Verification + Reader Certification, and Partitioned by Grading Engine × Criterion Structure

**Date:** 2026-08-03
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0016 Phase C (cross-subject grading calibration)

**Problem.** The all-human gold-set authoring model
(`GOLD_SET_AUTHORING_GUIDE.md` v1.0) required ~330 answers at 12 min to write
plus 5 min to verify — roughly **94 hours of reader time**, against the roster
that is already the binding constraint on content review. It would not have been
completed, and an unbuilt gold set measures nothing.

**Decision, part 1 — production model.** Gold-set answers are **generated by AI**
and checked by **two independent non-OpenAI model families** before a reader sees
them. Reader effort moves off production and onto **certifying the pipeline**:

- Readers verify answers **cold** (no script, no verifier output, no grader
  output, no route indication), marking rubric elements present/absent — never
  points, never a score.
- Readers confirm **element decompositions** for multi-point criteria — the one
  step whose error would be invisible, since a bad breakdown corrupts all eight
  answers for an item identically.
- The automated path is certified by measuring its false-accept rate against a
  reader-verified sample, under a **pre-registered gate**: upper 95% bound ≤5%
  certifies; 5–15% requires diagnosis and re-pilot; >15% rejects the automated
  path and reverts to full reader verification.

Reader cost thereby **decouples from corpus size** — the audit sample is sized by
the required confidence bound (~100 answers per set), not by how many answers
exist.

**Decision, part 2 — independence constraint.** The grader under test is OpenAI
(`gpt-4.1-mini`, `gpt-5.5`). Therefore: no OpenAI model may write or verify
gold-set answers; no verifier may share a model family with the writer of the
answer it verifies; verifiers are blind to the script, the grader output, and
each other; and the writer never verifies its own output. A writer sharing a
family with the grader writes in the grader's idiom and destroys the A2 probe
(full credit in unconventional phrasing) — the probe that caught the grader
awarding full marks to only 7 of 10 complete answers. A verifier sharing a family
with the grader encodes the grader's own misreading as ground truth, and the set
then reports the grader as accurate regardless of its behaviour. **Three
non-OpenAI families are required**, since the writer consumes one and the
remaining two must reach unanimity.

**Decision, part 3 — set partition.** A gold set is a regression suite for a
**code path × rubric shape**, not for a subject. There is no per-subject gold
set, no "all physics" or "all calculus" set, and no science-vs-math split —
subject is a *stratum inside* a set, sized to catch subject-specific breakage.
Verified against Production `pcntajvbdfqhbeewmdry` on 2026-08-03, this yields
**two active sets, not seven**:

| Set | Engine / evaluator | Criterion structure | Population |
|---|---|---|---|
| **A** | 1 — `llm_discrete_text` | multi-point | Biology 36 items / 158 criteria; Chemistry 5 / 30 |
| **B** | 1 — `llm_discrete_text` | single-point independent | Physics ×4 35 / 113; Statistics 15 / 60; Precalculus 11 / 66 |
| **C** | 4 — `spatial` / `human_shadow` | single-point | Statistics 33 / 132 — deferred until Engine 4 leaves shadow |
| — | 3 — formula/ECF/symbolic | — | **zero published items**; no set until content routes there |

Every automated FRQ path in the published bank is Engine 1; Calculus AB/BC
(3 items) folds into Set A.

**Implementation.** Protocol: `docs/research/GOLD_SET_GENERATION_PROTOCOL.md`.
Reader guide rewritten to v2.0 (`docs/research/GOLD_SET_AUTHORING_GUIDE.md`) —
readers no longer author. Pilot pre-registration:
`docs/research/GOLD_SET_PILOT_STATS_PHYSICS_2026_08_03.md` (Set B; Jill on
Statistics, Saood on Physics; 14 items / 52 criteria / 112 answers; readers
verify 100% in the pilot because a false-accept rate cannot be estimated from a
sample of itself).

**Notes and limits.** The Set B pilot does **not** exercise element
decomposition (Set B has no multi-point criteria), so **Set A requires its own
certification pass** — a Set B pass does not license generating Biology
unsupervised. Every item available for the pilot is
`practice_format='targeted_drill'`; no `full_exam_frq` content exists in any
subject, so certification covers short drill items only. The pre-existing
standing rule is unchanged and load-bearing here: **the grader is never tuned on
a gold set** — cheap generation makes that more tempting, not less.

## DECISION-0044 — Universal Publication Rule (Double-Approve + AI QA, or Edit-Request Fixed by AI)

**Date:** 2026-08-02
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (publication governance; interacts with TASK-0017)

**Decision.** A question's latest active version is published when either:

- **Rule A:** it holds approvals from **two or more distinct, real, actively
  qualified tutors**, no conflicting tutor decision, **and** an AI QA approval
  recorded as an admin-profile decision on that same version; or
- **Rule B:** a tutor filed **approve_with_edits** anywhere in the item's
  review history **and the fix was applied by AI** (admin-authored successor
  version), the fix version carries no tutor non-approval, and an AI QA
  approval is recorded on the fix version.

This is a **universal, standing rule**, generalizing the one-off 2026-07-30
release (`20260730_publish_double_tutor_ai_qa_approved.sql`). Both rules keep
that release's structural gates (4 distinct MCQ choices with exactly one key
matching `canonical_answer_1`; FRQ criteria present with positive total
points; stimulus assets present; no competing published version). Items
failing a gate are skipped and reported, never silently published.

**Implementation.**
`scripts/content-seed/publication/20260802_decision_0044_universal_publish_rule.sql`
(sections 2–5 are the standing re-runnable rule; section 1 seeds the
2026-08-02 AI QA decisions). AI QA is represented in-database as an
admin-profile `approve` decision with `approval_basis` of
`two_qualified_tutor_approvals_plus_ai_qa` (Rule A) or
`approve_with_edits_fixed_by_ai_plus_ai_qa` (Rule B), always citing
`DECISION-0044` in the payload.

**Notes.** Rule B intentionally does not require a human re-read of the AI
fix; a tutor non-approval on the fix version blocks it. Disapprovals block
Rule A as conflicting decisions. The rule does not resurrect items whose only
decisions are disapprovals.

## DECISION-0043 — Operationalize Branch Hygiene R1–R7 (Trunk Protection, CI, Auto-Delete)

**Date:** 2026-08-01
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (governance)
**Area:** Operations

### Context

Rules R1–R7 were approved on 2026-07-26 (PR #54, squash `e535f06`). Sprawl recurred
within a week: 15 local branches, `main` unchanged since 2026-07-27, one branch 93
commits ahead.

**Audit of what was actually missing (2026-08-01).** Contrary to the working
assumption that "steps 5–9 are pending," verification against the live repository
found most of the mechanical enforcement already in place:

| Step | State before this decision |
| --- | --- |
| 4 — governance/docs adoption | **Missing.** The only genuine gap. |
| 5 — trunk protection | Already on: force-push blocked, deletions blocked, conversation resolution required, `enforce_admins: false` preserving human break-glass. |
| 6 — CI | Already on: `.github/workflows/minimal-ci.yml`, job `test`, passing. |
| 7 — required checks | Already on: `test` is a required context with `strict: true`. |
| 8 — auto-delete + auto-merge | Already on: `delete_branch_on_merge: true`, `allow_auto_merge: true`. |
| 9 — merge queue | Correctly not configured (conditional). |

This reframes the root cause. **Sprawl is not caused by a mechanical block** — no
gate is misconfigured, and CI passes. Work is not reaching `main` because nobody is
opening the PRs, which is a behavioural gap that R1–R3 address and that step 4 —
encoding the rules where agents and humans actually read them — was the missing
half of.

The cost is concrete, not theoretical. The AP Statistics CED fact pack —
`docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`, the sanctioned authoring input
gating G0A and therefore the entire approved Statistics rebuild — sat only on the
93-commit branch. It was invisible from `main` and was independently re-derived
more than once by sessions that could not see it.

The cost is concrete, not theoretical. The AP Statistics CED fact pack —
`docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`, the sanctioned authoring input
gating G0A and therefore the entire approved Statistics rebuild — sat only on the
93-commit branch. It was invisible from `main` and was independently re-derived
more than once by sessions that could not see it.

### Decision

Encode R1–R7 canonically in `docs/team_charter/AI_COLLABORATION_RULES.md`, and
enable the mechanical enforcement the rules assume:

1. **Canonical rules** live in `AI_COLLABORATION_RULES.md`; the proposal is demoted to evidence, not authority. No other document restates them.
2. **PR policy amended:** promotion to `main` is *always* by PR. The previous "Standing Approval work can merge directly" allowance is withdrawn — it is incompatible with the trunk protection already in force.
3. **Confirm and retain** the existing repository settings (steps 5–8) as the adopted configuration, now that they are documented rather than tacit.
4. **No merge queue** unless concurrent merges demonstrably cause stale-base problems.
5. **No custom privileged merge automation** — R5(c) stands unchanged.
6. **CI scope stays deliberately narrow.** `minimal-ci.yml` is retained as-is.

### Rationale

The recurrence proves the rules were never the missing piece and — per the audit
above — neither was enforcement tooling. What was missing is that the rules lived
in a proposal document nobody reads at session start, while the charter that agents
*do* read still said Standing Approval work could merge directly to `main`. The
charter actively contradicted the adopted policy.

CI is left alone on purpose. Proposal §5 specifies "one fast, deterministic,
secret-free workflow (not every checker blocking)," and `minimal-ci.yml` already
satisfies that. Broadening a *required* check is how required checks become flaky
and then get bypassed — the exact failure this decision exists to prevent. A
broader non-required workflow is available later if wanted: the full
`supabase/functions/_shared` suite is 83 tests in ~1s and every edge function
currently typechecks clean, both verified 2026-08-01.

### Consequences

- All work reaches trunk by PR. The charter no longer offers a direct-merge path,
  so the documented policy and the enforced configuration now agree.
- Merged remote branches disappear automatically; local cleanup stays manual and
  gated by the R7 three-check preflight.
- Unique unmerged work must be archive-tagged before deletion, not simply dropped.
- `enforce_admins` remains `false`. This is deliberate — it is the human-only
  break-glass R1–R7 requires. It also means an admin *can* still push directly to
  `main`, so trunk protection is a guardrail against accident, not a hard
  guarantee against a determined bypass.
- The one-time cleanup of the existing 15 branches (proposal §4) is **not** covered
  by this decision and remains outstanding; it must run from a clean checkout of
  `origin/main`, not from a dirty working branch.
- Because no gate was broken, expect no immediate mechanical change in merge
  throughput. If sprawl persists after this, the next lever is R3 enforcement
  (small, frequent PRs), not more tooling.

## Decision Format

```markdown
## DECISION-0000 — Decision Title

**Date:** YYYY-MM-DD
**Decision Owner:** David Bloom
**Status:** Proposed / Approved / Superseded
**Related Task:** TASK-0000 / N/A
**Area:** Product / Architecture / Security / Design / Operations / Integration

### Context

### Decision

### Rationale

### Consequences

### Risks / Follow-ups
```

## DECISION-0001 — Use GitHub as Cramapple's Durable Source of Truth

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0001
**Area:** Operations

### Context

Cramapple planning has begun in chat and in speculative blueprint documents. Durable project state needs a consistent home and operating workflow.

### Decision

Use the AI Project Operating Kit and store canonical documents, tasks, approvals, decisions, and activity records in `david-bloom/Cramapple`.

### Rationale

This prevents chat-only decisions, establishes approval boundaries, and allows human and AI collaborators to reorient from the same records.

### Consequences

GitHub documents override unrecorded chat memory. Earlier `Blueprint_*` files remain speculative inputs unless promoted through an approved decision.

### Risks / Follow-ups

The operating workflow may need simplification after practical use.

## DECISION-0002 — Product and Strategy Authority

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0001
**Area:** Operations

### Context

The project needs explicit authority for product decisions and a role for strategic planning.

### Decision

David Bloom is Product Owner and final approver. Add Strategy Advisor to work with David and the co-founders on plans and business decisions.

### Rationale

The team benefits from strong strategic challenge and planning support while preserving one clear final product authority.

### Consequences

The Strategy Advisor may recommend, draft, analyze, and challenge. The role may not independently approve product scope, execution, risk, Done decisions, or launch.

### Risks / Follow-ups

The named person or agent filling the Strategy Advisor role may vary and should be recorded when assigned.

## DECISION-0003 — Allow Qualified Estimated AP Score Guidance

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0002
**Area:** Product

### Context

The initial vision prohibited official AP score prediction but left the role of estimated scoring unresolved. Students need understandable guidance about their likely current range and what improvement could move them forward.

### Decision

Cramapple may provide estimated AP score ranges or readiness estimates when supported by sufficient evidence. Estimates must be clearly identified as non-official, express uncertainty, disclose important evidence gaps, and connect the estimate to concrete next actions.

### Rationale

Qualified estimates can make criterion-level feedback more useful and motivating while preserving a clear distinction between Cramapple guidance and official College Board scoring.

### Consequences

The grading and recommendation systems will need evidence thresholds, confidence rules, calibration datasets, versioned estimation logic, and monitoring for systematic error. A single response must not be presented as a definitive overall AP score.

### Risks / Follow-ups

- Define the minimum evidence required before displaying an estimate.
- Establish expert review and calibration standards before launch.
- Determine how estimated ranges should be updated as new performance evidence arrives.
- Validate customer-facing language with students, parents, tutors, and legal review.

## DECISION-0004 — High-Level Architecture Boundaries

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0003
**Area:** Architecture

### Context

Cramapple needs a durable architecture before detailed teaching, grading, data, and implementation designs. Earlier root-level blueprints move too quickly into preliminary schemas and provider-specific model routing.

### Decision

Adopt a high-level architecture organized around managed presentation and application services, Supabase as the proposed durable system of record, replaceable task-specific AI providers, versioned canonical content, durable learner evidence, separate teaching and grading responsibilities, first-class validator operations, and event-based marketing interoperability.

### Rationale

This establishes stable ownership and trust boundaries before committing to detailed schemas or vendors. It supports grading and teaching quality, low-code maintainability, cross-session learning, and additional AP exams.

### Consequences

- Detailed teaching and grading designs will be separate canonical documents.
- Student attempts remain durable while mastery, recommendations, and progress are derived and rebuildable.
- Validators require scoped entitlements and version-specific approval workflows.
- Marketing integrations receive approved events rather than sensitive learning content.
- User-provided questions remain isolated from canonical content.
- Parent progress is a future paid entitlement with separate relationship, consent, billing, and visibility checks.

### Risks / Follow-ups

- Detailed data, security, teaching, grading, and integration designs remain open.
- Managed-service boundaries must be tested against latency, cost, privacy, and seasonal load.
- Legal review is required for minors, uploads, official materials, and parent access.

## DECISION-0005 — Version Official Exam Facts Separately from Product Models

**Date:** 2026-06-10
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0004
**Area:** Architecture

### Context

Section weights, point distributions, task types, and curriculum ranges directly influence what Cramapple recommends. Scattering those facts through prompts or prose would make updates, review, and audit unreliable.

### Decision

Create a versioned Exam Specification Registry for official exam facts. Store Cramapple-derived weights, formulas, and predictions as separate records with explicit assumptions and model versions.

### Rationale

This prevents official facts from being confused with product inference and allows each school year's exam pack to be reviewed, activated, superseded, and audited.

### Consequences

- Every recommendation can identify the exam facts and derived model that influenced it.
- Source scope must be precise; for example, AP Biology unit ranges apply to the multiple-choice section.
- Exam changes can trigger impact analysis and revalidation.

### Risks / Follow-ups

- Source licensing and authorized-material rules require legal review.
- The physical schema and update workflow remain to be designed.

## DECISION-0006 — Adopt an Exam-Horizon Retrieval Pedagogy

**Date:** 2026-06-10
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0004
**Area:** Product

### Context

Cramapple's initial use case is approximately ten days before an AP exam. A year-long curriculum model does not fit this constraint, while passive cramming offers weak evidence of independent retrieval and transfer.

### Decision

Use attempt-first diagnosis, minimal targeted teaching, immediate transfer, delayed retrieval, deliberate interleaving, confidence calibration, and exam-value-aware recommendations as the teaching-system foundation.

### Rationale

The approach directs limited study time toward demonstrated gaps that appear teachable and valuable while preserving return visits before exam day.

### Consequences

- Weakness, improvability, and exam value are separate recommendation inputs.
- Explanations do not count as mastery without retrieval.
- FRQs are taught by task and criterion; CER is used where the scoring opportunity calls for argumentation.
- Student-facing recommendations explain their reasoning.

### Risks / Follow-ups

- AP Biology tutors must review the pedagogy before implementation or launch.
- Cramapple-specific intervals and effect claims require product validation.
- A detailed grading and calibration design remains open.

## DECISION-0007 — Use Evidence-Weighted Escalation Within One Learning Model

**Date:** 2026-06-10
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0004
**Area:** Product

### Context

A deterministic three-miss trigger, universal Sideways-first sequence, and generic learner-preference memory would create false precision and could waste limited study time.

### Decision

Use one per-assessable-target-and-facet learning-state model. Weight failure evidence by independence, variation, delay, and support; use discriminating probes to select Sideways, Apart, or Down; confirm intervention success through independent and delayed performance; offer Move On; and calculate Park return from exam horizon, frustration, and expected exam utility.

Anonymous student responses and outcome traces may be used to improve Cramapple's grading, teaching, content, evaluation, model configurations, and routing. Public publication remains separately gated and includes a signed-in-user proper-name sweep.

### Rationale

The model creates a rational, auditable policy without claiming certainty about hidden cognitive causes. Subsequent independent performance tests whether the selected intervention was useful.

### Consequences

- Learner state must preserve support level, route, immediate transfer, delayed retention, Move On, and Park evidence.
- The content graph needs prerequisite, component, representation, and transfer relationships.
- Validators need compact evidence packages for uncertain and repeated-failure cases.
- Demonstrated intervention effectiveness is specific to skill and task type.
- Legal terms and notices must describe anonymous improvement use.

### Risks / Follow-ups

- Entry weights, thresholds, and Park constants require pilot calibration.
- Counsel must finalize age, consent, retention, deletion, and jurisdictional requirements.
- Grading thresholds remain owned by the future grading design.

## DECISION-0008 — Define Skill Evidence, Learner Override, and Publishing Ownership

**Date:** 2026-06-11
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0004
**Area:** Product

### Context

The unified model required clearer boundaries for what counts as the same skill, how Frame affects evidence, who chooses interventions, when success becomes independent, and whether public question pages belong to learning or marketing.

### Decision

Use an assessable skill target composed of canonical operation, required knowledge or concept cluster, and substantive success criterion, with representation and support recorded as facets. Use Frame for both diagnosis and teaching, but classify evidence according to what the Frame reveals. Recommend interventions with visible alternatives and learner override. Treat per-target time and stronger success thresholds as research items. Assign public student-question publishing primarily to marketing/content while requiring pedagogical and grading release gates.

### Rationale

This avoids counters that are either too broad or question-specific, preserves the evidentiary meaning of assistance, and implements the principle that Cramapple guides without dictating. It also keeps private learning evidence separate from acquisition publishing while protecting educational quality.

### Consequences

- Learner evidence stores target identity, representation, support, Frame type, recommendation, and override.
- A supported attempt cannot become independent merely through relabeling; a fresh unsupported transfer attempt is required.
- The product may recommend Move On but does not enforce an unvalidated pedagogical time cap.
- Marketing owns public packaging and distribution; validators own teaching and grading quality approval.

### Risks / Follow-ups

- AP Biology tutors must validate target-equivalence examples.
- Product research must establish stable-improvement thresholds and time budgets by task type and exam horizon.
- Analytics must distinguish recommendation acceptance, override, and outcome without penalizing learner agency.

## DECISION-0009 — Adopt Content Governance and Validation Operating Policy

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0005
**Area:** Architecture / Operations

### Context

The approved architecture requires immutable versioned content, source and
rights provenance, separate teaching and grading validators, independent release
gates, atomic exam-pack publication, monitoring, revalidation, retirement,
rollback, and audit. Exact operating rules and thresholds were still open.

### Decision

Adopt `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` as the controlling
operating procedure for content and rubric governance after Learning Quality
Owner, counsel, and Product Owner review.

### Rationale

The policy makes release authority, reviewer independence, qualifications,
schemas, acceptance criteria, numeric quality thresholds, refresh schedules,
and revalidation scope explicit and auditable.

### Consequences

- Content and rubric releases use immutable versions and complete manifests.
- Teaching and grading have independent reviewer and evidence gates.
- Source and rights status can block use independently of educational quality.
- Model, prompt, rubric, source, and policy changes receive defined
  revalidation scope.
- Implementation requires separate approved technical, security, and data work.

### Risks / Follow-ups

- Numeric thresholds require expert review and pilot evidence before adoption.
- Counsel must review official-material, license, retention, and public-use
  boundaries.
- Validator staffing and cost must be tested against launch coverage.
- Physical schemas and workbench implementation remain separate tasks.

## DECISION-0010 — Use Paid Tutors for Original Question Authoring

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0005 / CONTENT-001
**Area:** Product / Operations

### Context

Cramapple needs a scalable original question bank. A proposed model would have
used historical College Board questions as seed material for a proprietary
question-making skill. That approach creates rights risk, derivative-content
risk, and weak accountability for question quality.

### Decision

Pay qualified tutors and subject experts to independently author original
questions and complete question packages from Cramapple coverage briefs.

Official historical questions and scoring materials are not seeds, adaptation
targets, few-shot examples, or generative-model inputs. Authorized humans may
review public official materials for abstract alignment where legally permitted,
but commissioned artifacts must be independently expressed.

Paid tutors create or sell Cramapple the base AP Biology packages. AI does not
draft base questions from official or third-party material. Controlled
versioning of Cramapple-owned or fully licensed packages is governed by
`DECISION-0011`.

### Rationale

Paid human authorship creates clear accountability, supports contractual
ownership and originality attestations, and separates exam familiarity from
copying or automated derivation. It also allows question quality to be improved
through structured author feedback without making official material part of the
production pipeline.

### Consequences

- Content coverage is commissioned from a coverage matrix rather than generated
  as a fixed number of derivatives per historical question.
- Tutor authors deliver complete question packages, not question text alone.
- Authors may revise but cannot approve their own work.
- Validation remains independent and includes scientific, teaching, grading,
  originality, provenance, and rights gates.
- Contracts must address compensation, confidentiality, originality, source
  disclosure, restricted materials, revisions, and IP assignment or license.

### Risks / Follow-ups

- Human authoring cost and throughput may constrain coverage.
- Tutor quality and writing skill will vary and require qualification.
- Independent similarity review is still required.
- Counsel must approve author agreements and official-material review guidance.

## DECISION-0011 — Define the Proprietary Question Bank and AI Versioning Model

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0005 / CONTENT-001
**Area:** Product / Operations

### Context

The paid-tutor model required decisions about bank coverage, MCQ and FRQ scope,
AI use, AP Reader eligibility, IP release, diagnostic lifecycle, and production
monitoring.

### Decision

- Use a human abstraction firewall. Official question text and scoring material
  do not enter the authoring or AI-versioning workflow.
- Include both MCQs and FRQs.
- Target at least ten approved questions for each subject-and-subtopic pair.
- Build the proprietary base set from Cramapple-authored and purchased question
  packages.
- Permit AI to create candidate variants only from proprietary packages for
  which Cramapple holds explicit adaptation, derivative-work, and model-input
  rights.
- Require a complete rubric and teaching package for every base question and
  every AI variant.
- Define an AP Reader Validator as someone who served as an AP Biology Reader
  in at least one of 2024, 2025, or 2026 and also meets the applicable Cramapple
  validator qualification.
- Use a simple counsel-approved release for authors, sellers, and AP Reader
  reviewers.
- Allow diagnostic questions to graduate to teaching use or be retired through
  a governed lifecycle decision.

### Rationale

This creates a coverage-driven proprietary bank while preserving human
accountability, contractual rights, exam authenticity, and independent
validation. AI expands owned content rather than deriving content from official
questions.

### Consequences

- AI variants are new immutable artifacts and do not inherit base approval.
- Superficial reskins do not count toward coverage targets.
- Question performance is monitored by version and intended use.
- Performance evidence opens review but does not automatically change item
  status until sample and decision thresholds are approved.
- AP Reader status does not authorize disclosure or use of secure material.

### Open Gates

- Minimum student sample and evidence thresholds for changing or retiring an
  item.
- Independent holdout set and passing thresholds for AI-versioning changes.
- Permitted sources and rights rules for graphs, datasets, experimental
  contexts, passages, and images.
- Final counsel-approved release language.

### Supersession Note

The quantity language in this decision is superseded by `DECISION-0014`, which
uses all 60 official topics and sets separate MCQ, short-FRQ, and long-FRQ
planning targets.

## DECISION-0012 — Require Local Documents to Be Synchronized to GitHub

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A
**Area:** Operations

### Context

GitHub is Cramapple's durable source of truth, but project documents can still
be created or revised locally before they are pushed.

### Decision

Every project document retained in the local Cramapple workspace must also be
committed and pushed to `david-bloom/Cramapple`. A local-only document is not a
durable project record.

Temporary renders, caches, editor files, and operating-system metadata are not
project documents and should remain untracked.

### Rationale

This prevents source-of-truth drift, preserves work across machines and agents,
and ensures project decisions can be reconstructed from GitHub.

### Consequences

- Agents include all retained project documents in the relevant commit.
- Synchronization is complete only after the commit is pushed and the remote
  branch is verified.
- Any document that cannot be pushed must be reported explicitly.
- `.DS_Store` and comparable machine-local files are excluded.

### Risks / Follow-ups

- Sensitive information must not be placed in project documents merely to
  satisfy synchronization; secrets and protected data require approved secure
  storage.

## DECISION-0013 — Make Markdown the Default Project Document Medium

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A
**Area:** Operations / Documentation

### Context

Cramapple has accumulated Markdown, Word, RTF, spreadsheet, and other document
formats. Maintaining ordinary project documents in multiple editable formats
creates synchronization work and ambiguity about which copy governs.

### Decision

Markdown (`.md`) in GitHub is the default and canonical medium for project
documents.

Google Docs is the preferred secondary format when live collaboration,
comments, suggestion mode, or a cloud backup copy is useful. Accepted changes
must be incorporated into the canonical Markdown file.

Word (`.docx`) should be avoided unless a specific external recipient,
submission, printing, or layout-fidelity requirement makes it necessary. A Word
document must be derived from a canonical source and must not become an
independent competing source.

### Rationale

Markdown is easy to review, compare, version, search, and maintain in GitHub.
Google Docs supports human collaboration without replacing the source of truth.
Limiting Word documents reduces duplicate maintenance and format drift.

### Consequences

- Agents create ordinary durable project documents as Markdown by default.
- Google Docs are collaboration or backup copies, not authoritative records.
- Accepted Google Docs edits return to Markdown and GitHub.
- Existing Word snapshots may remain, but they are not refreshed by default.
- New or updated Word deliverables require a specific format need.
- Artifact-native formats such as spreadsheets, images, presentations, and
  executable source files remain appropriate when Markdown cannot represent the
  artifact itself.

### Risks / Follow-ups

- A Google Docs backup process and link registry may be defined later if needed.
- External stakeholders may occasionally require Word, PDF, or another format.

## DECISION-0014 — Adopt Corrected AP Biology Coverage and Diagnostic Direction

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0005 / CONTENT-001A
**Area:** Product / Content Operations / Architecture

### Context

Claude proposed a useful coverage model but calculated the bank using 48
topics. The current official AP Biology Course and Exam Description contains 60
topics, and the proposed table was internally inconsistent. The review also
identified unresolved definitions for inventory counting, pre-confirmation
diagnostic use, automated lifecycle changes, and physical database timing.

### Decision

- Use all 60 official public AP Biology topics as Cramapple's coverage taxonomy.
- Target at least ten approved MCQs and five approved short-FRQ prompts for each
  topic.
- Target four long-FRQ stimulus packages per unit, with two independently
  deliverable prompts per package.
- Count one MCQ or one independently delivered and answered FRQ prompt as one
  inventory item.
- Treat 964 items as the corrected full planning target: 600 MCQs, 300
  short-FRQ prompts, and 64 long-FRQ prompts.
- Work to meet or exceed the target; any launch shortfall requires a visible
  coverage-gap report, Learning Quality review, and Product Owner decision.
- Permit independently expert-curated diagnostic candidates to be used with
  students before empirical confirmation.
- Require statistical item signals to open human review. They do not
  automatically demote, retire, revise, or publish an item.
- Defer physical Supabase or Postgres design until the logical governance model
  and application architecture are approved.

### Rationale

The official taxonomy gives Cramapple a stable public alignment layer. Separate
targets for MCQs and FRQs support focused practice without confusing inventory
count with package workload. Human review preserves governance authority when
early item statistics are noisy or assignment is adaptive. Deferring physical
DDL prevents a premature schema from weakening immutable content, independent
approval, audit, and atomic-release requirements.

### Consequences

- `CONTENT_QUANTITY_AND_DISTRIBUTION.md` is the controlling planning matrix.
- The prior ten-total-questions quantity in `DECISION-0011` is superseded.
- The initial Claude patch and its 784-item calculation must not be applied.
- Diagnostic candidates may serve learners before statistical confirmation,
  while remaining clearly classified as expert-curated candidates.
- A later physical-schema task must implement the approved logical contracts
  rather than replacing them with mutable rows or direct approval booleans.

### Open Gates

- Learning Quality review of topic-level feasibility and content variety.
- Beta-launch coverage threshold and prioritization if 964 items are incomplete.
- Minimum sample sizes and statistical methods for item-performance review.
- AI-variant holdout policy and permitted source/asset rules.

## DECISION-0015 — Adopt a Governed Four-Lane Visual Architecture

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0006
**Area:** Architecture / Product / Accessibility / Content Operations

### Context

The initial visual proposal recommended structured product-rendered data
visuals, prose fallback for diagrams, and deferral of image generation. Review
found that this direction reduces rendering risk but does not fully preserve
visual-assessment validity, accessibility equivalence, diagram coverage,
versioning, rights, or learner-created graphing.

### Proposed Decision

- Use deterministic structured rendering for semantic tables and common
  quantitative charts.
- Use governed human-authored assets or constrained domain renderers for
  diagrams, trees, models, and experimental setups.
- Require an accessible companion or separately validated equivalent for every
  visual.
- Do not silently replace a visual-dependent task with prose.
- Defer free-form generative scientific images from production.
- Treat learner-created graphing as a separate assessment capability.
- Define vendor-neutral logical artifacts before physical database design or
  renderer selection.

### Rationale

Visual interpretation and graph construction are assessed operations, not
presentation details. The architecture must give learners access without
revealing the answer or changing the skill being measured. Immutable visual,
dataset, accessibility, and renderer dependencies also preserve audit and
revalidation integrity.

### Consequences

- The 964-item content plan requires a representation audit.
- Common charts and phylogenetic trees become the first proposed prototypes.
- Semantic HTML is preferred for tables.
- Renderer upgrades require corpus-wide regression testing.
- Missing or unsupported visual equivalents fail closed.

### Risks / Follow-ups

- Product Owner direction is required on the five decisions in `TASK-0006`.
- Learning Quality, accessibility, and counsel reviews remain required.
- Graph construction may need a larger minimum viewport than chart viewing.
- Renderer and physical-schema decisions remain deferred.

## DECISION-0016 — Reject the Official-Derived Candidate and Use Abstract Failure Cards

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0007
**Area:** Content Operations / Rights / Quality

### Context

A proposed MCQ identified an official question as its source and changed the
organism, setting, and values. The same review found consequential quality
failures in other candidate questions.

### Decision

- Reject the official-derived item completely.
- Do not store it in the Cramapple repository, prompt library, exemplar pool,
  model inputs, evaluation sets, or production content.
- Preserve useful lessons from flawed candidates only as abstract failure cards
  and independently authored synthetic regression cases.
- Do not retain the original wording, distinctive scenario, organisms, values,
  answer choices, or source locator in an anti-example corpus.

### Rationale

Numerical and organism substitutions remain adaptation and violate the approved
human abstraction firewall. Abstract failure cards preserve quality lessons
without creating rights, contamination, or prompt-anchoring risk.

### Consequences

- The reviewed ZIP patches are not applied.
- Initial failure cards cover missing data, duplicate distractor logic,
  underdetermined predictions, omitted causal links, unsourced specificity,
  pseudoreplication, undefined thresholds, and exam-format mismatch.
- Future contaminated artifacts require documented scope review and exclusion.

### Risks / Follow-ups

- Counsel must define retention and deletion rules for contaminated working
  material outside the canonical repository.

## DECISION-0017 — Test Alternative Authoring Models Without Changing Production Policy

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0007
**Area:** Product / Content Operations / Experimentation

### Context

The reviewed proposal implicitly replaced paid tutor authorship with
AI-generated base questions seeded by exemplars. The potential quality, speed,
cost, and scaling differences are worth measuring, but an implicit replacement
would bypass approved governance.

### Decision

- Keep paid qualified tutors as the production base-package authors.
- Run a controlled validation-only experiment comparing tutor-first, AI-first
  with paid tutor revision, and AI-first with independent validation.
- Give all arms the same blank governed briefs, approved factual sources,
  package contracts, and independent gates.
- Prohibit official questions, adaptation descriptions, contaminated content,
  and evaluation holdouts from every arm.
- Do not count experimental items toward production coverage or publish them
  without a later Product Owner decision.

### Rationale

A blinded comparison can test the business model without allowing cost or speed
to override originality, scientific accuracy, educational quality, grading
reliability, accessibility, or accountability.

### Consequences

- `CONTENT_AUTHORING_MODEL_EXPERIMENT.md` controls the pilot design.
- Experiment execution still requires Learning Quality, counsel, participant,
  data-capture, and budget gates.
- Pilot success authorizes analysis, not production use.

### Risks / Follow-ups

- Validator labor can hide the true cost of weak AI drafts.
- Small pilot samples cannot establish broad equivalence.
- Long FRQs require a later replicated phase.

## DECISION-0018 — Use Versioned Prompt Build Manifests

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0007
**Area:** Architecture / Content Operations

### Context

The reviewed multi-subject proposal correctly separated shared, subject, and
question-type concerns but proposed loosely concatenating Markdown files and
premature physical database changes.

### Proposed Decision

Use immutable prompt build manifests that resolve universal governance, exam
pack, taxonomy schemes, task archetype, coverage brief, permitted sources or
base packages, output contract, failure-card suite, and model configuration.
Keep Markdown as the human-reviewable source while a deterministic compiler
records the ordered components and final prompt hash.

### Rationale

This preserves reviewability while making prompt assembly reproducible,
testable, provider-independent, and compatible with multiple parallel
taxonomies and future subjects.

### Consequences

- Multi-subject support remains logical rather than physical.
- External pipeline services, not model self-critique, own authoritative
  verification.
- Physical Supabase design remains deferred.

### Risks / Follow-ups

- The compiler and manifest schema require a later approved implementation
  task.

## DECISION-0019 — Create a Clean Proprietary Replacement Exemplar

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0008
**Area:** Content Operations / Rights

### Context

The rejected official-derived candidate left the authoring workflow without its
intended first MCQ exemplar.

### Decision

Create a replacement from a blank governed brief through a paid qualified tutor
who has not received the rejected candidate or its source description. The new
package must pass the complete originality, rights, scientific, teaching,
grading, accessibility, and exemplar-admission gates.

### Consequences

- The rejected candidate is not repaired or used as inspiration.
- Approval as production content does not automatically approve use as a model
  exemplar.
- `TASK-0008` owns the replacement workflow.

## DECISION-0020 — Reconcile Schemas Before Physical Database Design

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0009
**Area:** Architecture / Data Governance

### Context

The reviewed Supabase proposals contain useful entities but use mutable content
rows, approval booleans, direct state updates, and cascade deletion that
conflict with approved governance.

### Decision

Create a conceptual reconciliation model mapping useful schema concepts to
immutable artifact versions, append-only reviews and lifecycle events,
rebuildable projections, reusable stimulus packages, and atomic release
manifests. Do not create or approve physical DDL until reconciliation passes.

Text-only visual storage is not accepted as the permanent approach. Authoring
may proceed against logical stimulus-package Markdown and JSON contracts while
physical design remains deferred.

### Consequences

- The archive schemas are inputs to analysis, not canonical schemas.
- `TASK-0009` precedes physical Supabase design.
- Structured visual work does not need to wait for DDL.

## DECISION-0021 — Develop MCQ and FRQ Authoring Simultaneously

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0007
**Area:** Content Operations

### Context

The reviewed proposal deferred FRQ implementation until MCQ authoring reached
coverage. That sequence would delay discovery of grading, visual, and graphing
risks.

### Decision

Run coordinated MCQ and FRQ authoring workstreams simultaneously. Share
governance and infrastructure, but preserve separate package contracts and
independent gates.

All currently reviewed FRQs remain unapproved candidates. Tutors and AP Reader
Validators may edit them into new immutable versions or drop them.

### Consequences

- Neither question form blocks initial architecture work on the other.
- Candidate FRQs are not exemplars, calibration evidence, or production
  content.
- The first vertical slice includes MCQ, short FRQ, and long FRQ packages.

## DECISION-0022 — Research Paper-First Handwritten Graph Capture

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved for Research
**Related Task:** TASK-0011
**Area:** Product / Assessment / Accessibility

### Context

A general digital graph editor would be complex and may be less authentic than
paper graph construction.

### Decision

Prefer paper-first graphing and research a QR-linked secure phone camera flow.
The system may assist with image quality and feature extraction, but uncertain
graphs require retake or human review.

### Consequences

- Digital drawing is not the default graph-construction plan.
- Production use requires upload-security, privacy, accessibility, usability,
  and held-out grading validation.
- `TASK-0011` is a research placeholder, not implementation approval.

## DECISION-0023 — Resolve Official Exam Dates from the Exam Specification

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** UX-001
**Area:** Product / Architecture

### Context

The first-run UX asked students to enter the date of a standardized AP exam
whose official schedule is already known to Cramapple.

### Decision

Resolve and display the official date from the active versioned exam
specification. Ask the learner to confirm registration status instead of
entering the date.

### Rationale

The exam authority, not the learner, defines the official date. Treating it as
system data removes avoidable input burden and prevents conflicting dates while
still capturing the learner-specific fact that affects reminders and planning.

### Consequences

- Learner setup stores registration status, not a user-entered official date.
- The UX supports registered, not registered yet, and unsure states.
- Missing official-date data is a system-data problem and must not be shifted
  to the learner.
- Registration itself remains outside Cramapple and occurs through a school or
  AP coordinator.

## DECISION-0024 — Use Staged Tutor and AP Reader Candidate Review

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved for UX Design
**Related Task:** UX-002
**Area:** Product / Content Operations

### Context

Cramapple needs a simple reviewer workflow for deciding whether original
question candidates and MCQ answer options should advance, be revised, or be
excluded.

### Decision

Use two independent tutor scores of 1 Yes, 2 Maybe, or 3 No. Sum the locked
tutor scores: aggregate 2 advances to AP Reader review, aggregate 3 reserves a
new version for modification and reassessment, and aggregate 4-6 excludes the
current version.

Use AP Reader scores of 1 Approve, 2 Edit and recycle to two tutors, and
3 Exclude. Apply the same staged review independently to each of the four MCQ
answer options after the question passes question review.

### Rationale

The model is easy to teach, preserves two independent tutor judgments, creates
a clear expert escalation, and prevents edits from inheriting approval.

### Consequences

- Any excluded answer excludes the current four-option MCQ package.
- All four answers must pass before answer review is complete.
- Edits create new immutable versions and reset the affected review.
- Every question receives two tutor difficulty labels; a question reaching AP
  Reader review receives the third label.
- Exact agreement confirms difficulty; disagreement creates a discussion item.
- This workflow decides candidate disposition and does not replace downstream
  content-governance or release gates.

## DECISION-0025 — Use a Verified Five-Stage Outside-Question Intake

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved for UX Design
**Related Task:** UX-004
**Area:** Product / Learning / Trust

### Context

Students may bring incomplete, photographed, copyrighted, personally
identifying, off-subject, or actively assessed questions. A single text box
does not provide enough context or trust handling.

### Decision

Use five stages: add the question, confirm capture, confirm match, choose help,
and review before beginning. Support typed/pasted, photo/screenshot, and
document concepts. Use one clarification round for missing context or relevance
and disclose confidence before teaching or grading.

### Rationale

The staged flow preserves the student's real intent while preventing extraction
errors, missing context, and uncertain classification from silently becoming
confident teaching or scoring.

### Consequences

- Check My Work requires the learner's attempted answer.
- Low-confidence matches avoid authoritative scoring.
- External questions remain isolated from canonical content.
- Anonymous improvement and public publication remain separate.
- A conservative active-assessment prototype limits solution and answer-check
  behavior, but final enforcement awaits the approved academic-integrity
  policy.
- Photo and document implementation remains blocked on upload security,
  privacy, rights, retention, and provider decisions.

## DECISION-0026 — Separate Authoring, Revision, and Independent Review

**Date:** 2026-06-15
**Decision Owner:** David Bloom
**Status:** Approved for UX Design
**Related Task:** UX-003
**Area:** Product / Content Operations / Rights

### Context

UX-002 can reserve or recycle a question or answer version, but it previously
had no designed interface where an author could receive the task, revise the
complete package, preserve provenance, and return a successor version for
reassessment.

### Decision

Use UX-003 as a content authoring and revision workbench. It owns assigned-work
acknowledgement, complete MCQ and FRQ package editing, document import,
reviewer-comment response, immutable version comparison, provenance and rights
capture, preflight, and resubmission.

Keep UX-002 as the independent scoring and disposition surface. Qualified users
may switch between modes, but cannot review work they authored, revised, or
collaborated on.

Renumber the student-provided question intake to UX-004.

### Rationale

This gives recycled review outcomes an operational destination while preserving
reviewer independence, immutable history, complete-package integrity, and
rights controls.

### Consequences

- Tutor aggregate 3, AP Reader score 2, and revision outcomes create UX-003
  tasks.
- Resubmission creates a new immutable version and returns it to the required
  reassessment queue.
- Autosaves remain drafts and are not version history.
- Reviewer comments remain immutable; authors attach responses and changes.
- Provenance and rights checks can block submission without implying counsel
  approval.
- UX-004 now identifies student-provided question intake.

## DECISION-0027 — Adopt Charter Simplification and Tiering (Pilot: Cramapple Only)

**Date:** 2026-06-23
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (governance/process)
**Area:** Operations

### Context

The AI Project Operating Kit, in production use on Cramapple and PassTo, had accumulated real friction: heavy approval ceremony routed entirely through the Product Owner, duplicated guidance across charter docs (most visibly the sync handshake, repeated near-verbatim in five files), self-reported "synced"/"done" claims with nothing checking them, and unrotated logs already running to 1,000+ lines. Two independent reviews (`docs/proposals/2026-06-14-team-charter-improvements.md` and `docs/proposals/2026-06-23-kit-simplification-memo.md`) converged on largely the same diagnosis but had six unreconciled points of conflict between them.

### Decision

Adopt, into Cramapple's `docs/team_charter/` only (the public `ai-project-operating-kit` repo is explicitly out of scope for this decision):

- The full content of `docs/proposals/2026-06-23-kit-simplification-memo.md`.
- Proposals 1, 2 (recording structure/SLA substrate, not its deferred automation), 3, 4, 5 (reconciled), 7, 8 (reconciled), and 9 of `docs/proposals/2026-06-14-team-charter-improvements.md`.
- Not adopted: Proposal 6 and Proposal 10 of the 06-14 proposal — out of scope, not depended on by the simplification memo.

Conflict resolutions (see `APPROVAL-0022` for full detail): the 6-state status taxonomy wins over keeping `QA Passed`/`QA Blocked` distinct, with Proposal 5's actual safety property (only the Main Conductor closes a task) preserved as a role rule; `APPROVALS_LOG.md` stays a separate file rather than merging into `DECISIONS_LOG.md`, since Proposal 2's structure is the substrate the new Standing-tier SLA depends on.

### Rationale

Both proposals identified the same root cause from different angles: high-stakes process machinery was being applied uniformly regardless of actual risk. The fix is conditional rigor, not less rigor — ambiguous-but-reversible work gets a clarifying question instead of an automatic hard gate; domain-specific decisions go to a named delegate instead of always to the Product Owner; small reversible work skips ceremony it doesn't need; sync claims get a real check instead of a narrated one; and the two governance docs that disagreed on six points needed to be reconciled before either was implementable, not adopted independently.

### Consequences

- Seven `docs/team_charter/` documents changed; `SKILLS_GUIDE.md` renamed to `TOOL_AND_INTEGRATION_GUIDE.md`; two new files added (`CHANGELOG.md`, `scripts/verify-sync.sh`); both new-session prompts updated; `docs/tasks/TASK_TEMPLATE.md` gained a `Tier` field; all three activity logs gained an index block and a stated (not yet executed) rotation rule.
- Existing tasks and log entries are **not** retroactively rewritten onto the new status vocabulary or tiering scheme — old entries read under the rules in force when they were written.
- The public `ai-project-operating-kit` repository is untouched. Upstreaming is a separate future decision, contingent on this pilot working in practice.

### Risks / Follow-ups

- Two leading indicators should be watched for a few weeks: hard-gate escalations per week, and QA round-trips per task. No tooling collects these automatically yet — this is currently a manual read of `APPROVALS_LOG.md` and `DECISIONS_LOG.md`.
- `DECISIONS_LOG.md` is already roughly double its newly-stated rotation threshold (~600 lines); the first archive pass is overdue and not done as part of this decision.
- Proposal 2's batch-approval expiration automation, Proposal 6, and Proposal 10 (Cross-Agent Notes) remain candidates for separate future decisions.
- This decision does not authorize pushing any of this work to `github.com/david-bloom/ai-project-operating-kit`.

## DECISION-0028 — Auto-Trigger QA and Model Routing (Codex Proposal Folded In)

**Date:** 2026-06-23
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (governance/process)
**Area:** Operations

### Context

`docs/proposals/2026-06-23-agent-routing-and-qa-proposal-for-claude.md` (Codex) observed that the charter adopted under DECISION-0027, while reducing approval ceremony, still left QA-triggering and model selection as things someone had to remember to ask for, rather than automatic workflow steps — a residual source of avoidable waiting.

### Decision

Fold into `AGENT_OPERATING_MODEL.md`:

- The Main Conductor auto-triggers QA for any `Standard`/`Hard-Gate` tier task reaching `Ready for Review`; `Micro` tier QA remains optional at the conductor's judgment.
- The Main Conductor auto-applies the Model and Effort Policy per agent call rather than asking the Product Owner to pick a model each time.
- Explicit good-use/bad-use guidance for spawning additional agents, and three new Anti-Patterns reflecting the above.

The proposal's guardrail requiring the orchestrator to record which model was used and why on every call was narrowed to: record only on deviation from the default tier.

### Rationale

Auto-triggering QA and model selection removes waiting without removing any approval boundary — QA was already Lane 1 standing-approved, this just makes it fire automatically instead of on request, and model choice was never itself a hard-gated decision. Recording every routine model choice would have reintroduced exactly the ceremony DECISION-0027 was trying to remove; recording only deviations keeps the audit trail useful instead of noisy.

### Consequences

- `AGENT_OPERATING_MODEL.md` gains explicit auto-trigger language in the Main Conductor and QA Agent sections, a narrowed recording requirement in Model and Effort Policy, agent-spawning good-use/bad-use guidance in the Default Pattern section, and three new Anti-Patterns.
- No change to any Hard Gate, Standing Approval Lane, or Delegated Domain Approval boundary from DECISION-0027 — this decision is additive process automation, not a new approval grant.

### Risks / Follow-ups

- If auto-triggered QA produces a backlog of QA work outpacing available QA-agent capacity, revisit whether `Standard` tier should auto-trigger QA at the same rate as `Hard-Gate` tier, or whether `Standard` should batch.
- Same success metrics as DECISION-0027 (hard-gate escalations/week, QA round-trips/task) apply; no new metric introduced for this decision specifically.

## DECISION-0029 — ALLOWED_ORIGINS Required in All Environments; No Wildcard CORS Fallback

**Date:** 2026-06-21
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0012
**Area:** Security

### Context

PR #14 introduced an `ALLOWED_ORIGINS` env-driven allow-list in
`supabase/functions/_shared/cors.ts`. The first cut kept a wildcard
fallback (`Access-Control-Allow-Origin: *`) when the env was unset, on
the rationale that dev / local convenience was worth the production risk
of a missed deployment checklist item.

QA flagged the wildcard fallback as a real production footgun. With no
code-level guard, a production deploy without `ALLOWED_ORIGINS` would
silently send `*` and weaken defense-in-depth against CSRF-style abuse
from rogue origins.

### Decision

`ALLOWED_ORIGINS` is required in every environment (production, beta,
preview, local dev). The Edge Function `_shared/cors.ts` module fails
fast at load time if the env is unset or parses to an empty list. There
is no wildcard fallback path in the code.

Local-dev convention:

```
ALLOWED_ORIGINS=http://localhost:5173,http://localhost:3000,https://cramapple-beta.lovable.app
```

### Rationale

- Production wildcard CORS is a real risk; the dev cost of setting one
  env var is trivial.
- Eliminating the conditional removes a class of operational error
  (forget the checklist item, ship wildcard to prod).
- Non-browser callers (curl, server-to-server, CI) don't need CORS
  headers and are unaffected by the strict policy.

### Consequences

- All Cramapple deploys (Supabase Edge Functions in production and dev,
  any future preview environment, local Supabase) must set
  `ALLOWED_ORIGINS` before functions can start. The function will throw
  `Missing required environment variable: ALLOWED_ORIGINS` at module
  load otherwise.
- The `corsHeaders` legacy export with `Access-Control-Allow-Origin: *`
  has been removed; nothing in the repo imported it.
- The deployment checklist gains one mandatory env var per environment.

### Risks / Follow-ups

- First-time local-dev setup must include the env. Document in any
  developer-onboarding instructions (no such doc exists yet — when one
  lands, the env example above belongs in it).
- Future preview / staging environments need their origins added.
- This decision does not address Decision 2 (failed/rejected grading
  and the daily budget cap), which remains pending owner direction.

## DECISION-0030 — Failed/Rejected Grading Burns the Daily Budget Cap When Cost Is Known

**Date:** 2026-06-22
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0012
**Area:** Cost control

### Context

`app.complete_model_usage` (introduced in `202606210004_daily_budget_row_lock.sql`)
burned `actual_cost_usd` against `OPENAI_DAILY_CAP_USD` only when a
grading call completed successfully. Any `failed` or `rejected`
outcome burned `0`, regardless of whether the provider call had
already incurred a real, known cost (e.g. OpenAI returned a billable
response but Cramapple's own downstream validation then rejected it).
This under-counted real spend against the daily cap.

### Decision

`app.complete_model_usage` now burns cost as follows:

- `completed` — burns `actual_cost_usd` (unchanged).
- `failed` / `rejected` with a non-null `actual_cost_usd` — burns
  `actual_cost_usd`.
- `failed` / `rejected` with a null `actual_cost_usd` — burns `0`
  (caller has no cost data to report; the provider call may never have
  happened).

Implemented in
`202606210010_complete_model_usage_burn_known_cost_on_failure.sql`.
Reservation-release behavior (`reserved_cost_usd` reduction on the
`app.daily_budgets` row) is unchanged.

### Rationale

- `OPENAI_DAILY_CAP_USD` should track real provider spend, not just
  spend on calls that happened to finish cleanly. A failed call that
  still cost money is still money spent.
- Burning `0` only when the cost is genuinely unknown avoids inventing
  a cost figure for calls that never reached the provider.

### Consequences

- Grading calls that fail after the provider responds (with usage
  data) now reduce remaining daily budget headroom.
- `supabase/functions/evaluate-attempt/index.ts` is unaffected by this
  migration — it already passes whatever `actual_cost_usd` it computed
  (defaulting to `0` if the provider call never returned usage), so no
  Edge Function change was required.

### Risks / Follow-ups

- Failed rows that complete with a null `actual_cost_usd` are not
  reconciled against provider billing by this migration. That
  reconciliation should happen during production monitoring — compare
  `app.model_usage_ledger` against the OpenAI usage dashboard/API — not
  be guessed at here.
- No real Postgres instance was available to apply this migration
  (Docker/Colima/Podman unavailable in this environment); verification
  was `deno check` / `deno fmt --check` (no Edge Function files
  changed) plus manual schema cross-reference against
  `202606210004_daily_budget_row_lock.sql` and
  `202606210008_reserve_model_usage_race_fix.sql`.

## DECISION-0031 — Launch AP Statistics as Subject 2, Reusing the Tutor-Authored Content Model

**Date:** 2026-06-30
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0013
**Area:** Product / Architecture / Operations

### Context

Cramapple's architecture was designed for multiple subjects
(`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §6, `app.subjects` schema
normalization) but only AP Biology is built and live. David requested an
assessment of which AP subject — among AP Statistics, AP Calculus AB, and AP
English Literature (Orly's subjects this year) and AP World History (Micah's)
— is the closest technical match to AP Biology, then asked for a launch plan.

### Decision

1. AP Statistics is Subject 2. It ranked closest to AP Biology on
   grading-architecture reuse: criterion/rubric-scored FRQs with quantitative
   thresholds (same scoring shape as Biology's FRQ criterion contracts), and
   it needs a verification technique (deterministic calculation checks)
   already named but unbuilt in §7, rather than a wholly new grading
   paradigm (e.g. holistic essay scoring, which AP English Literature would
   require).
2. Content sourcing reuses the existing tutor-authored-base-package model
   (TASK-0007/0008) under Orly — no new authoring arm.
3. The pilot content batch follows AP Statistics' 9-unit structure with
   per-unit MCQ/FRQ counts David provided (71 MCQs / 33 FRQs total across
   units 1–9; investigative-task form and count still TBD — see
   `TASK-0013-AP-STATISTICS-LAUNCH.md` Approval State for the full table).
4. Existing reviewers can be cross-credentialed across subjects, including
   AP Statistics — no new tutor pool required for the review/calibration
   pipeline.
5. Rights/licensing posture is unchanged from AP Biology: no official
   CollegeBoard material as model input or exemplar. This was already
   settled policy and is restated here for the record, not reopened.

Full phased delegation plan (Codex / Lovable / Orly / David) recorded in
`docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md`.

### Rationale

Maximize reuse of the grading/verification investment already made for AP
Biology, and avoid opening a new content-ownership or tutor-credentialing
relationship at the same time as a new subject.

### Consequences

- Phase 1 (de-hardcoding `grade-frq`/`evaluate-attempt` away from literal "AP
  Biology" strings, wiring the prompt-build manifest to `subject_id`) is
  cleared for Codex to execute — it was the one piece blocking any second
  subject regardless of which one was chosen.
- The investigative-task archetype is not yet defined and blocks Phase 4
  content authoring for that item type specifically; it does not block the
  MCQ/FRQ portions of the pilot batch.
- No target date is set for the pilot batch yet — pending Orly's bandwidth
  confirmation alongside ongoing AP Biology work.

## DECISION-0032 — Authorize TASK-0013 Phase 2 Database Migration (AP Statistics Schema)

**Date:** 2026-06-30
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0013
**Area:** Architecture / Operations

### Context

`TASK-0013`'s overall Hard-Gate approval (`DECISION-0031`) covered subject
selection, content-sourcing model, and pilot batch composition — it did not
cover the Phase 2 database migration itself. `STANDING_APPROVAL_LANES.md`
Lane 3 lists database migrations as their own Hard Gate, separate from
"implementation not already covered by an approved task," so Phase 2's
migration (`prompts/CODEX_AP_STATISTICS_PHASE2_SCHEMA_INSTANTIATION.md`)
was drafted but explicitly marked do-not-execute pending a separate
sign-off.

### Decision

David authorized the Phase 2 migration to proceed, in the same exchange
where Phase 3 (PR #24) was confirmed merged. Scope: one additive,
idempotent migration inserting an `app.subjects` row for AP Statistics, an
`app.exam_packs`/`exam_pack_versions` pair (version `status: 'draft'`, not
`'published'`), and `app.content_labels` rows for the 9 AP Statistics units
— exactly as scoped in the Phase 2 prompt. No other migration is authorized
by this decision.

### Rationale

Phase 1 (subject-driven grading) and Phase 3 (calculation verifier) are
both complete and merged with passing independent QA. The schema work is
additive-only and was deliberately scoped (draft status, no publish) to
stay inert until content actually exists, so the blast radius of proceeding
now is low.

### Consequences

- `prompts/CODEX_AP_STATISTICS_PHASE2_SCHEMA_INSTANTIATION.md`'s
  do-not-execute condition is satisfied; Codex is cleared to execute it.
- Phase 4 (content authoring) unblocks once Phase 2 lands.
- This decision does not authorize publishing the exam pack, content
  labels, or any content — that remains a separate decision per the
  prompt's explicit scope boundary.

## DECISION-0035 — Resolve Phase 0 of the Backend Consolidation Migration (Schema Reconciliation, Option A/A2)

**Date:** 2026-07-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (Backend Consolidation & Migration Plan, 2026-07-08)
**Area:** Architecture / Integration

### Context

The live Lovable app (Supabase project `tazjfzphsevtgervlyit`, `public.*`, ~26
tables) and Production (`pcntajvbdfqhbeewmdry`, `app.*`, ~60 tables, RPC/view
design) are two independently-built, diverged schemas — the root cause of
"published content doesn't appear in the app." The plan
(`docs/architecture/BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md`, with the
mapping in `APP_SCHEMA_RECONCILIATION_2026_07_08.md`) already chose **Option A /
A2**: adapt the app to the `app` schema via a curated `public` interface (views
for reads + `supabase.rpc(...)` for writes), not a table-for-table env flip.
Phase 0 (decisions only) blocked all downstream work and was reserved for the
Product Owner. This entry resolves it.

### Decision

1. **Review workflow →** the reviewer UI targets **`content_review_*`**
   (content-version review: `app.content_review_assignments` /
   `content_review_decisions`), not the artifact-review `review_*` tables.
2. **Auth users →** **start fresh** in Production; the Lovable-Cloud users on
   `tazjfzphsevtgervlyit` do NOT carry over (treated as pre-beta/test accounts).
3. **Anonymous practice →** **No** — require sign-in on prod. Drop
   `anonymous_sessions`; curated views grant only `authenticated` (no `anon`).
4. **App AI keys →** move the app's own AI features to **`OPENAI_API_KEY`**
   (already set), off the Lovable AI Gateway. (Distinct from the grading runners'
   Vercel AI Gateway, which is unchanged.)
5. **Gap tables →** `config`: **add a small `app.config`** KV table (exposed via a
   curated read view). Drop `anonymous_sessions`, `capture_sessions` (re-add when
   the TASK-0011 capture path lands), `idempotency_keys` (use
   `grading_results.request_id/request_hash`), and `predictions` (embedded in
   `grading_results`). Adapt the app to the **`blind_group_id` column** instead of
   a `review_blind_groups` table. **Rebuild the 6 `dashboard_*_v1` views** as
   `public` views over `app`.

### Rationale

Each choice minimizes surface and churn for an Aug-2026 beta: `content_review_*`
matches a pre-launch content-vetting reviewer UI; fresh auth avoids a `pg_dump`
migration of throwaway accounts; sign-in-only shrinks the public API surface;
`OPENAI_API_KEY` decouples the app's AI from Lovable now that the key exists; the
gap-table dispositions follow the schema's existing design (idempotency and
predictions already live in `grading_results`; blind grouping is already a
column).

### Consequences

- **Unblocks Phase 1** (Codex: build the curated `public` interface — views +
  RPC confirmation over `app`, incl. `app.config` and rebuilt `dashboard_*_v1`)
  and **Phase 2** (Lovable: repoint to the curated interface, native Supabase
  Google OAuth, `.env`/`config.toml` → Production).
- Docs `BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md` §7 and
  `APP_SCHEMA_RECONCILIATION_2026_07_08.md` gap table updated to "resolved."
- Phase 1 build spec captured in
  `prompts/CODEX_BACKEND_CONSOLIDATION_PHASE1_CURATED_INTERFACE.md`.

### Risks / Follow-ups

- "Start fresh" auth assumes the current Lovable-Cloud users are not real
  beta users with data to preserve — reconfirm before disabling Lovable Cloud.
- `content_review_*` pick should be validated against the actual reviewer UI
  routes during Phase 2; if the UI also grades artifacts, revisit (the "both"
  option was declined).
- Migration docs and this decision originate on branch
  `claude/backend-consolidation-migration` (off `main`). `main` is at
  DECISION-0032; branches for DECISION-0033/0034 are outstanding. If numbering
  collides on merge, renumber whichever merges second and update the index.

## DECISION-0039 — Adopt Branch Hygiene Rules (R1–R7) to Resolve and Prevent Branch Sprawl

**Date:** 2026-07-26
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (operating-model / charter change)
**Area:** Operations

### Context

Recurring branch sprawl (20 local / 21 remote branches, 9 worktrees, per-session
branch names, unmerged divergence, orphaned uncommitted work) caused real work loss.
Reconciled across Claude v1 → Codex second opinion → PR #54 review rounds 1–2.

### Decision

Adopt R1–R7: (R1) branch = one reviewable slice named
`<agent>/<task-or-work-id>-<slug>`, continue-don't-fork; (R2) continuation via the
canonical task record's `Branch`/`PR` fields, machine-local paths ephemeral; (R3)
integrate small slices via small PRs, no standing integration branches; (R4) durable
session close (commit-and-push checkpoint; explicit dirty-state handoff if
interrupted); (R5) readiness (human) separated from execution (GitHub-native
auto-merge/merge-queue), custom privileged agent contingent not default; (R6)
delete-on-merge of the remote head, local cleanup client-side, archive-tag only
unique unmerged work; (R7) removal preflight = no uncommitted changes + no unique
commits + no unpushed refs. Trunk protection: no normal direct commits to `main`;
force-push/deletion blocked; human-only break-glass.

### Rationale

Per-session branching + slow integration + no cleanup was the root cause; branch =
slice + task-record continuation is the highest-leverage fix. GitHub-native
automation is preferred over a custom privileged agent for lower privilege/risk.
See APPROVAL-0027 and the source proposal (merged PR #54).

### Consequences

- Charter + session prompts now require branch-per-slice, task-record continuation,
  durable session close, and delete-on-merge; agents follow R1–R7 going forward.
- `main` is the single integrated-truth trunk; active work stays on scoped branches
  until reviewable.

### Risks / Follow-ups

- Operational enforcement (main branch protection, required CI checks, native
  auto-merge) is not yet in place — sequenced separately in the proposal (steps 5–9).
- One-time cleanup of the existing 20 branches / 9 worktrees is a separate phased
  pass (step 10), from a clean checkout, after recovery PRs #50–#52 finish.
- Numbering: DECISION-0039 / APPROVAL-0027 were allocated above open-PR claims
  (#38/#39/#43 claim 0026/0036, #39 up to 0038); recheck open PRs immediately before
  merge and renumber the later-merging branch on any collision.
