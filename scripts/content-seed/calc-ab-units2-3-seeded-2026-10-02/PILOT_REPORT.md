# AP Calc AB Units 2-3 seeded-variant pilot (2026-10-02)

**Author:** Claude Sonnet 5.5. **Checkers (Product Owner's pick):** Gemini 3.8 Flash + DeepSeek V4 Pro; labels also GPT-6.1 Sol (as on 9/30).
**Scope (confirmed 2026-10-02, `APPROVAL-0082` (originally numbered 0069)):** Units 2-3, 3 variants per seed. **Nothing loaded to any database.** Loading and publishing need their own approval.
**Seeds (class A, all audited first, S0a):** Unit 2: `006`, `025`, `026`, `027`, `028`. Unit 3: `005`, `007`, `008`, `029`, `030`. 10 seeds x 3 = **30 variants**.
**Skipped:** `u1n-001` and `u1n-002` (Unit 2) already have 3 variants each from the Unit 1 batch (`u1v-001-v1..3`, `u1v-002-v1..3`), so the plan's 12 seeds became 10.
**Keys:** `apcalcab-mcq-sv-<seed>-vK`, with K = 3-5 for the six seeds that already have published `sv-<seed>-v1/v2` (005, 007, 008, 026, 029, 030), else 1-3. Those six families now have up to 5 siblings.

## Results by stage
| Stage | Result |
|---|---|
| S0a seed audit (12 seeds, 2 models) | 24 of 24 solves match the stored key. 1 real flag: `026` choice C ("confuses evaluation at 1 with squaring e" does not produce e^2). Many seeds have one-line rationales that pass but explain little (`006`, `025`, `027`, `028`, `029`). |
| Sympy (every key and every distractor, written from the stated error) | 30 of 30 pass. Max similarity to a seed 0.56 (limit 0.7); no variant near an existing sibling. |
| Blind solve, 2 models | **60 of 60 match the key.** |
| Rationale audit, first pass | **5 of 30 variants (17%) had a real defect**, all hand-verified, all in my own explanatory wording, none in a key (below). |
| After patching the 5 and re-checking them in full | 10 of 10 solves match, 0 audit flags. |
| CED scope, 2 models, fact pack in every prompt | **60 of 60 `fully_in_scope`**, no consistency issues. |
| Label probe, 3 models x 2 samples, 30 variants + 10 seeds | See "Labels". |

### The five defects (all fixed in the unloaded drafts, then re-checked)
| Item | Defect | Caught by |
|---|---|---|
| `006-v3` choice | Said (2, 2) is "swapping the coordinates of (2, 1/2)"; a swap gives (1/2, 2) | both models |
| `025-v1` choice | Said the quotient "grows without bound"; it is +infinity from the right and -infinity from the left | **DeepSeek only** |
| `025-v3` choice | Same imprecision | **DeepSeek only** |
| `005-v4` choice | Rationale said the error used -cos(3x); the choice -3x^2 cos(3x) comes from -3cos(3x) | both models |
| `028-v3` choice | Called the one-sided derivatives "2 and 1"; those are the pieces' slopes, not one-sided derivatives of a function with a jump | **DeepSeek only** |

Three of five real defects were raised by DeepSeek alone; Gemini raised none that DeepSeek missed. Same pattern as the Calc and Bio pilots: keep both, verify every flag by hand. The patch regressed nothing this time (patches are small and re-checked).

## Labels (3 models x 2 samples; a dimension inherits only when variant and seed pluralities match with >= 4 of 6 support)
| Dimension | Inherited | Note |
|---|---|---|
| Max required unit (the serving gate) | **30 of 30** | |
| Required-unit set | 29 of 30 | `025-v1` split 3/6 ([1,2] vs [2]) |
| Topic | 22 of 30 | Held on the 005 family (seed itself split 3.5/3.1), the 006 family (variants change the function type: seed 2.7, variants 2.5/2.8), `025-v3`, `027-v3` |
| Skill | 26 of 30 | provisional only |
| Difficulty | 25 of 30 | held on the 029 family (seed Easy 4/6, variants Medium) and `007-v5`, `028-v2` |

**Two things for the Product Owner:**
1. **Seed `028` has a unit disagreement with its own database label.** Production says required units [2, 5] (max unit 5). All three blind models, on both the seed and its three variants, say [1, 2]. Unit 5 is not needed to answer "differentiable implies continuous". Not changed.
2. **`025-v1` units are held.** If loaded as served items it should carry [2] after a decision, or stay held.

## What I did right and wrong
- Read the fact pack for Units 1-3 before authoring (the Bio pilot's lesson): no boxed exclusions; wrote distractors from its documented misconceptions (product-rule shortcuts, dropped chain factors, sign errors, implicit-differentiation errors).
- All five defects came from prose I wrote after the arithmetic was verified. Sympy checks values; it cannot check a sentence like "grows without bound". Same finding as 9/30.
- My first draft set failed 4 similarity checks (too-short stems). Fixed before any model spend; nothing to do with the models.
- Word-level Jaccard on symbolic stems is weak: a bare `d/dx[...]` item is mostly shared tokens. The stems for `005-v3`, `006`, `028-v2`, `008-v4` had to carry context words to clear 0.7. It measures wording, not mathematical novelty.

## Spend (tokens, from the scripts' usage logs)
CED dominates: 1.26M input tokens (the fact pack is in every call), about 90% of input. Math check 1st pass 169k in / 149k out (both models), labels 453k in / 249k out (3 models, 40 items x 2 samples), S0a 27k in / 48k out. At the 9/30 rates this batch is roughly $2-3 in total (estimate, not read from the gateway bill).

## Open
1. Load and publish the 30 variants: needs approval; build on the 9/30 `publish_step.sql` pattern with `label_inheritance.json` (held dimensions stay held). Do **not** re-run `units23.py export` (it re-randomizes letters; `math_items.json` sha256 prefix `d9f8dde6b0bd` before patch, patched in place with `patch_round1.py`).
2. ~~Seed repair for `026` choice C; seed `028` unit set~~ DONE 2026-10-02 (`APPROVAL-0083` (originally numbered 0071), `seed_fixes_apply.sql`): C is now `2e`; 028 is [1,2], validated.
3. `025-v1` units still held.
4. `frq-u13-003` (max unit split Unit 2 vs Unit 4) still held.
5. No `family_id` in the schema: six families now have 5 siblings each. Serving can put several in one session.
6. Gateway roster has `deepseek/deepseek-v4-pro-0813` and `deepseek/deepseek-v4.1-flash`; kept `deepseek-v4-pro` (the model with measured behaviour here). A re-calibration would be needed before swapping.
