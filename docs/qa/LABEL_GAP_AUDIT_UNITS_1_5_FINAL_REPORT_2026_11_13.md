# Label gap audit and fill, Units 1-5, all ten AP subjects: final report (2026-11-13)

Scope (owner): serving labels and topic cells only for published MCQs and FRQs; difficulty rows and skill cells were excluded and remain open (Stage 1 Q1). Production `pcntajvbdfqhbeewmdry`. Approvals: `APPROVAL-0265` (513 items), `APPROVAL-0266` (82 items). Earlier reports: Stage 1 audit, Stage 2 plan, Stage 3 result, round-2 rulings (all in `docs/qa/LABEL_GAP_AUDIT_UNITS_1_5_*`).

## Result (recounted from a fresh Production export, `docs/qa/..._ITEMS_AFTER.json`)
| In scope (4,214 published items) | Missing before | Missing after |
|---|---|---|
| Serving label (not served by the selector) | 373 | **24** |
| Validated topic cell | 525 | **184** (176 are AP Statistics items that keep their `authored` topic x skill cell, which the selector already accepts; 8 are inside the 24) |
| Difficulty row (out of scope) | 2,467 | 2,467 |
| Skill cell (out of scope) | 3,237 | 3,237 |

**595 items labeled in total** (513 + 82); 349 of those received a new validated serving label (298 + 51), including 183 Statistics items that had none and 48 released holds (36 in round 1, 12 in round 2).

## Listed residue: 24 items still not served (`docs/qa/LABEL_GAP_AUDIT_UNITS_1_5_FINAL_RESIDUE_2026_11_13.json`)
- 17 held for `rubric_preflight_failure` (FRQ rubric defects; a label cannot fix them; need a rubric repair first).
- 4 where the vote moves the item to a unit different from the unit on record (`apcalcbc-frq-u13-014`, `apchem-frq-l-017`, `apphy1-mcq-022`, `apphycm-frq-003`): owner call.
- 2 AP Statistics items whose existing validated cell disagrees with the vote (`APSTAT-MOD4-H001-INV` cell 1.13 vote 4.10; `APSTAT-MOD5-H001-INV` cell 5.2 vote 1.13): validated cells are never changed; probably need a unit review.
- 1 with no single topic (`apprecalc-frq-np2-010`, three unrelated parts).
Also flagged, not changed (validated labels): `apcalcab-frq-u13-003` (published 2.3, parts-informed revote 2.1), `apcalcbc-frq-u13-015` (published 3.6, revote split 2.10/3.6), `apphycm-frq-012` (existing validated label max unit 6, vote 5).

## Verification
- **Live selector** (`select_student_practice_items`, called, not modelled; random user with no attempts; each item with its own topic; paged until found): **595 of 595** newly labeled items returned, **595 of 595 with `topic_match = true`**, 0 errors; includes the 30 `apstats-frq-u45r2-%` FRQs (30 of 30). Script `selector_check.py`.
- **Nothing previously served stopped being served:** all 3,841 in-scope items that were fully served before (validated cell, fresh validated label) still are (0 lost, 0 unpublished); a 50-item random sample (5 per subject) is returned by the live selector with `topic_match = true`. A same-function before/after snapshot was not taken before the write (limitation); the check rests on the label rows being untouched plus the sample.
- Transactions: every subject rehearsed in rollback form, committed once with an advisory lock, post-checked inside the transaction, then read back independently (513/513 and 82/82).

## Cost
Measured at token usage times listed price (the gateway key is shared; balance deltas are not attribution): Stage 3 votes **$10.31** (2,978 calls: gemini-3.8-flash $2.40, deepseek-v4-pro $6.02, gpt-6.1-sol $1.88); parts-included revote of 43 FRQs **$0.89** (213 calls); **total $11.20** against the plan's $18 estimate. By method: model vote $11.20; deterministic and inherited $0; CED-text rulings by Claude in session (83 items reviewed) not gateway-priced. Session-slice token cost not estimated. Ledgers: `stage3/cost_ledger.jsonl`, `stage3_rerun/cost_ledger.jsonl`.

## Method defect found and handled
43 FRQs were voted from a stem that omitted their part prompts (stored in `prompt_json.parts`). All were re-voted with the parts: 25 of the 27 already-published labels agreed; the two that differ are listed above, unchanged.

## Update 2026-11-13 (APPROVAL-0269): 16 of the 17 rubric-held FRQs repaired, published and labeled
Rubric-side edits, new item versions, validated topic cells and serving labels; 16 of 16 returned by the live selector with topic_match. Residue is now **8 unserved**: `apcalcbc-frq-u13-020` (no prompt parts; author-or-retire is the owner's call), the 4 unit-move items, the 2 validated-cell conflicts and `apprecalc-frq-np2-010`. See `docs/activity_log/APPROVAL-0269_RUBRIC_PREFLIGHT_REPAIR_AND_LABEL_16_FRQS_PRODUCTION_2026_11_13.md`; rubric-check cost $0.50 (total gateway for the task about $11.70).

## Update 2026-11-13 (APPROVAL-0270): `apcalcbc-frq-u13-020` authored, published and labeled
Prompt parts authored from the surviving criteria; probe put it at topic 5.12 (Unit 5), units [2, 3, 5]. Residue is now **7 unserved**: the 4 unit-move items, the 2 validated-cell conflicts and `apprecalc-frq-np2-010`. All 17 rubric-held FRQs are done.
