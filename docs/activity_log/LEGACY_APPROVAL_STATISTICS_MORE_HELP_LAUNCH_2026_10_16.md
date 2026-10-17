# Historical approval record — Statistics More help launch, 2026-10-16

> **Identifier correction, 2026-10-17:** this branch originally claimed `APPROVAL-0183`, which is already assigned on canonical `main` to the AB-to-BC question-image mirror. Bare `APPROVAL-0183` refers only to that BC approval. Cite this Statistics historical record by its full path, `docs/activity_log/LEGACY_APPROVAL_STATISTICS_MORE_HELP_LAUNCH_2026_10_16.md`; the old number is provenance, not a second active approval. This archives the earlier reported authorization/execution without granting new Production authority or claiming a fresh live verification. Later state is in `docs/handoffs/MORE_HELP_REMAINING_TASKS_2026_10_17.md`.

**Decision:** Approved and applied; verified live.
**Date:** 2026-10-16
**Approver:** Product Owner David Bloom ("Then launch More Help for statistics"; app publication performed by the Product Owner in Lovable)
**Tier:** Hard-Gate (live Production database functions, Edge Function and app)

**Sequence (backend first, app last):**
1. **Gate migration** (`docs/qa/more_help_release/01_apply_gate.sql`): `app.more_help_subject_policy` seeded with Calculus AB/BC and Chemistry (all units, behavior unchanged); reservation function replaced. Guarded on the recorded Production MD5; rehearsed on Production (rolled back); post-apply MD5 `582930f351d7fbd7b9ad01a2bc8adccb` equals the tested Development function.
2. **Grounding migration** (`20261015175446_more_help_question_grounding.sql`): replaces `get_question_experience` with the additive authored-parts/visual/figure version. Guarded on Production MD5 `afa7b92b…`; rehearsed on Production including a rollback to the exact prior function; post-apply MD5 `5c4799dfb8ca48d6e7f5491806e63803` equals Development. Rollback definition saved privately.
3. **`more-help` Edge Function** deployed from `codex/more-help-all-subjects-u1-u3` @ `c58ff339` (Production counter v2, JWT-verified). Diff against Production v1 was a strict superset (v14 fixes, grounding module, FRQ identify/define rule).
4. **Policy row:** `ap-statistics` allowed units `{1,2,3}` (`02_enable_subject.sql`). Units 4+ and every other new subject stay refused.
5. **App:** ap-prep-blueprint#33 (restores the Statistics entry) merged at `6ee28af`; published by the Product Owner.

**Pre-launch Development check (identify/define FRQ rule), 15 of 30 Statistics generations used in total:** after the first rerun a residual leak appeared ("one population proportion"); the validator pattern was tightened (Dev, 35 tests) and the two affected FRQs (3.5-type, G06/G08) are now refused as `answer_disclosure` instead of being delivered. Consequence: for FRQs that ask to identify the procedure/parameter, students may see "More help couldn't connect" rather than help. Accepted as the safe failure; to be improved by prompt/validator work, not by weakening the check.

**Live smoke (signed-in Chrome, Production, 2 requests):** MCQ (Statistics 1.7): grounded method explanation, formulas and a next step, no answer given. FRQ (1.1 population/sample): points to the stem and the published definitions without naming the population or sample. Smoke SQL: 4 policy rows, both function MD5s as tested, 2 delivered receipts.

**Rollback:** `03_rollback_subject.sql` (switch Statistics off at once); `04_rollback_function.sql` (restore the reservation function); grounding rollback = saved prior `get_question_experience` definition; `more-help` v1 source is recoverable from the Development v10 / `main` history. App: revert #33.

**Not done / open:** the identify/define limitation above; Statistics has 15 topics with no practice MCQ (Codex prompt `docs/handoffs/CODEX_PROMPT_STATISTICS_MCQ_GAP_FILL_2026_10_16.md`); the Product Owner has not read the Development output packets (launch directed anyway); Calculus AB/BC/Chemistry More help not re-tested live after the function replacement.

**Historical ID check (incorrect):** the originating session reported no other claim on 0183. The collision above was found at integration; the canonical BC approval retains that number.
