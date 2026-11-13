# Label gap fill, Units 1-5: Stage 2 plan and cost (2026-11-13)

Owner direction (2026-11-13): **serving labels and topic cells only**; difficulty rows and skill cells are out of scope (Stage 1 Q1 stays open for a later task). Population = the in-scope items missing a validated topic cell **or** a servable serving label: **619 items** (recounted from `docs/qa/LABEL_GAP_AUDIT_UNITS_1_5_2026_11_13_ITEMS.json`). Nothing has been written anywhere.

## Population by current state
| Group | Items | Notes |
|---|---|---|
| No serving label at all | 213 | Stats 183 MCQ seeds with an `authored` topic cell (legacy), 20 u45r2 FRQ variants, 10 u45r2 FRQ seeds |
| Only a non-validated serving label | 160 | provisional_model 89, held 68, legacy_unvalidated 2, stale 1 (66 of them also lack a validated topic cell) |
| Serving ok, topic cell not validated | 246 | no cell 69 (MCQ 43 + FRQ 26), provisional_model (Calc AB) 157 (57 seeds: MCQ 31 + FRQ 26; 100 variants: MCQ 85 + FRQ 15), authored 20 |
Held reasons across all 227 active held serving labels in Production (not only these 68): model_unit_disagreement 129, rubric_preflight_failure 37, other 30, empty_required_units 17, model_call_failure 10, ab_bc_only_content 3, one exam-scoring item.

## Method per group
- **(b) Deterministic, 10 items:** the u45r2 Statistics FRQ seeds. Topic and required unit come from the stored six-vote probe and ruling in `prompt_json.provenance` and `scripts/content-seed/frq-stats-u5-2026-11-12/r2/slots/`. Topic 5.3 seed: checkers split on difficulty (not relevant to topic); topic from the votes, confidence recorded low.
- **(a) Inherit, 20 items:** the u45r2 variants (`-v1`, `-v2`) take their seed's topic and required units, same unit. Also any variant elsewhere whose seed can be matched by key or provenance and whose seed is (or becomes) validated.
- **(c) Model vote, up to 589 items:** six-vote topic probe (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol x2... per the brief: accept at >=5 of 6, required units named by >=4 of 6, CED-text tiebreak recorded, both checker families agree or the item is dropped and listed). Template: `scripts/content-seed/frq-topic-labels-u13-2026-10-09/` and `scripts/vercel-gateway-check/subject_label_probe.mjs --mode=serving`. The 100 Calculus AB variants with provisional cells are inherited from their seed where the seed is found, else voted.

## Rules this plan applies (each is a place where I stop rather than guess)
1. **Never change an existing validated label.** Labels are added; there are none to supersede for these 619 (every validated item already has it).
2. **Calculus AB provisional topic cells (157 items).** The database allows one primary cell per version, so a validated cell cannot sit beside the provisional one. Plan: promote the provisional cell to validated **in place only when the vote agrees with its topic**; where the vote disagrees, leave it and list it. This changes a non-validated row only, and the served set does not change (the selector ignores provisional cells for `topic_match`). *Needs your yes before Stage 4.*
3. **Held items (68) and provisional serving labels (89).** A new validated label is added only when the hold reason is gone: model_call_failure and empty_required_units get a fresh probe; model_unit_disagreement is released only if both families now agree at >=5 of 6; rubric_preflight_failure, ab_bc_only_content, the exam-scoring item and "other" stay held and are listed (about 68 minus those). Releasing a held item makes it newly served, so each such release goes in the approval record by key.
4. **Statistics 183 unserved MCQ seeds** with only an `authored` cell: probe them like any seed; publish only the ones both families agree on. This makes legacy items newly served (owner Q2 is answered by your direction to label them; items that fail the vote stay dark and are listed).
5. Hash freshness: every new serving label is validated against `taxonomy_relevant_hash(latest version)` inside the transaction; no item text is edited.
6. Unit mapping: Physics 2 = 9-13, E&M = 8-12, Precalculus 1-4; a vote that lands outside the item's own subject taxonomy is rejected.

## Cost (estimate, not measured)
- Measured basis: the 2026-10-09 FRQ probe cost $8.26 for 339 items = **$0.024 per item** (six votes, student-visible text only).
- 589 voted items x $0.024 = **about $14**; roster refresh and re-probes of failed calls, CED-text tiebreak reads and a second pass on held items: **about $4**; **total about $18, cap $25** (stop and report if reached). Deterministic and inherited items cost $0. My own session slice is not priced by the gateway; I will report it separately from the measured gateway spend in `cost_ledger` (one row per call: model, tokens in/out, USD). The gateway key is shared with other sessions, so balance deltas will not be used as attribution.

## Before Stage 3
- Refresh the roster with `gateway.getAvailableModels()` and confirm the four voters still exist; check the credit balance; symlink the gitignored `.env.local` into this worktree (never printed).
- Approval number: highest on origin/main is APPROVAL-0258; open PR #640 and other branches will be re-checked immediately before the record is written.

## Decisions needed from you
1. Calculus AB provisional cells: promote in place when the vote agrees (rule 2)? Default if you say nothing: yes, listed disagreements left alone.
2. Held items: release only under rule 3? Default: yes.
