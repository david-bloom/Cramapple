# Label gap, Units 6+: Stage 3 result (votes done, no Production writes) (2026-11-13)

Votes: `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/stage3/votes.jsonl`; ledger `stage3/cost_ledger.jsonl`; decisions `stage3/resolved.json`; residue `stage3/residue.json`; resolver `resolve.py`.

## Cost (priced from token usage; gateway key shared)
Cheap phase (540 calls, all ok) $2.80; gpt-6.1-sol phase 1 (126 calls) $0.41; phase 2 (27 calls) $0.10. **Total $3.31** against the $6 cap (plan estimate $2.5, ceiling $4). Deterministic and inherited $0. Session-slice token cost not priced.

## Result for the 141 gap items
- **118 resolved** to a write plan: 112 seeds by a >=5 of 6 vote, 6 variants by inheritance. Plan: 118 validated topic cells (83 new, 35 promoted in place from provisional/authored) and 66 new validated hash-fresh serving labels (46 supersede a `provisional_model` label, 20 release a held label: 18 `model_unit_disagreement`, 2 `empty_required_units`; all released on a >=5 of 6 vote). 52 items already had a servable label and get a cell only.
- **23 residue, nothing written for them:**
  - 8 held and staying held (not releasable without a content decision): `rubric_preflight_failure` `apcalcab-frq-017`, `apcalcab-frq-036`, `apchem-frq-l-023`; `ab_bc_only_content` `apcalcab-frq-035`, `apcalcbc-mcq-mv045`, `apcalcbc-mcq-mv050`; `other` `apchem-frq-l-021`, `apchem-sfrq-035`.
  - 9 with no majority after the cheap votes (2-2 splits; GPT not run, 5 of 6 impossible): `apcalcab-frq-020` (6.5/6.4), `apcalcab-frq-022` (8.11/8.4), `apchem-frq-l-026` (8.9/8.10), `apchem-sfrq-029` (8.11/7.11), `apchem-sfrq-031` (4.8/8.1), `apchem-sfrq-033` (8.8/8.4), `apphy1-mcq-016` (7.3/7.1), `apphy2-frq-032` (15.3/15.2), `apphycm-mcq-041` (7.1/7.2).
  - 5 below 5 of 6: `APBIO-HDG-2026-GRAPH-010` (8.3 x4, 8.4 x2), `apcalcab-frq-np2-005` (6.4 x3, 6.5 x2), `apcalcab-frq-np2-006` (6.2 x4, 8.2 x2), `apchem-frq-l-028` (9.8 x4, 9.10 x2), `apphycm-mcq-014` (6.4 x3, 6.3 x2).
  - 1 owner call: `apphy2-mcq-013` is served today with a validated label at Unit 14, but all five votes say topic 13.3 (Unit 13). A new cell at 13.3 would contradict the label; held back. (I read this from the vote only; not CED-arbitrated.)
- The 74 unit-less held items remain out of scope (your Stage 1 answer).

## Flags in the plan
- `apchem-sfrq-026`: unit on record 6 (from a provisional label), 5 votes say 9.6. Unserved today, so no served item moves; it is in the plan at 9.6 and flagged.
- No resolved item lands outside units 6+ except none; no `max_required_unit` below the primary unit.

## Next (needs your call)
Round 2 would arbitrate the 14 split or sub-majority items against the CED text (I read each item against the fact packs, as last round) and then label what the text settles. The 9 held-staying-held items need a content decision from you per class. Stage 4 (approval record, rehearsal, publish) is ready to start on the 118.
