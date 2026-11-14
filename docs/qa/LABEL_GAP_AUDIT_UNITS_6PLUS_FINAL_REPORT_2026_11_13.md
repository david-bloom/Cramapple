# Label gap audit and fill, Units 6+, all ten AP subjects: final report (2026-11-13)

Scope (owner): serving labels and topic cells only, published MCQs and FRQs in registry units above the Units 1-5 range (mapping in the Stage 1 report). Production `pcntajvbdfqhbeewmdry`. Approval: `APPROVAL-0275`. Earlier stages: `LABEL_GAP_AUDIT_UNITS_6PLUS_2026_11_13.md` (audit), `..._STAGE2_PLAN_...`, `..._STAGE3_RESULT_...`.

## Result (recounted from a fresh Production export, `..._ITEMS_AFTER.json`)
| In scope (242 published items) | Missing before | Missing after |
|---|---|---|
| Validated topic cell | 141 | **23** |
| Servable serving label | 86 | **20** |
| Skill cell (out of scope) | 200 | 200 |
| Difficulty row (out of scope) | 0 | 0 |

**118 items labeled:** 118 validated topic cells (82 new, 36 promoted in place from provisional/authored) and 66 validated hash-fresh serving labels (46 replaced a `provisional_model` label, 20 released a held label on a >= 5 of 6 vote). The 23 still missing are exactly the Stage 3 residue (no other item gained or lost a gap).

## Verification
- Every subject rehearsed in rollback form with constraints forced immediate, then committed once with an advisory lock and plan-hash check; independent read-back **118/118 MATCH** (validated cell with the voted topic, fresh validated label with the planned max unit).
- **Live selector** (`select_student_practice_items`, called, not modelled; random user with no attempts; each item queried with its own topic): **118 of 118 returned, 118 of 118 with `topic_match = true`**, 0 errors (script `selector_check_u6plus.py`, result `stage4/selector_check.json`).
- **Nothing previously served stopped being served:** comparing the before and after exports, 0 items that had a servable label before lost it and 0 validated cells were lost. A regression sample of 20 previously served items (up to 6 per subject, fixed seed) was returned by the live selector 20/20 with `topic_match = true`. Limitation: no same-function before/after selector snapshot was taken before the write; the claim rests on the export comparison plus the sample. Other sessions were publishing to Production during this run (APPROVAL-0272 to 0274); the in-scope count stayed at 242.

## Cost
Measured at token usage times listed price (shared gateway key): cheap phase 540 calls $2.80, gpt-6.1-sol 153 calls $0.51; **total $3.31** against the $6 cap (plan $2.5, ceiling $4). By method: model vote $3.31; inherited (6 variants) and deterministic $0. CED-text arbitration: none done this round. Session-slice token cost not estimated. Ledger: `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/stage3/cost_ledger.jsonl`.

## Residue: 23 items still unlabeled (`scripts/.../residue_after.json`, reasons in the Stage 3 result)
- 8 held, stay held (owner decision per class): rubric_preflight_failure `apcalcab-frq-017`, `-036`, `apchem-frq-l-023`; ab_bc_only_content `apcalcab-frq-035`, `apcalcbc-mcq-mv045`, `-mv050`; other `apchem-frq-l-021`, `apchem-sfrq-035`.
- 14 split or sub-majority votes (CED-text arbitration would settle them): 9 two-way ties and 5 below 5 of 6.
- 1 owner call: `apphy2-mcq-013` (validated label at Unit 14, five votes for 13.3).
Also: 74 unit-less held items remain out of scope (Stage 1 question, owner kept them out).

## Not verified / limits
No CED arbitration yet on the 14 splits; the 20 released holds relied on the vote alone (>= 5 of 6), not a separate soundness check of the item; `apchem-sfrq-026` moved from unit 6 on record to 9.6 (unserved before).

## Update (APPROVAL-0276): round 2, CED-text rulings on the vote splits
Owner said "Yes, arbitrate". 13 of the 14 split items were ruled against the CED text and labeled (13 validated topic cells, 11 new validated serving labels; 2 items already had validated labels and got a cell only). Rulings: `LABEL_GAP_AUDIT_UNITS_6PLUS_ROUND2_CED_RULINGS_2026_11_13.md`. Read-back 13/13; live selector 13/13 with `topic_match`; regression sample 48/48. **No new gateway spend** (total stays $3.31).

**Residue is now 10** (recounted from a fresh export): 9 held items (3 rubric_preflight_failure `apcalcab-frq-017`, `-036`, `apchem-frq-l-023`; 3 ab_bc_only_content; 2 other) and `apphy2-mcq-013` (owner call). **Correction to the first report:** `apchem-frq-l-026` is held for `rubric_preflight_failure` (I had it as a vote tie); its CED reading is 8.9, but it stays held. So the 9 held are: rubric `apcalcab-frq-017`, `apcalcab-frq-036`, `apchem-frq-l-023`, `apchem-frq-l-026`; AB/BC-only `apcalcab-frq-035`, `apcalcbc-mcq-mv045`, `apcalcbc-mcq-mv050`; other `apchem-frq-l-021`, `apchem-sfrq-035`.
In-scope count is 241: `apchem-sfrq-031` is a Unit 4 topic (4.8) by the CED, so it is no longer in units 6+.

## Update (APPROVAL-0277 and 0278): the four rubric-held FRQs repaired and labeled
Owner said "Yes, all four". New versions published with repaired rubrics (`apcalcab-frq-017`, `-036`, `apchem-frq-l-023`: rubric-side only; `apchem-frq-l-026`: parts (d) and (f) rewritten as qualitative reasoning because the CED excludes computing the pH change on adding acid or base to a buffer). Edits checked by three models (12 of 12 pass, after two rounds of fixes to 026) and by recomputation. Then 4 validated topic cells and 4 validated serving labels: `apchem-frq-l-023` 7.4 (5 of 5 votes), `apcalcab-frq-017` 8.3, `apcalcab-frq-036` 8.11, `apchem-frq-l-026` 8.8 (the last three by CED-text ruling after split votes; judgment calls within one unit). Read-back 4/4, live selector 4/4 with `topic_match`, regression sample 48/48.

**Residue is now 6** (fresh export): AB/BC-only content `apcalcab-frq-035`, `apcalcbc-mcq-mv045`, `apcalcbc-mcq-mv050`; other `apchem-frq-l-021`, `apchem-sfrq-035`; owner call `apphy2-mcq-013`. **Total labeled in units 6+: 135** (118 + 13 + 4). **Gateway total about $3.69** ($3.31 votes, $0.24 rubric checks, $0.15 topic votes on the repaired versions). Not verified: the repaired rubrics and the new prompt text for 026 have not been reviewed by a human subject specialist; they rest on recomputation and three-model checks.
