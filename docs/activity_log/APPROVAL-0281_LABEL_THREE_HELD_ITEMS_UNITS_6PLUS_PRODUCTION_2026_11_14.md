# APPROVAL-0281 — Label three held items (Units 6+), 2026-11-14

- **Date:** 2026-11-14.
- **Authorization:** David Bloom (Product Owner), in chat: "Try to label the 5". Three of the five are safe to label; two are not (see below).
- **What is written (Production `pcntajvbdfqhbeewmdry`), one transaction per subject (Calculus BC 2, Chemistry 1):** 3 validated primary topic cells and 3 validated hash-fresh serving labels; the held label on each item is superseded (non-validated rows only).
  - `apcalcbc-mcq-mv045`: 7.5 (Euler's method), unit 7, required [7]; 5 of 6 votes. Worked check: y(1) = 2.5 (choice A) matches.
  - `apcalcbc-mcq-mv050`: 8.13 (arc length), unit 8, required [2, 6, 8]; 5 of 6 votes. Worked check: arc length of y = x^2 on [0, 1.4] is about 2.520 (choice B) matches.
  - `apchem-frq-l-021`: 6.9 (Hess's law), unit 6, required [6]; 5 of 6 votes. Worked check: ΔH = 116.8 kJ/mol, endothermic, so the classmate's claim in (c) is wrong as the item intends.
- **Basis for releasing the holds:** the two Calculus BC items were held as `ab_bc_only_content` when they sat in the AB bank; the CED fact pack (corrections 2026-08-08 and 2026-09-29) records that Euler's method 7.5 and arc length 8.13 are BC-only and that these items were moved to BC, so labeling them in BC is correct. The Chemistry hold was a null second-model answer.
- **NOT labeled, and why:**
  - `apcalcab-frq-035` (AB item): parts (b) and (d) require Euler's method, which is BC-only; the fact pack says not to author or approve an `apcalcab-*` item on it. Labeling would serve out-of-course content to AB students. Needs a repair (drop the Euler parts) or a move to BC, owner's call.
  - `apchem-sfrq-035`: parts (b) and (c) ask for the new pH after adding HCl to a buffer, which CED 8.9 says is not assessed ("Computation of the change in pH resulting from the addition of an acid or a base to a buffer"). Same defect repaired in `apchem-frq-l-026` (APPROVAL-0277). Needs the same prompt repair; topic would be 8.10 (5 of 6 votes).
- **NOT changed:** item text, any validated cell or label, any other item, schema, functions, frontends.
- **Rollback:** delete cells, labels and validation decisions with source `label_gap_fill_u6plus_r5_2026_11_14`; clear `superseded_by` on the held labels they superseded; restore the two promoted cells to their prior `authored` status.
- **Numbering check:** highest APPROVAL on origin/main, open PRs and remote branches was 0280; this record takes 0281.
- **Rehearsal:** two `REHEARSAL OK` (rolled back, constraints forced immediate). No gateway spend.
- **Result:** see the execution record below.

## Execution record (2026-11-14)
- Two transactions COMMITTED; read-back MATCH 2/2 (Calculus BC) and 1/1 (Chemistry). Live selector: 3/3 returned with `topic_match = true`; regression sample of 48 previously served items 48/48.
- Units 6+ unlabeled residue is now **2**: `apcalcab-frq-035` (Euler parts, BC-only) and `apchem-sfrq-035` (excluded buffer pH-change computation). Both need a content repair first.
