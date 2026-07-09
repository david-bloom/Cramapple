# Lovable Prompt - Tutor / Reader Supabase Review Pilot

Build or update the Cramapple tutor/reader review experience so it can run as a thin UI on top of Supabase-backed review APIs.

Lovable deployed the HTML for this UX-002 reviewer portal, so update the deployed Lovable project.
Do not invent a separate architecture.

## Backend Contract

Use the curated `public` interface over `app`, not direct `app.*` reads from the browser.

Read from:

- `public.config`
- `public.profiles`
- `public.subjects`
- `public.exam_packs`
- `public.exam_pack_versions`
- `public.content_labels`
- `public.content_items`
- `public.content_item_versions`
- `public.mcq_choices`
- `public.frq_criteria`
- `public.content_item_labels`
- `public.learning_sessions`
- `public.attempts`
- `public.response_versions`
- `public.attempt_criterion_results`
- `public.grading_results`
- `public.content_review_assignments`
- `public.content_review_decisions`
- `public.dashboard_overview_v1`
- `public.dashboard_subjects_v1`
- `public.dashboard_pipeline_v1`
- `public.dashboard_engagement_v1`
- `public.dashboard_quality_v1`
- `public.dashboard_attention_v1`

Write only through the approved RPCs and server-backed flows:

- `public.submit_response` via the edge function wrapper
- `public.apply_student_memory_event` via the edge function wrapper
- `public.compose_learning_runtime_context` via the edge function wrapper

Do not read from or write to `app.*` directly in the frontend. `role` lives on `profiles`, not a `user_roles` table. Treat `content_review_*` as the canonical review workflow.

## Goal

Make the tutor/reader review loop work for the pilot:

- reviewer queue loads from Supabase for the signed-in reviewer;
- tutor question reviews submit the correct payload;
- FRQ question reviews are supported for the 80 available FRQs;
- reader review appears only after the tutor gate is satisfied;
- MCQ answer review fans out correctly after reader approval;
- FRQ canonical review is supported only if the current pilot scope includes it;
- submitted decisions stay immutable in the backend;
- mock mode still works when backend config is absent.

## URLs

- Sign in: `https://cramapple.com/tutor-login`
- Tasks after sign-in: `https://cramapple.com/reviewer`
- Submissions: `https://cramapple.com/reviewer/submissions`

## Scope

Use the existing UX-002 review portal UX and keep the editorial workbench feel.

Do not add gamification, streaks, scoring flair, or marketing copy.

## Required Behavior

### Queue

- Load the live queue from the backend when a Supabase session is present.
- Show assignment metadata, stage, role, due date, artifact summary, and backend `review_status` when available.
- Do not show another tutor’s identity, score, or rationale before the blind group is complete.
- Keep mock-mode warnings visible when backend config is missing.

### Submission

Use stage-specific payloads, not a generic `decision` field.

For tutor question review, submit the fields the backend expects:

- `content_review_assignment_id`
- `review_stage`
- `tutor_score`
- `difficulty_label`
- `concern_codes`
- `note` or `rationale`
- `supersedes_id` when applicable

For AP Reader or FRQ paths, use the matching backend fields for that stage.

### UX rules

- Show the full artifact content needed to make the decision.
- Keep Previous / Next controls visible.
- Keep draft state local until submit.
- Warn on unsaved changes.
- Do not imply a review is complete until the backend confirms it.

## Pilot Scope Decisions

- Exclude `tutor_frq_canonical` unless canonical answers are populated and the pilot explicitly includes that path.
- Defer difficulty discussion unless the schema and queue support it cleanly.
- Treat concern codes as the controlled vocabulary: `Accuracy`, `Ambiguity`, `Rubric gap`, `Other`.
- Use the normalized `content_items` / `content_item_versions` artifact model; if that pair is missing in the deployed project, add it rather than introducing `mcq_items` / `frq_packages` polymorphism.
- Reflect `content_item_versions.review_status` in the UI as the backend-driven review state marker.

## Forbidden Behavior

- Do not use service-role keys.
- Do not decide workflow progression in the browser.
- Do not write trust fields directly.
- Do not bypass the backend to fake a submitted state.
- Do not rely on the frontend as the source of truth for reviewer identity.

## QA Expectations

- Live queue loads for a signed-in reviewer.
- A tutor question submission succeeds with the exact backend contract.
- An FRQ question submission succeeds with the exact backend contract.
- A reader decision can be submitted only when the backend stage allows it.
- Live mode and mock mode are visibly distinct.
- No unauthorized reviewer can read or write another reviewer’s items.
- Queue refresh after submit reflects the backend, not local assumptions.
