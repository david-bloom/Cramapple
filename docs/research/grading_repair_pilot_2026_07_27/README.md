# Engine 1 Grading + Repair Pilot — Accuracy / Speed / Cost — 2026-07-27

## Purpose

This is the first real (non-mocked, non-deterministic-only) exercise of Cramapple's
Engine 1 grading path (`evaluate-attempt` + `grading-router` + `grading-repair`)
against real published/reviewed content in Production. It answers three questions
David asked, in this priority order (matching the standing
[Grader priority order](../../../docs/GRADING_PROGRAM.md) — Speed > Quality > Cost,
up to $0.03/FRQ acceptable, never trade speed for cost):

1. **Accuracy** — does the grading engine's score ranking track the intended
   quality ordering of a set of varied student answers? Does the repair layer
   (`grading-repair.ts`) correctly identify and act on genuine errors
   (arithmetic slips, missing evidence, conceptual errors) versus over-firing
   on strong answers or under-firing on weak ones?
2. **Speed** — real per-grade latency (`evaluate-attempt` → `grading_results`
   timestamp delta), and whether repair passes add meaningful additional
   latency.
3. **Cost** — real per-grade token/dollar cost as logged in `grading_results`,
   projected to per-1000-student and exam-week-tail-latency scale (per
   [Cramapple scale](../../../ — see memory `project_cramapple_scale.md`): ~2500
   AP Bio students for Aug 2026 beta, exam-week tail latency is brand-critical).

This is a **pilot** — 6 items × 5 answers = 30 real grading calls. It is not a
statistically powered calibration study; treat results as directional signal
for whether Engine 1 is on track, not a launch-gate pass/fail.

## Why this sample

All 6 items were verified live against Production (`pcntajvbdfqhbeewmdry`) on
2026-07-27:
- `status = 'published'`
- backed by a real `content_review_decisions` row with
  `tutor_decision in ('approve', 'approve_with_edits')`

This matters because `evaluate-attempt` hard-rejects any content that isn't
`published` (`content_not_published`) — `reviewed_approved`-only items will not
work. It also matters because, per the
[publish-without-approval finding](../../../ — memory `project_publication_p0_and_task0017.md`),
most currently-published content was **never** actually reviewed — these 6
items are deliberately the exception, so grading results here reflect real
vetted rubrics, not the ~half of "published" content that skipped review.

MCQs were deliberately excluded: MCQ grading uses `evaluator_strategy:
"rule_based_mcq"` (see `scripts/content-seed/build-chemistry-physics-load.mjs:76`)
— pure choice-match, no model call, no partial credit, no repair path. There is
nothing for this pilot to test on MCQs.

## Data provided

`candidate_answers.json` in this directory contains all 30 candidate answers,
already mapped to real `content_item_id` / `content_item_version_id` values.
**Re-verify these IDs and each item's `status`/review-decision at execution
time** — they were correct as of 2026-07-27 but content state can change.

Each answer carries a `quality_tier` (1–5, one tier-5 per item). This tag was
generated independently by Gemini, **blind to the canonical answer and rubric
criteria** (to avoid the grading-content author's own bias leaking into the
test set), and is a **self-assessed, uncertified expected-quality signal** —
not verified ground truth. See `_meta.quality_tier_caveat` in the JSON for one
known ordering quirk on `APSTAT-MOD3-E005` that was deliberately left as-is.

The exact generation prompt is preserved in `gemini_answer_generation_prompt.md`
for provenance/reproducibility.

## Execution plan

### 0. Pre-flight

- Confirm you're working from `claude/cramapple-grading-experiments-9lkjqc` (or
  its current successor) — this branch has `grading-router.ts`,
  `grading-repair.ts`, and the current `evaluate-attempt/index.ts`.
- Re-run the verification query below against Production and confirm all 6
  `content_item_version_id`s still show `status = 'published'` with a real
  approval decision:

  ```sql
  with decided as (
    select distinct content_item_version_id
    from app.content_review_decisions
    where tutor_decision in ('approve','approve_with_edits')
  )
  select ci.content_key, ci.status, d.content_item_version_id is not null as has_approval
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id = ci.id
  left join decided d on d.content_item_version_id = civ.id
  where ci.content_key in (
    'APBIO-FRQ-L-015','APBIO-FRQ-L-028','APBIO-FRQ-L-021',
    'STATS-MOD1-E005','APSTAT-MOD3-E005','APSTAT-MOD4-M003'
  );
  ```

### 1. Create one isolated test identity

- Create a single Supabase Auth user in Production, clearly labeled as
  synthetic, e.g. email `grading-pilot-20260727+test@cramapple-internal.test`.
- Create a matching `app.profiles` row, `role = 'student'`, with something in
  a notes/metadata field (if one exists) marking it as pilot/test data. If no
  such field exists, record the user id and profile id in this directory's
  `EXECUTION_LOG.md` (create it) so cleanup can find it unambiguously later
  even if this conversation is lost.
- Do not reuse any real student's identity or any account tied to real usage.

### 2. Run each of the 30 answers through the real grading path

For each of the 30 `(content_item_version_id, response)` pairs:

1. Insert an `app.attempts` row for the test student against that
   `content_item_version_id` (check current schema for any other required
   FKs — e.g. exam session / learning_session linkage — and satisfy them
   minimally; do not create real-looking session state beyond what's
   required).
2. Insert an `app.response_versions` row under that attempt with
   `is_submitted = true` and the answer `text` from `candidate_answers.json`.
3. Call `evaluate-attempt` with a real bearer token for the test student (or
   admin, which skips the entitlement RPC but still writes the same tables),
   passing `attempt_id`, `response_version_id`, `content_item_version_id`,
   the correct `rubric_version_id`, and a unique `idempotency_key`.
4. Record the full response and the resulting `grading_results` row: points
   earned/available, per-criterion breakdown, cost, latency, and — critically
   — whether a repair pass fired, and if so its `repair_class` and
   `expected_point_gain` (see `grading-repair.ts`).

Do this for all 30. Where feasible, run within-item calls sequentially (not
concurrently) so latency numbers aren't skewed by shared-resource contention,
but different items can run in parallel.

### 3. Analyze and report

Produce `RESULTS_2026_07_27.md` in this directory with:

- **Accuracy**: per item, a table of `quality_tier` vs. actual
  `points_earned / points_available`. Note whether the ordering is monotonic;
  flag and discuss any inversion (including the known `APSTAT-MOD3-E005`
  tier-2/tier-3 quirk — does the grader's score order agree with Gemini's tag,
  or with your own independent read of which answer is more wrong?). Separately
  report repair-pass behavior: on which of the 30 calls did repair fire, was
  the `repair_class` a sensible match to the actual error type, and did it
  measurably move the score in the right direction?
- **Speed**: latency per call (mean, median, max), broken out by whether a
  repair pass fired vs. not, and by subject/item length. Flag anything that
  would be concerning at exam-week tail-latency scale.
- **Cost**: real dollar cost per grade from `grading_results` (or computed from
  logged token counts), mean and total for the 30 calls, and a projection to
  the ~2500-student Aug 2026 beta scale. Compare against the ≤$0.03/FRQ
  ceiling already accepted in
  [Grader priority order](../../.. — memory `feedback_grader_priority.md`).
- **Open issues**: anything encountered that should block wider Engine 1
  rollout (e.g., repair systematically over/under-firing, cost per grade above
  ceiling, latency spikes), vs. things that are fine to note and move on from.

### 4. Cleanup (required — do not skip)

- Delete all 30 `grading_results` rows tied to the test attempts.
- Delete all `response_versions` and `attempts` rows for the test student.
- Delete any `student_memory`/session-state rows written by
  `persistGradingMemory` for the test student, if any were created.
- Delete the test `app.profiles` row and the test Supabase Auth user.
- Confirm via a final query that no rows referencing the test student id
  remain anywhere in `app.*`.
- Record what was deleted in `EXECUTION_LOG.md`.

## Guardrails

- This touches Production. The only identity used must be the one isolated
  test student created in step 1 — never a real student, tutor, or admin
  identity's real data.
- All writes must be fully reversible via the cleanup step above.
- Do not modify `status`, review decisions, or any other field on the 6 real
  content items themselves — this pilot only reads their content and grades
  synthetic submissions against them.
- This work is independent of, and does not block or depend on, the two other
  queued items: the publish-without-approval backfill and the
  `codex/five-subject-harness-and-content` branch-consolidation merge.
