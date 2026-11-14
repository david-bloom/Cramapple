# Session close: label gap audit and fill, Units 6+ (2026-11-13)

Read first: `docs/qa/LABEL_GAP_AUDIT_UNITS_6PLUS_FINAL_REPORT_2026_11_13.md`. Approval `APPROVAL-0275`. Scripts: `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/` (`publish_labels_u6plus.py` is one-shot per plan; its guards refuse a re-run).

## State (updated after round 2, APPROVAL-0276)
Round 2 labeled 13 more items; the four rubric_preflight_failure items were then repaired and labeled (APPROVAL-0277, 0278); **6 remain unlabeled** (5 held, 1 owner call). Everything below about 23 residue is superseded by `residue_after.json`.

242 in-scope published items in units 6+ (mapping in the Stage 1 report; Precalculus and Statistics have none). 118 labeled and verified; 23 remain unlabeled and are listed in `residue_after.json`. Gateway $3.31.

## Exact next step
1. Round 2 is DONE (APPROVAL-0276). Next approval number is 0279 or higher; check main, open PRs and remote branches first.
2. **Owner decisions:** the 5 held items (AB/BC-only content `apcalcab-frq-035`, `apcalcbc-mcq-mv045`, `-mv050`; other `apchem-frq-l-021`, `apchem-sfrq-035`); `apphy2-mcq-013` (served at Unit 14, votes say 13.3, check against the CED before changing anything); whether to vote the 74 unit-less held items.
3. Skill cells (200 missing in scope), Units 1-5 residue from the earlier round, and the other open items in the Units 1-5 handoff are unchanged.

## Do not touch
- Any validated cell or label (changes need an explicit yes); the 8 held labels; the 74 unit-less held items; Lovable frontends, migrations, edge functions.
- Calculus Unit 5 and explainer work from other sessions (APPROVAL-0267 to 0274) is not part of this change.

## Traps hit
- The branch was cut before other sessions took APPROVAL-0273/0274; merged `origin/main` before numbering (0275).
- The Stage 1 `analyze.py` scope is `sorted(units)[5:]`, which is correct for every subject here only because Physics 2 and E&M start at 9 and 8 (their first five are 9-13 and 8-12).
- Cheap-phase cost ran about 2.5 times the estimate ($2.80 vs $1.1): reasoning-heavy FRQ packets. GPT phases were cheap because only 126 + 27 items qualified.
- `resolve.py` now also holds back any item whose new cell would contradict the unit of its existing validated label.

## Update: rubric repairs (APPROVAL-0277/0278)
`apcalcab-frq-017`, `-036`, `apchem-frq-l-023` rubric-side repairs and `apchem-frq-l-026` prompt repair published as new versions and labeled; scripts `stage5/` and `stage5v/`, `publish_rubric_repair_u6plus.py`, `publish_labels_u6plus_r3.py`. Do not touch the new versions' rubrics without a fresh check. A subject specialist should eventually review the 026 prompt wording.

## Update 2026-11-14: residue is 0 (APPROVAL-0280 to 0283)
All six remaining items are now labeled: `apphy2-mcq-013` (14.3), `apcalcbc-mcq-mv045` (7.5), `apcalcbc-mcq-mv050` (8.13), `apchem-frq-l-021` (6.9), and the two repaired FRQs `apcalcab-frq-035` (v2, 7.7) and `apchem-sfrq-035` (v4, 8.10). Scripts: `publish_labels_u6plus_r4/r5/r6.py`, `publish_content_repair_u6plus_r6.py`, `stage6/`, `stage6v/`.
- **Exact next step:** none required for labels. Optional: a subject specialist reads the repaired items (`apcalcab-frq-035`, `apchem-sfrq-035` and the four from 0277); the 74 unit-less held items and the 200 missing skill cells are separate work.
- **Do not touch:** the validated cells and labels written under 0275 to 0283; do not re-run the r4/r5/r6 publishers (their plan hashes would fail, nothing to add).
- **Trap:** other sessions took APPROVAL-0279; check open PRs and remote branches for the highest number before numbering.
