# TASK-0061 — UX Monitoring Phase B: Direct Product Feedback

STATUS: IN PROGRESS

**Task ID:** TASK-0061  
**Title:** Add lightweight general product feedback in Development  
**Owner:** Main Conductor / ChatGPT  
**Tier:** Hard-Gate for Production; Development implementation approved by owner continuation to Phase B  
**Status:** In Progress — Development built, E2E pending  
**Created Date:** 2026-10-03  
**Branch:** `chatgpt/ux-monitoring-user-research-v1`  
**PR:** TBD

## Goal

Add a low-friction general product/UX feedback path while preserving the existing per-question content report and grading-dispute paths as separate evidence types.

## Development implementation

### Supabase

Applied Development migration `create_product_feedback_phase_b` to `wmgjsdkphcyhngaffbqf`.

New `app.product_feedback` fields:
- `id`
- `user_id`
- `category`: `not_working | confusing | idea | other`
- optional `note` (max 2000)
- optional `route` (max 200)
- optional `subject_key` (max 100)
- `created_at`

RLS:
- authenticated users may insert their own rows;
- authenticated users may select their own rows;
- anon has no table access.

Repository migration recorded at:
`supabase/migrations/20261003000100_create_product_feedback_phase_b.sql`

### Student frontend

Lovable student-app Development commit:
`1a9140aaa7263c04f5b396045edef7326da45bb7`

Implemented:
- persistent, unobtrusive `Send feedback` affordance on authenticated student surfaces;
- four categories:
  - Something didn't work
  - Something was confusing
  - I have an idea
  - Other
- optional note;
- student reminder not to include name, email, school, or answers;
- safe route handling strips query/hash material;
- subject key only when already known;
- successful inserts emit coarse `feedback_submitted` with category + route/subject only;
- feedback note and user ID never enter PostHog;
- PostHog initialization is memoized so concurrent explicit captures cannot race SDK load.

Existing `ReportQuestionButton` and grading disputes were not changed.

Lovable reported clean typecheck and 454 tests passing. Connector diff was independently inspected.

## Known Development gap

The existing `ReportQuestionButton` writes to `public.question_reports`, but the current Development database audit found no `question_reports` table. That is an existing Dev/Prod convergence/reproducibility gap already documented in TASK-0027; Phase B does not silently repurpose or replace it.

## E2E still required

Before Phase B is Ready for Review:
1. verify the Development API exposes the `app` schema to the browser client;
2. use an authenticated Development student to submit each representative feedback path;
3. verify the exact row in `app.product_feedback` contains only approved fields;
4. verify `feedback_submitted` emits only category/route/subject when Development PostHog delivery is configured;
5. visually inspect mobile and desktop placement so the fixed affordance does not obscure core controls;
6. confirm question reporting remains a distinct UI path.

No Production migration, frontend publication, deployment, secret, or analytics configuration change is authorized by this task checkpoint.
