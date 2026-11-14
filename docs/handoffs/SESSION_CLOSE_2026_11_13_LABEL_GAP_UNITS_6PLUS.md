# Session close: label gap audit and fill, Units 6+ (2026-11-13)

Read first: `docs/qa/LABEL_GAP_AUDIT_UNITS_6PLUS_FINAL_REPORT_2026_11_13.md`. Approval `APPROVAL-0275`. Scripts: `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/` (`publish_labels_u6plus.py` is one-shot per plan; its guards refuse a re-run).

## State
242 in-scope published items in units 6+ (mapping in the Stage 1 report; Precalculus and Statistics have none). 118 labeled and verified; 23 remain unlabeled and are listed in `residue_after.json`. Gateway $3.31.

## Exact next step
1. **Round 2 arbitration (recommended, cheap):** read the 14 tie / sub-majority items against the CED text (`subject packs/`, `docs/product/*_CED_FACT_PACK.md`), rule per item, label what the text settles via a new plan, approval and a copy of `publish_labels_u6plus.py`. Check APPROVAL numbers first (last was 0275).
2. **Owner decisions:** the 8 held items (per class: rubric repair, AB/BC-only content, other); `apphy2-mcq-013` (served at Unit 14, votes say 13.3, check against the CED before changing anything); whether to vote the 74 unit-less held items.
3. Skill cells (200 missing in scope), Units 1-5 residue from the earlier round, and the other open items in the Units 1-5 handoff are unchanged.

## Do not touch
- Any validated cell or label (changes need an explicit yes); the 8 held labels; the 74 unit-less held items; Lovable frontends, migrations, edge functions.
- Calculus Unit 5 and explainer work from other sessions (APPROVAL-0267 to 0274) is not part of this change.

## Traps hit
- The branch was cut before other sessions took APPROVAL-0273/0274; merged `origin/main` before numbering (0275).
- The Stage 1 `analyze.py` scope is `sorted(units)[5:]`, which is correct for every subject here only because Physics 2 and E&M start at 9 and 8 (their first five are 9-13 and 8-12).
- Cheap-phase cost ran about 2.5 times the estimate ($2.80 vs $1.1): reasoning-heavy FRQ packets. GPT phases were cheap because only 126 + 27 items qualified.
- `resolve.py` now also holds back any item whose new cell would contradict the unit of its existing validated label.
