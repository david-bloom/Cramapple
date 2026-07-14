# Lovable Prompt - Tutor / Reader Supabase Review Pilot

Build or update the Cramapple tutor/reader review experience so it can run as a thin UI on top of Supabase-backed review APIs.

Lovable deployed the HTML for this UX-002 reviewer portal, so update the deployed Lovable project.
Do not invent a separate architecture.

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
The live review tables key off `content_review_assignment_id` and
`content_review_decision_id`; do not assume a generic `id` field exists on the
backend rows.

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
- Treat `content_review_assignments.content_review_assignment_id` as the queue
  row key and `content_review_decisions.content_review_decision_id` as the
  immutable submission key.
- For `/reviewer/submissions`, use the same UX-002 `content_review_*` review pipeline as the queue and submission path. Do not query the older `review_assignments` / `review_decisions` pipeline for this screen.
- Treat `difficulty_label` as the canonical column name for the newer review pipeline.
- Use `review_queue_scope = 'all_pending'` as the explicit capability for the CC view. The ordinary reviewer experience must stay on `my_queue` by default.

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
