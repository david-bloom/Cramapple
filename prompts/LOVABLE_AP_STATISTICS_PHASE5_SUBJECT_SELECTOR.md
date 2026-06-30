# Lovable Build Prompt — TASK-0013 Phase 5: AP Statistics Subject Selector

**Blocked until Phase 2 and Phase 4 land** (schema + at least a few
published AP Statistics items to render against). Do not start building
against this prompt until both exist in the target Supabase environment —
check `app.exam_packs` for an `'ap_statistics'` row with at least one
`published` `content_item_version` before beginning. This file is drafted
now so it's ready the moment those land.

## How To Use This File

Give this file to Lovable as an **amendment** to the existing student
experience build, not a fresh build. The baseline is already built per
`prompts/LOVABLE_UX001_STUDENT_EXPERIENCE.md` and
`docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md`. Do not re-derive the
student experience from scratch — extend it.

## Context

Cramapple's student experience was built AP-Biology-only:
`LOVABLE_UX001_STUDENT_EXPERIENCE.md` says outright "the initial product
focuses on AP Biology." The backend no longer assumes that —
`evaluate-attempt` resolves the subject/exam name from `app.exam_packs` per
attempt (PR #20, TASK-0013 Phase 1) — but nothing in the frontend lets a
student pick a subject. There is currently exactly one implicit subject.

## Goal

Let a student choose AP Statistics or AP Biology, and have the rest of the
existing practice/assessment flow (topic selection, MCQ attempt, FRQ
attempt, criterion feedback, repair/retry) work unchanged for whichever
subject is selected — because the backend already resolves subject-specific
data per attempt, the frontend's job is routing and selection, not
rebuilding the grading/feedback UI.

## What does NOT need to be built

Before assuming a new input primitive is needed for AP Statistics responses
(e.g. a calculation-entry widget distinct from Biology's free-text FRQ
box): check `app.content_items.item_type` for the actual item being
rendered. The schema already has three item types —`'mcq'`, `'frq'`, and
`'quantitative'` (`supabase/migrations/202606200001_initial_app_schema.sql:204`)
— and AP Statistics content authored under `'frq'` should render with the
**exact same free-text response component** Biology FRQs already use; no
new UI work there. If/when content is authored under `'quantitative'`
instead (see the open question in
`docs/product/AP_STATISTICS_PHASE4_CONTENT_AUTHORING_BRIEF.md`), check with
the backend/conductor before building bespoke UI for it — it may still be
fine as a constrained free-text numeric entry rather than anything more
elaborate, and that decision shouldn't be made unilaterally on the frontend
side.

## Scope

1. **Subject selection surface.** Wherever a student currently starts a
   session/practice flow (post-setup or topic-selection point in the
   existing flow — follow `STUDENT_PORTAL_INTERACTION_DESIGN.md`'s actual
   flow, don't invent a new entry point), add a subject choice if more than
   one published subject exists for the student's account. If only one
   subject is published (the common case until AP Statistics content is
   live), skip the selector entirely — don't show a one-item dropdown.
2. **Route/data threading.** Whatever currently implicitly assumes AP
   Biology (route names, copy, any hardcoded "AP Biology" string in
   frontend code) should read the subject from the selected/active
   exam_pack instead. Grep the frontend codebase for literal "AP Biology"
   strings before assuming you've found them all.
3. **No new grading/feedback UI.** Criterion feedback, repair flow,
   uncertainty states — all of that is subject-agnostic already by design
   (the backend payload shape didn't change in Phase 1). Reuse it exactly.
4. **Empty/single-subject states.** A student account with access to only
   one subject should see no selector friction at all — this should feel
   like nothing changed for an AP-Biology-only user.

## Out of Scope

- Any new grading logic or response-format primitive — that's a backend
  decision (Phase 2/3), not this prompt's job.
- Marketing/SEO pages for AP Statistics (`docs/seo/`, separate workstream).
- Pricing or subject-bundling UI.
- Building anything before Phase 2/4 content actually exists to test
  against — there is nothing real to render before that.

## Required Evidence on Completion

- Screenshot or recording of the subject selector appearing only when
  more than one subject is published, and absent otherwise.
- Confirmation that an existing AP Biology student flow renders identically
  to before this change (regression check).
- List of any hardcoded "AP Biology" strings found and fixed in the
  frontend, for the record.

## Next Expected Output

Per the existing Lovable workflow conventions in this repo — changes
visible in the Lovable editor/preview, ready for review. Reference
`TASK-0013` when describing the change.
