# AP Chemistry 1.5 structured-pieces test (recommendation #3), 2026-11-12

Status: APPLIED TO DEVELOPMENT ONLY (2026-11-13 UTC, version 20261113033115). Production untouched and not approved. `proposed.json` holds the current and proposed text for four explainer fields; `answer_move`, `common_point_loss`, `mini_example_question`, `weak_answer`, `practice_bridge` and `title` are unchanged, and the seven briefs are untouched.

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

## Checks run 2026-11-12 (greenlit by David)
- Checkers (different families from the Claude author): openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro. Both returned 0 findings and verdict pass. Planted-defect control (Al configuration 3p2, Al core electrons 12): both caught both defects. deepseek/deepseek-v4-pro spent its whole output budget on reasoning twice (4k and 16k tokens) and returned nothing, so it does not count. Gateway spend about $0.20 (balance before: $20.01).
- Dev apply: migration `supabase/migrations/20261113033115_chem_u1_1_5_structured_explainer.sql` (guarded on the row's prior hash; file renamed to the recorded version). Read-back: Dev field hash equals proposed.json; exactly 1 row touched; Production hash unchanged and not touched.
- `topic_guides_database_qa.sql` run against Development via the CLI (--workdir pinned to the Dev-linked checkout): exit 0, no hard failure. The CLI printed only the first statement's result, so the C9/C13 warnings were not visible; I computed the overlap coefficient for the three brief/explainer pairs separately: 0.50, 0.29, 0.40 (all under 0.80). Caps checked in Python above.
- Not independent of the author: Claude authored and arbitrated; no findings needed arbitration.

## NOT done
- Render check of the Dev payload through the app harness (the structured text is only previewed from strings; app PR 60 not yet merged or published).
- Production approval (Hard Gate), APPROVAL number (check open PRs first), Production apply.
- A weak-answer table to pair with the strong one (kept as is).
