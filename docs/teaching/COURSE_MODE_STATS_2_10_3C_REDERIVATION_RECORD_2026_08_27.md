# Course Mode AP Statistics 2.10 x 3.C Re-Derivation Record

Date: 2026-08-27
Branch: `content/course-mode-stats-2.10-3c`
Cell: `2.10 x 3.C` — The Binomial Distribution, calculate binomial probability
Track: A computational, served as MCQ choice-match with deterministic numeric substrate
Template: `binomial_probability`
Package sample checked: `binomial_probability-021000`

## Scope And Conformance

The item asks students to calculate an exact binomial probability for a fixed number of independent trials with a constant success probability. This matches Unit 2 topic 2.10 and skill 3.C. The contexts are original synthetic settings; no College Board prompt, scoring wording, or released item text was used.

## Gate 1 Property Harness Evidence

Explicit `generator.property_report(120)` over the full computational registry:

- `binomial_probability`: 120 instances, 2160 checks, reject rate `0/120`.
- Full Track A sweep: 1440 instances, 21720 checks, all reject rates `0/120`.
- Meta failures: `[]`.
- Overall: `ok=true`.

Additional required sweeps:

- `python3 generator.py`: PASS; `binomial_probability` 80 instances, 1440 checks, `0/80` rejects; full Track A 960 instances, 14480 checks.
- `python3 slot_frames.py`: PASS; Track B full sweep 960 instances, 9600 checks.
- `python3 scenarios.py`: PASS; scenario catalog ok; binomial context bank count 6.
- `python3 misconceptions.py`: PASS; misconception catalog ok; 67 entries.

## Gate 2 Independent Re-Derivation

Emitted sample stem: A botanist models each seed as an independent trial with probability 0.55 that it germinates within two weeks. For 12 trials, calculate the probability of exactly 7 successes.

Let `X ~ Binomial(n=12, p=0.55)`. The requested probability is exact-count, not cumulative.

Correct key:

- Formula: `P(X=7) = C(12,7)(0.55)^7(0.45)^5`.
- `C(12,7) = 12!/(7!5!) = 792`.
- `(0.55)^7(0.45)^5 = 0.0002809633...`.
- `792 * 0.0002809633... = 0.2225229...`, displayed as `0.2225`.
- Matches emitted correct option and deterministic numeric check `0.2225 ± 0.005`.

Distractor `u2_10__omitted_combination_count`:

- Claimed misconception: omit the binomial coefficient.
- Wrong formula: `(0.55)^7(0.45)^5`.
- Value: `0.0002809633...`, displayed as `0.0003`.
- Matches emitted distractor and correctly represents the tag.

Distractor `u2_10__swapped_success_failure_probability`:

- Claimed misconception: swap success and failure probabilities.
- Wrong formula: `C(12,7)(0.55)^5(0.45)^7`.
- Value: `0.1488835...`, displayed as `0.1489`.
- Matches emitted distractor and correctly represents the tag.

Distractor `u2_10__used_tail_probability_for_exact_count`:

- Claimed misconception: answer an exact-count question with a cumulative tail.
- Wrong formula: `P(X >= 7) = sum_{j=7}^{12} C(12,j)(0.55)^j(0.45)^(12-j)`.
- Value: `0.5269412...`, displayed as `0.5269`.
- Matches emitted distractor and correctly represents the tag.

## Gate 3 Rights / CED Check

The template is synthetic and uses only CED/fact-pack structure: binomial assumptions, exact binomial formula, and probability notation. Misconception entries are cell-namespaced (`u2_10__...`) and cite `AP_STATISTICS_2027_CED_FACT_PACK.md S10 Unit 2 (2.10)`. No verbatim College Board wording appears in the authored stem, contexts, choices, or worked solution.

## Gate 4 Distractor Realism

All distractors are probabilities in `[0, 1]`, are distinct after display rounding, and are separated from the key by more than the deterministic tolerance margin. Each wrong option is a plausible student formula error for this exact-count binomial task: missing arrangements, swapping success/failure roles, or computing a cumulative tail instead of exactly k.

## Release Safety

No loader application, database write, release, serving switch, frontend/router/engine change, Dev mutation, Edge deploy, or Prod action was performed. `build_load_sql.py` was used only for local validation and DRAFT SQL regeneration.
