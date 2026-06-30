# Canonical Answer Test Series

**Status:** Draft research protocol  
**Owner:** Product Owner with Learning Quality Owner  
**Date:** 2026-06-27  
**Purpose:** Determine when canonical answers improve grading quality, then speed, then cost, in that order.

## 1. Why This Series Exists

The gated-prompt, exemplar, oracle-boundary, and flywheel experiments all point to the same pattern:

- the model often has enough biological context;
- the recurring problem is boundary definition and criterion separation;
- larger reference blocks can help calibration, but they often add cost and sometimes introduce new errors.

Canonical answers are worth testing because they are the smallest possible reference artifact that can still define a scoring boundary. They may help most when a criterion is under-specified, paired with a near-neighbor criterion, or vulnerable to over-credit from generic biology language.

This series is ordered deliberately:

1. Quality first.
2. Speed second.
3. Cost third.

If a test does not improve quality, later speed/cost measurements do not matter for promotion.

## 2. Working Hypothesis

Canonical answers improve grading when they do one or more of the following:

- separate two nearby criteria cleanly;
- restate the boundary in concrete, criterion-specific language;
- provide a short enough reference block that the grader can use it without drifting into generic biology explanation;
- expose an over-credit trap that the rubric text alone leaves ambiguous.

Canonical answers do not help much when:

- the rubric is already crisp;
- the answers are too broad and cover both criteria at once;
- the reference block adds extra tokens without changing the decision boundary;
- the corpus is too easy and leaves no real ambiguity to resolve.

## 3. Test Order

### Test 1 - Canonical Pair Integrity

Goal:
- Verify that each short-FRQ canonical pair is cleanly matched to its two criteria.

Why first:
- If the pair itself is swapped, duplicated, or drift-prone, downstream grading tests are noisy.

What to check:
- answer-criterion alignment;
- swapped or duplicated pairs;
- overbroad language that leaks into the neighboring criterion;
- whether the pair is concise enough to function as boundary memory.

Current state:
- The 20 AP Biology short-FRQ pairs have already been reviewed locally and tightened to a clean 20/20 matched set.

### Test 2 - Boundary Definition vs No Canonical Answers

Goal:
- Measure whether canonical answers improve strict grading agreement compared with no canonical answers.

Comparison:
- Control: no canonical answers.
- Treatment: two canonical answers per FRQ.

Primary outcome:
- strict agreement on the hard or borderline corpus.

Secondary outcomes:
- under-credit and over-credit by criterion;
- paired changes versus control;
- schema validity.

Interpretation:
- If strict agreement does not improve, canonical answers are not yet helping boundary definition.

### Test 3 - Canonical Pair Count Ablation

Goal:
- Determine whether one canonical answer is enough or whether the pair is required.

Comparison arms:
- 0 canonical answers.
- 1 canonical answer.
- 2 canonical answers.

Questions this answers:
- Does the first canonical answer already carry most of the boundary signal?
- Does the second answer add real separation or just extra tokens?
- Are two answers better only for specific criterion shapes, such as identify-plus-explain or cause-plus-mechanism prompts?

### Test 4 - Boundary Specificity Test

Goal:
- Find out whether canonical answers help only when they are criterion-specific and compact.

Comparison arms:
- Criterion-specific canonical pair.
- Broader canonical pair that also mentions neighboring concepts.
- Boundary-table style rewrite derived from the same pair.

This test matters because the prior reports suggest the best signal comes from short, precise boundary language, not from bulky exemplars.

### Test 5 - Corpus Difficulty Split

Goal:
- Determine whether canonical answers help more on borderline responses than on clear responses.

Split:
- clear subset.
- ambiguous/borderline subset.

Expected pattern:
- Canonical answers should help most on borderline responses.
- If they only help on the easy set, they are probably not doing real boundary work.

### Test 6 - Speed and Cost Confirmation

Goal:
- Once a quality-positive canonical-answer configuration exists, measure whether it is also competitive on speed and cost.

Compare:
- p50 latency;
- p95 latency;
- input tokens;
- output tokens;
- reasoning tokens;
- estimated cost per FRQ.

Rule:
- Do not promote a canonical-answer variant on speed or cost if it does not first win on quality.

### Test 7 - Reasoning-Level Ablation

Goal:
- Check whether the winning canonical-answer configuration still works with lower reasoning effort.

Compare:
- medium reasoning.
- low reasoning.

Interpretation:
- If low reasoning preserves quality, that is the first place canonical answers can pay off operationally.

### Test 8 - Fast-Primary Follow-On

Goal:
- If canonical answers are quality-positive and compact, test whether a faster primary model can use them without quality loss.

This is downstream from the boundary work. It is not the first canonical-answer question.

## 4. Recommended Metrics

Use the following ranking when interpreting results:

1. Strict agreement.
2. Over-credit and under-credit by criterion.
3. Paired changes versus control.
4. p50 and p95 latency.
5. Input tokens and estimated cost.
6. Output tokens.
7. Reasoning tokens.

Quality should always be interpreted before speed. Speed should always be interpreted before cost. Cost matters only after the earlier two pass.

## 5. Acceptance Rule

A canonical-answer configuration is interesting only if it satisfies:

- better strict agreement than control on the borderline corpus;
- no meaningful new over-credit pattern;
- no major schema regression;
- then, and only then, competitive latency and cost.

If a configuration is cheaper but less accurate, it does not advance.
If a configuration is faster but noisier, it does not advance.
If a configuration improves quality but only by adding too many tokens, it moves to the next stage for speed/cost confirmation.

## 6. Current Candidate Set

The current AP Biology short-FRQ set is the best candidate for this series because:

- the 20 canonical pairs are now cleanly matched;
- the set spans multiple criterion shapes;
- it already includes both clear and boundary-sensitive content;
- it can be paired with the existing short-FRQ rubric corpus.

The current corpus should be split into:

- clear cases;
- borderline cases;
- known boundary-cluster cases.

That split is important because canonical answers should show their strongest value on the borderline cases.

## 7. Suggested Run Sequence

1. Run integrity review on the canonical pairs.
2. Run no-canonical control on the hard corpus.
3. Run two-canonical-answer treatment on the same corpus.
4. Run 1-answer ablation.
5. Run criterion-specific vs broader canonical wording.
6. Run medium vs low reasoning on the winning boundary configuration.
7. Only after that, test any speed-first or fast-primary variant.

## 8. Decision Tree

- If canonical answers do not improve quality, stop and redesign the boundary language.
- If they improve quality but not enough to beat control, test tighter criterion-specific wording before adding more context.
- If they improve quality and stay compact, optimize for speed next.
- If they improve quality, speed, and cost, they become a real candidate for the grading prompt.

