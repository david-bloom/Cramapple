# TASK-0052 — Wire Open Hand to Live Data (Frontend, Lovable)

**Status:** Not started. **Blocked on TASK-0051** — do not begin wiring before the backend gate lands.
**Tier:** Hard-Gate (it is the change that first exposes real answer keys to real students)
**Owner:** TBD — frontend/Lovable
**Product Owner:** David Bloom
**Date opened:** 2026-09-29
**Depends on:** `TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md`, `DECISION-0086`
**Repository:** **Lovable project `56cae479-f7c9-4988-b536-56538c38ee4e`** ("New Cramapple App" → `app.cramapple.com`). Front-end commits live in Lovable, **not** in `david-bloom/Cramapple`.
**Related:** `docs/product/PLATE_LOOP_BUILD_PLAN_2026_09_27.md` (on PR #256), `docs/product/OPEN_HAND_BRANCH_RESOLUTION_PLAN_2026_09_29.md`
**Area:** Open Hand / frontend / answer-key exposure

## Why this is its own task

TASK-0051 closes the backend gate. **It changes nothing a student can see.** The Open Hand screens
today (`src/screens/OpenHandMcqScreen.jsx`, `OpenHandFrqScreen.jsx`, reached at `/cramapple` through
`QuestionRoute`) are demo-only: they take `question` as a prop, make **no network call of any kind**,
and render from local sample content in `src/content/sample/*`. A logged-in student practising goes
to bare `/session` → `SessionFrame`, which has no Open Hand at all.

**This task is the moment the risk becomes real.** Everything TASK-0051 builds exists to be correct
on the day this wiring ships. That is the whole reason the two are separate records rather than one.

## The contract — build against this, not against what #256 currently does

`DECISION-0086` settled the design, and David confirmed the disclosure contract on 2026-09-29:

1. **The list step returns no answer content.** Reuse the already-stripped `student-session-items`
   shape. Do **not** request or expect `is_correct`, `rationale`, `minimum_fix`, `frq_criteria` or
   `credited_response_spans` in a list response.
2. **The answer key is fetched one item at a time**, at the moment the student actually opens that
   item, via `public.get_open_hand_item`.
3. **Every key fetch permanently excludes that item from scoring for that student.** This is the
   point of the feature, not a side effect. The UI must say so before the student opens a key —
   consent-style copy, in the same spirit as the capture consent notice already shipped.

**Do not rebuild the direct-read path.** PR #256's `open-hand-item` fetched answer tables directly in
a batch of up to 50 and recorded nothing. That version is superseded. Wiring against it would recreate
exactly the gap TASK-0051 exists to close — and because the old code reads cleanly, nothing will stop
you. Read `DECISION-0086` before writing the first fetch.

## Required behaviour

- **Exclusion is visible to the student.** An item whose key has been opened must be shown as
  not-scorable wherever it can still appear. Do not let a student answer an item that cannot be
  graded and discover it only on submit.
- **Handle `409 open_hand_item_not_scorable`.** `evaluate-attempt` returns it for an excluded item.
  Until the serving side filters excluded items (a known open follow-up in TASK-0051 — neither
  `student-session-items` nor `get_home_start_queue` consults the exclusions table today), an
  excluded item **can still be served**. The frontend must render that refusal as a clear explanation
  — "you opened the answer key for this one" — and must not retry in a loop.
- **No answer content in client state or logs** beyond the item being viewed.

## Acceptance

- [ ] Opening one Open Hand item writes exactly one exclusion row; opening a list writes none.
- [ ] The pre-open consent copy is shown and is accurate about the scoring consequence.
- [ ] A student who opens a key and then meets that item in practice sees an intelligible
      not-scorable state, never a generic error and never a retry loop.
- [ ] Verified against live data with a throwaway test account, labelled as test data.
- [ ] Fresh independent QA in a new context.
- [ ] Product Owner go-ahead before publishing to `app.cramapple.com` — publishing is its own step in
      Lovable and does not follow from a commit.

## Open question for the Product Owner

**Where does Open Hand actually live for a student?** The plate templates are not what students
practise in — `SessionFrame` is. This task assumes Open Hand keeps its own route rather than being
folded into `SessionFrame`, which would be the much larger B2-style rebuild described in the
front-end's own findings doc
(`.lovable/plan/gate-the-four-aids-in-practice-findings-and-plan-2026-09-27.md`). Confirm before
estimating.
