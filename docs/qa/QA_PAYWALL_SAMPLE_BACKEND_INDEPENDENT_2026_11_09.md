# Independent QA: paywall sample access backend (2026-11-09)

**Reviewer:** Codex. **Tier:** Hard-Gate. **Scope:** Development backend on `claude/paywall-backend-sample-access-95ac1a` at `fbec64c7`; no Production change. **Recommended verdict:** Block release pending the findings below and completion of the live integration test. This is a proposed QA verdict, not final acceptance.

## Authority and state

- `APPROVAL-0206` authorizes Development design/build and independent Codex QA, but no Production migration, deployment, publish, or flag enablement. `DECISION-0134` approved spec P1–P8 after the QA packet was written. [PR #595](https://github.com/david-bloom/Cramapple/pull/595) (Development implementation) and [PR #596](https://github.com/david-bloom/Cramapple/pull/596) (decision record) are both merged. The packet's "draft PR" and "P1–P8 awaiting David" statements are stale.
- Development project was verified by `supabase_list_projects` as `wmgjsdkphcyhngaffbqf`. `sample-try` v1 (`verify_jwt=false`), `attempt-response` v50, and `student-session-items` v48 are active. No Production project query or mutation was run.

## Independently executed checks

| Check | Result |
| --- | --- |
| Deno suites in packet, isolated environment | **78 passed, 0 failed** (2026-11-09). |
| `deno check` and `deno lint` on the three edited/new functions | **Pass.** |
| Development migration ledger | Both `20261031143302` and `20261108201632` present. |
| Development switches and residue | `sample_access_enabled=false`, `sample_access_honor_existing=true`; zero rows in four sample tables, sample sessions, and `sample-test-%@example.invalid` users. |
| Development triggers and patched function bodies | Three named triggers present; `get_question_experience` readback, `has_study_subject_access` sample admission, and `authorize_grading_access` sample branch present. `learning_sessions` check allows `sample`. |
| Development access control | `anon` has no execute on sampled functions; `authenticated` has execute only on `public.claim_sample_try`, `public.get_sample_access_state`, and the reserved `public.claim_sample_frq_source`; no anon/authenticated sample table grants; RLS enabled and forced on all four sample tables. |
| Development unit availability | AP Statistics unit 1 eligible (199 MCQs, 1 FRQ); units 2, 3, and 5 ineligible. This is fixture-dependent, not a Production content claim. |
| Rollback-only SQL integration suite | **Not executed.** Connected `execute_sql` returned `confirmation expired`; the local Supabase CLI could not start because its telemetry write under `~/.supabase` was denied by the sandbox. The script was inspected: it ends with an exception intended to roll back the transaction. Its claimed 21/21 result remains author evidence, not independent QA evidence. |
| Live edge smoke | **Not executed.** The shell could not resolve the Development Supabase hostname. The disabled flag and deployed function metadata were verified through the Supabase connector. |

## Findings

### F1 — Scheduled entitlement can leave the sample revivable (release blocker)

`sample_supersede_on_entitlement` runs on insert or updates of `status`, `starts_at`, or `ends_at`, and supersedes only if `starts_at <= now()` at that moment (`20261108201632_paywall_sample_access.sql`, lines 526–541). If an `active` regular entitlement is inserted with a future `starts_at`, the trigger leaves the sample grant `active`. Time passing makes the regular entitlement effective without another trigger. Once that entitlement ends or is revoked, `sample_grant_phase` can still return `active` for the grant until its own expiry (lines 172–183), and `sample_study_access` admits it again (lines 212–221). That violates decided P4's permanent supersession. The 21-check suite covers immediate entitlement insertion, not scheduled activation. Add a focused test for a future-start entitlement becoming effective and then ending while the original sample clock remains active.

### F2 — Photo extraction cap fails open on an unexpected RPC error (release blocker before photo enablement)

`attempt-response/index.ts` calls `sample_take_photo_run` before `propose_transcript` (lines 1076–1097). It returns 403 for a recognized `sample:*` error, but for any other RPC error it only logs and continues to the model call (lines 1094–1175). A transient database/RPC failure therefore skips the decided P2 per-sample limit of three extraction runs. The existing daily/user spending caps are separate limits and do not enforce three runs per FRQ. The photo feature is dark on Development, so this is a release boundary when photo answers are enabled. Fail closed for an unrecognized guard error and add a handler test that proves no transcription call occurs.

## Coverage still needed

- Run the 21-check rollback-only SQL suite independently against Development and recheck the two switches and zero residue afterward.
- Exercise a signed-in sample user end to end: imported first MCQ readback, ordinary dashboard/Open Hand/More help denials, scoped serving, typed attempt refusal, and trial transition. No sample user was created in this QA session.
- Exercise concurrency (two claims and two different-item attempt inserts near the allowance), which the existing sequential SQL suite does not prove.
- Compare the five trial function bodies with `main` or a read-only Production baseline if that comparison remains a release requirement. Development MD5 values were captured in the query output but no baseline comparison was performed.

**Next owner:** backend implementer for F1/F2; then independent QA rerun. Any Production action remains a separate Product Owner hard gate under `APPROVAL-0206` and `DECISION-0134`.
