# Session close: label gap audit and fill, Units 1-5 (2026-11-13)

Read first: `docs/qa/LABEL_GAP_AUDIT_UNITS_1_5_FINAL_REPORT_2026_11_13.md`. Approvals `APPROVAL-0265` (513 items) and `APPROVAL-0266` (82 items); scripts and evidence in `scripts/content-seed/label-gap-audit-2026-11-13/`.

## State
Serving labels and topic cells filled for 595 published items across all ten subjects (Physics 2 = units 9-13, E&M = 8-12, Precalculus 1-4). 24 items remain unserved and are listed in `docs/qa/LABEL_GAP_AUDIT_UNITS_1_5_FINAL_RESIDUE_2026_11_13.json`. Live selector returns 595/595 with topic match.

## Exact next steps (owner decisions)
1. 17 rubric_preflight_failure FRQs: repair the rubrics first, then a fresh label (the stored label is held).
2. 4 unit conflicts and 2 validated-cell conflicts (names in the final report): read each against the CED; any change to a validated label needs an explicit owner yes.
3. Review the three flagged published labels (`apcalcab-frq-u13-003`, `apcalcbc-frq-u13-015`, `apphycm-frq-012`).
4. Difficulty rows (2,467 items) and skill cells (3,237) are untouched; decide whether they are required (Stage 1 Q1) before any task.
5. Dev was not touched and still lags Production.

## Do not touch
- Any validated cell or label (changes need an explicit yes). The 173+3 AP Statistics `authored` topic x skill cells were kept on purpose (promoting them would validate a skill).
- The held rubric-failure labels; the Lovable frontends, migrations and edge functions (not in scope).
- `publish_labels.py` / `publish_labels_r2.py` are one-shot per plan (guards refuse a re-run); do not reuse them without a new plan and approval.

## Traps hit
- Packets for FRQs omitted `prompt_json.parts` (voters saw titles only): include the parts in every FRQ packet.
- The one-primary-cell-per-version unique index: demote the old primary cell before inserting its replacement.
- Plan hashes: aggregate with `order by ... collate "C"` (mixed-case keys sort differently in the database).
- `cat > file` with an unset variable hangs a shell on stdin; the gateway key is shared and the balance moves for other reasons.
- I mis-added a group size (68 instead of 50) in a message to the owner; the record states the correction.

## Update 2026-11-13 (APPROVAL-0269): 16 of the 17 rubric-held FRQs repaired, published and labeled
Rubric-side edits, new item versions, validated topic cells and serving labels; 16 of 16 returned by the live selector with topic_match. Residue is now **8 unserved**: `apcalcbc-frq-u13-020` (no prompt parts; author-or-retire is the owner's call), the 4 unit-move items, the 2 validated-cell conflicts and `apprecalc-frq-np2-010`. See `docs/activity_log/APPROVAL-0269_RUBRIC_PREFLIGHT_REPAIR_AND_LABEL_16_FRQS_PRODUCTION_2026_11_13.md`; rubric-check cost $0.50 (total gateway for the task about $11.70).

## Update 2026-11-13 (APPROVAL-0270): `apcalcbc-frq-u13-020` authored, published and labeled
Prompt parts authored from the surviving criteria; probe put it at topic 5.12 (Unit 5), units [2, 3, 5]. Residue is now **7 unserved**: the 4 unit-move items, the 2 validated-cell conflicts and `apprecalc-frq-np2-010`. All 17 rubric-held FRQs are done.

## Update 3 (APPROVAL-0271): residue 7 to 2
Five of the seven residue items were labeled: `apphy1-mcq-022` (6.6, Unit 6), `apphycm-frq-003` (7.2, Unit 7), `apchem-frq-l-017` (8.5, Unit 8), and the two Statistics `-INV` items, which keep their existing validated cells (1.13 and 5.2) and gained a matching validated serving label. None was served before, so no served item moved; verified by read-back and the live selector. Still unlabeled, with reasons: `apcalcbc-frq-u13-014` (re-voted with its parts: 4.1 x2, 5.1, 2.3, no single topic) and `apprecalc-frq-np2-010` (three unrelated sub-skills). Owner decisions open: whether the Statistics cells 1.13 (MOD4; votes say 4.10) and 5.2 (MOD5; all six votes say 1.13) should change; whether to retire or split the two unlabeled items. Scripts: `scripts/content-seed/label-gap-audit-2026-11-13/stage7/`, `publish_labels_r5.py`. Measured gateway cost this round $0.08.
