# Label gap fill, Units 1-5: Stage 3 result (2026-11-13) — label generation, no Production writes

Owner-approved scope: serving labels and topic cells only; rules from `LABEL_GAP_AUDIT_UNITS_1_5_STAGE2_PLAN_2026_11_13.md` (Calc AB/Statistics non-validated cells promoted in place only on agreement; held items released only under the stated rules). Nothing was written to any database; Production was read only. Files: `scripts/content-seed/label-gap-audit-2026-11-13/` (`build_packets.py`, `vote_runner.mjs`, `resolve.py`, `finalize_stage3.py`, `stage3/`).

## Result: 619 gap items
| Outcome | Items |
|---|---|
| Load-ready (`stage3/load_<subject>.json`, 10 files) | **513** |
| Residue, not labeled (`stage3/residue_final.json`) | **106** |

Load-ready by method: model vote 483, deterministic from stored provenance 10 (Statistics unit 4/5 FRQ seeds; topic 5.5 is the recorded CED-text tiebreak, 5.3 labeled from its 6/6 topic votes), inherited from seed 20 (their variants). By subject: Statistics 205, Calc AB 157, Physics C E&M 30, Mechanics 25, Precalculus 24, Physics 1 22, BC 20, Physics 2 20, Chemistry 8, Biology 2.
Actions in the load files: **298 new validated serving labels** (183 items with none, 78 over a provisional_model label, 38 over a held label, 2 legacy_unvalidated, 1 stale; the old non-validated rows get `superseded_by`); **447 topic cells** (330 promoted in place from provisional_model/authored, 117 inserted); 66 items need no cell action. 38 held items are released: 28 `model_unit_disagreement` (now at least 5 of 6), 7 `empty_required_units`, 3 `model_call_failure`; each is listed by key in `resolved_final.json` (`hold_reason`) for the approval record.

## Residue (106, each listed with its tally in `residue_final.json`)
- 32 no majority among the four cheap votes (5 of 6 arithmetically impossible, no gpt call spent); 18 below 5 of 6 after gpt.
- 27 stay held (rubric_preflight_failure 17, other 10), per the approved rule.
- 25 where the vote disagrees with an existing non-validated cell (authored 20, provisional_model 3) or a validated cell (2, never changed); 4 where the vote moves the item to a unit different from the unit on record (not applied; owner call).
Not covered by 6 votes: items accepted at 5 of 5 (only 5 votes needed because the sixth could not change the outcome) are marked in the tallies; a second gpt vote ran for 65 items where it could.

## Cost (measured by token usage times listed price; the key is shared, so balance deltas are not attribution)
2,978 calls (2 failed after retries): gemini-3.8-flash 1,178 calls $2.40; deepseek-v4-pro 1,178 calls $6.02 (reasoning output ~924 tokens per call); gpt-6.1-sol 622 calls $1.88. **Total $10.31** against the plan's $18 estimate (deepseek cost more per call than assumed; gpt far fewer calls by sequential early stopping). Gateway `totalUsed` moved by $10.47 over the same window, consistent with the ledger. My session slice is not priced by the gateway and is not estimated here. Per-call ledger: `stage3/cost_ledger.jsonl`; summary `stage3/cost_summary.json`.

## Not done / next
Stage 4: record the APPROVAL (check main, open PRs and remote branches for the highest number), per-subject rehearsal in rollback form, one transaction per subject with an advisory lock, independent verify; Stage 5 selector spot-check. The 106 residue items need an owner decision on any that should be handled differently.
