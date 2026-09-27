# Codex Work Order — AP Statistics Launch-Readiness Measurement

**Context.** AP Biology went from "unclear" to launch-ready today (2026-09-24) by measuring against
live Production via the real serving RPCs rather than trusting docs — see
`docs/product/AP_BIOLOGY_LAUNCH_READINESS_2026_09_24.md` and
`docs/product/AP_BIOLOGY_FAST_FOLLOW.md` for the pattern and the format this should follow. This
order asks for the same treatment for **AP Statistics**. Proposal/measurement only — no Production
writes, no PR, no merge to main.

Paste the block below into Codex.

```text
Work order — AP Statistics launch-readiness measurement, Biology-pattern.

Merge main first:

    git fetch origin
    git switch codex/apstats-launch-readiness-2026-09-24
    # If that branch does not exist instead run:
    # git switch -c codex/apstats-launch-readiness-2026-09-24 origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/apstats-launch-readiness-2026-09-24 as you go. Production project ref: pcntajvbdfqhbeewmdry.
Read-only SQL only against Production; this order produces a report and proposals, not writes.

READ FIRST:
- docs/product/AP_BIOLOGY_LAUNCH_READINESS_2026_09_24.md (the six-condition format to mirror,
  including its own correction section -- notice how the FIRST version of that doc computed a wrong
  servable-item number by modeling the serving selector instead of calling it; call every RPC for
  real, do not model it)
- docs/product/AP_BIOLOGY_FAST_FOLLOW.md (the tracker format for whatever fast-follow items you find)
- docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md (Phase 7 "Launch readiness review" is marked not
  started -- this order effectively is that phase)
- docs/tasks/TASK-0022-AP-STATISTICS-MULTIPOINT-RUBRIC-DEFECT.md (Status: In Progress -- every
  published AP Statistics FRQ criterion defaults to points_possible=1 regardless of real AP point
  value; a pilot fixed 4 items, "pass 2" language suggests more since, but the doc's own header says
  spatial-item and reviewed_approved-backlog scope is still open)
- docs/research/grading_launch_gate_audit_2026_07_08.md (records the Statistics gold set as not yet
  adjudicated against a launch bar)

PART 1 -- THE DUAL-PUBLISHED-EXAM-PACK-VERSION FINDING (highest priority; investigate and explain
this before anything else)

Verified directly against Production just now, not modeled:

  select epv.id, epv.status, epv.created_at,
    (select count(*) from app.content_items ci where ci.exam_pack_version_id = epv.id and ci.status='published') as published_items
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_statistics'
  order by epv.created_at;

  -- 548f06be-ccf4-426d-b82b-b424137a4438  published  2026-07-01  193 published items
  -- 7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada  published  2026-08-24  203 published items

Both are simultaneously `status='published'`. Calling the real selector against each:

  select count(*) from public.select_practice_frqs('548f06be-ccf4-426d-b82b-b424137a4438'::uuid, 'targeted_drill', 999);  -- 49
  select count(*) from public.select_practice_frqs('7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada'::uuid, 'targeted_drill', 999);  -- 0

The newer version (203 published items) serves **zero** targeted-drill content -- almost certainly
because it has no serving labels populated for it yet (check `app.content_taxonomy_labels` scoped to
this exam_pack_version_id / its content_items to confirm). A student's version is chosen by
`public.set_active_exam_pack_version`, gated only by `app.exam_pack_version_is_selectable` (published
+ not retired + subject active) -- both versions pass that gate equally, so nothing in the database
prevents a student from being routed to the empty one.

This is not hypothetical. Real session history:

  select ls.exam_pack_version_id, count(*), min(ls.created_at), max(ls.created_at)
  from app.learning_sessions ls
  where ls.exam_pack_version_id in ('548f06be-ccf4-426d-b82b-b424137a4438','7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada')
  group by ls.exam_pack_version_id;

  -- old (working) version: 49 sessions, 2026-07-09 through 2026-09-24
  -- new (empty) version:   51 sessions, 2026-08-27 through 2026-09-23

51 sessions ran against a version that structurally cannot serve targeted-drill content, for almost a
month. Find out:
1. Why the newer version was published without serving labels ever being generated for it -- was
   this an in-progress content refresh that got published prematurely, or something else? Check
   content_item_versions.created_at / created_by patterns, any migration or seed script that touched
   this exam_pack_version_id, and whether the 203 published items under it are genuinely new/different
   content from the 193 under the old version or largely the same content re-published under a new
   version row.
2. Which accounts actually ran the 51 sessions against the empty version, and what those sessions'
   actual experience was (do the same silent-empty-queue check FF-15 fixed for Biology apply here too
   -- does student-session-items report a reason, or just `items: []`?).
2a. Note this is likely the exact same silent-absence failure class as Biology's FF-15
    (`docs/product/AP_BIOLOGY_FAST_FOLLOW.md`, FF-15): an empty queue reporting `status: ok` with no
    indication anything is wrong. Confirm whether student-session-items' FF-15 fix (a `reason` field
    on the empty branch) already covers Statistics too (it should -- that fix wasn't subject-scoped),
    and if so, whether the 51 historical sessions predate that fix landing today.
3. Propose (do not apply) a fix: likely candidates are (a) retire the empty version properly
   (epv.retired_at) once you've confirmed nothing needs it, (b) finish labeling the newer version's
   content and make IT the sole published one, retiring the old one, or (c) something else your
   investigation surfaces. State which you recommend and why -- this is a real content/ops decision,
   not just a query fix.

PART 2 -- THE SAME SIX-CONDITION MEASUREMENT BIOLOGY GOT

For whichever exam_pack_version_id you determine is (or should be) the one students actually use,
measure and report exactly like AP_BIOLOGY_LAUNCH_READINESS_2026_09_24.md did:

1. Real servable item counts by calling `select_practice_frqs` for both `targeted_drill` and
   `full_exam_frq`, and separately whatever the unit-gated selector reports for this subject.
2. Canonical answer coverage: how many published FRQs have `canonical_answer_1`, and separately how
   many have `app.canonical_answer_spans` rows (the segmentation Open Hand strikes against -- see
   `docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md`'s D0/M0 sections for what this table is and
   why span coverage is a distinct, later-arriving fact from canonical-answer coverage; do not
   conflate "has a canonical" with "has spans").
3. Difficulty: does `app.content_item_difficulty` have any rows for AP Statistics content_item_version_ids? (Answer is very likely no --Statistics wasn't in scope for today's Biology-only load-- but verify rather than assume, and note the table shape already supports it if a future work order is wanted.)
4. Serving-label coverage/status distribution, same shape as Biology's census: how many current
   (non-superseded, label_scope='serving') content_taxonomy_labels rows exist per label_status
   (legacy_unvalidated / provisional_model / validated / stale / held), for the exam_pack_version_id
   from Part 1.
5. TASK-0022's exact remaining scope: how many published Statistics FRQ still have every criterion at
   points_possible=1 (the defect), separated from how many have been genuinely fixed already. Cross-
   reference against the task doc's claimed progress rather than trusting it.
6. DECISION-0052 grader-gate reachability: pick 2-3 published Statistics FRQ with a canonical answer
   and run `app.qa_grade_frq` against each 3 times (same multi-run discipline as Biology's M5 baseline
   -- a single run proved nothing there). Report status/confidence/integrity per run. Note: this only
   works for items with `canonical_answer_1` populated; if none exist yet, say so plainly rather than
   skipping the section.
7. Confirm (do not assume) that the mcq_choices.is_correct/rationale column-grant fix (migrations
   20260824040000/20260824060000/20260827010000, described as table-wide in memory, not
   Biology-scoped) actually applies to AP Statistics MCQ the same way -- spot-check by reading
   grants on a Statistics-scoped query the same way FF-13's original verification did for Biology.

DELIVERABLE

A single doc, `docs/product/AP_STATISTICS_LAUNCH_READINESS_2026_09_24.md`, in the same structure as
Biology's: a top-line "what's actually servable" number with the reasoning, the condition-by-condition
table, and a "what launch actually needs, in order" section. Call out Part 1's dual-version finding as
the first and highest-priority item regardless of where it'd otherwise rank.

WHAT WOULD MAKE THIS REJECTED AT QA

- Any Production write, including retiring a version or touching a label.
- Modeling a selector's behavior instead of calling it (this is exactly the mistake Biology's own
  readiness doc made and had to correct same-day -- do not repeat it).
- Treating canonical_answer_1 coverage and canonical_answer_spans coverage as the same fact.
- A single grader-gate run reported as if it were reliable evidence.
- Skipping Part 1 or treating it as equal priority to the rest -- it's a live, dated problem (a month
  of real sessions against dead content), not a backlog item.
```
