# Codex Prompt — Commit Biology Drafts + Build a Grader Path Claude Can Use

STATUS: orchestration prompt (hand to Codex) | DATE: 2026-09-22 | AUDIENCE: David
(orchestrator) → Codex (builder). Operating model: **Codex builds, Claude QAs.**

> Paste the block below into Codex. It is self-contained; the drafts are on this
> machine and everything else lives in `david-bloom/cramapple` or the Cramapple
> Production Supabase project.

---

You are the builder. Claude is the independent QA validator and runs in a
**separate cloud environment** that cannot see your local disk. Two build tasks,
so Claude can QA the AP Biology canonical-answer drafts:

**Task A — commit the drafts to the repo.** Move your local outputs into the repo
and push them, so Claude's session can read them:
- `scripts/content-seed/canonical-answers/APBIO_canonical_drafts_2026_09_21.json`
- `scripts/content-seed/canonical-answers/APBIO_coverage_manifest.md`

Before committing, re-verify each draft against Production (`pcntajvbdfqhbeewmdry`,
`exam_code='ap_biology'`): it still targets the **latest** `content_item_version`,
`canonical_answer_1` is still null/empty on that version, and the
`content_item_version_id` is present and correct. Record any drift in the manifest.
These files are **answer keys** — the repo (access-controlled) is their home; never
put them on a student-facing surface. Do not write any draft into
`canonical_answer_1/2`.

**Task B — build a grader path Claude can invoke.** Claude must be able to grade
each draft against the **real production `evaluate-attempt` grader** and get
criterion-level results, from an environment whose only capabilities are:
- **read-only Supabase SQL against Production** via an `execute_sql` tool
  (project `pcntajvbdfqhbeewmdry`); and
- **bash / curl**, with **no Production service credentials** and **no ability to
  invoke Supabase edge functions** through its tools.

So a raw edge-function URL Claude can't call, and any path that persists rows or
needs a secret Claude doesn't hold, does not qualify. Build one of these, in
preference order:

1. **Preferred — a no-persist QA RPC callable via `execute_sql`.** A Postgres
   function, e.g. `app.qa_grade_frq(p_content_item_version_id uuid, p_answer_text text)
   returns jsonb`, that runs the **same grading logic as production
   `evaluate-attempt`** for that item's engine (invoking the edge function
   internally via `pg_net`/`http` in a no-persist QA mode is fine) and returns the
   per-criterion result (each `criterion_key` → awarded/possible, plus total,
   carry-forward flag, grader/deploy version, and raw grader response). It **writes
   nothing** — no `attempts`, `attempt_responses`, `grading_results`, and no
   content change. Lock it down: `SECURITY DEFINER`, granted **only** to the role
   Claude's QA connection uses (or `service_role`); **never** to `anon`/
   `authenticated` (it would leak the answer key and a grading oracle to students).
2. **Fallback — capture + offline harness.** If (1) is not feasible, run every
   Biology draft through the real grader yourself in no-persist QA mode and commit
   the **production-shaped** outputs to
   `scripts/content-seed/canonical-answers/APBIO_grader_capture_2026_09_22.json` —
   one record per draft with the raw grader response, per-criterion awarded/possible,
   carry-forward flag, grader/deploy version, request payload, and timestamp — in the
   `ResultCase[]` shape `scripts/grading-model-assessment` expects. Claude then scores
   it with that offline harness and audits it against the Production rubric. (This
   leans on your capture being faithful; include the raw responses so Claude can
   check them.)

**Document the contract.** Commit `scripts/content-seed/canonical-answers/QA_GRADER_PATH.md`
stating exactly how Claude invokes the path: for (1), the precise
`SELECT app.qa_grade_frq(...)` call, its return shape, the grant/role, and the
no-persist guarantee; for (2), how to run the offline harness against the capture,
the grader/deploy version, and the capture schema. Whichever you build, state the
grader/deployment identifier so Claude can record it.

## Guardrails

- **No persistence, no content mutation.** The QA grader path writes nothing to
  Production content or to attempt/grading tables, and never alters the live
  `evaluate-attempt` persistence for real student traffic — add a **new** no-persist
  QA entrypoint, do not weaken the real one.
- **Answer-key secrecy.** Drafts, captures, and any QA RPC are answer keys / grading
  oracles: repo-only and role-locked; never reachable by `anon`/`authenticated`/a
  student surface.
- **Scoped, reviewed, reversible.** Ship the DB function/migration through the repo's
  normal migration + PR review path; keep it a clean add that can be dropped without
  touching production grading.
- **Stay in the builder lane.** You build the path and commit the drafts; you do NOT
  decide PASS/FAIL or promote any canonical — that's Claude's independent QA. Do not
  grade the drafts for the record here.
- **Do not begin Statistics.**

## Definition of done

Pushed to the repo: the two Biology draft files (freshness-verified), the grader-path
build (the no-persist QA RPC + migration, or the capture file), and
`QA_GRADER_PATH.md` documenting exactly how Claude invokes it — with the
grader/deploy version stated. Nothing persisted to Production, no content mutated, no
answer key exposed to students. Then hand off to Claude for the independent QA pass.
