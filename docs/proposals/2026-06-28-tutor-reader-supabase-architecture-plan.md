# Tutor / Reader Supabase Architecture Plan

**Status:** Draft for Claude execution  
**Date:** 2026-06-28  
**Scope:** Lovable tutor/reader review experience, FRQ quality workflow, Supabase wiring

## 1. What Lovable Actually Built

Lovable has already built a credible reviewer prototype, but it is still a prototype with partial live wiring rather than a production-ready review app.

### Built in the frontend

- A reviewer dashboard with a task picker, live/mock mode messaging, and role switching between tutor and AP Reader contexts.
- A review carousel for:
  - MCQ question review;
  - MCQ answer-option review;
  - FRQ canonical-answer review;
  - AP Reader decisioning;
  - difficulty discussion.
- Local validation for required score, difficulty, rationale, and discussion rationale states.
- Local-only state management for draft notes, navigation, and review feedback.
- A structured upload parser for CSV/JSON intake templates.
- A mock/live dual mode that attempts to read the real queue when Supabase config and session are available.

### Built in the backend

- `review-queue` reads reviewer assignments from Supabase using the user session.
- `review-decision` writes review decisions to Supabase with an immutable decision payload.
- `content-intake` ingests batch uploads and materializes assignments.
- The schema already contains the review tables needed for the workflow:
  - `content_ingest_batches`
  - `content_ingest_rows`
  - `artifact_label_assignments`
  - `content_review_assignments`
  - `content_review_assignment_labels`
  - `content_review_decisions`

The current Supabase content set includes 80 FRQs, so FRQ question review is in scope for the pilot. Canonical-answer review remains conditional on canonical answers being present.

## 2. What Is Still Broken or Incomplete

The prototype is wired in spirit, but several contract mismatches mean the live path is not yet reliable.

### Current mismatches

- Reviewer roles are not yet permitted by the database role constraint, so tutor and reader sessions are blocked before queue access.
- The frontend submits a generic `decision` field, but the Edge Function expects stage-specific fields such as `reader_decision` and `canonical_decision`.
- The queue response does not currently expose the exact shape the frontend expects for live task construction.
- The frontend’s live task mapping expects fields like `assigned_role` and `artifact_version_id`, while the queue function returns `reviewer_id` and `content_item_version_id`.
- The queue function and submission function do not yet orchestrate downstream assignments after a decision lands.
- The frontend still behaves like a prototype in several places where production should be server-authoritative:
  - decision state;
  - stage transitions;
  - next-item progression;
  - difficulty discussion resolution.

### Practical consequence

The current Lovable build can demonstrate the tutor experience, but live reviewer workflow completion will fail or degrade in several branches until the request/response contract is aligned.

### Additional blockers confirmed by Claude review

- `content_item_versions` does not yet expose reviewer-readable content under the assigned reviewer path.
- `content-intake` stage names no longer match the current review-stage constraint.
- Existing content cannot yet be assigned directly for review without a new admin assignment path.
- Difficulty discussion exists as a UX concept, but it is not ready as a pilot-stage workflow until the schema supports it cleanly.

## 3. Target Architecture

The cleanest path is to treat Lovable as a thin client on top of Supabase-authenticated review APIs.

### 3.1 Frontend

Lovable should:

- use Supabase Auth session as the source of reviewer identity;
- fetch only reviewer-scoped queue data from an Edge Function;
- submit only stage-appropriate payloads to a locked submission endpoint;
- never infer trust state locally;
- remain mock-capable when Supabase config is absent;
- keep draft state local only until submission.

### 3.2 Edge Functions

Use three backend touchpoints:

1. `content-intake`
   - Parse uploaded batches.
   - Create ingest rows.
   - Materialize artifacts and review assignments.

2. `review-queue`
   - Return the reviewer’s queue in a frontend-friendly DTO.
   - Include assignment, artifact, stage, blind-group, and current decision context.
   - Return derived status counts for dashboard UX.

3. `review-decision`
   - Validate the assignment ownership and stage.
   - Enforce stage-specific payload contracts.
   - Insert an immutable decision row.
   - Advance assignment status.
   - Trigger downstream workflow creation when the current stage is complete.

### 3.3 Database

Use Supabase as the system of record for:

- reviewer assignments;
- reviewer decisions;
- ingest batches and rows;
- label assignments;
- immutable audit hashes;
- downstream state transitions.

Recommended relational pattern:

- one assignment row per reviewer, content version, and stage;
- one immutable decision row per submission;
- one blind group per independent tutor pair;
- explicit stage values for question, answer, canonical-answer, and difficulty discussion work.

### 3.4 Workflow orchestration

The orchestration layer should create the next stage only after the current stage is fully satisfied.

Example flow:

1. ingest batch materializes an artifact version;
2. two blind tutor assignments are created for the question stage;
3. when both decisions land:
   - aggregate and determine follow-up;
   - create AP Reader review or a revision/discussion path;
4. if MCQ question review passes:
   - create answer-option assignments;
5. if FRQ canonical review passes:
   - create the next FRQ-specific downstream state;
6. if difficulty labels disagree:
   - create a difficulty discussion assignment;
7. every transition writes an audit trail.

### 3.5 Scope boundaries to settle before build

There are still a few product decisions that affect the implementation path:

- Lovable delivery target:
  - Lovable deployed the HTML, so the right update path is a Lovable prompt/message.
- Reviewer URLs:
  - Sign in: `https://cramapple.com/tutor-login`
  - Tasks after sign-in: `https://cramapple.com/reviewer`
  - Submissions: `https://cramapple.com/reviewer/submissions`
- Review pipeline ownership:
  - This plan currently targets the UX-002 `content_review_*` pipeline.
  - The older governance pipeline should stay separate unless Product explicitly wants tutors/readers to use it.
- Admin surface:
  - Assignment creation, tutor invitation, and review-progress monitoring are not yet designed here.
  - Treat them as a follow-on admin surface unless we explicitly widen this plan.
- Concern codes:
  - The prototype currently uses button labels backed by `text[]`.
  - Enforce the controlled vocabulary: `Accuracy`, `Ambiguity`, `Rubric gap`, `Other`.

## 4. Supabase Data Contract

The review workflow should normalize around a single frontend contract and a single submission contract.

### Queue DTO

The queue response should include:

- `content_review_assignment_id`
- `artifact_version_id`
- `content_item_version_id`
- `review_stage`
- `review_kind`
- `assigned_reviewer_id`
- `assigned_role`
- `blind_group_id`
- `due_at`
- `status`
- the artifact summary needed to render the card
- any already-submitted sibling decisions that the UI is allowed to reveal

### Submission DTO

The submission endpoint should accept:

- `content_review_assignment_id`
- `review_stage`
- stage-specific decision fields:
  - `tutor_score`
  - `difficulty_label`
  - `reader_decision`
  - `canonical_decision`
  - `answer_key`
  - `answer_approval`
- `concern_codes`
- `rationale`
- `change_request`
- `supersedes_id`
- `decision_payload`

### Contract rule

Do not let the UI invent its own submission schema. The frontend should render from a typed contract and submit the exact backend-shaped payload for the current stage.

## 5. RLS And Trust Boundaries

Keep the security boundary simple:

- `authenticated` can read only assigned queue items and its own decisions.
- `authenticated` can insert only its own decision rows.
- `service_role` owns assignment creation, stage orchestration, and any privileged updates.
- Lovable must not write trust fields directly.

Important invariants:

- submitted decisions are immutable;
- corrections are new rows linked by `supersedes_id`;
- the other tutor’s identity and decision remain hidden until the blind group is complete;
- the browser is never authoritative for progression or approval.

## 5.1 Phase 0 prerequisites

These must exist before the rest of the plan is meaningful:

- add `tutor` and `reader` to the role model used by `profiles`;
- fix `content_ingest_rows.review_stage` so it matches the values actually emitted by `content-intake`;
- add the concern-code constraint or lookup table so `content_review_decisions.concern_codes` only accepts `Accuracy`, `Ambiguity`, `Rubric gap`, and `Other`;
- add reviewer-safe `SELECT` access to `content_item_versions` for assigned reviewers;
- add `supabase/migrations/202606270001_assignments_staging_bridge.sql` to the working migration baseline before coding against column names;
- add a direct assign-for-review edge function for existing content versions that accepts `content_item_version_id`, `reviewer_a_id`, `reviewer_b_id`, and `review_kind`;
- add a direct assign-for-review path for existing content versions so the pilot can use already-owned content.
- use `content_item_versions.review_status` as the pilot state machine marker and keep it synchronized by the server, not the browser.

## 6. Execution Plan For Claude

### Phase 1: Contract audit

Completed in the current Codex session. This session already read the prototype, edge functions, and schema and captured the mismatches that drive the rest of the plan. Treat that audit as the working review record for this plan.

- Compare the Lovable prototype request payloads with `review-queue` and `review-decision`.
- Confirm the exact field mapping for:
  - tutor question;
  - tutor answer;
  - FRQ canonical review;
  - AP Reader review;
  - difficulty discussion.
- Identify every frontend assumption that does not match the backend contract.

### Phase 2: DTO alignment

- Update `review-queue` so the frontend receives a stable DTO with the names it actually uses.
- Expose both the canonical database field names and any UI-friendly aliases if needed.
- Include enough artifact metadata for the card to render without additional ad hoc queries.
- Update `review-decision` to accept the exact stage payloads Lovable sends, or update Lovable to send the exact stage payloads the backend expects.
- Prefer one explicit schema over generic `decision` branching.
- Make reader and FRQ canonical paths first-class, not special cases hidden behind a generic field.

### Phase 3: Add workflow advancement

- After a submission is inserted, create the next stage assignments or discussion tasks.
- Keep the transition logic server-side.
- Ensure every stage transition is idempotent.
- For the pilot, do this synchronously inside `review-decision` once a blind group becomes complete.

### Phase 3a: Write the state machine first

Document the exact branching before coding it:

| Stage | Outcome | Next action |
| --- | --- | --- |
| `tutor_question`, aggregate 2 | both tutor decisions submitted | create `reader_question` assignment |
| `tutor_question`, aggregate 3 | both tutor decisions submitted | flag `modification_reserved` |
| `tutor_question`, aggregate 4-6 | both tutor decisions submitted | flag `excluded` |
| `reader_question`, score 1 | submitted | MCQ: create `tutor_answer` assignments for all four options for both tutors; FRQ: done |
| `reader_question`, score 2 | submitted | create new version, then new `tutor_question` assignments |
| `reader_question`, score 3 | submitted | flag `excluded` |
| `tutor_frq_canonical`, approved | submitted | continue FRQ path as scoped |
| difficulty labels disagree | locked labels mismatch | create `difficulty_discussion` assignment |
| `difficulty_discussion` | resolved | either confirm label or route to revision |

MCQ fan-out must be explicit in code and in tests. If a downstream insert fails after a submission is recorded, the function should fail atomically or use idempotent upserts so retries do not duplicate assignments.

### Phase 4: Tighten security

- Re-check RLS policies for assignment reads, decision writes, and label writes.
- Ensure no client-writable field can alter reviewer identity, trust state, or workflow completion.
- Confirm service-role-only operations are not reachable from the browser.

### Phase 5: Update the Lovable prototype

- Replace generic submission branching with stage-specific request builders.
- Map queue items from the backend DTO directly.
- Disable any UI affordance that suggests a completed workflow when the backend has not actually recorded it.
- Keep mock mode available, but clearly separate it from live mode.

### Phase 5a: Lovable delivery path

- If the build lives in a deployed Lovable project, send a Lovable prompt/message with the DTO contract and prohibited behaviors.
- If the build lives in this repo, patch `prototypes/ux-002/index.html` directly.

### Phase 5b: Pilot scope choices

- Exclude `tutor_frq_canonical` from the first pilot batch unless canonical answers are populated and a clear content set exists.
- Defer difficulty discussion from the first pilot batch unless a migration is added specifically for that workflow.
- Derive aggregate review status from assignments and decisions rather than adding a new `review_status` column during the pilot.

### Phase 6: QA

- Verify live queue load with a real Supabase session.
- Verify a full MCQ scenario end to end:
  - two tutor question decisions;
  - reader assignment appears;
  - reader decision produces the next stage;
  - answer assignments fan out correctly.
- Verify a full FRQ question-review scenario end to end:
  - tutor question decisions on one of the 80 available FRQs;
  - revision path if rejected;
  - canonical path only if canonical answers are present.
- Verify invalid submissions fail cleanly.
- Verify the queue refreshes after submission.
- Verify no unauthorized user can read or write another reviewer’s items.

## 7. Acceptance Criteria

- Lovable can load a real reviewer queue from Supabase using the signed-in session.
- Lovable can submit every supported review stage with the correct payload contract.
- Decisions are immutable and auditable.
- Next-stage assignments are created by the server, not the browser.
- FRQ quality review is connected to Supabase with the same contract rigor as MCQ review.
- FRQ question review works against the available FRQ batch.
- Tutor and reader review remain separate, blinded, and reviewable.
- Existing content can be assigned directly for review without re-ingestion.
- The first pilot batch has a clearly scoped stage set and does not depend on unfinished schema branches.

## 8. Recommended Next Action

Have Claude start with the phase-0 blockers first:

1. patch the phase-0 blockers;
2. patch the DTO mismatch;
3. then add downstream workflow advancement;
4. only after that, polish the UI.

## 9. Decisions

**Product Owner decisions (2026-06-28):**

1. Governance pipeline remains separate. Tutors and AP Readers use only the UX-002 `content_review_*` tables. The older `review_assignments` / `review_decisions` pipeline handles operational content lifecycle and is not part of this workflow.
2. Concern codes are a controlled vocabulary of four values: **Accuracy**, **Ambiguity**, **Rubric gap**, **Other**. Enforced as a check constraint — not free text.
3. Admin surface (tutor invitation, item assignment, review progress monitoring) is out of scope for this plan and is the next follow-on task.
4. `review_stage` for the UX-002 review workflow is `tutor_question`, `tutor_answer`, `tutor_frq_canonical`, and `reader_question`. Difficulty discussion is deferred and is not part of the pilot stage enum.
5. `tutor_score` is an integer 1-3, not an enum.
6. Difficulty labels are deferred for the pilot. If enabled later, use the five-label set in the design doc.
7. Blind groups are pairs of tutor assignments. A blind group is complete when both tutor decisions for that group have been submitted.
8. `supersedes_id` is for same-stage revision history by the same reviewer. Cross-stage progression creates new assignments instead of superseding prior stage decisions.
9. Reviews attach to `app.content_item_versions`. The existing normalized `content_items` / `content_item_versions` model is the artifact source; do not introduce a new `mcq_items` or `frq_packages` table for this workflow.
10. If the deployed project is missing `content_items` / `content_item_versions`, add that normalized pair and the phase-0 policies rather than falling back to polymorphic artifact references.
11. `content_item_versions.review_status` is the pilot state-machine field; do not invent a second review-status table or derive status ad hoc in the browser.
12. FRQ question review is in scope for the pilot because 80 FRQs are available; canonical-answer review remains conditional on canonical answers being present.

**Proposed scope decisions (pending Product Owner ratification):**

4. Use a direct assign-for-review edge function for existing content rather than re-ingesting through `content-intake`.
5. Keep `tutor_frq_canonical` conditional on canonical answers being present.
6. Defer difficulty discussion from the first pilot batch — schema support is incomplete.
7. Treat the deployed Lovable HTML as the editable Lovable target for UX-002.

## 10. Open Questions

1. ~~Should the older governance pipeline remain separate?~~ **Decided: separate.**
2. ~~Should concern codes stay free text for the pilot?~~ **Decided: controlled vocabulary — Accuracy, Ambiguity, Rubric gap, Other.**
3. ~~Should the admin surface be part of this plan?~~ **Decided: follow-on task, not this plan.**
4. ~~Is the UX-002 reviewer portal deployed as a Lovable project separate from `cramapple-beta.lovable.app`, or does the prototype only exist as `prototypes/ux-002/index.html` in this repo?~~ **Decided: Lovable deployed the HTML, so Phase 5 uses a Lovable prompt/message.**
