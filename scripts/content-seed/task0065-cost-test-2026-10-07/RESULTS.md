# Pipeline Cost Changes: Measured (2026-10-07)

**Task:** TASK-0065. **Protocol:** `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §0.7.
**Same 24 topics as the method test** (`sample.json`), so the before/after comparison is like for like.
Nothing was written to any database.

## Changes (in `teaching_pipeline/run.mjs`)

1. **Cache-friendly prompts.** Every long prompt is split into a fixed prefix (role, rubric, full CED fact pack,
   identical across a subject's calls) and the topic- or item-specific part. Claude's prefix carries an explicit
   cache marker; other providers cache identical prefixes automatically. The content each model sees is unchanged;
   only its order changed.
2. **Writers run one after the other.** GPT-6.1 writes first, and Claude writes only if GPT's candidate is rejected
   (`--author-order`). Before, both wrote in parallel and the second candidate was often paid for and never used.
3. **Tighter length instructions for writers:** two sentences before the Fix, about 40 words. Length was the most
   common rejection.

## Results

| | Before (method test) | After | Change |
|---|---:|---:|---:|
| Topics accepted | 23 / 24 | **24 / 24** | +1 (Chem 3.9 passed) |
| Candidates generated | 47 | **26** | −45% |
| Rejected at the free format check | 10 | **1** | |
| Model cost, cache-aware | $16.56 | **$6.75** | −59% |
| **Cost per accepted question** | **$0.72** | **$0.28** | **−61%** |
| Wall-clock | 13.7 min | 10.1 min | |
| Controls caught | 6 / 6 | 6 / 6 | |

The "before" cost is recomputed cache-aware: cached input priced at the cache rate. The method test's naive figure
was $16.91.

**Where the cost went (after):**

| Item | Cost |
|---|---:|
| Audits | $3.71 |
| Veto | $1.09 |
| Writers | $1.64 |
| Solves | $0.31 |

**Cache hit rate by model:**

| Model | Cache hit rate |
|---|---:|
| DeepSeek | 78% |
| Claude | 68% (its cost fell from $8.21 to $1.64) |
| Kimi | 18% |
| Gemini | 3% |
| GPT | 2% |

GPT and Kimi are now the largest costs. Getting their caching to work is the next lever.

## Quality check (blind, held-out judges)

The 24 accepted items and the 4 planted defects were judged blind with the method test's procedure, judges and
scoring rules:
- **Judges:** Mistral Large 4, GLM-5.3, MiniMax M3, two samples each, against CED PDF text.
- **Calls:** 336, with 2 failures re-run. Cost $2.99.

| Measure | After (24 items) | Method-test pipeline (23) | Method-test legacy (24) |
|---|---:|---:|---:|
| Items with a confirmed accuracy or CED defect | **0** | 1 | 4 |
| Key correct (12 numeric keys recomputed) | 24 | 23 | 24 |
| No false statement | 24 | 23 | 21 |
| On topic / within CED | 24 / 24 | 23 / 22 | 24 / 23 |
| Pedagogy clean | 24 | 23 | 19 |
| Judges would publish as is | 24 | 23 | 18 |

- **Judges valid.** All 4 planted defects were caught on their intended measures.
- **One dispute.** It was adjudicated as not a defect: the judge itself wrote "not an error" for both notes
  (`judging/adjudication_reasons.json`).
- **Statistics 2.12 is clean.** It was the earlier pipeline defect, and its brief has since been fixed
  (APPROVAL-0129). Part of the improvement comes from that fix, not from the cost changes.
- **Not a regression.** The cost changes did not lower the bar on any measure. The sample is small (24), as before.

## New finding: LaTeX

Two Calculus items wrote maths in LaTeX (`\(\lim…\)`, `$\lim…$`). Live content uses plain text (0 LaTeX stems in
more than 1,600 published MCQs, apart from a few dollar signs in Statistics). The rubric's style rule now requires
plain-text maths, and the lint rejects LaTeX markup. Both items would now be rejected and regenerated. The controls
were re-checked after the change and behave as before.

## Next levers (not yet done)

- Get GPT and Kimi caching working (provider cache keys, or check how the gateway routes these models).
- Calibrate a cheaper fourth checker in place of Kimi K3.
- Send only the topic's unit section of the fact pack. Measure it with this same procedure, because it changes what
  the checkers see.

## Files

| Area | Files |
|---|---|
| Batch | `batch/` (state, `calls.jsonl`, `accepted.json`, `controls_result.json`) |
| Run | `run.sh`, `timing.log`, `run_*.log` |
| Cost | `cost.py`, `baseline_cost.json`, `new_cost.json`, `pricing_2026-10-07.json` |
| Judging | `judging/` (blind set and key, judgements, `recompute.py`, scores, adjudication) |
