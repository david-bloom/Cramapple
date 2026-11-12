# Unit 2 re-leveling status (2026-11-12)

**Scope (owner direction):** Unit 2 for every subject except Physics 2, Physics C: Mechanics and Physics C: E&M (on hold). AP Statistics Unit 2 was done earlier (APPROVAL-0214). Plan: `QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`; Unit 3 and 4 status: `UNIT3_RELEVELING_STATUS_2026_11_12.md`, `UNIT4_BUILDOUT_STATUS_2026_11_12.md`.

## Audit of what was published (read-only, `scripts/difficulty-audit/`)
Published practice MCQs in Unit 2 before this batch: Biology 73 (10 topics), Calculus AB 96 (10), Calculus BC 94 (10), Chemistry 44 (7), Physics 1 56 (9), Precalculus 110 (15). Every subject shows the same pattern as Units 3 and 4: almost no R3 items (zero in most topics), several R1-heavy topics (Physics 1 2.1, 2.3-2.6, 2.8 at 75-100% R1; Precalculus 2.1, 2.3, 2.5, 2.9 at 75-100%; Calculus 2.2, 2.3 and BC 2.6 at 80-88%), and thin topics (Precalculus 2.4 and 2.12 have 2 MCQs).

## Executed 2026-11-12 (APPROVAL-0236 to 0242); hash checks 100% and the selector serves the new items in every topic
Two new seeds per topic with three variants each (8 new practice MCQs per topic). Retirements are the whole families whose seed the tool rated R1 (teaching items excluded).
| Subject | Topics | Package folder (`scripts/content-seed/`) | New MCQs | Retire |
|---|---|---|---|---|
| AP Biology | 2.1-2.10 | `apbio-harder-seeds-u2-2026-11-12` | 80 | 4 |
| AP Calculus AB | 2.1-2.10 | `apcalcab-harder-seeds-u2-2026-11-12` | 80 | 27 |
| AP Calculus BC | 2.1-2.10 | `apcalcbc-harder-seeds-u2-2026-11-12` | 80 | 33 |
| AP Chemistry | 2.1-2.7 | `apchem-harder-seeds-u2-2026-11-12` | 56 | 18 |
| AP Physics 1 | 2.1-2.9 | `apphysics1-harder-seeds-u2-2026-11-12` | 72 | 40 |
| AP Precalculus | 2.1-2.8 | `apprecalc-harder-seeds-u2a-2026-11-12` | 64 | 31 |
| AP Precalculus | 2.9-2.15 | `apprecalc-harder-seeds-u2b-2026-11-12` | 56 | 20 |
| **Total** | | | **488** | **173** |

## Checks run
- Format validator OK on every draft; packages built by `_tools/make_package.py` (unit 2; required_units [2], and [1,2] for AB/BC 2.4 and Precalculus 2.11 as in the existing labels).
- Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`: DeepSeek agreed with the key on 485 of 488 items (misses: Physics 1 2.2-B-v2, Calculus AB 2.4-B-v2, Precalculus 2.8-B-v2, each re-derived by hand and the key confirmed); Kimi agreed on 487 of 488 (miss: Precalculus 2.14-A-v2, key confirmed by hand). Tool key-disputes on Chemistry 2.2-A-v3, Calculus AB 2.4-B-v2, BC 2.7-A-v3, Precalculus 2.8-A-v2 and 2.11-B were each re-derived by hand: the keys are correct.
- No near-duplicates between the Calculus AB and BC sets (difflib ratio over 0.8 within a topic: 0 pairs).

## Caveats
- Tiers are uncalibrated model judgements. The tool rates five seeds R1 or R1/R2 (Chemistry 2.5-B, Calculus AB 2.1-B and 2.7-B, BC 2.6-B and 2.10-B); they are kept because each topic's other seed and variants are R2/R3 but they are the weakest items in the batch.
- Biology: the author flagged 2.8-A (coupled transport) as possibly beyond CED wording, 2.7-B-v2 (interpolated isotonic point), and 2.9-B / 2.10-B as closer to R2.
- No subject-expert read, no model audit of rationales; Executed with the owner's go-ahead.
