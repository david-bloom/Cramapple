# Codex Work Order FF-1 Step 2 — Implement the Biology MCQ Practice Selector

**Step 1 is approved.** Claude independently re-verified every Production fact and every code
citation in `docs/research/ff1_mcq_serving_design_2026_09_24.md` (re-run against Production directly,
not taken on trust) and confirms Option C. Two nits from that QA are folded into this order below;
neither changes the design, both are implementation details. This is the only open fast-follow item
that changes what a Biology student is served — closing it completes the fast-follow tracker's
definition of done for launch-moving work (J.0/N/N.1 remain separate, unit-gated-path work).

Paste the block below into Codex.

```text
Work order FF-1 Step 2 — implement the Biology-scoped combined practice selector designed in Step 1.

Merge main first:

    git fetch origin
    git switch codex/work-order-ff1-mcq-serving
    # If that branch does not exist instead run:
    # git switch -c codex/work-order-ff1-mcq-serving origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/work-order-ff1-mcq-serving as you go. Do not open a PR and do not merge to main.

FIRST: if docs/research/ff1_mcq_serving_design_2026_09_24.md is not already committed on this
branch, commit it now, unchanged, as the record of the approved design. If you cannot recover that
file, the approved design is fully restated below and you do not need to reconstruct it.

THE APPROVED DESIGN (Option C)

A Biology-only combined selector serves both eligible FRQ and all published Biology MCQ for the
existing `targeted_drill` session type. `practice_format` is not touched, not migrated, and its
FRQ-only meaning does not change. Every other subject and every other format keeps calling
`public.select_practice_frqs` exactly as today. At today's pool (71 eligible FRQ, 43 MCQ) a 20-item
request returns 12 FRQ + 8 MCQ, interleaved, session-stable.

STEP 2A — DATABASE MIGRATION

Add a new migration creating:

    app.select_biology_practice_items(
      _exam_pack_version_id uuid,
      _practice_format text,
      _selection_seed uuid,
      _limit integer default 20
    )

Required properties, all of them:

  1. `LANGUAGE sql STABLE SECURITY INVOKER`, with `SET search_path = 'pg_catalog'` exactly as
     `public.select_practice_frqs` and `public.select_unit_gated_practice_items` already do. (This
     was flagged at QA as implied but not explicit in the design doc -- treat it as required, not
     optional.)
  2. `REVOKE EXECUTE ... FROM PUBLIC, anon, authenticated;` then `GRANT EXECUTE ... TO service_role;`
     -- the identical pattern already used for `app.select_confirm_transfer_item`. Verify with
     `has_function_privilege` for all three roles as part of your own QA before handing back.
  3. Fail closed to zero rows unless the resolved `exam_code = 'ap_biology'` and
     `_practice_format = 'targeted_drill'` exactly. Do not serve `full_exam_frq` from this function;
     that stays on the old selector and stays empty (FF-2, out of scope).
  4. FRQ eligibility mirrors `select_practice_frqs` exactly: published item and version,
     `item_type = 'frq'`, `practice_format = 'targeted_drill'`,
     `coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true`.
  5. MCQ eligibility: published item and version, `item_type = 'mcq'`, and the SAME hand-drawn
     predicate as FRQ --
     `coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true`. (Second QA nit: the
     design doc said "not hand-drawn" without pinning the exact predicate. All 43 current Biology
     MCQ are non-hand-drawn today, so this is a no-op now, but write the filter so a future
     hand-drawn Biology MCQ is excluded automatically rather than silently served.) Do not read
     taxonomy labels or `practice_format` for MCQ eligibility.
  6. Return only existing render metadata plus an explicit `item_type` column. Never join
     `app.mcq_choices`, never select an answer key, never use `SELECT *`.
  7. Derive the FRQ/MCQ quota proportionally from the two eligible pool sizes with largest-remainder
     rounding, filling unused quota from the other pool if one is short.
  8. Order within each type by a deterministic hash of `_selection_seed` (the owning learning
     session ID) and content-item-version ID, then interleave by quota. Re-fetching the same session
     must return a stable set; different sessions must not permanently starve the MCQ pool.
  9. Clamp `_limit` exactly like the existing selectors:
     `limit greatest(1, least(coalesce(_limit, 20), 50));`

Resolve `exam_code` inside the function via `content_items -> exam_pack_versions -> exam_packs`, the
same join path used for every fact-check in the design doc.

STEP 2B — EDGE FUNCTION (student-session-items)

In `supabase/functions/student-session-items/index.ts`:

  - Extend the Gate-1 session lookup (currently
    `select("id, user_id, exam_pack_version_id, practice_format, status")`) to also resolve the
    session's `exam_code`, via the same join path as the migration.
  - In the branch that currently calls `select_practice_frqs` unconditionally when
    `session.practice_format` is set: if the resolved exam is AP Biology AND
    `session.practice_format === 'targeted_drill'`, call
    `app.select_biology_practice_items` instead, passing the learning session ID as
    `_selection_seed`. Every other subject and every other format must call
    `select_practice_frqs` exactly as today -- do not change that branch's behavior.
  - The new function already returns `item_type`; do not add a hardcoded tag the way the
    confirm-transfer branch does for its all-MCQ result.
  - Reuse `withHandDrawnFlag`, `deliverRows`, and `buildRenderItem` unchanged.
  - Add a fail-closed check inside `deliverRows`: any row with `item_type === 'mcq'` that resolves
    to zero choices must be omitted from the response with a non-sensitive reason such as
    `choices_missing`, not silently served with an empty choice array and not a 500.

Do not modify `attempt-response` or `evaluate-attempt`. Step 1 established both already handle a
NULL-format MCQ correctly (`attempt_mode` check passes, `practice_format_mismatch` does not fire,
`evaluate-attempt` already routes `item_type='mcq'` to the deterministic `rule-based-mcq` path).
Confirm this with a test, but do not add code there unless a test actually fails.

STEP 2C — TESTS

Add, at minimum:

  - SQL: Biology targeted-drill returns the proportional mix at today's pool sizes, explicit
    `item_type` on every row, no `is_correct`/`rationale`/other answer field in the returned columns,
    stable order for a repeated call with the same seed, rotation for a different seed, zero rows
    for a non-Biology pack or a non-`targeted_drill` format, zero rows if a hand-drawn Biology MCQ
    exists in the eligible set.
  - SQL: `has_function_privilege` false for `anon` and `authenticated`, true for `service_role`.
  - Edge: Biology `targeted_drill` sessions route to the new selector; every other
    subject/format combination still calls `select_practice_frqs` with unchanged arguments; a
    served MCQ row's choices contain only `choice_key`/`choice_text`; a choices-missing MCQ is
    omitted, not served empty; session ownership enforcement (Gate 1) is unchanged.
  - Attempt/grading integration: create an attempt on a served NULL-format Biology MCQ with
    `attempt_mode='mcq'` and confirm no `practice_format_mismatch`; submit a known-correct and a
    known-wrong choice and confirm `evaluate-attempt` returns 1/1 and 0/1 through `rule-based-mcq`
    with zero model tokens; confirm grading rejects an unsubmitted response before loading the
    answer key (existing behavior -- write a regression test, do not change the code path).

STEP 2D — REQUIRED AUTHENTICATED FUNCTIONAL PROBE (not optional, not satisfied by the SQL tests
above)

Using a real non-admin student access token against your deployed branch/QA target, not the service
key and not a SQL role switch:

  1. Start or reuse an owned, active Biology `targeted_drill` session.
  2. Call `/functions/v1/student-session-items` with that token and a limit-20 request. Assert
     HTTP 200, 20 items before any legitimate media omission, 12 FRQ and 8 MCQ at today's pool, and
     every MCQ has four `choice_key`/`choice_text` pairs.
  3. Recursively scan the full raw JSON body and fail if any key anywhere equals `is_correct` or
     `rationale`.
  4. With the same student token, issue a Data API projection against `app.mcq_choices`: confirm
     `choice_text` succeeds and both `is_correct` and `rationale` return 403/permission denied. (This
     repeats, under a real token this time, the column-grant check Claude ran with a bare
     `SET LOCAL ROLE` during Step 1 QA -- that earlier check proved the column boundary but not the
     request-time path; this probe is the one that counts.)
  5. Create an attempt on one served MCQ with `attempt_mode='mcq'`, submit a selected
     `response_parts.selected_choice_key`, then call `evaluate-attempt`. Assert the pre-submit call
     is rejected, the post-submit call returns the correct 0/1 result, and neither response reveals
     the correct key or rationale.

Report the actual request/response evidence for all five checks, not a summary that they "passed."

WHAT WOULD MAKE THIS REJECTED AT QA

  - `is_correct` or `rationale` reachable by `authenticated`, by any path, at rest or in a response.
  - `anon`, `authenticated`, or `PUBLIC` able to execute the new function.
  - Any change to `select_practice_frqs`'s behavior or arguments for non-Biology subjects, or to
    `attempt-response`/`evaluate-attempt` without a failing test that required it.
  - The new function missing the pinned `search_path`, or using `SELECT *` anywhere, or being marked
    `SECURITY DEFINER`.
  - A hand-drawn Biology MCQ (now or added later) served through this path.
  - Skipping the Step 2D authenticated probe in favor of the SQL-only checks.

Proposal only. No Production writes. Claude QAs this and applies both the migration and the Edge
Function change to Production.
```

## Why this is scoped the way it is

FF-1 is the only open fast-follow item that changes what a Biology student receives (per
`docs/product/AP_BIOLOGY_FAST_FOLLOW.md`); J.0, N, and N.1 are already queued separately and none of
them touch launch-day serving. Closing FF-1 Step 2 is therefore the remaining launch-content work,
not a parallel track.

## What stays with Claude

- QA of this implementation against the "what would make this rejected" list above, including
  independently re-running the Step 2D probe rather than trusting Codex's report of it.
- Applying the migration and Edge Function change to Production after QA passes.
- Updating `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` to close FF-1 once verified live.
