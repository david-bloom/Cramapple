# Unit 4 build-out status (2026-11-12)

**Scope (owner direction 2026-11-12):** Unit 4 for every subject except Physics 2, Physics C: Mechanics and Physics C: E&M (on hold). Plan: `QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`; Unit 3 status: `UNIT3_RELEVELING_STATUS_2026_11_12.md`.

## Finding: Unit 4 is mostly unbuilt, so this is new content, not re-leveling
Published practice MCQs for Unit 4 before this batch: Statistics 78 (done under APPROVAL-0217), Biology 8 (4.1 to 4.4 only), Calculus AB 11 (4.2, 4.5, 4.6, 4.7), Chemistry 5 (4.2, 4.5, 4.6, 4.8), **Physics 1 none, Calculus BC none, Precalculus none (14 topics)**. Precalculus Unit 4 (parametric functions, vectors, matrices) is not assessed on the AP exam, so it gets one seed per topic.

## Prepared, NOT executed
| Subject | Topics | Package folder (`scripts/content-seed/`) | New MCQs | Retire |
|---|---|---|---|---|
| AP Physics 1 | 4.1-4.4 | `apphysics1-harder-seeds-u4-2026-11-12` | 32 | 0 |
| AP Biology | 4.1-4.6 | `apbio-harder-seeds-u4-2026-11-12` | 48 | 5 |
| AP Chemistry | 4.1-4.9 | `apchem-harder-seeds-u4-2026-11-12` | 72 | 4 |
| AP Calculus AB | 4.1-4.7 | `apcalcab-harder-seeds-u4-2026-11-12` | 56 | 10 |
| AP Calculus BC | 4.1-4.7 | `apcalcbc-harder-seeds-u4-2026-11-12` | 56 | 0 |
| AP Precalculus | 4.1-4.7 | `apprecalc-harder-seeds-u4a-2026-11-12` | 28 | 0 |
| AP Precalculus | 4.8-4.14 | `apprecalc-harder-seeds-u4b-2026-11-12` | 28 | 0 |
| **Total** | | | **320** | **19** |

All items blind-solved by `deepseek/deepseek-v4-pro` (100% agreement with the key on every package) and `moonshotai/kimi-k3.1-pro` (a few misses per package, each re-checked). The 36 items that Kimi or the difficulty tool disputed were solved again by `openai/gpt-5.5`, which agreed with the key on all 36; the disagreements were model noise (the models' own working often matched the key). The difficulty tool (`scripts/difficulty-audit/`) rates the sets mostly R2/R3.
Authoring was done in session by subagents against the strict format and `_tools/validate_draft.py`; packaging by `_tools/make_package.py` (now unit-aware, batches may have no retirements); execution by `_tools/exec_package.py`.

## Caveats
- No subject-expert read, no model audit of rationales; tiers are uncalibrated model judgements.
- Several Calculus seeds are strong R2 rather than R3 (related-rates setups, motion sign analysis).
- Calculus AB and BC were authored by separate agents; no cross-pool duplicate check was run.
- Biology and Chemistry retire a few existing R1 or near-duplicate families (19 items in total across subjects).
