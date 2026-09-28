# Cramapple Session Close — Oct 2 Launch Audit, TASK-0049 Dedup + Cold-Start Test, TASK-0039 BYOQ Status Check — 2026-09-28

Task:
- Ad hoc Oct 2 launch-readiness audit, followed by two scheduled-trigger follow-ups: (1) fix the
  TASK-0049 file collision + add missing cold-start grading test coverage, (2) check TASK-0039
  (BYOQ) actual implementation status. No single TASK-XXXX id covers this session end-to-end.

Prompts Included:
- [ ] Implementation Agent
- [ ] QA Agent
- [ ] UX / Prompt Agent

(None included — this session's remaining work is a Product Owner decision on BYOQ scope and a
PR review, not a scoped implementation/QA/prompt handoff.)

## 1. What this session did

1. **Oct 2 launch-readiness audit** (read-only, no code): reviewed `docs/INDEX.md`-routed canonical
   docs (`LAUNCH_RUNBOOK_2026_10_02.md`, `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`,
   `ACTIVITY_LOG.md`/`DECISIONS_LOG.md` indexes) and reported a prioritized punch list to David.
   Headline finding: Biology/Statistics grading and free-entitlement paths are proven live, but the
   runbook's own brand-new-student smoke test (real signup → real entitlement → real submit-to-grade
   round trip) has never actually been run against the live app — that remains the top open risk.
2. **PR #251** (`claude/task-0049-dedup-and-cold-start-test`, still open as of this doc): fixed the
   two issues the audit flagged.
   - Annotated (not renamed/moved) `docs/tasks/TASK-0049-CLAUDE-INDEPENDENT-AUDIT-2026-09-28.md` in
     place, per `DECISION-0075`'s annotate-in-place convention — a same-day Production migration and
     an active Codex prompt already cite that exact filename as their evidence trail, so renaming it
     would have broken that citation chain. Added a reciprocal pointer in the real task doc
     (`TASK-0049-BIOLOGY-STATISTICS-SIX-CRITERION-REMEDIATION.md`) and refreshed its Status/baseline
     fields, which were themselves stale relative to files already in the repo (Phase 1 promoted 100
     items to Production the same day; a Phase 2 Codex prompt is queued).
   - Added `supabase/functions/start-trial/index_test.ts` — previously zero test coverage of the
     entrypoint a brand-new/stranger student calls to get the free-trial entitlement
     `authorize_grading_access` checks at submit time. Extracted a `handleStartTrial(req, deps)` seam
     matching `attempt-response`'s existing pattern. Wired into `minimal-ci.yml`.
   - First CI push failed (`NotCapable` on `Deno.env.set` — the CI invocation had never needed
     `--allow-env` before this test). Diagnosed and fixed by scoping `--allow-env` to the exact vars
     touched; verified the failure/fix in isolation (this sandbox blocks `esm.sh`, so the real test
     file couldn't run locally — same pre-existing limitation every handler-level test here has).
     Pushed; CI green as of `9f50cab`.
   - **This is unit coverage of `start-trial`'s own contract, not a substitute for the live-Production
     brand-new-student smoke test** the runbook still requires.
3. **TASK-0039 (BYOQ) status check** (read-only, no code): confirmed BYOQ backend is genuinely not
   started — zero migrations for `byoq_items`/`byoq_responses`/`byoq_attachments`/
   `byoq_capture_pairing_tokens`, zero edge-function code, confirmed via grep across
   `supabase/migrations`/`supabase/functions` and a full `git log --all --grep=byoq` (every BYOQ
   commit is a doc/decision record or the `web/` prototype, which the task doc itself says was never
   wired to production). The task doc's own "implementation not yet started" status line is accurate
   today, not stale. Flagged a real discrepancy: `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` estimates
   BYOQ at "~2-4 hrs remaining" inside a larger line item, but `TASK-0039`'s own spec (parallel
   tables + RLS + edge function + camera/QR capture + new Home entry point + new Practice screen,
   camera capture being launch-required per `DECISION-0076`) is a multi-day Hard-Gate build with an
   unresolved "New gaps" list David is supposed to sign off on before it ships. Reported to David;
   **no code changes made** — this was a status check, not a fix.

## 2. Current Source

- Task docs: `docs/tasks/TASK-0049-BIOLOGY-STATISTICS-SIX-CRITERION-REMEDIATION.md` (updated this
  session), `docs/tasks/TASK-0049-CLAUDE-INDEPENDENT-AUDIT-2026-09-28.md` (annotated this session),
  `docs/tasks/TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md` (read only, unchanged).
- Related docs: `docs/product/LAUNCH_RUNBOOK_2026_10_02.md`,
  `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md`, `docs/INDEX.md`.
- Latest commits reviewed: `main` at `0beb9e0` (base of this session's branch).
- Branch / PR: `claude/task-0049-dedup-and-cold-start-test` →
  [PR #251](https://github.com/david-bloom/Cramapple/pull/251), draft, open, CI green
  (`test` + Vercel preview both passing at `9f50cab`), `mergeable_state: clean`, no open review
  threads.
- Uncommitted / unpushed state: none — working tree clean, everything in this doc is pushed to
  `origin/claude/task-0049-dedup-and-cold-start-test` except this handoff doc and its matching
  `ACTIVITY_LOG.md` entry, committed and pushed in the same push as this file.

## 3. Approval State

- Approved: nothing in this session required new Production-write approval — PR #251 is docs +
  test-only, no schema/migration/deploy change.
- Not approved / open: TASK-0049's Phase 2 label remediation (`prompts/CODEX_TASK0049_PHASE2_LABEL_REMEDIATION_2026_09_28.md`,
  Hard-Gate, per-batch approval required); TASK-0039/BYOQ's full build (Hard-Gate, and per the
  finding above, effectively needs a fresh scope decision from David given the Oct-2 timeline).
- Required before execution: David's review/merge decision on PR #251 (still draft by design); a
  clear go/no-go from David on BYOQ scope for Oct 2 (ship without it vs. compress the build).

## 4. Live / Tool State

- Environments checked: this repo's git history and working tree only (`main` HEAD `0beb9e0`,
  branch HEAD `9f50cab`). No Production Supabase reads/writes performed this session.
- Services checked: GitHub Actions CI on PR #251 (green), Vercel preview build on PR #251 (ready).
- Not checked / unavailable: live Production (`pcntajvbdfqhbeewmdry`) — not queried this session;
  the BYOQ finding is based entirely on repo/git-history evidence, not a live system check. `deno
  test` could not run end-to-end in this sandbox (`esm.sh` blocked by network policy) — validated
  the new test logic by manual trace plus an isolated permission-flag repro, and let GitHub Actions'
  unrestricted network be the real validation venue.

## 5. Files / Systems Affected

- Docs: `docs/tasks/TASK-0049-BIOLOGY-STATISTICS-SIX-CRITERION-REMEDIATION.md`,
  `docs/tasks/TASK-0049-CLAUDE-INDEPENDENT-AUDIT-2026-09-28.md`, this handoff doc,
  `docs/activity_log/ACTIVITY_LOG.md`.
- Code: `supabase/functions/start-trial/index.ts` (refactored to an injectable-deps seam, logic
  unchanged), `supabase/functions/start-trial/index_test.ts` (new),
  `supabase/functions/start-trial/_test_setup.ts` (new).
- Data/schema: none touched.
- Integrations: `.github/workflows/minimal-ci.yml` (added the new test to the run list + scoped
  `--allow-env`).
- Frontend/routes: none touched.
- Other: none.

## 6. Open Risks / Blockers

- **P1 — Runbook's brand-new-student smoke test still not run.** Unchanged from the original audit;
  the highest-priority open item for Oct 2.
- **P1 — BYOQ (TASK-0039) has zero backend and is scoped as launch-critical.** Needs a direct
  David decision: descope for Oct 2 (fast-follow) or accept a compressed, still-decisions-open build
  in the remaining days.
- **P2 — PR #251 unmerged.** Green and mergeable, waiting on David's review since it was opened as a
  draft by design; no action needed from an agent unless he asks for changes.
- **Pending owner decisions:** BYOQ Oct-2 scope (above); TASK-0049 Phase 2 label-remediation batch
  approval (unrelated to Oct 2 — post-launch/unit-gated work, not urgent).

## 7. Do Not Touch

- Scope exclusions: no Production Supabase writes were made or are pending from this session.
- Deferred features: TASK-0049 Phase 2 (label remediation) — queued in
  `prompts/CODEX_TASK0049_PHASE2_LABEL_REMEDIATION_2026_09_28.md`, not this session's to execute.
- Hard gates: BYOQ implementation itself (TASK-0039) — this session only checked status, per the
  request; do not start building it without David's scope decision given the finding above.

## 8. Next Expected Output

- Spec / implementation / QA / prompt / issue comment: David's go/no-go on PR #251 (merge or
  request changes) and a scope decision on BYOQ for Oct 2.
- Required files to update: none pending from this session.
- Required evidence: none pending — PR #251's own CI/test evidence is complete as documented above.
