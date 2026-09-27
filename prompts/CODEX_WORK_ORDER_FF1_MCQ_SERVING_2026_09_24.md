# Codex Work Order FF-1 — Make AP Biology's 43 MCQ Reachable

**This one does move launch-day content**, unlike J.0, N and N.1. A third of Biology's published
corpus — 43 of 118 items — cannot reach a student on the launch path.

**FF-13 is closed and this is not gated on it.** The tracker previously said the `mcq_choices`
answer-key exposure had to land first. Verified on Production 2026-09-24: all three parts of that
fix are live. `authenticated` can read `choice_text` and is denied `is_correct` and `rationale`;
`anon` is denied everything. Details in `docs/research/ff2_ff13_verification_2026_09_24/`.

**Design first, build second.** This changes a live serving surface, so the first deliverable is a
design proposal, not code.

## Late addition — read this before designing anything

`docs/activity_log/ACTIVITY_LOG.md`, entry dated 2026-09-24 (a different session, same day),
reports that **a Practice MCQ screen is already live in the new Lovable app and grades correctly
against Production** — and that it reaches MCQ through **a client-side fallback that queries
published items directly**, because `student-session-items` does not reliably honour its
`item_type` parameter.

That reframes FF-1 and makes it more serious, not less:

- MCQ are not unreachable to a *student*. They are unreachable through the **serving contract**.
- The frontend is therefore selecting content with no unit gate, no hand-drawn exclusion, no
  taxonomy check and no `practice_format` logic — none of the rules the serving functions exist to
  apply.
- So the goal is not "make MCQ appear". It is **make the server-side path correct enough that the
  client-side fallback can be deleted**, and the fallback's removal is the real definition of done.

Also in scope, because it is the same root: **`student-session-items` does not reliably honour
`item_type`** (returned zero MCQ for one pack, FRQ when MCQ were requested for another). Diagnose
that as part of the design. It may be the whole bug.

This is second-hand from the activity log; Claude has not verified the Lovable side and cannot from
the backend. Treat it as a strong lead to confirm, not as established fact.

---

```text
Work order FF-1 — make AP Biology's 43 published MCQ reachable on the practice serving path.

Merge main first:

    git fetch origin
    git merge origin/main
    # read: docs/product/AP_BIOLOGY_FAST_FOLLOW.md
    #       docs/research/ff2_ff13_verification_2026_09_24/README.md

THE PROBLEM

AP Biology launches on the practice path (DECISION-0063), which is public.select_practice_frqs. That
function filters item_type = 'frq'. Biology's 43 published MCQ are therefore unreachable: the
unit-gated path that would serve them returns 0 items for Biology and 8 across all ten subjects, and
select_confirm_transfer_item is a parallel-item flow needing a source item, not a queue.

Measured facts, from Production today. Check them yourself; do not take them on trust:

  * Biology published items: 118 = 75 FRQ + 43 MCQ.
  * Biology practice_format: 72 frq/targeted_drill, 3 frq/null, 43 mcq/null.
  * NO MCQ IN ANY SUBJECT HAS A practice_format. 0 of 783 published MCQ product-wide.

That last fact is the crux. practice_format was never applied to MCQ, which strongly suggests MCQ
were always intended to arrive through the unit-gated path and the practice path was built for FRQ
only. You are being asked to change that, so say clearly what the change means.

STEP 1 — DESIGN PROPOSAL. Deliver this and STOP. Do not write the implementation yet.

Compare at least these three, and recommend one:

  A. Give MCQ a practice_format and reuse select_practice_frqs, widening its item_type filter.
     Cheapest in code. Ask: does 'targeted_drill' mean the same thing for an MCQ as for an FRQ, and
     what happens to the other 740 MCQ in nine other subjects when the filter widens?
  B. A sibling function (select_practice_mcqs, or a combined select_practice_items) that serves MCQ
     without using practice_format at all. More code, no semantic stretch, no cross-subject blast
     radius.
  C. Something you think is better. Say why.

For your recommendation, state explicitly:
  - what a student receives, and in what mix of MCQ and FRQ
  - the blast radius on the other nine subjects, item by item where it is not obvious
  - what happens to attempt-response, which currently rejects a mismatch between the session's
    practice_format and the item's with error practice_format_mismatch
  - whether student-session-items needs changes. Note it already has an MCQ delivery precedent:
    the select_confirm_transfer_item branch tags rows item_type 'mcq' so the client renders choices
    rather than an FRQ textarea. Say whether your path reuses that or needs its own.
  - how grading works. evaluate-attempt handles FRQ against frq_criteria; establish what the MCQ
    path does and whether it already works, rather than assuming.

STEP 2 — after the design is approved, implement it. Proposal only, no Production writes; Claude
QAs and applies.

THE ONE INVARIANT THAT CANNOT BEND

A student must never receive is_correct or rationale before submitting. The current boundary is
enforced by COLUMN-LEVEL GRANTS on app.mcq_choices: authenticated has SELECT on id,
content_item_version_id, choice_key, choice_text, created_at and on nothing else.

So whatever you build must deliver choices WITHOUT those two columns. Two specific traps:

  1. A SECURITY DEFINER function bypasses column grants. If your serving function is SECURITY
     DEFINER (the existing ones are), the grants stop protecting anything and the function's own
     select list becomes the only boundary. Name the columns explicitly; never select *.
  2. Do not widen any grant or add is_correct to any view "temporarily to test". The revoke that
     closed this took a coordinated three-part fix; re-opening it casually would undo that.

Include in your proposal how you would PROVE the key is not served — a functional probe as
authenticated, not an inspection of the code.

BEFORE YOU DESIGN: confirm the client-side fallback. The activity log entry for 2026-09-24 says the
Lovable app reaches MCQ by querying published items directly, bypassing student-session-items,
because that function does not reliably honour item_type. If true, your design's success condition
is that the fallback can be DELETED -- not merely that MCQ appear. Establish what the fallback
actually queries before proposing anything, and diagnose the item_type filter bug: it may be the
entire problem, in which case options A, B and C above are all the wrong answer and the right one is
a bug fix.

WHAT WOULD MAKE THIS WORK REJECTED AT QA

  - Serving MCQ whose is_correct or rationale is reachable by authenticated, by any path.
  - Widening select_practice_frqs' item_type filter without accounting for the 740 MCQ in nine
    other subjects that would become servable at the same moment.
  - Setting practice_format on MCQ as a data migration without having argued, in the design, that
    the field means something coherent for an MCQ.
```

## Why this is the right thing for Codex to hold

FF-1 is the only open item that changes what a Biology student can be served. J.0, N and N.1 are all
real work and none of them move that number. If Codex has capacity for one thing, this is it.

## What stays with Claude

- QA of the design proposal and then of the implementation.
- FF-15 (`student-session-items` returns an empty queue with no reason) — one edge-function change,
  and the finding that produced it is in the FF-2 write-up.
