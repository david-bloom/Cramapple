# AP Statistics Unit 5 FRQs: cost-measured authoring run (2026-11-12)

**Status:** 5 seeds + 5 variants authored and accepted by the checks. **Nothing published; no Production, Development or database write.**
**Scope note:** the request said "Units 5 and 6". AP Statistics has five units in the registry (`20260821090000_ap_statistics_taxonomy_topics_seed.sql`) and in the approved 2027 CED fact pack (old Unit 9 slope inference removed, fact pack section 8). There is no Unit 6, so this is Unit 5 (Regression Analysis, topics 5.1-5.5) only, as confirmed by the parent session. No substitute unit was chosen.

## Files
| File | What |
|---|---|
| `rubric_patterns.json` | The rubric pattern library: 25 criterion patterns (text/evidence/fix templates + slots), each tied to CED essential knowledge. |
| `build_items.py` | One template function per topic; a seed and its variant are the same function called with two `cfg` dicts, so rubric shape is identical by construction. Writes `authored/*.json` and `pattern_use.json`. |
| `authored/seeds.json`, `authored/variants.json` | The 10 load-ready items (pipeline item schema: title, calculator, stimulus, parts/criteria, model_answer, verification_python). |
| `slots/`, `variants/` | Raw check results (candidates, probe votes, both checkers, flags, arbitration). |
| `answer_grades.json` | Model answers graded criterion-by-criterion by a third family (gemini-3.8-flash): 10/10 full credit. |
| `cost/ledger.csv`, `cost/cost_summary.json`, `cost/gateway_balance.jsonl`, `cost/*calls.jsonl` | Every paid call with model, tokens, USD; summary; balance snapshots. `cost_ledger.py` rebuilds them. |
| `../../vercel-gateway-check/frq_pipeline/variant_check.mjs` | New diff-style variant check. |

## Method
- **Author:** Claude in session; no gateway model authors. Items are filled from the pattern library.
- **Seed (full check, `frq_pipeline.mjs run --no-author --max-unit=5`):** lint, exact recompute, six-vote topic probe (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol x2), then GPT-6.1 Sol + DeepSeek V4 Pro solve blind, audit and re-derive the rubric; a flag counts only if it repeats on one re-sample. Pair unchanged from the 2026-10-09 run; both models still on the gateway roster.
- **Variant (diff check, `variant_check.mjs`):** parent must be an accepted seed. Deterministic gate: lint, recompute, **identical ordered pattern ids** to the parent, structural diff. Then both checker families get the parent, the variant and the diff and answer only: what changed, do the changed numbers recompute, does each criterion still hold, do the parent's conditions still hold, distinct, topic unchanged, new issues only. No blind solve, no topic vote (inherits parent), no fact pack. Same re-sample rule.
- **Tool validation:** the diff check was run on 3 planted-defect variants (prompt value changed but rubric not; a table value changed so the claim becomes false; fitted range changed so extrapolation becomes interpolation): 3/3 caught by both checkers (`cost/variant_controls_results/`). The seed-side planted-defect controls (8/8, `frq-u13-gap-fill-2026-10-09/controls_result.json`) were not re-run because they plant defects with a paid Opus call; the rules and checker pair are unchanged apart from one lint change below.

## Results (recounted from `slots/` and `variants/`)
- Seeds accepted: **5/5** (5.1-5.5), one candidate each. Variants accepted: **5/5**, first pass. Criteria per item: 6, 6, 5, 6, 5 (seed and variant identical per topic).
- Checker difficulty ratings on seeds: Easy x4, Medium x1 (5.2). **These are easy by checker rating**: see open items.
- Two seeds were flagged on first pass and are the only rework:
  - **5.1:** GPT-6.1 Sol (repeated on resample): `EXPL_RESP` evidence accepted naming roles without the axes. Real defect; fixed once in the pattern library (applies to the 5.1 variant too) and the item re-ran every gate.
  - **5.5:** topic vote 5.3 x4, 5.5 x2. Ruled by CED text (every criterion is a 5.5 learning objective; extrapolation appears only as the reason inside 5.5.B.3): topic ruling recorded in the slot's `arbitration`, per the 2026-10-10 precedent. Both checkers then passed it with no flags.
- Lint change: `rubric.mjs` read the bare noun "plot" in "residual plot" as an instruction to draw; the rule now needs a verb-like "plot the/a/...". Pilot-on-real-items lesson repeated.

## Cost (USD; see `cost/cost_summary.json`)
**Gateway, measured at token level** (usage the gateway returned per call x gateway list prices; 102 calls):

| | Per item (checks + answer grade) | Items | Total |
|---|---|---|---|
| Seed, average | **$0.1465** | 5 | $0.7325 |
| Variant, average | **$0.0279** | 5 | $0.1395 |
| Variant-check planted-defect control (tool validation, not per item) | | | $0.2071 |
| **Gateway total** | | | **$1.0791** |

Per seed: 5.1 $0.2855 (two runs), 5.2 $0.1518, 5.3 $0.0774, 5.4 $0.0977, 5.5 $0.1200 (two runs). Per variant: 5.1 $0.0342, 5.2 $0.0281, 5.3 $0.0214, 5.4 $0.0325, 5.5 $0.0232. A clean first-pass seed (5.2-5.4) averages $0.1090.
Seed stage split: audit $0.4999, probe $0.1109, solve $0.1021, answer grade $0.0196. Variant: diff check $0.1204, answer grade $0.0191.

**Cross-check:** gateway balance fell $29.5309 to $28.7144 ($0.8165) over the run, below the $1.0791 computed total. The balance lags and other sessions use the same key (it kept falling after my last call), so it is not an attribution source; it suggests list-price x tokens is conservative (cached-read discounts). Both are recorded; the token-level figure is the one used.

**In-session Claude authoring: ESTIMATED, not measured** (Max plan: no per-token bill; list-price equivalents, Sonnet 5.5 $2/$10 per M):
- Marginal output tokens (authored characters / 3.5): **seed about $0.0102, variant about $0.0022** (a variant is only a `cfg` dict, about 780 characters; a seed adds its template function).
- One-time infrastructure (pattern library, builder helpers, `variant_check.mjs`, installer, ledger): about 12k output tokens, **$0.1225**, $0.0122 per item over these 10 items; reusable.
- Whole session including protocol reading, debugging and this report: **about $2.70** (cache writes $0.71, cache reads $1.54, output $0.45), plus or minus 40 percent. Not attributable per item.

**Per item all-in (gateway measured + marginal authoring estimate):** seed about **$0.157**, variant about **$0.030**. Grand total: measured gateway **$1.08** + estimated authoring **$0.12 marginal/infrastructure to $2.70 whole-session**.

## Variants versus new seeds
A variant costs about **19 percent** of a seed ($0.030 vs $0.157 all-in; gateway only $0.0279 vs $0.1465), about 5 times cheaper, and takes the author about a fifth of the output. It needs no new rubric: pattern order is enforced equal to the parent's before any model is called. Caveats: variant checking relies on the parent having passed the full check; it skips the blind solve and topic vote by design (planted-defect control 3/3 caught); a variant only multiplies a seed's coverage, it does not add a new angle on the topic (distinctness is context and numbers, not scenario type). The seeds here were cheaper than the 2026-10-10 estimate of about $0.20 per FRQ because Unit 5 prompts are short; clean seeds cost $0.077-$0.152.

## Not done / needs approval
- **Publication:** a new Hard-Gate APPROVAL (numbered after checking open PRs and the log at that time; none was numbered here) and the 2026-10-10 publish path (`frq-u13-gap-fill-2026-10-09/publish_frq_batch.py`, one rehearsed transaction, verify) plus a six-vote topic label. No Dev rehearsal was run (the Units 1-3 Dev load was a separate owner choice).
- **Distinctness against published Unit 5 FRQs was not checked:** the run avoided Production reads, so `existing` is empty. Before publishing, compare against any published 5.x FRQ (for example `APSTAT-MOD5-H001-INV` is topic-labelled 5.2) and run the planted-defect seed controls once.
- **Difficulty:** four of five seeds rated Easy. Given the Unit 2-4 MCQ difficulty work, consider harder seeds before publishing; a second authoring pass would reuse the library at the variant-level marginal cost.
- **Unit 6:** does not exist; if David wants a stand-in unit, `build_items.py` needs new template functions and patterns for it (Unit 5 patterns do not transfer).
