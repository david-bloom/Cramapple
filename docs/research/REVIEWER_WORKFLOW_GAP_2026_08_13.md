# Reviewer workflow gap: the AP-reader dead end — 2026-08-13

**Trigger:** Owner questions after the 08-13 backlog publish — "why are these
18 `reviewed_approved` items not published?" and, more pointedly, "if the
question has `tutor_review_pending` how does it have an approved label?"
Both questions led to a real code bug, not just a data cleanup.

## 1. The bug

`supabase/functions/review-decision/index.ts`'s `advanceWorkflow` function:
when both tutors on a blind pair approve (aggregate score 2, "Yes+Yes"), the
code looked up a `profiles` row with `role='reader'`, created a
`reader_question` assignment for that reader if one was found, and then
**unconditionally** set `review_status='ap_reader_pending'` — regardless of
whether a reader was actually found and assigned.

**No `reader` role has ever been staffed in Production.** Confirmed: the
reader lookup always returns nothing, no `reader_question` assignment is ever
created, and `ap_reader_pending` has no code path anywhere in the codebase
that ever advances it further. Every item that reached this branch got
permanently stuck below the P0-B publish gate's allowlist
(`CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §7.2) — identical in shape to a bug
already fixed on 2026-08-08 one step later in the same state machine (the
`reader_question`/MCQ branch, which used to leave `review_status` at
`answer_tutor_review_pending` with nothing to advance it — see that fix's
inline comment for the parallel).

A second, related branch had the same dead-end shape: when the two tutors'
`difficulty_label` values disagreed, the code set
`review_status='difficulty_discussion'` — another value nothing ever
resolves back out of.

**Owner direction, 2026-08-13:** this operation does not use an AP-reader
role at all — "that label should not be used for any question." And
difficulty-label disagreements should not block publish — "when in doubt,
use the harder level of difficulty."

## 2. The fix

`supabase/functions/review-decision/index.ts`, the `aggregate === 2` branch:
removed the reader lookup/assignment entirely and the `ap_reader_pending`
status; goes straight to the terminal `review_status` the `reader_question`
branch would have set on approval (`mcq_answer_review_complete` for MCQ,
`question_review_approved` for FRQ). Removed the `difficulty_discussion`
blocking branch — a difficulty-label disagreement between two tutors is no
longer a publish gate.

Deployed to Production (`review-decision`, version 25).

## 3. Why `tutor_review_pending` items had an "approved" label — the deeper finding

Investigating the owner's second question turned up something more
significant than a code gap: **`content_items.status='reviewed_approved'`
is never set by any application code path.** A repo-wide `grep` for
`reviewed_approved` across `supabase/functions/**/*.ts` returns zero matches.
Every occurrence of that status in Production was set by an ad hoc SQL
script at some point (remediation passes, backfills — the same kind of
script this session has been writing all day), not by the review workflow
reaching a genuinely terminal state.

This means `content_items.status='reviewed_approved'` is not a reliable
signal on its own — it has to be cross-checked against
`content_item_versions.review_status` actually being terminal, which is
exactly why this session's publish steps have always filtered on
`review_status`, never on `content_items.status` alone.

Concretely, two of the 18 stuck items turned out to be more than a simple
reader-stage dead end:

- **`APBIO-FRQ-S-031`** never advanced past the *initial* `tutor_review_pending`
  value assigned when the assignment was created — the `advanceWorkflow`
  logic never ran for it at all. Root cause: a stray third `tutor_question`
  assignment (reviewer "Morgan," in its own separate, incomplete blind group)
  meant the item's *real* pair — Sarah Sohail and Adil Abbasi — should have
  triggered the state machine normally when both submitted, but something
  prevented it (not fully diagnosed; plausibly predates the current
  `advanceWorkflow` code, or the decisions were submitted through a path that
  bypassed it). Their actual scores: Sarah approve (1) + Adil approve_with_edits
  (2) = aggregate 3, "modification_reserved" — **not** an approval at all.
  Whatever process set `content_items.status='reviewed_approved'` on this item
  was simply wrong.

  Checked Adil's stated concern ("only FRQ with no stimulus at all") against
  current content: **does not reproduce.** The item has a complete,
  well-formed stimulus (synthetic phospholipid bilayer fluidity comparison),
  and the membrane-fluidity biology in both criteria was independently
  re-derived and confirmed correct (unsaturated tails increase fluidity via
  kinks that prevent tight packing; cholesterol restricts fluidity at high
  temperature and prevents over-rigidity at low temperature — standard,
  correct AP Biology content). Owner-adjudicated: approved and published,
  with the discrepancy logged in the decision note rather than silently
  overridden.

- **`APSTATS-HDG-2026-GRAPH-005`** is a genuine, different gap: it has only
  ever had **one** assigned tutor (Jill Schmidlkofer), never paired with a
  second reviewer, so the two-reviewer blind-check the state machine requires
  can never complete for it as-is. **Not touched by this remediation** —
  needs either a second reviewer assigned or an explicit owner decision to
  accept single-reviewer approval for this item, which is a bigger policy
  call than a data-consistency fix.

## 4. Remediation

`scripts/content-seed/reviewer-qa-remediation/20260813_workflow_gap_reader_stage_repair.sql`:

- **13 items** (12 of the 16 auto-advance candidates, plus `APBIO-FRQ-S-031`)
  also had `content_item_versions.status` stuck at `retired` despite being
  the current, only version and despite `content_items.status` correctly
  reading `reviewed_approved` — the same stale-version-status pattern found
  and fixed twice already this session (`apchem-frq-l-012` in the backlog
  publish; recurring here across a whole batch of AP Biology FRQ-S items).
  Corrected before publish could proceed.
- **13 items** were also missing `practice_format` (with `frq_archetype`
  also null) — same fix applied throughout this session:
  `practice_format='targeted_drill'`.
- **16 items** whose `aggregate=2` was already validly computed by the
  (buggy) code advanced straight to their terminal `review_status` and
  published. No content changes — these were always correctly approved,
  just never allowed to leave the dead-end status.
- **1 item** (`APBIO-FRQ-S-031`) owner-adjudicated per §3 above.

**Result:** P0-B net check **0**, 0 duplicate published versions, all 17
confirmed published. `APSTATS-HDG-2026-GRAPH-005` is the sole remaining
non-terminal `reviewed_approved` item corpus-wide, left for an owner
decision.

## 5. Follow-ups

- **Decide `APSTATS-HDG-2026-GRAPH-005`**: assign a second reviewer, or
  accept Jill's single review as sufficient and adjust policy/code to match.
- **`content_items.status` is not a trustworthy standalone signal.** Nothing
  in the application code ever sets it to `reviewed_approved` — every
  instance in Production came from a script. Worth deciding whether this
  status field should be derived automatically from `review_status`
  (removing the drift risk entirely) rather than continuing to be set by
  ad hoc scripts that can (and did, at least once) get it wrong.
- **Root cause of `APBIO-FRQ-S-031`'s stuck `tutor_review_pending` state**
  (why `advanceWorkflow` never ran for its real Sarah/Adil pair) was not
  fully diagnosed — worth a closer look if the same symptom (assignment
  group complete and submitted, but `review_status` still at its initial
  value) turns up again elsewhere in the corpus.
