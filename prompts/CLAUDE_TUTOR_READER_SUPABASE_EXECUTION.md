# Claude Prompt - Execute the Tutor / Reader Supabase Plan

Before doing any work, read the current source of truth for this task:

- `docs/proposals/2026-06-28-tutor-reader-supabase-architecture-plan.md`
- `docs/product/QUESTION_AND_ANSWER_REVIEW_PORTAL_DESIGN.md`
- `prompts/LOVABLE_UX002_REVIEW_PORTAL.md`
- `supabase/functions/review-queue/index.ts`
- `supabase/functions/review-decision/index.ts`
- `supabase/migrations/202606230003_content_intake_and_review_workflow.sql`
- `supabase/migrations/202606260002_content_review_workflow.sql`
- `supabase/migrations/202606270001_assignments_staging_bridge.sql`
- `supabase/migrations/202606270004_review_kind_stage_pairing.sql`
- `supabase/migrations/202606270006_validate_answer_key_vs_choices.sql`

The contract audit is already done in this Codex session. Do not repeat it.
Use the audit record from this session and the plan doc as the working baseline.

## Objective

Execute the tutor/reader Supabase plan end to end:

- unblock the Phase 0 prerequisites;
- align the queue and submission DTOs;
- implement server-side workflow advancement;
- update the prototype or Lovable prompt path as appropriate;
- verify the pilot with end-to-end QA.

## URLs

- Sign in: `https://cramapple.com/tutor-login`
- Tasks after sign-in: `https://cramapple.com/reviewer`
- Submissions: `https://cramapple.com/reviewer/submissions`

## First Decisions to Preserve

- Use the UX-002 `content_review_*` pipeline for the pilot.
- Keep the older governance pipeline separate unless Product explicitly widens scope.
- Use a direct assign-for-review path for existing content.
- Exclude `tutor_frq_canonical` from the first pilot batch unless canonical answers are present.
- Defer difficulty discussion unless the schema and workflow explicitly support it.
- Lovable deployed the HTML for UX-002, so treat the deployed Lovable project as the UI target.
- Use the normalized `content_items` / `content_item_versions` artifact model; if the deployed project is missing it, add that pair rather than introducing `mcq_items` / `frq_packages` polymorphism.
- The current Supabase content set includes 80 FRQs, so FRQ question review is in scope for the pilot; canonical-answer review remains conditional on canonical answers being present.
- Keep `/reviewer/submissions` on the UX-002 `content_review_*` pipeline only. Do not mix the older `review_assignments` / `review_decisions` pipeline into the reviewer submissions screen.
- Use `difficulty_label` as the canonical newer-pipeline column name.
- Treat `content_review_assignment_id` and `content_review_decision_id` as the
  live row identifiers in the newer pipeline; do not assume a generic `id`
  column on those rows.
- Use `review_queue_scope = 'all_pending'` as the explicit capability for the CC view. Keep the ordinary reviewer queue on `my_queue`.

## Execution Order

### Phase 0: Prerequisites

- Add `tutor` and `reader` to the permitted role model for reviewer access.
- Fix `content_ingest_rows.review_stage` so it matches the values actually emitted by `content-intake`.
- Add the concern-code constraint or lookup table so `content_review_decisions.concern_codes` only accepts `Accuracy`, `Ambiguity`, `Rubric gap`, and `Other`.
- Add reviewer-safe `SELECT` access to `content_item_versions`.
- Add `supabase/migrations/202606270001_assignments_staging_bridge.sql` to the working migration baseline before coding against column names.
- Add a direct assign-for-review edge function for existing content versions that accepts `content_item_version_id`, `reviewer_a_id`, `reviewer_b_id`, and `review_kind`.
- Use `content_item_versions.review_status` as the pilot state machine marker and keep it synchronized on the server.

### Phase 1: DTO alignment

- Make `review-queue` return the fields the prototype actually needs.
- Make `review-decision` accept the stage-specific payloads the UI sends.
- Remove generic payload ambiguity.
- Ensure reader and FRQ paths are first-class, not alias-based fallthroughs.

### Phase 2: Workflow advancement

- Implement the explicit state machine documented in the plan.
- Handle MCQ fan-out explicitly.
- Keep downstream assignment creation server-side.
- Make the operation idempotent so retries do not duplicate assignments.

### Phase 3: Security

- Re-check RLS for assignments, decisions, content reads, and labels.
- Ensure assigned reviewers can read only what they are allowed to read.
- Ensure browser code cannot write trust fields or workflow truth.

### Phase 4: Prototype update

- If the build is local, patch `prototypes/ux-002/index.html`.
- If the build is a deployed Lovable project, send a Lovable prompt/message instead of editing the file.
- Keep mock mode distinct from live mode.
- Keep the UX calm, editorial, and review-oriented.

### Phase 5: QA

- Verify one full MCQ path end to end:
  - two tutor decisions;
  - reader assignment appears;
  - reader decision advances the workflow;
  - answer assignments fan out correctly.
- Verify one full FRQ question-review path end to end against the available FRQ batch.
- Verify canonical-answer review only if canonical answers are present.
- Verify invalid submissions fail cleanly.
- Verify queue refresh reflects backend state.
- Verify unauthorized access is blocked.

## Output Requirements

When you finish, report:

1. files changed;
2. schema or API changes made;
3. remaining risks or open questions;
4. QA performed;
5. whether the pilot is ready for the next review step.
