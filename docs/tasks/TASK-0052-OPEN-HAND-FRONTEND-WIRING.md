# TASK-0052 — Wire Open Hand to Live Data (Frontend, Lovable)

**Status:** In progress (2026-10-05) — unblocked by owner override `DECISION-0097`; build instruction sent to Lovable `56cae479` with the plate loop ON by default and the `?loop=` override removed. Publish follows Claude's diff review.

> **Build 2026-10-05 — Lovable commit `450e107d` (not yet published).** Claude reviewed the full diff. `open-hand-item` removed from `src` (test-enforced); one `get_open_hand_item` call per item, only after the student taps "Show the worked answer" under the consent line; Next never wraps, with an end state; RPC errors mapped (entitlement → "This subject isn't unlocked on your account", not-accessible → skip, other → retry); Practice drops `open_hand_excluded` items and shows "You've seen the worked answer for this one, so it won't be scored" on a 409; plate loop on unless `VITE_PLATE_LOOP=off`, with the `?loop=` override and its stored key gone. `runtime-context-client.ts` now surfaces the JSON `error` code from function errors (needed for the 409), which changes the error string every function caller sees. Lovable reports 63 files / 543 tests passing and a clean typecheck. **Known regressions:** the reference pane and deep dive render empty placeholders in Open Hand (the RPC carries no reference content), and FRQs without criteria or a credited answer are skipped. **Not verified live:** the signed-in loop end to end, the 409 path, and the entitlement and not-accessible states.
**Tier:** Hard-Gate (it is the change that first exposes real answer keys to real students)
**Owner:** TBD — frontend/Lovable
**Product Owner:** David Bloom
**Date opened:** 2026-09-29
**Depends on:** `TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md`, `DECISION-0086`
**Repository:** **Lovable project `56cae479-f7c9-4988-b536-56538c38ee4e`** ("New Cramapple App" → `app.cramapple.com`). Front-end commits live in Lovable, **not** in `david-bloom/Cramapple`.
**Related:** `docs/product/PLATE_LOOP_BUILD_PLAN_2026_09_27.md` (on PR #256), `docs/product/OPEN_HAND_BRANCH_RESOLUTION_PLAN_2026_09_29.md`
**Area:** Open Hand / frontend / answer-key exposure

> **CORRECTED AND EXPANDED 2026-09-29.** Two things this record originally got wrong, and three
> decisions David made after it was written.
>
> **Wrong: "the Open Hand screens make no network call" is true of `/cramapple` only.** The app
> already has a **live Open Hand route** — `src/routes/open-hand-mcq.tsx` → `LiveOpenHandMcq` →
> `LiveOpenHand.jsx` → `fetchOpenHandItems()` in `src/lib/open-hand/client.ts` →
> `supabase.functions.invoke("open-hand-item", …)`, on the superseded **batch** contract, pointed at
> **Production**. `src/lib/practice-entry.ts` routes Home's "start practice" there whenever the
> plate-loop flag is on, and `src/lib/feature-flags.ts` enables that flag from **`?loop=plate` in the
> URL, persisting it to `localStorage`**. So this is not greenfield wiring: **a wired, dormant
> answer-key path already exists**, and the work is to replace it, not to build it.
>
> **Wrong: "no session required."** D1(c) removed the session requirement from the **RPC**. The list
> step still uses `student-session-items`, which requires a `learning_session_id`, so a session is
> still created for the list. "No session" is a property of the RPC, not of the screen.
>
> **Decision 1 (David) — `open-hand-item` is deleted.** The front end calls
> `supabase.rpc("get_open_hand_item", …)` **directly**. `client.ts` and `LiveOpenHand.jsx`'s batch
> fetch are to be **replaced, not adapted** — adapting risks leaving the batch path alive. Acceptance
> line: **no code in the app imports or invokes `open-hand-item`.**
>
> **Decision 2 (David) — remove the `?loop=` URL override.** A student-reachable, self-persisting
> switch into an unfinished path is not acceptable. Remove the override (and the `localStorage`
> persistence of it) from `feature-flags.ts`; keep the flag itself off by default.
>
> **Decision 3 (David) — the not-scorable marker is backend, and is already built.**
> `student-session-items` items now carry **`open_hand_excluded: boolean`** (TASK-0051). Use that;
> do **not** track disclosed items in `localStorage`, which would not survive a device change. Note
> the queue deliberately still **returns** excluded items so they can be shown as not-scorable rather
> than silently vanishing.
>
> One more thing to fix while in there: `handleNext` currently cycles the whole fetched list
> (`(i+1) % length`). Under the new contract **every Next is a new exclusion**, so it needs per-item
> consent and must not loop back around.

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

## Where Open Hand lives — ANSWERED 2026-09-29

**Open Hand keeps its own route** (`/open-hand-mcq`, plus an `/open-hand-frq` sibling). It is **not**
folded into `SessionFrame`. Note this was never really a choice: the route already exists and is
already routed from Home behind the flag.

The reason it should stay its own route is structural, not stylistic. In a dedicated route the answer
key only ever renders in a component with **no `submitResponse`, no attempt, and no session cursor**,
so "nothing on this screen can be scored" is greppable and unit-testable. Inside `SessionFrame` it
becomes a third state threaded through `assisted` → `effectiveAssistance` → `submitResponse`,
`needsConfirmTransfer`, the repair panel's own "Show" (which also sets `assisted`), recheck, and the
queue cursor in `use-session` — where **one missed branch shows a key on a scorable attempt.**

It also keeps two different consequences visibly different, which matters for the student as much as
for the code: `DECISION-0080` hint use means *still scored, evidence weight drops*; an Open Hand
disclosure means *never scored*. Sharing one `assisted` bit would blur them. The consent copy this
task requires is unambiguous only on a page with no submit button.

**Not on the B1/B2 axis.** The front-end findings doc's B1/B2 options are about gating the four aids
in Practice (`DECISION-0080`). Open Hand is not an aid — different consequence — so B1 can proceed
independently of this task and should not be scoped against it.

## Entry point — DECIDED 2026-09-29 (`DECISION-0087`)

**Home's "start practice" always starts with Open Hand.** Teaching-first is the default entry, not a
flagged experiment. David, 2026-09-29. `practice_entry.ts` should therefore stop branching on the
plate-loop flag for this decision and route to Open Hand unconditionally (the flag's other job — and
its `?loop=` override — is removed per Decision 2 above).

### The consequence this creates, and the requirement that falls out of it

Every disclosed answer key **permanently removes that item from the student's scorable pool**. With
Open Hand as the mandatory entry, that interacts directly with `DECISION-0074`'s mastery bar
(2 correct MCQ + 1 full-point FRQ per topic×skill cell). Measured against Production, 2026-09-29:

| Subject | Published MCQ | Max masterable cells now | After 10 disclosures | After 20 |
| --- | --- | --- | --- | --- |
| AP Biology | 43 | 21 | **16** | **11** |
| AP Statistics | 101 | 50 | **45** | **40** |

Roughly **one masterable cell lost for every two MCQ keys disclosed**, permanently and per student.
Biology is the tight one: 43 MCQs total.

**Therefore — a hard requirement for this task.** The answer key must be revealed on an **explicit
student action**, never on mount. `OpenHandMcqScreen` today renders every choice's verdict
immediately when it renders. Combined with "always start with Open Hand," that would mean **every
session start silently burns an item** with no student choice involved — which is both a content
problem and a consent problem, since TASK-0052 already requires the student be told the consequence
*before* it happens.

The screen must therefore open in a **keys-hidden** state showing the question only, with disclosure
behind a deliberate "show me the answer key" action carrying the consent copy. A student who passes
through Open Hand without opening a key must burn nothing. Under that design, teaching-first costs
inventory only when the student actually asks to be taught — which is the behaviour the decision
intends.

**Still open, and worth revisiting once real usage exists:** whether Open Hand should draw from a
reserved teaching pool rather than the same published pool practice scores from. That would decouple
teaching cost from mastery ceiling entirely, at the price of authoring or designating dedicated
items. Not required for this task; recorded so the option is not lost.
