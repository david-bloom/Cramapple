# APPROVAL-0277 — Repair four rubric_preflight_failure FRQs (Units 6+ label gap), 2026-11-13

- **Date:** 2026-11-13.
- **Authorization:** David Bloom (Product Owner), in chat: "Yes, all four", answering the proposal in `docs/qa/LABEL_GAP_AUDIT_UNITS_6PLUS_RUBRIC_HELD_TRIAGE_2026_11_13.md` (rubric-side edits for `apcalcab-frq-017`, `apcalcab-frq-036`, `apchem-frq-l-023`; option B, prompt parts (d) and (f) rewritten as qualitative reasoning, for `apchem-frq-l-026`). The approval covers these four items only.
- **What is written (Production `pcntajvbdfqhbeewmdry`), two transactions (Calculus AB, Chemistry), advisory lock, plan-hash check:** for each of the 4 items the published version is retired and a new version (v2 for the Calculus items, v4 for the Chemistry items) is published (draft, assigned, reviewed_approved, published, same walk as APPROVAL-0269) with new rubric criteria, difficulty rows carried over. Points are unchanged (9, 9, 10, 10).
  - `apcalcab-frq-017`: `part-c-criterion-4` now scores the conclusion the prompt asks for (time of the greatest amount, t about 4.443 minutes); the 107.953 L value is optional. Prompt unchanged.
  - `apcalcab-frq-036`: `part-c-criterion-1` accepts washers in y (pi times the integral from 0 to 4 of y minus y squared over 4) or shells; both give 8 pi over 3. Prompt unchanged.
  - `apchem-frq-l-023`: criteria rebalanced within 10 points (a3 now scores substitution to Kc = 160, overlapping interpretation merged into a4, a5 shift 2 points, new a6 Kc unchanged). Prompt unchanged.
  - `apchem-frq-l-026`: **prompt text changed.** Parts (d) and (f) no longer ask for a computed pH after adding acid or base (the CED excludes it, Topic 8.9); (d) asks for a prediction justified from the NH3 and NH4+ amounts, (f) for the reacting component, new amounts and the direction and approximate size of the pH change. Criteria a1, b1, c1, c2, d1, d2, f1 aligned; model answer text for (d) and (f) updated.
- **Checks before publishing:** deterministic recomputation in session (Calculus integrals and amounts; Kc = 160; buffer ratios and pH values). Three-model rubric check (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol) on all four edited rubrics: 12 of 12 pass after fixes to the 026 edits (two rounds, flagged criteria rewritten). Measured gateway cost $0.24 (cap $1); ledger `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/stage5/check_ledger.jsonl`.
- **Not changed:** the prompt text of the other three items; any validated cell or label; any other item; schema, functions, edge functions, frontends. Cells and serving labels for these four items are a separate step under the next approval (vote with the parts included first).
- **Rollback:** retire the new versions and republish the previous ones (old version ids in `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/stage5/rubric_held_full.json`); delete the new criteria rows.
- **Numbering check:** highest APPROVAL on origin/main, open PRs (#652, #654) and all remote branches was 0276; this record takes 0277.
- **Rehearsal:** two `REHEARSAL OK` (rolled back, constraints forced immediate).
- **Result:** see the execution record appended below.

## Execution record (2026-11-13)
- Two transactions COMMITTED (Calculus AB 2, Chemistry 2); independent read-back MATCH 4/4 (new version published, planned rubric hash and stem/model-answer hash, exactly one published version per item). Labels followed under `APPROVAL-0278`.
