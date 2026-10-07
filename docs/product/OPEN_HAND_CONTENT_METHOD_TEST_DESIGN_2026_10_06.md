# Content Method Test: Legacy Patch Loop vs Generate-and-Select

**Status:** Draft for David's approval. Nothing has been run.
**Task:** TASK-0065. **Date:** 2026-10-06. **Owner:** Claude. **Product Owner:** David Bloom.

## Question

Does the no-edit generate-and-select pipeline produce better Open Hand teaching questions than the legacy
author-check-patch method? "Better" means three things:

1. **Quality:**
   - the question and every answer option are accurate;
   - the item is faithful to the College Board CED (on topic and in scope).
2. **Speed:** time to a publishable item.
3. **Cost:** dollars per publishable item.

## The two arms

Both arms run on the same day and the same machine, with the same gateway roster, the same corrected fact
packs and the same topics.

| | Legacy (L) | Pipeline (N) |
|---|---|---|
| Method source | `docs/research/open_hand_teaching_batch_2026_10_06/AUTHORING_SPEC.md` and the Units 1–3 runbook | `scripts/vercel-gateway-check/teaching_pipeline/` |
| Author | Claude, one item per topic, following the authoring spec | Claude Opus 5.5 and GPT-6.1, stateless, writing to the shared rubric |
| Checks | Gemini 3.8 + DeepSeek v4 (`open_hand_teaching_check.mjs`: blind solve + fact-pack audit), union of flags | Lint, then 4 non-author families (blind solve + rubric audit), re-sample on flag, then own-family veto |
| On failure | A Claude session adjudicates the flags and hand-patches once. Both checkers re-check. Still failing → dropped | Regenerate. After 2 rounds → escalated. Never edited |
| Run by | A separate Claude session following the legacy runbook, timed | `run.mjs`, timed |

The legacy arm is the method as it was actually used, not a weakened copy. Its patch session runs on its own,
so its time and tokens are measured, not estimated.

## Sample

- **24 topics:** 6 from each of Biology, Statistics, Chemistry and Calculus AB, units 1–3.
- Drawn at random with a fixed seed from `teaching_pipeline/inputs/scope_u1-3.json`.
- The 21 Biology pilot topics are **excluded** (the pipeline has already seen them). Biology therefore draws
  from units 4–8 topics that have a point brief.
- Statistics, Chemistry and Calculus AB are the computational subjects, where accuracy errors are likeliest,
  so they make up three quarters of the sample.

At about 24 items per arm the test detects large differences only (for example 25% vs 5% defective). If the
result is close, extend to 48 topics with the same design before deciding.

## Judging (the arms never grade themselves)

Every item that either arm finally accepts goes into one **blind review set**:
- provenance stripped;
- same layout for both arms;
- one shuffled order;
- **4 planted-defect items** mixed in (wrong key, false rationale, off-topic, out-of-CED term), to measure
  whether the judges catch errors at all.

**Held-out model panel.** Three families that neither arm uses: Mistral Large 4, GLM-5.3 and MiMo v2.6 Pro.
- Each judges every item, twice.
- Judges get the **CED PDF text** for the topic (extracted from `docs/teaching/*.pdf`), not our fact packs.
  The fact packs are inputs to both arms, and today showed they can be wrong (the Biology 3.3 coupling gap).
- A judge's verdict counts only if both of its samples agree.

**Deterministic recompute.** Every numeric key is recomputed in Python (sympy), independently of all models.

**Human review.** A qualified reviewer from the `validator_qualifications` roster reviews:
- every item where the model panel disagrees or the recompute fails;
- a random 25% of the rest.

The human verdict is final. David reviews a sample of 6 for the pedagogy rating.

## Measures

### Quality (primary)

| ID | Measure | How | Unit |
|---|---|---|---|
| Q1 | Key correct and unique | Blind solve by the panel, plus the numeric recompute, plus the human on disputes | % of items |
| Q2 | Option accuracy | Every statement in the stem, the options and the rationales judged true or false against the CED and standard science | % of items with zero false statements; false statements per item |
| Q3a | On topic | Judge picks the topic from the full unit list with CED text; must equal the designated topic | % of items |
| Q3b | In CED scope | Every concept required is in the CED's required content, exclusion statements included | % of items |
| Q* | Publishable as is | Human verdict: publish / needs edit / reject | % publish |

### Quality (secondary)

**P: Pedagogy.** Named traps, action fixes, one to three sentences, and fit with the topic's point brief.
- The pipeline is built to this house rubric, so P is reported but cannot decide the test on its own.
- David's 6-item rating is reported alongside it.

### Speed

| ID | Measure |
|---|---|
| S1 | Wall-clock from start to the last accepted item, per arm |
| S2 | Median minutes per accepted item |
| S3 | Session minutes spent adjudicating and patching (legacy only; the pipeline's should be zero) |
| S4 | Yield: accepted ÷ attempted, and number of topics escalated or dropped |

### Cost

| ID | Measure |
|---|---|
| C1 | Dollars per accepted item: tokens from each arm's call log × gateway prices at run time, **including the legacy patch session's own tokens** |
| C2 | Dollars per publishable item: C1 ÷ Q* rate. This is the number that decides cost |
| C3 | Calls per accepted item |

Judging cost is reported separately and charged to neither arm.

## Decision rule (proposed; David to confirm)

Adopt the pipeline as the only method for teaching items if **all** of these hold:
1. Q1, Q2 and Q3 are not worse than legacy by more than 5 points on any measure, and Q* is at least equal.
2. Pipeline yield (S4) is at least 80%.
3. C2 is no more than 3× legacy.

If the pipeline wins on quality but fails on cost, tune it: fewer re-samples, cheaper checkers on the solve
stage. Do not drop it. If legacy is better on Q1 or Q2, keep legacy and find out which pipeline stage let the
errors through.

## Validity checks

- **Judge sensitivity:** if the panel misses any planted defect, the quality results are void until the panel
  is fixed.
- **Leakage:** neither arm sees the other's items; the judges never see provenance.
- **Same inputs:** both arms use the fact packs as corrected on 2026-10-06 (Biology 3.3) and the briefs as
  corrected (Biology 2.10).
- **Shared author family:** both arms have Claude authors, so any Anthropic self-preference is shared. That is
  why the judges come from three other families.

## Outputs

`scripts/content-seed/task0065-method-test-<date>/`:
- `legacy/` and `pipeline/` batch directories with call logs;
- `review_set.json` (blind) and `review_key.json` (provenance);
- `judgements.jsonl`;
- `human_review.json`;
- `RESULTS.md` with every measure above and the decision.

## Estimated effort

- Pipeline arm: about 30–40 minutes for 24 topics.
- Legacy arm: about 20 minutes of generation and checking, plus its patch session.
- Judging: about 300 model calls, then human review of an estimated 10–15 items.
- Model spend: about $35–45 in total.
  - Pipeline arm: about $27, based on the Biology pilot's measured $20.13 for 21 topics (about $1.12 per
    accepted item; Kimi K3 and Claude Opus 5.5 were the largest costs).
  - Legacy arm: about $5 plus its patch session.
  - Judges: about $3. Mistral Large 4, GLM-5.3 and MiMo v2.6 Pro are each under $1.50 per million input tokens.
