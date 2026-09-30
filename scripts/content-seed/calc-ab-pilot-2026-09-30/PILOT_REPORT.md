# Seeded-variant pilot: do the Unit 1 findings hold? (2026-09-30)

**Design.** 8 published AP Calc AB MCQs as class-A seeds (one per unit; Unit 8's seed is provisional-labeled, Unit 7's is the only one available),
2 variants each = **16 variants**. Author: Claude Sonnet 5.5 (this session). Checkers (Product Owner's pick): **Gemini 3.8 Flash + DeepSeek V4 Pro**.
Checks: sympy recompute of every key and every distractor value; blind solve + rationale audit by both models (on 16 variants **and** the 8 seeds);
two-family CED check (16 variants); blind label probe with Gemini 3.8 Flash, 2 samples (16 variants + 8 seeds). Nothing loaded to any database.
Files: `pilot.py`, `all_math_items.json`, `out_math/`, `out_ced/`, `out_labels/`, `analyze.py`, recheck folders.

## Verdict per Unit 1 finding

| Unit 1 finding | Pilot | Holds? |
|---|---|---|
| No wrong keys (0 of 136) | 0 of 48 blind solves disagreed with the key (24 items x 2 models) | **Yes** |
| Defects are in explanatory text, not keys | Yes. Sympy failed 4 of 48 hand-typed distractor numbers at first draft (2 of 16 variants); the 2-model audit + CED then found 1 more variant item with 2 real text/design defects | **Yes** |
| A deterministic check cannot see prose errors | 038-v2 passed sympy while its rationale described the wrong algebra ("3x+18>0" for a choice that needs "<0") | **Yes** |
| Real-defect rate about 15% of items after the first pass (20 of 136) | 1 of 16 variants (6%), n too small to say it is lower | **Consistent, not resolved** |
| Both checkers needed: different models catch different things | 038-v2's second defect (a distractor "0<x<6" that is itself true, since it lies inside the correct "x<6") was raised by DeepSeek only; Gemini passed it | **Yes** |
| Patching creates new defects; re-check the whole item | My fix here (replacing that distractor) was re-verified by sympy, both solvers, both auditors and both CED checkers: clean. No regression this time (1 patch) | **Untested at scale** |
| Stale checker models cause failures | 0 structured-output failures in 32 CED calls and 96 math calls (Unit 1's older Gemini failed 11 items) | **Yes** |
| Solver noise: weaker models produce false flags | This pair produced 0 false solve disagreements; audit flags were mostly real (below) | **Better with these two models** |
| Label inheritance: units/difficulty stable, topic mostly, skill weakest | Variant vs seed: same unit set 16/16, topic 32/32 samples, skill 28/32 (88%), difficulty 31/32 (97%). Unit 1: 97 / 90 / 85 / 83% | **Yes, slightly higher; one model x 2 samples vs three models, so not identical method** |
| Seed defects propagate | See new finding | **Extended** |

## New finding: the seeds were worse than the variants
The same audit run on the 8 published seeds flagged **6 of 8** for distractor rationales that do not produce the shown value
(both models agreed on 5 of the 6). Independently verified: `mcq-026` D ("polynomial only" gives 2e, not e), `mcq-031` A and B (-5.34 not reproducible; the
"position" distractor is -2.04 m, not -3.81), `mcq-np2-006` B ("linear" result is quadratic), `mcq-038` (vague/misdescribed B, C), `mcq-016` B (borderline).
All 8 keys are correct. Separately, `mcq-037` is keyed A in `canonical_answer_1` but B is flagged correct (B is right). Both filed as tasks.
Caveat: I wrote the variants knowing the audit criteria, so the gap partly reflects that. It still means the "fix the original first" rule (Phase 5b) has real teeth.

## Cost, time (measured this time; Unit 1's scripts did not log usage)

| Step | Items | Cost | Wall clock |
|---|---:|---:|---:|
| Math check (2 models, solve + audit) | 24 | $0.325 (Gemini $0.128, DeepSeek $0.197) | 9.0 min (DeepSeek median 8.3 s/call, Gemini 4.6 s) |
| CED check (2 models, fact pack in every prompt) | 16 | $0.548 (Gemini $0.294, DeepSeek $0.254) | 4.2 min |
| Label probe (Gemini, 2 samples) | 24 | $0.154 | 1.0 min |
| Re-check of the patched item | 1 | under $0.05 | about 1 min |
| **Total checking** | | **about $1.03** | ~15 min |

Per item: math $0.014, CED $0.034, labels $0.006, about **$0.054 per item** all-in (about $0.064 per variant once the seed checks are spread over 16).
CED is 53% of checking cost because the whole fact pack (about 10.7k tokens) is sent on every call; trimming or caching it is the obvious saving (untested).
Author time and tokens were not metered here or in Unit 1, so the true cost of generation is unknown and probably larger than checking.
Unit 1 cost cannot be compared: it was not logged. The same per-item rate would put a 136-item run at roughly $7-8 of checking.

## Limits
16 variants, MCQ only, one author session, one round of checks, single-model labeling. Enough to say the qualitative findings reproduce; not enough to compare defect
rates (6% vs 15% is one item). Seeds were not chosen at random: one per unit, preferring validated and simple.

## Recommendations for the protocols
1. Add "audit the seed before varying it" as an explicit Phase 5b gate (the seeds carried more defects than the variants).
2. Keep two checkers per stage; the one-model-only catches prove it.
3. Log token usage and cost in every checker script (done in this pilot; committed with it).
4. Send a trimmed/cached fact pack to the CED check to cut its cost.
