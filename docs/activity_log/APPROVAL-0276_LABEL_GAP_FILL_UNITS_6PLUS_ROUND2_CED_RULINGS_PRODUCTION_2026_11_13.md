# APPROVAL-0276 — Label gap fill Units 6+, round 2 (CED-text rulings on vote splits), 2026-11-13

- **Date:** 2026-11-13.
- **Authorization:** David Bloom (Product Owner), in chat: "Yes, arbitrate" (CED-text rulings by Claude on the 14 split items), following the brief's direction to publish the missing labels and APPROVAL-0275.
- **What is written (Production `pcntajvbdfqhbeewmdry`), labels only, one transaction per subject:** 13 published items (Biology 1, Calculus AB 4, Chemistry 4, Physics 1 1, Physics 2 1, Physics C: Mechanics 2).
  - **13 validated primary topic cells:** 10 new, 1 promoted in place (`apcalcab-frq-np2-006`), 2 replacing a non-validated provisional cell (`apcalcab-frq-020`, `-np2-005`; old cell kept, non-primary, superseded).
  - **11 validated hash-fresh serving labels** (non-validated predecessors superseded: 1 stale, 4 provisional, 6 held for `model_unit_disagreement` or `empty_required_units`). `apphycm-mcq-014` and `-041` already have validated labels: cell only, label untouched.
- **Basis:** rulings per item in `docs/qa/LABEL_GAP_AUDIT_UNITS_6PLUS_ROUND2_CED_RULINGS_2026_11_13.md` (item text and parts read against `docs/product/*_CED_FACT_PACK.md`); script `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/publish_labels_u6plus_r2.py`.
- **Not written:** `apchem-frq-l-026` (label held for `rubric_preflight_failure`; stays held). The other 8 held items and `apphy2-mcq-013` from APPROVAL-0275's residue are unchanged.
- **NOT changed:** item text, versions, rubrics, difficulty, skills, any validated cell or label, schema, functions, edge functions, frontends.
- **Rollback:** delete cells, labels and validation decisions with source `label_gap_fill_u6plus_r2_2026_11_13`; restore the promoted/replaced cells per `stage4/u6plus_r2_pre_state_*.json`; clear `superseded_by` on the labels they superseded.
- **Cost:** no new gateway spend (votes from APPROVAL-0275; rulings by Claude in session).
- **Numbering check:** highest APPROVAL on origin/main, open PRs (#652, #654) and all remote branches was 0275; this record takes 0276.
- **Rehearsal:** six `REHEARSAL OK` (rolled back, constraints forced immediate).
- **Result:** see the execution record appended below.
