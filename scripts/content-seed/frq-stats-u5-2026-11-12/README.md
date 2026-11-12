# AP Statistics Units 5 and 4 FRQs: cost-measured authoring run (2026-11-12)

> **ROUND 2 (difficulty rewrite) is at the end of this file and supersedes round 1 (r1) for the nine topics it covers.** Feedback on r1: anything the checkers rated Easy is too easy for AP level. r2 adds a difficulty target to the pipeline and rewrites the Easy seeds and their variants. Files: `r2/`.

**Status:** 15 seeds + 15 variants authored and accepted by the checks (Unit 5: 5+5; Unit 4: 10+10). **Nothing published; no Production, Development or database write.**
**Scope note:** the request said "Units 5 and 6". AP Statistics has five units in the registry (`20260821090000_ap_statistics_taxonomy_topics_seed.sql`) and in the approved 2027 CED fact pack (old Unit 9 slope inference removed; fact pack section 8), so there is no Unit 6. **David confirmed Unit 4 (Inference for Quantitative Data: Means, topics 4.1-4.10) as the stand-in for Unit 6.** It is labelled "Unit 4 (stand-in)" below.

## Files
| File | What |
|---|---|
| `rubric_patterns.json` | Rubric pattern library: 49 criterion patterns (text/evidence/fix templates + slots), each tied to CED essential knowledge (25 for Unit 5, 24 added for Unit 4). |
| `build_items.py`, `build_items_u4.py` | One template function per topic; a seed and its variant are the same function called with two `cfg` dicts, so rubric shape is identical by construction. Write `authored/*.json` and `pattern_use*.json`. |
| `authored/seeds.json`, `variants.json` (Unit 5); `seeds_u4.json`, `variants_u4.json` (Unit 4) | The 30 load-ready items (pipeline item schema). |
| `slots/`, `variants/` | Raw check results (candidates, probe votes, both checkers, flags). `history_before_patch` keeps flagged rounds. |
| `arbitration_u4.md` | Every Unit 4 flag and ruling (all accepted as real; none rejected). |
| `answer_grades.json`, `answer_grades_u4.json` | Model answers graded criterion by criterion by a third family (gemini-3.8-flash): 10/10 and 20/20 full credit. |
| `cost/ledger.csv`, `cost/cost_summary.json`, `cost/gateway_balance.jsonl`, `cost/*calls*.jsonl` | Every paid call with model, tokens, USD; per unit and item; balance snapshots. `cost_ledger.py` rebuilds them. |
| `../../vercel-gateway-check/frq_pipeline/variant_check.mjs` | New diff-style variant check. |

## Method
- **Author:** Claude in session; no gateway model authors. Items are filled from the pattern library.
- **Seed (full check, `frq_pipeline.mjs run --no-author`):** lint, exact recompute, six-vote topic probe, then GPT-6.1 Sol + DeepSeek V4 Pro solve blind, audit and re-derive the rubric; a flag counts only if it repeats on one re-sample. Pair unchanged from 2026-10-09; both still on the gateway roster. Arbitration: Claude rules on every flag; a changed item is a new draft through every gate.
- **Variant (diff check, `variant_check.mjs`):** the parent must be an accepted seed. Deterministic gate: lint, recompute, **identical ordered pattern ids** to the parent, structural diff. Both checker families then get parent, variant and diff and answer only: what changed, do changed numbers recompute, does each criterion still hold, do the parent's conditions still hold, distinct, topic unchanged, new issues. No blind solve, no topic vote (inherits parent), no fact pack. Same re-sample rule.
- **Tool validation:** the diff check caught 3/3 planted defects on Unit 5 variants; it then caught three real defects in Unit 4 variants (below).
- **Lint change:** `rubric.mjs` no longer reads the noun "plot" in "residual plot" as an instruction to draw.

## Results (recounted from `slots/` and `variants/`)
| | Seeds accepted | Variants accepted | Seed difficulty (checker majority) | Criteria per item |
|---|---|---|---|---|
| Unit 5 | 5/5 | 5/5 | Easy 4, Medium 1 | 6,6,5,6,5 (variant identical) |
| Unit 4 (stand-in) | 10/10 | 10/10 | Easy 6, Medium 4 | 4,5,6,4,6,4,4,6,4,6 (variant identical) |

- **Unit 5:** two first-pass flags (5.1 axis evidence, a real defect; 5.5 topic vote overruled by CED text). One rework run each.
- **Unit 4:** all ten seeds were flagged on the first run. Every flag was a real library-level defect, fixed in the pattern library and re-run: criteria that prescribed a z-score, required a reason for an Identify task, bundled randomization with the 10% condition, defined the population wider than the sample frame, used a later topic's interpretation (4.2 part c, 4.7 part c), misstated the p-value region, bundled df with the test statistic, and said "p < alpha" at the boundary. Ten seeds took three full-check runs (4.1, 4.5, 4.7, 4.9, 4.10) or two (the other five). **This is two patch loops, not one:** a deviation from the one-loop checker policy, taken because every remaining flag was valid and cheap to fix; every ruling is in `arbitration_u4.md`.
- **Unit 4 variants:** 7/10 accepted first pass; 4.4, 4.6 and 4.8 were flagged by both checkers for real defects the context change introduced (population wider than the sample frame; "exceeds by less than 2" versus a rubric that computed the whole lower tail, probability 0.0355 vs 0.0369; causal wording in an observational comparison). Fixed, re-run, accepted.

## Cost (USD; `cost/cost_summary.json`)
**Gateway, measured at token level** (usage the gateway returned per call x gateway list prices; 450 calls). Per-item numbers include every re-run and the third-family answer grade.

| | Seeds | Avg per seed | Variants | Avg per variant | Unit total |
|---|---|---|---|---|---|
| Unit 5 | 5: $0.7325 | **$0.1465** | 5: $0.1395 | **$0.0279** | $0.8721 |
| Unit 4 (stand-in) | 10: $4.0540 | **$0.4054** | 10: $0.6204 | **$0.0620** | $4.6744 |
| All | 15: $4.7866 | **$0.3191** | 15: $0.7599 | **$0.0507** | $5.5465 |

Plus **$0.2071** tool validation (planted-defect control of the variant check, not an item cost). **Gateway total $5.7535.**

Per item, seeds: 5.1 $0.2855, 5.2 $0.1518, 5.3 $0.0774, 5.4 $0.0977, 5.5 $0.1200; 4.1 $0.4778, 4.2 $0.4223, 4.3 $0.2540, 4.4 $0.2899, 4.5 $0.4917, 4.6 $0.2413, 4.7 $0.5832, 4.8 $0.2602, 4.9 $0.4849, 4.10 $0.5488.
Per item, variants: 5.1 $0.0342, 5.2 $0.0281, 5.3 $0.0214, 5.4 $0.0325, 5.5 $0.0232; 4.1 $0.0275, 4.2 $0.0376, 4.3 $0.0306, 4.4 $0.1216, 4.5 $0.0406, 4.6 $0.1119, 4.7 $0.0392, 4.8 $0.1185, 4.9 $0.0472, 4.10 $0.0458.
Stage split (all seeds): audit $3.2805, topic probe $0.7881, blind solve $0.6635, answer grade $0.0544. Variants: diff check $0.7061 (of which re-samples $0.0972), answer grade $0.0538.

**Why Unit 4 seeds cost 2.8 times Unit 5 seeds:** 25 full-check runs for 10 seeds (about **$0.162 per run**, versus about $0.13 for a Unit 5 run), because the Unit 4 prompt carries the Units 1-4 fact pack and topic list, and 15 of those runs were rework. A clean single-run Unit 4 seed would cost about $0.16; a first-pass variant about $0.04.

**Cross-check:** the gateway balance fell $29.5309 to $25.5717 ($3.9592) over the whole run, below the $5.7535 computed. The balance lags and other sessions use the same key (it kept falling after my last call in earlier checks), so it is not an attribution source; it suggests list price x tokens is conservative. Both are recorded; the token-level figure is the one used.

**In-session Claude authoring: ESTIMATED, not measured** (Max plan: no per-token bill; list-price equivalents, Sonnet 5.5 $2/$10 per M):
- Marginal output tokens (authored characters / 3.5): Unit 5 seed about $0.0102, variant about $0.0022; Unit 4 seed about $0.0087, variant about $0.0029.
- One-time infrastructure output: Unit 5 $0.1225 (library, helpers, variant check, ledger); Unit 4 $0.0484 (new patterns and helpers); about $0.0057 per item over 30 items.
- Whole-session slices including protocol reading, debugging, arbitration and reporting: Unit 5 about $2.70, Unit 4 about $1.66 (cache writes, cache reads and output priced from context growth, tool rounds and output size; plus or minus 40 percent). Not attributable per item.

**Per item all-in (gateway measured + marginal authoring estimate):** Unit 5 seed $0.157, variant $0.030; Unit 4 seed $0.414, variant $0.065; all 30: seed $0.328, variant $0.053.
**Grand total:** gateway **$5.75 measured** + authoring **$0.35 estimated (marginal + infrastructure) to $4.36 estimated (whole session)**, so about **$6.10 to $10.11**.

## Variants versus new seeds
A variant costs about **16 percent of a seed** all-in ($0.053 vs $0.328; gateway only $0.0507 vs $0.3191), about 6 times cheaper, and takes the author a few hundred characters of configuration instead of a new template. Unit 5: 19 percent; Unit 4: 16 percent. It needs no new rubric: pattern order is enforced equal to the parent's before any model is called. Cost scales with how long the seed's rework ran, not with the variant. Caveats: the diff check relies on the parent having passed the full check; it skips the blind solve and topic vote by design; it is not free of rework (3 of 10 Unit 4 variants needed a second pass, always for a real defect). A variant multiplies a seed's coverage; it does not add a new angle on the topic.

## Not done / needs approval
- **Publication:** a new Hard-Gate APPROVAL (to be numbered then, after checking open PRs and the log; none numbered here), the 2026-10-10 publish path (`frq-u13-gap-fill-2026-10-09/publish_frq_batch.py`, one rehearsed transaction, verify) and a six-vote topic label. No Dev rehearsal was run.
- **Distinctness against published FRQs was not checked** (no Production reads, so `existing` is empty). The 2026-10-25 batch published FRQs for Statistics Units 1-4 zero-FRQ topics; compare every item against any published 4.x/5.x FRQ before publishing.
- **Seed-side planted-defect controls were not re-run** (they plant defects with a paid Opus call); rules and checker pair are unchanged since the 8/8 run except the pattern-level fixes above.
- **Difficulty:** ten of fifteen seeds were rated Easy by the checkers. Given the Unit 2-4 MCQ difficulty work, consider harder seeds before publishing.
- **Unit 4 variants 4.7 and 4.9** were turned from experiments into independent random samples so the 10% condition applies; they test the same objectives but are observational contexts.


---

# Round 2 (r2): difficulty target and rewrite of the Easy items

**Trigger (David, 2026-11-12):** "whatever rated easy is too easy to qualify as AP level. Add the difficulty target and update the easy seeds and variants from r1 to r2."

## What changed in the pipeline
- **Difficulty scale in the audit prompt** (`rubric.mjs`, `DIFFICULTY_SCALE`): rated against the AP exam, not the topic. Easy = every part is one recall/identify/substitute/restate step with all inputs given; Medium = at least one part needs multi-step work, choosing or justifying a method, a condition check with a non-obvious outcome, or critiquing a statement; Hard = several of these or a subtle trap.
- **Gate** (`frq_pipeline.mjs --min-difficulty=Medium`): an item is rejected if **any** checker rates it Easy (stage `difficulty`). r1 had used the majority with ties rounded to Medium, which hid split ratings.
- **Variant check** (`variant_check.mjs`) now also asks `difficulty_vs_parent` and flags a variant that is easier than its parent (it did, for two of nine: 4.4 and 4.9).
- **Pattern library:** 61 patterns now (49 + 12 r2 patterns: critique of a student claim, impossible prediction, residual sign sequence, solve for x-bar, confidence-level and sample-size reasoning, p-value misconception, solve for n, conservative df). r1's library is kept as `cost/rubric_patterns_r1_snapshot.json`; r1 items are unchanged in `authored/`.

## Which items were rewritten
Easy by both checkers in r1: 5.1, 5.3, 5.4, 5.5 and 4.3, 4.4, 4.5, 4.6, 4.7, 4.9. How each was made harder (all still one point per criterion, at most six): 5.1 now a curved association (form, changing direction, strength of a non-linear pattern, critique of "weak because not a line", two claims checked against the data); 5.4 all seven residual signs and the pattern; 5.5 critique of an r-squared misreading and solving for the mean of x from the line; 4.3 confidence level versus a misreading about individuals, a sample-size change, two claims; 4.4 and 4.9 whether the sample-data condition is met (it is not), a sign-reversed difference, a critique of a two-sample test on paired data; 4.5 critique of a p-value statement and a second significance level; 4.6 direction of the difference and the sample size needed; 4.7 a t table with conservative df and why it is wider than technology's interval.

## Results (recounted from `r2/slots/`, `r2/variants/`)
| | r2 seeds | r2 variants | Both checkers Medium or better | Model answers full credit |
|---|---|---|---|---|
| Accepted | **9 of 10** | **9 of 9 attempted** | 9 and 9 | 18 of 18 |
| Held | 5.3 (ratings Medium + Easy after four tries; no rubric flags) | not attempted (parent not accepted) | | |

- First-run accepts: 4.3, 4.5, 4.6. The other six needed two to four full runs (25 full-check runs for the 10 seeds), mostly because one checker still rated the item Easy, plus real rubric flags (double-counted criteria, a criterion demanding more than the part asked, evidence saying a condition "is met" when it is not). Every flag was accepted and fixed; the 5.5 topic vote (5.3 vs 5.5) was overruled on CED text twice. All rulings: `r2/arbitration.md`.
- **Variant diff check:** 6 of 9 accepted first pass. 4.4 and 4.9 were flagged as easier than their parent (the seed's condition fails; the first variant's held), so the variants were rewritten to fail the same way; 4.9 also needed the population described the same way as the parent ("thousands", not an exact count). 4.6 needed one wording fix. This is the difficulty check doing its job.
- **Not yet through the new gate:** five r1 items that had a split rating (one Easy, one Medium) are unchanged and have **not** been re-rated: 5.2, 4.1, 4.2, 4.8, 4.10 (seeds and variants). Under the strict gate they would likely fail. 5.3 is the topic where the CED asks for one thing (calculate a prediction; classify extrapolation), so its ceiling is low; GPT-6.1 Sol rates it Medium, DeepSeek V4 Pro Easy.

## r2 cost (`r2/cost/`; 341 calls; token-level)
| | Items | Total | Average |
|---|---|---|---|
| Seeds (incl. held 5.3) | 10 | $3.8500 | **$0.3850** |
| Variants | 9 | $0.6231 | **$0.0692** |
| **r2 gateway total** | | **$4.4731** | |

By unit: Unit 5 seeds $1.9008 (4 items), variants $0.1158 (3); Unit 4 (stand-in) seeds $1.9493 (6), variants $0.5073 (6). Per seed: 4.3 $0.152, 4.4 $0.727, 4.5 $0.185, 4.6 $0.167, 4.7 $0.328, 4.9 $0.390, 5.1 $0.642, 5.3 $0.489 (held), 5.4 $0.343, 5.5 $0.427. Per variant: 4.3 $0.038, 4.4 $0.100, 4.5 $0.054, 4.6 $0.078, 4.7 $0.047, 4.9 $0.190, 5.1 $0.035, 5.4 $0.050, 5.5 $0.031. About $0.154 per full-check run; the cost is rework rounds against the stricter gate, not run price.
Stage split: audit $2.5784, probe $0.6249, solve $0.6063, answer grade $0.0776; variant diff check $0.5858 (re-samples $0.0698).

**Authoring estimate (r2, not measured):** marginal output about $0.12 for the r2 builder and library additions (about 12k tokens); session slice about **$3.3** (context grew 399k to 532k; about 55 tool rounds at about 465k cached context; about 45k output tokens; plus or minus 40 percent).
**Per item all-in (gateway + marginal):** r2 seed about $0.40, variant about $0.072 (variant is about 18 percent of a seed).

## Whole run (r1 + r2)
Gateway: r1 $5.7535 + r2 $4.4731 = **$10.2266** measured at token level (791 calls). Authoring estimate: marginal plus infrastructure about $0.6, whole session about $7.7 (r1 $2.70 + $1.66, r2 $3.3). Combined about **$10.8 to $17.9**.
Making the Easy items harder cost about $4.47 gateway plus the authoring slice; it more than doubled the per-seed check cost (seed average $0.385 in r2 against $0.319 in r1 across the same topics' rework) because the stricter gate forces more full-check runs.

## Needs David
- **Decision:** re-rate the five split-rated r1 items (5.2, 4.1, 4.2, 4.8, 4.10 and variants) under the new gate (about $2.5 gateway if they behave like r2), or accept them as Medium-by-majority. And what to do with 5.3: hold, accept as a topic-ceiling exception, or merge it into a harder topic.
- Everything under "Not done / needs approval" in the r1 section still applies (publication approval, distinctness check against published FRQs, seed-side controls not re-run).
