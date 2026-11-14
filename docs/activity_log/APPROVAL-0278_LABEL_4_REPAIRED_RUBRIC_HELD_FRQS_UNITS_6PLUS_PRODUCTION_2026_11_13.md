# APPROVAL-0278 — Label the four repaired rubric-held FRQs (Units 6+), 2026-11-13

- **Date:** 2026-11-13.
- **Authorization:** David Bloom (Product Owner), in chat: "Yes, all four" (repair, then label), following APPROVAL-0277 and the standing direction to publish the missing labels.
- **What is written (Production `pcntajvbdfqhbeewmdry`), labels only, one transaction per subject (Calculus AB 2, Chemistry 2):** for the new published versions created by APPROVAL-0277, 4 validated primary topic cells and 4 validated hash-fresh serving labels; the held `rubric_preflight_failure` label on each item is superseded (non-validated rows only).
  - `apchem-frq-l-023`: 7.4, primary unit 7, required [7] (5 of 5 votes).
  - `apcalcab-frq-017`: 8.3, primary unit 8, required [4, 5, 6, 8] (CED-text ruling; votes 8.3 x2, 5.5, 6.5; part (c) uses the Candidates Test on the accumulated amount).
  - `apcalcab-frq-036`: 8.11, primary unit 8, required [6, 8] (CED-text ruling; votes 8.11 x2, 8.4 x2; two washer-method volumes carry 4 of 9 points).
  - `apchem-frq-l-026`: 8.8, primary unit 8, required [4, 8] (CED-text ruling on the repaired prompt; votes 8.8 x4, 8.10 x2).
- **Basis:** blind topic probe on the new versions (gemini-3.8-flash x2, deepseek-v4-pro x2, gpt-6.1-sol where the cheap votes could still reach 5 of 6), measured $0.15; rulings per item above, read against the CED fact pack; evidence in `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/stage5v/`.
- **Flags:** `apcalcab-frq-017` (8.3 vs 5.5) and `apcalcab-frq-036` (8.11 vs 8.4) are judgment calls within one unit each; all four items were unserved before this change, so no served item moves.
- **NOT changed:** item text or rubrics (APPROVAL-0277 did that), any validated cell or label, any other item, schema, functions, edge functions, frontends.
- **Rollback:** delete cells, labels and validation decisions with source `label_gap_fill_u6plus_r3_2026_11_13`; clear `superseded_by` on the held labels they superseded.
- **Numbering check:** highest APPROVAL on origin/main, open PRs and all remote branches was 0277; this record takes 0278.
- **Rehearsal:** two `REHEARSAL OK` (rolled back, constraints forced immediate).
- **Result:** see the execution record appended below.
