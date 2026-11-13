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
