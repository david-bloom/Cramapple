# Codex Remediation — TASK-0016 Phase A (post-commit `8f79ebe`)

Two items from the post-commit QA check
(`docs/research/CODEX_TASK0016_PHASE_A_QA_FINDINGS_2026_07_08.md`, "Post-commit
check" section). The three verifier bugs (B1/B2/B3) are fixed and verified — do
not touch that logic. This note covers only what is still missing.

## R1 (blocking for deploy) — commit the migrations the code already depends on

`8f79ebe` committed `evaluate-attempt/index.ts` and migration `…0010` (verifier
pins) but left the migrations that create the columns the function uses
**untracked**. On a fresh DB / CI / deploy, the function fails.

Columns referenced by the committed code vs. their untracked migrations:

- `content_item_versions.rubric_type`, `evaluator_strategy` — SELECTed at
  `evaluate-attempt/index.ts:796`, read at `:933-934` → migration
  `supabase/migrations/202607080005_add_rubric_routing_columns.sql` (+ its
  backfill `…0006_backfill_rubric_routing_metadata.sql`).
- `grading_results.feedback_preview` — written at `:1131`, `:1487` →
  `…0007_add_feedback_preview_to_grading_results.sql`.
- `grading_results.action_hint` — written at `:359`, `:1408`, `:1488` →
  `…0008_add_action_hint_to_grading_results.sql`.
- `grading_results.repair_hint` — written at `:360`, `:1409`, `:1489` →
  `…0009_add_repair_hint_to_grading_results.sql`.

**Do:**
1. Commit `…0005`, `…0006`, `…0007`, `…0008`, `…0009` (they already exist in the
   working tree; verify each with `git status supabase/migrations/`). Do **not**
   sweep in unrelated untracked files (e.g. `…0004_promote_dbloom01_to_admin.sql`
   is a separate change — leave it).
2. Confirm ordering/idempotency: each is `add column if not exists`; verify the
   sequence applies cleanly on a fresh DB (migration numbers `…0005`→`…0010`
   monotonic, no gap the runner rejects).
3. State how you verified a clean apply (e.g. `supabase db reset` / local apply,
   or the project's migration check).

## R2 (non-blocking, safe-direction) — negative exponents fail to parse

The B2 precedence fix set the exponent operand to `parsePower`, which starts at
`parsePrimary` and cannot accept a signed exponent, so bare negative exponents
ABSTAIN (`parse_error:unexpected_token`): `2^-1`, `x^-1`, `k*Q/r^2` vs
`k*Q*r^-2`. Parenthesized `2^(-1)` works. Safe-direction (routes to human, no
wrong grade) — does not affect the AP Statistics keys (they use `sqrt(...)` /
`**2`), but must land before physics coverage (`r^-2`, `t^-1`).

**Do:**
1. `math-verifier.ts:283` — change `const rhs = this.parsePower();` to
   `const rhs = this.parseUnary();`. This lets the exponent take a leading sign
   while preserving right-associativity and the base rule (`-2^2 = -(2^2)`, base
   is still `parsePrimary`).
2. Add a regression test: `2^-1` → `0.5` (numeric) and `x^-1` ≡ `1/x`
   (expression), and a guard that `-2^2` still evaluates to `-4` and `(-2)^2` to
   `4` (so the fix does not reopen B2).

## Do NOT change

- B1/B2/B3 fixes and their tests, the router, the ECF verdict logic, the
  Statistics keys, or the shadow-first wiring — all verified PASS.

## Required evidence on completion

- `git status supabase/migrations/` showing `…0005`–`…0009` now tracked/committed
  and a clean fresh-DB apply.
- `deno test supabase/functions/_shared/math-verifier_test.ts …` green, including
  the new negative-exponent test.
- `git diff --check` clean.

## Next expected output

A commit (or PR) referencing `TASK-0016` that closes R1 and R2, ready for a quick
confirmation QA pass (re-probe negative exponents + fresh-DB migration apply). The
Phase A handoff note should then be updated to drop the "complete" framing until
R1/R2 land.
