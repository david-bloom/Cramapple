# Unit 3 re-leveling status (2026-11-12)

**Scope (owner direction 2026-11-11):** audit and re-level all Unit 3 topics for every subject except Physics 2, Physics C: Mechanics and Physics C: E&M (on hold). Plan: `QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`.

## Done and live (Production)
- AP Statistics Unit 3 (APPROVAL-0215), Chemistry, Calculus AB and Precalculus topics 3.1 to 3.3 (APPROVAL-0218, 0219, 0220).

## Prepared, NOT executed (this batch)
| Subject | Topics | Package folder (`scripts/content-seed/`) | New MCQs | Retire |
|---|---|---|---|---|
| AP Physics 1 | 3.1-3.5 | `apphysics1-harder-seeds-u3b-2026-11-12` | 40 | 42 |
| AP Biology | 3.1-3.5 | `apbio-harder-seeds-u3-2026-11-12` | 40 | 11 |
| AP Precalculus | 3.4-3.9 | `apprecalc-harder-seeds-u3b-2026-11-12` | 48 | 24 |
| AP Precalculus | 3.10-3.15 | `apprecalc-harder-seeds-u3c-2026-11-12` | 48 | 26 |
| AP Chemistry | 3.4-3.13 | `apchem-harder-seeds-u3b-2026-11-12` | 80 | 41 |
| AP Calculus AB | 3.4-3.6 | `apcalcab-harder-seeds-u3b-2026-11-12` | 24 | 4 |
| AP Calculus BC | 3.1-3.6 | `apcalcbc-harder-seeds-u3-2026-11-12` | 48 | 46 |
| **Total** | | | **328** | **194** |

Each package: items.json, load chunks, verify_hashes.sql, publish and retire SQL with rehearsals, `superseded_keys.json`. All new items were blind-solved by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro` (agreement: Physics 1, Biology, Precalculus 3.10-3.15, Chemistry*, Calculus AB and BC 100%; Precalculus 3.4-3.9 and Chemistry had one and two model misses, each re-checked by hand and the key confirmed). The difficulty tool (`scripts/difficulty-audit/`) rates every batch mostly R2/R3.
Authoring was done in session by subagents against a strict format and a validator (`scripts/content-seed/_tools/validate_draft.py`); no checker pass on rationales, no subject-expert read.

## Known caveats
- Teaching items cannot be retired, so a few families are retired only partly (orphan teaching variants stay).
- Some seeds are strong R2 rather than R3 (Calculus procedural topics, Precalculus 3.4); the tool takes the lower of two model tiers and disagrees often, so tiers are triage only.
- Precalculus 3.4-A and its variants are a deliberate systematic coverage set that the tool flags as duplicates of the seed.
- A few items go slightly past core AP wording (Biology N-3.4-B, N-3.5-A-v1, Physics 1 N-3.4-B-v3 and N-3.5-B-v3, Calculus BC N-3.3-B).
- Statistics Unit 3 topics 3.7, 3.12, 3.14 still have an R1-leaning family each; not yet re-leveled.
