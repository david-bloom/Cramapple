# APPROVAL-0283 — Label the two repaired FRQs (Units 6+), 2026-11-14

- **Date:** 2026-11-14.
- **Authorization:** David Bloom (Product Owner), in chat: "Repair both and label them", following APPROVAL-0282.
- **What is written (Production `pcntajvbdfqhbeewmdry`), one transaction per subject (Calculus AB 1, Chemistry 1):** for the new published versions created by APPROVAL-0282, 2 validated primary topic cells and 2 validated hash-fresh serving labels; the held label on each item is superseded (non-validated rows only).
  - `apcalcab-frq-035`: 7.7 (particular solution by separation of variables), primary unit 7, required [2, 3, 4, 5, 6, 7]; 5 of 5 topic votes, each required unit named by 5 of 5.
  - `apchem-sfrq-035`: 8.10 (buffer capacity), primary unit 8, required [8]; 5 of 5 topic votes, unit 8 named by 5 of 5.
- **Basis:** blind six-vote probe on the repaired versions (gemini-3.8-flash x2, deepseek-v4-pro x2, gpt-6.1-sol; the runner stops once 5 votes agree), measured $0.089. Topic 7.7 and 8.10 are the same topics the earlier probes chose on the original versions.
- **NOT changed:** item text or rubrics (APPROVAL-0282 did that), any validated cell or label, any other item, schema, functions, frontends.
- **Rollback:** delete cells, labels and validation decisions with source `label_gap_fill_u6plus_r6_2026_11_14`; clear `superseded_by` on the held labels they superseded.
- **Numbering check:** highest APPROVAL on origin/main, open PRs and remote branches was 0282; this record takes 0283.
- **Rehearsal:** two `REHEARSAL OK` (rolled back, constraints forced immediate).
- **Result:** see the execution record below.

## Execution record (2026-11-14)
- Two transactions COMMITTED; read-back MATCH 1/1 each. Live selector: 2/2 returned with `topic_match = true`; regression sample of 48 previously served items 48/48.
- Units 6+ unlabeled residue is now **0**. Total labeled in units 6+: 141 topic cells and 86 serving labels (APPROVAL-0275 to 0278, 0280, 0281, 0283). Gateway total about $3.84.
