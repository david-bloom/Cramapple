# APPROVAL-0275 — Label gap fill, Units 6 and above, all subjects: topic cells and serving labels, 2026-11-13

- **Date:** 2026-11-13.
- **Authorization:** David Bloom (Product Owner), brief "Do the same for every remaining unit ... The Product Owner has directed publication of the labels"; chat "Yes, proceed" (Stage 2), "Yes, run votes" (Stage 3, cap $6) and "Stage 4 now" (this write).
- **Scope (Production `pcntajvbdfqhbeewmdry`), labels only, one transaction per subject, advisory lock, plan-hash check:** 118 published items in registry units 6+ (Biology 1, Calculus AB 35, Calculus BC 19, Chemistry 11, Physics 1 19, Physics 2 11, Physics C: E&M 10, Physics C: Mechanics 12).
  - **118 validated primary topic cells:** 82 new, 36 `provisional_model`/`authored` cells promoted in place (only where the vote agrees with the existing cell).
  - **66 validated, hash-fresh serving labels:** 46 replace a `provisional_model` label, 20 release a held label (18 `model_unit_disagreement`, 2 `empty_required_units`) on a >= 5 of 6 vote. Only non-validated labels are superseded. 52 items already had a servable label and receive a cell only.
- **Basis:** six-vote blind topic probe (gemini-3.8-flash x2, deepseek-v4-pro x2, gpt-6.1-sol x2), topic accepted at >= 5 of 6, required units named by >= 4 of 6; 112 seeds by vote, 6 Calculus AB variants inherit from their seeds. Packets hold student-visible text only. Evidence: `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/stage3/` and `docs/qa/LABEL_GAP_AUDIT_UNITS_6PLUS_STAGE3_RESULT_2026_11_13.md`. Unit mapping: Stage 1 report.
- **Not written (23 residue, listed in the Stage 3 result):** 8 held that stay held (rubric_preflight_failure, ab_bc_only_content, other); 9 with no 5 of 6 majority after the cheap votes; 5 below 5 of 6; `apphy2-mcq-013` (served at Unit 14 by a validated label, votes say 13.3; owner call).
- **Flag:** `apchem-sfrq-026` moves from unit 6 on record (provisional label) to topic 9.6 (5 of 5 votes). Unserved today.
- **NOT changed:** item text, versions, rubrics, difficulty, skills, any validated cell or label, the 74 unit-less held items, schema, functions, edge functions, Lovable frontends.
- **Rollback:** delete cells and labels (and their validation decisions) with source `label_gap_fill_u6plus_2026_11_13`; restore in-place promoted cells to their prior status per `stage4/u6plus_pre_state_*.json`; clear `superseded_by` on the labels they superseded.
- **Cost:** $3.31 measured at token usage (ledger `stage3/cost_ledger.jsonl`), cap $6.
- **Numbering check:** highest APPROVAL on origin/main, open PRs (#652) and all remote branches was 0274; this record takes 0275.
- **Rehearsal:** eight `REHEARSAL OK` (rolled back, constraints forced immediate).
- **Result:** see the execution record appended below.
