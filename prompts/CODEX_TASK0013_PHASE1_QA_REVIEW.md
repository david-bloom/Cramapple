# Codex QA Prompt — TASK-0013 Phase 1 (PR #20)

Use per `docs/team_charter/AGENT_OPERATING_MODEL.md`'s QA Agent role: an
independent, skeptical review — not a relabeled continuation of whoever
implemented this. Treat yourself as having no prior context on this work;
verify everything from source, not from the PR description's claims.

## Task

Review GitHub PR #20 ("TASK-0013 Phase 1: subject-driven grading prompts in
evaluate-attempt") on branch `claude/task-0013-phase1-grading-generalization`
against `main`. Pull the actual diff (`gh pr diff 20` or equivalent) rather
than trusting the description.

## Background

`docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md` (Hard-Gate tier, Approved) is
the AP Statistics (Subject 2) launch task. Phase 1's goal: remove hardcoded
"AP Biology" literals from the grading edge functions so prompt composition
is subject-driven, with **zero behavior change for existing AP Biology
grading**.

## What to verify, not assume

1. **The core claim:** `supabase/functions/evaluate-attempt/index.ts`
   previously hardcoded `examName: 'AP Biology'` and a system-prompt literal
   "You are a production AP Biology criterion-based grader." The fix fetches
   `app.exam_packs` (via `examPackVersion.exam_pack_id`, selecting
   `exam_name`) and uses `exam_packs.exam_name` for both. Confirm
   `exam_packs.exam_name` was already seeded literally `'AP Biology'` —
   check `supabase/migrations/202606200003_seed_ap_biology_exam_pack.sql`
   directly. If it doesn't match exactly, this is a behavior change, not a
   no-op, and that's a blocking finding.
2. **Null-safety:** confirm the `examPack`/`examPackError` guard (early
   return on `exam_pack_not_found`, 404) sits before every use of
   `examPack.exam_name` in the function — not after. A reachable
   `examPack.exam_name` access past a missed guard would be a real bug, not
   theoretical.
3. **Diff surgical-ness:** `git diff origin/main --
   supabase/functions/evaluate-attempt/index.ts` should show only the
   additive exam-pack lookup plus the two literal swaps — nothing else in
   this 1300-line file should have changed. Flag anything broader.
4. **`grade-frq/index.ts` was deliberately left untouched.** The claim:
   it grades against a separate, Biology-only prototype schema
   (`public.questions`, defined in
   `supabase/migrations/202606230001_prototype_student_schema.sql`) with a
   hard `check (unit between 1 and 8)` constraint and no `subject_id` or
   equivalent column anywhere. Verify this directly in that migration file —
   don't take the PR's word for it. If there *is* a way to thread subject
   data through that table that was missed, that's worth surfacing even
   though it's non-blocking for this PR.
5. **Type/format checks:** run `deno check
   supabase/functions/evaluate-attempt/index.ts` (deno is on PATH) and
   confirm it passes. Run `deno fmt --check` on the same file — it should
   report exactly one pre-existing violation around line 832, confirm via
   the diff hunks that line 832 is genuinely outside the changed lines (not
   newly introduced).
6. **Governance bookkeeping:** this PR also carries `DECISION-0031` /
   `APPROVAL-0024` in `docs/activity_log/DECISIONS_LOG.md` /
   `APPROVALS_LOG.md` (catch-up from a prior PR that merged before these
   were pushed — see PR #20's description for why). Check these entries are
   structurally consistent with their neighbors (compare against
   DECISION-0029/0030, APPROVAL-0022/0023) and that
   `docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md`'s header fields (Status,
   Approved Date) don't contradict its Approval State section.

## Authority boundaries

You may propose a verdict and findings. You may **not** approve, merge,
mark `Done`, deploy, or alter live state — see `AI_COLLABORATION_RULES.md`.
David is the only one who closes this out.

## Required Output

1. Proposed verdict: Pass / Fail.
2. Blocking findings, with file:line, if any.
3. Non-blocking risks or test gaps.
4. Evidence actually checked (files read, commands run) — not just claims
   restated from the PR description.
5. Required remediation, if any.

Keep the report under 400 words.
