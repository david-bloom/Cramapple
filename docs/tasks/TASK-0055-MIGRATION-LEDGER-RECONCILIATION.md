# TASK-0055 — Reconcile The Migration Ledger With Production

**Status:** Not started. **Not launch gating**, but it is a standing rebuild-from-source risk.
**Tier:** Hard-Gate for any write; the audit itself is read-only.
**Owner:** TBD
**Product Owner:** David Bloom
**Date opened:** 2026-09-29
**Area:** Schema governance / migrations
**Related:** `TASK-0050` (PR #272 recovered five of these), `TASK-0027-DEV-PROD-SCHEMA-CONVERGENCE.md`

---

## The finding

Measured on Production 2026-09-29:

| | count |
|---|---:|
| Migrations applied to Production since 2026-09-01 | **185** |
| Migration files in the repo for that window (`main` ∪ `claude/task-0050-statistics-phase-b`) | **113** |

**At least 72 migrations exist only in Production.** "At least", because the comparison is by count,
not by set difference: any repo file that was never applied makes the real gap larger, not smaller.

This is the same class of problem `TASK-0027` recorded for Dev ("the Dev migration ledger cannot be
trusted"), now measured on Production.

## Why it matters

1. **The schema cannot be rebuilt from source.** A fresh environment built from `supabase/migrations`
   would be missing whatever those ~72 did. TASK-0050's five included
   `app.taxonomy_scope_selftest()`, 181 AP Statistics skill rows, 117 AP Calculus AB topic rows, an
   AB→BC item move and a 404-cell grid — none of which existed in git until PR #272.
2. **`supabase db push` is unsafe to run casually.** It matches on the version string. A local file
   whose timestamp does not match what Production recorded is treated as new and applied again. That
   exact case was live today: TASK-0050's Phase A stub was named `20260929113000` while Production
   recorded `20260929110501`.
3. **Review never happened for those statements.** A migration applied through the MCP
   `apply_migration` tool goes straight to the database; if no file is committed, no PR ever shows
   the SQL.

## Root cause

`apply_migration` records the statement in `supabase_migrations.schema_migrations` under a
server-assigned version and **does not write a local file**. Unless the agent separately commits a
matching file — with the exact recorded version as its name — the repo and the database diverge
silently. Nothing in CI catches it.

## Scope

**A. Audit (read-only, do first)**
- Set-difference applied versions against repo filenames across the full history, not just since
  September, and classify each gap: recoverable (statements present in the ledger), schema-visible
  only, or data-only.

**B. Recover**
- Write a file per missing version, verbatim from `supabase_migrations.schema_migrations`, named
  with the **recorded** version. PR #272 did this for five and is the worked example; byte counts
  matched the recorded lengths exactly.

**C. Prevent**
- A CI check that fails when a migration file's version is absent from the target environment's
  ledger, or vice versa. This is the durable fix — without it the gap reopens on the next
  `apply_migration` call.
- A written rule that `apply_migration` is always followed by committing the file under the recorded
  version.

## Open questions

1. How far back should recovery go — all history, or a cutoff (e.g. 2026-09-01) with everything
   older accepted as-is?
2. Should the CI check block merges, or only warn? Blocking is stronger but would fail immediately
   on the existing ~72 until B is complete.
