# AP Biology Units 1-2: S0a seed audit (2026-10-01)

Protocol step S0a of `docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md`. 8 published class-A MCQ seeds (see `README.md`), blind solve + rationale audit by
`google/gemini-3.5-flash` and `deepseek/deepseek-v4-pro`, run by the Product Owner on 2026-10-01 with `apbio_seeded_math_check.mjs`. Raw: `out_seed_audit/results.jsonl`.
Smoke test (`out_smoke/`, 1 item): 4 calls, no errors. Full run: **32 of 32 calls succeeded, all structured output (no plain-JSON fallback)**.

## Result
| | Biology (this run) | Calc AB pilot (comparison) |
|---|---|---|
| Blind-solve disagreements with the stored key | **0 of 16** | 0 of 48 |
| Auditor says keyed choice is not the correct answer | **0 of 16** | n/a |
| Rationale judgements flagged | **2 of 64** (both on one choice) | 5 of 8 seeds had at least one flagged rationale |
| Seeds with a flagged rationale | **1 of 8** (`APBIO-MCQ-023`, choice A, both models) | 5 of 8 |

Cost and time: **$0.247** total (Gemini $0.147, DeepSeek $0.100; list prices, token usage from the run), median 15.9 s (Gemini) and 12.7 s (DeepSeek) per call.
DeepSeek used 46.5k output tokens against Gemini's 14.6k (more reasoning text), yet cost less.

## The one defect (verified by hand, not by vote)
`APBIO-MCQ-023` choice A ("An integral transmembrane protein with its primary domain on the extracellular face"). Its rationale ends: "not being labeled by impermeant
biotin does not distinguish extracellular vs. cytoplasmic facing for a transmembrane protein." That is false for this stem: impermeant biotin-NHS labels
extracellular-facing domains, so an integral protein with its main domain on the extracellular face would be labeled; the observed absence of labeling is evidence
against that location. The first sentence (integral proteins need detergent, high salt will not release them) is correct, and is the stronger reason choice A fails.
The key (D, peripheral protein on the cytoplasmic face) is right.

## Seeds I also re-read and found no defect in
`005, 008, 014, 016, 018, 021, 022`. Before the run I suspected `018` C and `022` A; re-derived, both rationales are accurate (018 C: LDL-derived cholesterol feeds back on HMG-CoA reductase, so blocking uptake raises synthesis; 022 A: the double-membrane evidence is the only item specific to engulfment).
This is a read by the author model, which the protocol does not count as a check; it only means my own review found nothing the two checkers missed.

## Reading the comparison honestly
Biology seeds came out far cleaner than Calc seeds. Three differences could explain it, and this run cannot separate them: (1) Biology seeds went through a different authoring and review path than the Calc seeds;
(2) the auditor prompt for a conceptual subject may be less strict about "the rationale misdescribes the error that produces the choice", since Biology distractors are statements, not values that can be recomputed;
(3) there is no deterministic check here (no sympy equivalent), so a plausible-sounding false rationale is harder for either model to catch. Treat "1 of 8" as a lower bound.
Gemini 3.5 Flash vs the Calc pilot's 3.8 Flash is a further difference.

## Decision for the next step
- Seeds `005, 008, 014, 016, 018, 021, 022`: clean, usable as seeds now.
- Seed `023`: repair choice A's rationale first (owner-remediation path, new version, Product Owner approval), then vary it. Do not write 023's variants from the current text.
