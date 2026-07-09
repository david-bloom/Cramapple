# Codex QA Prompt — TASK-0012 Backend Migration State Review

Use per `docs/team_charter/AGENT_OPERATING_MODEL.md`'s QA Agent role: an
independent, skeptical review — not a relabeled continuation of whoever did
this work. Verify everything from source and from live Supabase state, not
from this prompt's or the branch's own claims.

## Task

Review the backend-migration surface for `TASK-0012` (Production Plumbing and
Beta-to-Prod Cutover Readiness) on branch `claude/backend-migration-ob26x7`
against `main`. This branch adds 15 previously-untracked migration files to
`supabase/migrations/` (reconciling local files against what's actually
applied to both Supabase projects) and updates
`docs/tasks/TASK-0012-PRODUCTION-PLUMBING-AND-CUTOVER.md` and
`docs/architecture/PRODUCTION_PLUMBING_EXECUTION_CHECKLIST.md`. Pull the
actual diff rather than trusting the PR description.

## What to verify, not assume

1. **Migration-file accuracy.** For each new file, confirm its content is
   byte-identical to what's actually applied. Run, for both project IDs
   (`pcntajvbdfqhbeewmdry` = production, `wmgjsdkphcyhngaffbqf` = development):
   `select version, md5(array_to_string(statements, E'\n')) from supabase_migrations.schema_migrations where version = '<version>';`
   — versions and expected filenames are listed in the task file's updated
   "Known Cutover Blockers" section. A mismatched hash is a blocking finding.
2. **Dev/prod schema divergence.** Confirm development
   (`wmgjsdkphcyhngaffbqf`) has 7 migrations production does not
   (`202607070001`–`202607070006`, `202607071200` — HDR assets, calibration
   sets, bootstrap FRQ schema, grading experiments, chemistry/physics subject
   instantiation, student memory runtime context, FRQ synthetic responses).
   Check `docs/MASTER_TODO.md`'s `EXPAND-001` entry (Status: Deferred) against
   `202607070005_chemistry_physics_schema_instantiation.sql`, which marks
   `ap-chemistry` and `ap-physics-1` subjects `status = 'active'` in dev. Is
   this a real policy/implementation conflict worth escalating, or is
   dev-only + `draft` exam-pack status enough containment? Say which.
3. **Undocumented decision reference.** Migration
   `202607090002_curated_public_interface_revoke_anon.sql` (applied to
   production 2026-07-09) cites `DECISION-0035` in a comment. Grep
   `docs/activity_log/DECISIONS_LOG.md` — confirm it tops out at
   `DECISION-0032` with no 0033/0034/0035 entries anywhere. A production
   schema change citing an approval record that was never logged is a Hard
   Gate / source-of-truth violation per `AI_COLLABORATION_RULES.md`
   §Source-of-Truth Rule — confirm this and flag it as blocking, don't soften
   it to a note.
4. **`admin-content` gate-trust gap.** Read
   `supabase/functions/admin-content/index.ts` directly. Confirm
   `enforceGatePolicy` (~line 156) only validates that client-supplied gate
   values are structurally `"passed"`/`"not_applicable"` — it does not check
   `validation_runs`, `review_decisions`, or `rights_records` server-side (the
   function's own `TODO(task-0012-trusted-gates)` comment says as much).
   Confirm `changeArtifactState`'s publish path (~line 654) lets
   `approved_by` default to `[profileId]` — i.e., the same caller can assert
   passing gates and self-approve the publish with no independent-review
   cross-check. Confirm whether this is reachable by the `content_author`
   role or only `admin` (`canPerformOperation`, ~line 117) — that changes the
   severity.
5. **`bulk_import` partial-failure risk.** In the `Deno.serve` handler
   (~line 891), `bulk_import` loops calling `createArtifactDraft` per item
   with one idempotency check for the whole batch. Confirm: if item N of M
   throws, items 1..N-1 already committed `source_records`/`rights_records`/
   `artifact_versions` rows (each defaulting to a fresh `crypto.randomUUID()`
   when the caller doesn't supply one), no audit event is written, and a
   client retry with the same idempotency key would re-run items 1..N-1 and
   insert duplicates rather than detecting them as already done. Confirm or
   refute against the actual code.
6. **Lovable boundary claim still holds.** Re-run
   `grep -rn "useServerFn\|createServerFn\|_serverFn"` across the repo and
   confirm it's still empty (this was last confirmed 2026-06-21; re-verify
   it wasn't reintroduced).

## Authority boundaries

Propose findings and a verdict only. Do not approve, merge, mark `Done`,
deploy, or alter live state (read-only `select`/`explain` queries against
Supabase are fine; no `insert`/`update`/`delete`/migration apply). David is
the only one who closes this out.

## Required Output

1. Proposed verdict: Pass / Fail.
2. Blocking findings, with file:line or migration version, if any.
3. Non-blocking risks or test gaps.
4. Evidence actually checked (files read, queries run) — not claims restated
   from this prompt.
5. Required remediation, if any.

Keep the report under 500 words.
