# Unit 1 re-leveling status (2026-11-12)

**Scope:** Unit 1 for every subject except Physics 2, Physics C: Mechanics and Physics C: E&M (on hold), including AP Statistics Unit 1 (Statistics Units 2 to 4 were done earlier). Plan: `QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`; Units 2 to 4: `UNIT2_RELEVELING_STATUS_2026_11_12.md`, `UNIT3_RELEVELING_STATUS_2026_11_12.md`, `UNIT4_BUILDOUT_STATUS_2026_11_12.md`.

## Audit of what was published (read-only, `scripts/difficulty-audit/`)
Published practice MCQs in Unit 1 before this batch: Biology 96, Calculus AB 136, Calculus BC 127, Chemistry 51, Physics 1 36, Precalculus 108, Statistics 298. Same pattern as Units 2 to 4: almost no R3, with R1-heavy topics (Statistics 1.2 is 21 of 21 R1, 1.7 is 40 of 53, 1.11 is 26 of 28; Chemistry 1.1 is 9 of 11; Physics 1.1, 1.2 and 1.4 are 62 to 100 percent; Precalculus 1.1 and 1.6 are 75 to 78 percent; Calculus 1.1, 1.9 and 1.16 have one to three items each).

## Executed 2026-11-12 (APPROVAL-0243 to 0253); hash checks 100% and the selector serves the new items in every topic
Two new seeds per topic with three variants each (8 new practice MCQs per topic). Retirements are whole families whose seed the tool rated R1 (teaching items excluded).
| Subject | Topics | Package folder (`scripts/content-seed/`) | New | Retire |
|---|---|---|---|---|
| AP Biology | 1.1-1.7 | `apbio-harder-seeds-u1-2026-11-12` | 56 | 26 |
| AP Calculus AB | 1.1-1.8 | `apcalcab-harder-seeds-u1a-2026-11-12` | 64 | 5 |
| AP Calculus AB | 1.9-1.16 | `apcalcab-harder-seeds-u1b-2026-11-12` | 64 | 7 |
| AP Calculus BC | 1.1-1.8 | `apcalcbc-harder-seeds-u1a-2026-11-12` | 64 | 6 |
| AP Calculus BC | 1.9-1.16 | `apcalcbc-harder-seeds-u1b-2026-11-12` | 64 | 8 |
| AP Chemistry | 1.1-1.8 | `apchem-harder-seeds-u1-2026-11-12` | 64 | 12 |
| AP Physics 1 | 1.1-1.5 | `apphysics1-harder-seeds-u1-2026-11-12` | 40 | 12 |
| AP Precalculus | 1.1-1.7 | `apprecalc-harder-seeds-u1a-2026-11-12` | 56 | 36 |
| AP Precalculus | 1.8-1.14 | `apprecalc-harder-seeds-u1b-2026-11-12` | 56 | 5 |
| AP Statistics | 1.1-1.7 | `apstats-harder-seeds-u1a-2026-11-12` | 56 | 69 |
| AP Statistics | 1.8-1.13 | `apstats-harder-seeds-u1b-2026-11-12` | 48 | 94 |
| **Total** | | | **632** | **280** |

## Checks run
- Format validator OK on every draft; packages built unit-aware (required_units [1]); same pipeline as Unit 2.
- Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`: DeepSeek disagreed with the key on 1 of 632 items (Chemistry 1.8-A-v1, its own working matched the key); Kimi on 8 (Precalculus 1.1-A-v3, 1.3-A-v2, 1.4-A-v3, 1.7-A-v1, 1.9-B-v1 and 1.11-A; Calculus AB 1.10-B-v3 and 1.13-B-v2). Every one, and every key the tool disputed, was re-derived by hand: the keys are correct.
- One real defect found and fixed before packaging: Calculus AB 1.16-A-v1 to v3 offered nested "at least n zeros" choices where two were true; the stems now ask for the strongest guaranteed statement and the package was rebuilt and re-solved (64 of 64 agree with both models).

## Caveats and decisions for the owner
- **Statistics retirements are large (163).** Statistics Unit 1 had hundreds of single-item R1 families; retiring every R1 seed family leaves 8 new items per topic (the standard minimum) where there were 21 to 53. The retire lists are in each package's `retire_keys.json`; they can be trimmed before executing.
- Tiers are uncalibrated model judgements; a few seeds (for example Precalculus 1.4-A, 1.7-A, Statistics 1.7-A, Chemistry 1.5-A) are R2.
- No subject-expert read, no model audit of rationales.

## Execution notes
- Totals executed: 632 new, 166 retired (Statistics retire lists were 163 in the table above and are now 49: the older Statistics pilot pack `7c5a2975` has no serving labels so its items were never served, and topics with old served items were kept at 12 or more published).
- Per-package retire counts in the table above for Statistics (69 and 94) are superseded by 25 (1.1-1.7) and 24 (1.8-1.13).
- Topics still below 12 published: Statistics 1.1-1.5 and 1.9 (9), Physics 1 1.4 (8), Chemistry 1.1 and 1.8 (11), the remainder of Calculus/Precalculus/Biology are at 16 or more where old items remain, otherwise 8.
- Models disagreed on answer keys rarely (about 1% or less); on difficulty tier about 29% of the time, mostly R2 versus R3.
