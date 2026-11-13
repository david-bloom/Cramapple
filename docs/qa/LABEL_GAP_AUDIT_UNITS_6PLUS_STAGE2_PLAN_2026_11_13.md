# Label gap, Units 6+: Stage 2 plan and cost (2026-11-13)

Basis: Stage 1 audit (`LABEL_GAP_AUDIT_UNITS_6PLUS_2026_11_13.md`): 141 in-scope items lack a validated topic cell; 86 of them also lack a servable serving label. Owner direction (the brief) authorizes publication of labels; Hard-Gate steps still apply. Scope: serving labels and topic cells only.

## Methods
| Method | Items | Notes |
|---|---|---|
| Model vote (six-vote blind topic probe) | **135 seeds** (76 MCQ, 59 FRQ) | gemini-3.8-flash x2, deepseek-v4-pro x2, gpt-6.1-sol x2. Topic accepted at 5 of 6; required units named by at least 4 of 6. Packets hold only student-visible text (stem, stimulus, choices, and `prompt_json.parts` when stored; 49 of the 59 FRQs keep their parts inside the stem or stimulus, 10 carry a separate `parts` list). No keys, rubrics or stored topic hints. |
| Inherit from seed | **6** Calculus AB MCQ variants (`apcalcab-mcq-sv-016-v1/v2`, `-017-v1/v2`, `-np2-006-v1/v2`) | Seeds `apcalcab-mcq-016`, `-017`, `-np2-006` are in the vote set; variants take the seed's topic and units if the seed resolves. |
| Deterministic | 0 | No provenance or earlier votes cover these items. |
| CED-text arbitration | only items at 4 of 6 or split on units | Claude reads the item against `subject packs/` and `docs/product/*_CED_FACT_PACK.md`; ruling logged per item; no hand edits of items or labels. |

Roster refreshed with `gateway.getAvailableModels()`: all three models still listed at unchanged prices (gemini-3.8-flash $0.75/$3.75, deepseek-v4-pro $1.32/$3.96, gpt-6.1-sol $2/$10 per million tokens in/out). Newer deepseek variants exist (v4-pro-0813, v4.1-flash) and `gpt-6.1-terra`; I keep the brief's three models so the rule matches last round.

## Label actions after the votes (additive only)
- Topic cell: insert a validated primary cell where none exists (97 items); promote a `provisional_model`/`authored` cell in place only when the vote agrees (44); where a vote disagrees with a non-validated cell, residue for the owner.
- Serving label: insert a new validated, hash-fresh label (next label_version) where the item has none, a provisional, a stale or a releasable held label (86); leave labels that are already servable (55) untouched.
- Held labels (35): `model_unit_disagreement` 24, `empty_required_units` 2 are released only on a 5 of 6 vote; `rubric_preflight_failure` 4, `ab_bc_only_content` 3, `other` 2 stay held, so those 9 items get no serving label (a topic cell is added only if the vote is clean). Rubric repair is a content change and needs your decision per class; I will list them, not edit.
- Validated cells conflicting with a vote: keep the cell, flag. Existing validated labels are never superseded.
- Old-version cells (`apcalcab-mcq-016`, `-np2-006`): the new cell goes on the latest published version; old-version cells are left.

## Cost estimate (measured price per token, gateway key shared)
- Last round: 2,978 calls cost $10.31, mean $0.0035/call. Phase `cheap`: 135 x 4 = 540 calls (about $1.1). GPT phases run only where the cheap votes could still reach 5 of 6: at most 270 calls (about $1.4). Expected total **about $2.5; ceiling $4**.
- **Spend cap: $6** (hard stop in `vote_runner.mjs`, ledger `stage3/cost_ledger.jsonl`, priced from token usage, not balance deltas). Session-slice token cost not gateway-priced.

## Decisions
- 74 unit-less held items: left out (your yes at the Stage 1 boundary).
- Nothing else needs you before Stage 3. No Production writes occur in Stage 3.

Stage boundary: stopping for your go-ahead on Stage 3 (votes cost money).
