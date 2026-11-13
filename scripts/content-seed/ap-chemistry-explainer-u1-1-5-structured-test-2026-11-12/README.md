# AP Chemistry 1.5 structured-pieces test (recommendation #3), 2026-11-12

Status: CANDIDATE ONLY. Nothing was written to Development or Production. No migration exists. `proposed.json` holds the current and proposed text for four explainer fields; `answer_move`, `common_point_loss`, `mini_example_question`, `weak_answer`, `practice_bridge` and `title` are unchanged, and the seven briefs are untouched.

## What changed
Structure is marked inside the existing text columns, so no schema change: `- ` bullet lines, `1. ` step lines, `| a | b |` table rows. The renderer is app PR 60 (david-bloom/ap-prep-blueprint#60) and must be published first.

| Field | Shape now | Words before -> after | Cap (chars) |
|---|---|---|---|
| core_idea | 3 bullets (mechanism) | 60 -> 51 | 304 / 360 |
| what_students_need_to_understand | 3 bullets (trap/dependency) | 52 -> 42 | 257 / 360 |
| how_this_becomes_points | 3 numbered steps (rubric path) | 42 -> 36 | 221 / 320 |
| point_attaining_answer | configurations, a Factor/S/Al table, 2-sentence conclusion | 76 -> 71 | 416 / 520 |

Four fields total 230 -> 200 words. The gain is scanning, not length.

## Checks done in session (READ/derived, not the full protocol)
- Configurations: S (Z=16) 1s2 2s2 2p6 3s2 3p4; Al (Z=13) 1s2 2s2 2p6 3s2 3p1 (unchanged from the published row, re-derived).
- Table: nuclear charge +16 vs +13; both valence shell n=3; both 10 core electrons (1s2 2s2 2p6).
- Conclusion: sulfur's first ionization energy is higher than aluminum's (about 1000 vs 578 kJ/mol).
- CED grounding: AP_CHEMISTRY_CED_FACT_PACK.md 1.5 (Coulomb's law EQN, Aufbau, qualitative ionization energy via distance and effective nuclear charge; quantum-number exclusion statement kept in core_idea).
- Length caps from `topic_guides_qa_budgets` (C9): all four within cap. C13 overlap vs briefs not run.

## NOT done (needs your go-ahead)
- Two-family checker run (DECISION-0093/0099) and the flag arbitration; needs a gateway spend estimate and roster fetch.
- Migration file, Development apply, QA script run, Production approval (Hard Gate), APPROVAL number (check open PRs first).
- A weak-answer table to pair with the strong one (kept as is).
