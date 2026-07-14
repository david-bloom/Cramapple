# Grading Model Assessment Harness — Build Scope

**Status:** Implementation-ready scope (v3 — reviewed after Codex Sol's
second review). Not yet implemented. Per Sol's v2 review: "once normalization, manifest
granularity, clustered statistics, and the complete shared contract are
nailed down, this is ready to become an implementation prompt" — this
revision is aimed at closing exactly those four items plus the smaller
refinements, so v3 should be the version an implementation prompt is drafted
from.
**Depends on:** `docs/architecture/GRADING_MODEL_ASSESSMENT_PROTOCOL_2026_07_11.md`.
**Test names:** Tier 1 = **Placement Test**. Tier 2 = **Grader Challenger**.

## What changed in v3

Four remaining blockers from Sol's v2 review, closed:

1. Normalization split into two separate pure functions (not one mixed
   interface); v1 scale chosen definitively; denominator treatment for
   `not_applicable`/`unable_to_determine`/malformed output defined (§1).
2. Shared grading contract expanded to include the system prompt,
   `sanitizeModelResult`, criterion-ordering handling, and usage/error
   extraction — and the call unit (one call per item-response scoring all
   its criteria, never one call per criterion) is now stated explicitly,
   because getting this wrong would have changed both cost and accuracy
   economics without anyone noticing (§2).
3. Sample manifest corrected to exclude MCQ (out of scope — MCQ is
   deterministic, never touches the LLM grader) and given a real row schema:
   `content_key + response_index + selected criterion_keys` (§5).
4. Bootstrap CIs specified as **cluster bootstrap at the item level**, not
   naive per-criterion resampling, since criteria within one response are
   correlated and naive resampling would understate variance (§10, new).

Plus the "important refinements" and "additional recommendations": a
compatibility hash equality matrix (§11, new), reservation-based cost-cap
enforcement (§9), unique idempotency keys per stability replicate, full
interleaving schedule recorded (not just the seed), pinned-version
requirement for promotion-grade runs, raw-artifact retention even on hash
mismatch, a concrete CLI/result contract (§12, new), and private-holdout
storage requirements (§8).

## 1. Label normalization — two pure functions, binary scale for v1

**Correction from v2:** v2 proposed one function,
`normalizeLabel(goldLabel, pointsAwarded, pointsPossible)`, mixing gold and
prediction normalization into a single operation. That's wrong — they're
different inputs with different shapes and should not share a signature.

```
normalizeGoldLabel(gold: "earned" | "not_earned" | "partially_earned" | "unable_to_determine")
  → ComparableLabel

normalizeModelResult(status: "earned" | "not_yet_earned" | "unable_to_determine" | "not_applicable",
                      pointsAwarded: number, pointsPossible: number)
  → ComparableLabel
```

**v1 scale, chosen definitively:** binary `full_credit | not_full_credit`,
plus an `abstained` value that both functions can also produce (see
denominator rule below). The fractional-credit alternative floated in v2
(extending production's schema to carry partial credit) is **not harness
work** — it would require changing what production actually stores and
grades against, which is a separate product migration with its own review,
not something this harness can decide unilaterally. Revisit only if that
migration happens independently.

Mapping:
- Gold `earned` → `full_credit`. Gold `not_earned` → `not_full_credit`.
  Gold `partially_earned` → `not_full_credit` (a 1-point criterion has no
  partial state to preserve under the binary scale — this is a real loss of
  information, logged as a known limitation, not hidden).
  Gold `unable_to_determine` → `abstained`.
- Prediction `earned` (with `pointsAwarded == pointsPossible`) →
  `full_credit`. `not_yet_earned`, or `earned` with
  `pointsAwarded < pointsPossible` → `not_full_credit`. Prediction
  `unable_to_determine` → `abstained`. Prediction `not_applicable` → its own
  value, `not_applicable` (see below — this has no gold analogue and must
  not be silently folded into either credit state).

**Denominator rule — corrected to prevent abstention from inflating apparent
accuracy.** An earlier version of this rule excluded prediction
`abstained`/`not_applicable`/malformed cases from the denominator entirely.
That's wrong: a model could abstain on every hard case and post excellent
accuracy on what's left. Report **two accuracy numbers, always paired**,
never one alone:

- **Overall accuracy** — denominator is every case where **gold** is
  determinable (gold is `full_credit` or `not_full_credit`; gold
  `abstained` cases are excluded here and scored separately, below). Within
  that denominator, a prediction of `abstained`, `not_applicable`, **or**
  malformed output **counts as incorrect** — it does not get excluded, and
  it does not get a free pass. This is the headline number, and it's the
  one that can't be gamed by abstaining.
- **Selective accuracy** — denominator is only cases where the model
  actually returned a credit decision (`full_credit` or `not_full_credit`).
  Always reported **paired with coverage** (credit-decision count ÷
  determinable-gold count), never alone — selective accuracy without its
  coverage figure is exactly the number that hides an abstain-on-hard-cases
  strategy.
- **Gold `abstained` cases** (gold itself is `unable_to_determine`) stay
  outside both accuracy numbers above and get their own metric: whether the
  model's prediction was *also* `abstained` (a correct abstention) vs. a
  confident credit decision on a case gold says is genuinely
  indeterminate (a different kind of failure, worth tracking separately).
- **Model-produced `not_applicable` is a semantic failure, not a neutral
  exclusion**, whenever it happens on a criterion the manifest selected for
  benchmarking (§5) — every selected criterion is, by construction, an
  applicable rubric criterion for that item-response, so the model claiming
  otherwise is simply wrong, not abstaining in a defensible way. It's
  folded into "incorrect" in overall accuracy and excluded from selective
  accuracy's denominator (consistent with "only where the model returned a
  credit decision") — same treatment as `abstained`, just tracked under its
  own rate so the two failure modes aren't conflated in reporting.
- Malformed-output rate is still reported as its own metric too, alongside
  (not instead of) its effect on overall accuracy above.

Confusion matrix, macro-F1, balanced accuracy, and point-weighted agreement
(§4) all follow the **overall** treatment as their primary/headline
computation (abstention counts as wrong); the selective/coverage-paired view
is reported as a secondary lens, not a replacement.

## 2. Shared grading contract — expanded scope

`supabase/functions/_shared/grading-contract.ts`, side-effect-free, no
top-level `Deno.serve()`. Exports, expanded from v2:

- The prompt-building function (`buildGradingPrompt` today).
- **The production system prompt** — currently inline in
  `evaluate-attempt/index.ts`'s call-construction code. This is part of what
  gets varied-by-omission if the harness reconstructs its own system prompt
  instead of importing the real one.
- The structured-output schema (`gradingSchema` today).
- **`sanitizeModelResult`** — production does not score the model's raw JSON
  output; it sanitizes it first. If the harness scores raw output while
  production scores sanitized output, the two are measuring different
  things even when using an identical prompt and schema. This must be
  shared, not reimplemented.
- **Canonical criterion ordering and unknown-criterion handling** — how
  production maps a model's returned criteria back onto the rubric's
  criterion set, including what happens if the model returns criteria out
  of order, omits one, or invents one not in the rubric.
- **Usage extraction and provider-error classification**, if these affect
  what gets reported as reliability (retry rate, timeout rate, etc. in §4/§9
  depend on classifying errors consistently between production and harness).
- The label-normalization functions from §1.

**Call unit — state this explicitly so it can't be gotten wrong silently:**
production's grading call is **one request per item-response, scoring every
criterion for that response in a single call** — not one call per criterion.
The harness must replicate this exactly. Calling once per criterion instead
would multiply the number of API calls, change the context each call sees
(a per-criterion call loses the other criteria as context), and change both
cost and latency economics in ways that would make the comparison invalid
even if every other setting matched. Import the shared contract's
request-body builder as-is; do not restructure it into a different call
shape "for convenience."

## 3. Transport mode (unchanged from v2, cross-referenced by §11)

Record `transport_mode: "production_exact" | "gateway_normalized"` on every
result. Promotion-grade comparisons require the same transport_mode on both
candidate and baseline (see §11's equality matrix) — cross-transport results
are exploratory only and must be labeled as such, never used for a
promotion decision.

## 4. Metrics (unchanged from v2, statistics detail now in §10)

Confusion matrix by gold label (post-normalization, per §1's denominator
rule), macro-F1/balanced accuracy, FP/FN rates separately, point-weighted
agreement, whole-response exact match, `abstained`/`not_applicable`/
malformed rates (§1), and the bootstrap CIs and stability/flip rate — see
§10 for the corrected statistical method.

## 5. Sampling — corrected scope and manifest granularity

**Scope correction:** this protocol evaluates the LLM-text (`discrete_text`)
grading route only. MCQ grading is deterministic
(`grading-router.ts` → `mcq_rule`) and **never reaches the LLM grader** —
v2's manifest description incorrectly mentioned stratifying across
"MCQ/FRQ," which contradicts this protocol's own stated scope. The corpus
and manifest contain FRQ/`discrete_text` items only. No MCQ item should ever
appear here.

**Manifest row schema**, corrected from v2's "list of content_keys":

```
{
  "content_key": "string",
  "response_index": 0,
  "selected_criterion_keys": ["string", ...]
}
```

One `content_key` can have multiple responses with different gold labels
(the existing gold-set corpus already has this shape — see
`provisional_labels.json`'s `responses[]` arrays); sampling by `content_key`
alone would not preserve the intended label distribution across those
responses.

**What `selected_criterion_keys` controls — and, just as importantly, what
it does not control:**

- **The model prompt always includes every rubric criterion for that
  item-response, exactly as production does** (§2's call-unit requirement).
  Sending only the selected subset to the model would silently change its
  context — the model would be grading with a different, smaller rubric
  than production ever shows it — and would violate the production-
  equivalence requirement that's the entire point of the shared grading
  contract.
- **`selected_criterion_keys` governs only which of the *returned* criteria
  enter benchmark scoring and stratification** — it's a post-hoc filter on
  the model's full response, not an input restriction on what the model
  sees.
- **Whole-response exact match** (§4) is computed over **all rubric
  criteria for that item-response, not just the selected subset**, whenever
  all of them have gold labels — an exact-match claim restricted to a
  subset would be a weaker and different claim than "the whole response was
  scored perfectly," and the metric's name should mean what it says. If a
  given response has rubric criteria without gold labels, whole-response
  exact match falls back to whatever subset does have labels for that
  response, and this fallback should be visible in the result (not silently
  averaged away) — see §12's result schema.

The manifest is a committed, versioned list of these rows,
stratified across module, difficulty, gold label, response type, and known
failure shape (per v2 §5, unchanged) — but at response-level granularity,
not item-level.

## 6. Grader Challenger baseline policy — corrected interleaving and stability

Unchanged from v2: same-session, interleaved, deterministic order; cached
baselines are informational only, never used for promotion unless every
compatibility hash matches (§11).

**Corrections:**
- **Interleave at the item-response level** (not a coarser granularity),
  and **randomize whether baseline or candidate is called first within each
  pair** — always calling baseline-then-candidate (or vice versa) could
  introduce an ordering bias (e.g. from provider-side caching or rate-limit
  warmup effects). Record the **complete realized schedule** (which model
  went first for every pair, and the full call order), not just the random
  seed — auditable directly from the artifact, without needing to re-derive
  it by re-running the same seed through the same algorithm.
- **Stability runs need a unique idempotency key per replicate.** If the
  harness reuses one idempotency key across repeated calls meant to measure
  stability, the provider (or production's own idempotency-key caching
  pattern, which this codebase already uses elsewhere — see
  `evaluate-attempt/index.ts`'s `grading_results` idempotency check) may
  return the same cached response both times, which would report perfect
  stability for a reason that has nothing to do with the model actually
  being stable. Generate a fresh key per replicate, always.

## 7. Provenance (unchanged from v2, one addition)

All of v2's provenance fields (commit, hashes, request params, timestamp,
pricing snapshot, raw usage categories), plus:

- **If a requested model alias cannot be resolved to an immutable version
  string, record `resolved_version: "unknown"` explicitly** — don't leave
  the field blank or guess. **Promotion-grade runs should require a pinned,
  resolvable version**, not an alias like "latest" that could silently
  change between the run and any later re-verification. Exploratory runs
  may use aliases; promotion-grade ones should not.

## 8. Regression suite and private holdout

Unchanged expansion plan from v2 (§8 there). **Storage correction:** the
private holdout suite must be stored **outside the normal tuning-visible
repository path** (i.e. not alongside `grading_model_assessment_regression_
suite.json`, which is readable by anyone iterating on prompts/models),
with controlled access. Reports may reference the holdout's **version and
content hash** and its pass/fail summary, but must never expose the actual
held-out cases in a report or log — the entire point is that repeated
tuning shouldn't be able to see (and therefore overfit to) these cases.

## 9. Cost cap — reservation-based, not post-hoc

**Correction from v2:** a hard `--max-cost-usd` flag alone doesn't prevent
overshoot in a concurrent harness, because actual usage is only known after
a response arrives — several calls can be in flight simultaneously, all
dispatched before any of them return, all checking the same "spent so far"
number that hasn't yet accounted for each other.

**Corrected mechanism:** before dispatching each call, compute its
configured **worst-case cost** (max output tokens × output price + estimated
input tokens × input price, from the versioned pricing file in v2 §9) and
**reserve** that amount against the remaining budget. Refuse to dispatch if
the reservation would push cumulative reserved cost over `--max-cost-usd`.
After the call completes, **reconcile** reserved vs. actual cost (release
the difference, or if actual somehow exceeds the worst-case estimate —
which shouldn't happen if the estimate is genuinely worst-case, but log it
as an anomaly if it does). This is standard admission-control, not a novel
mechanism — apply it rather than the simpler post-hoc check v2 proposed.

## 10. Statistical method — cluster bootstrap, predeclared parameters

**Correction from v2:** criteria within the same item-response are
correlated (they share context, share the model's read of that specific
response, etc.) — naive bootstrap resampling at the individual-criterion
level treats them as independent observations, which understates variance
and produces confidence intervals that are too narrow (false precision).

**Corrected method: paired cluster bootstrap at the item level.** Each
resample draws **whole items** (carrying every response and every criterion
for that item together) with replacement from the sample manifest, not
individual criterion-level observations. Recompute the metric of interest
on each resample; repeat B times; take the percentile interval.

**Predeclare, as part of the harness's fixed configuration (not left to
per-run discretion):**
- Number of resamples, `B` — e.g. 2000, stated explicitly in the
  implementation, not decided ad hoc per run.
- Confidence level — e.g. 95%, same.

Both values get recorded in the provenance block (§7) on every run so a
reader knows exactly what interval-construction procedure produced the
reported CI.

## 11. Compatibility hash equality matrix

Corrects v2's ambiguous "request-settings hashes must match" (candidate and
baseline intentionally use different models — that can't be a "must match"
field). Explicit three-way split for promotion-grade comparisons:

**Must match** (mismatch → comparison fails closed, per v2 §6):
- Prompt template hash, schema hash, corpus hash, normalization-policy
  version, `transport_mode`, reasoning/generation settings (temperature,
  max tokens, effort level, etc.), timeout, retry policy, concurrency
  setting.

**Must differ** (this is the entire point of the comparison):
- Requested model alias and resolved model version.

**May differ, but must be reported alongside the result:**
- Provider-specific usage fields (different providers report token/cost
  accounting with different granularity — this is expected and not a
  compatibility failure, but must be visible in the result, not silently
  normalized away).

Any comparison where a "must match" field differs is not promotion-eligible
— label it exploratory, and see §"Raw artifact retention" below for what
still gets kept.

## 12. CLI and result contract

**Correction from v2:** v2 became a pure design specification and dropped
v1's operational flow entirely. Reintroducing the minimum needed for an
implementation prompt to actually build something runnable:

**Required flags (illustrative, not final):**
- `--model <alias>` — candidate model, required.
- `--tier placement|challenger` — required.
- `--corpus <path>` — required for `challenger`; Placement Test can run
  regression-suite-only without one.
- `--sample-manifest <path>` — required for `challenger` (§5's committed
  manifest, not computed fresh per run).
- `--regression-suite <path>` — required both tiers.
- `--baseline-model <alias>` — defaults to production's currently
  configured model.
- `--max-cost-usd <float>` — required, no default (forces an explicit
  budget decision every run rather than an implicit one).
- `--concurrency <int>` — bounded worker pool size.
- `--resume <run-id>` — resume an interrupted run from its last completed
  item rather than re-spending cost on already-completed calls.
- `--out <dir>` — output directory for run artifacts.
- `--dry-run` — validate corpus/manifest/connectivity without real graded
  calls.
- `--bootstrap-resamples <int>`, `--confidence-level <float>` — override the
  predeclared defaults from §10 (still logged in provenance either way).
- `--seed <int>` — deterministic interleaving seed; auto-generated and
  recorded if omitted, never silently unrecorded.

**Exit codes (illustrative, refine during implementation):**
- `0` — completed, comparison valid and promotion-eligible.
- `1` — completed, but comparison invalid (a "must match" hash failed per
  §11) — raw artifacts are still written; see below.
- `2` — aborted due to the cost cap.
- `3` — aborted due to an unrecoverable error (corpus/manifest validation
  failure, or a promotion-grade run requested without a pinned model
  version per §7).

**Partial-run and resumability:** write per-item results to the output
directory incrementally as they complete, not only as one final blob at the
end — this makes a crash inspectable and makes `--resume` actually able to
skip already-completed, already-paid-for calls rather than restarting from
zero.

**Raw artifact retention:** even when a run's comparison hashes are
incompatible (§11) or a run is interrupted, keep the raw per-item outputs
that were produced. Mark the run's comparison as invalid and suppress its
promotion metrics, but do not discard the model outputs themselves — they
remain useful for later re-analysis even if this particular run can't
support a promotion decision.

**Result JSON schema (shape, not final field names) — two-level, call
records plus child criterion records.** A flat one-row-per-criterion schema
would duplicate the entire raw model output (which is shared across every
criterion in that item-response, per §2's call-unit rule) into every one of
its child rows — inflating artifact size for no reason and complicating
resumability (a resumed run needs to know which *calls* completed, not
count duplicated criterion rows). Structure instead as:

- One **call-level record** per item-response call: `content_key`,
  `response_index`, raw model output (once), cost, latency, retry count,
  any error, resolved model version, and whichever provenance fields are
  call-specific rather than run-specific.
- Child **criterion-level records** under each call record, one per scored
  criterion: `criterion_key`, normalized prediction, gold label, per-
  criterion correctness (under both overall and selective accuracy per
  §1), and whether it was in `selected_criterion_keys` for this run's
  benchmark scoring.

Top-level object wraps: the full provenance block (§7), the §11
compatibility-hash summary, the array of call-level records (each with its
nested criterion records), and a `summary` object with the aggregate
metrics from §4/§10 (confusion matrix, overall and selective accuracy with
coverage, F1, bootstrap CIs, stability/flip rate, cost/latency percentiles).

## Corpus contract

Unchanged from v2 — `final_gold_label` required, fail closed on
`provisional_label`-only data. **FRQ/`discrete_text` items only per §5** —
no MCQ items belong in this corpus.

```json
{
  "items": [
    {
      "content_key": "string",
      "question_text": "string",
      "stimulus": "string",
      "rubric": [
        {
          "criterion_key": "string",
          "learner_facing_text": "string",
          "points_possible": 1
        }
      ],
      "responses": [
        {
          "response_index": 0,
          "response_text": "string",
          "criteria": {
            "<criterion_key>": {
              "final_gold_label": "earned | not_earned | partially_earned | unable_to_determine"
            }
          }
        }
      ]
    }
  ]
}
```

## Explicit non-goals (unchanged)

Does not call/modify the deterministic/routing layer. Does not write to
Supabase or touch Production/Development. Does not decide pass/fail on its
own — the decision bar (protocol doc) is a separate, predefined-before-
viewing-results gate. Does not vary the prompt. Does not itself freeze or
adjudicate the corpus.

## Resolved open questions (unchanged from v2)

Runtime: Deno, after the shared-contract extraction. Location:
`scripts/grading-model-assessment/` for the harness, frozen corpora/
manifests/results under `docs/research/` (private holdout stored separately
per §8). Pricing: versioned config plus explicit override. Baseline: fresh
same-session interleaved rerun, not a cached file, for promotion-grade runs.
Decision bar: human approval with materiality thresholds defined before
viewing results (protocol doc).

## Still not implemented

This remains a scope document. The remaining specification blockers are
closed and it is ready to drive an implementation
prompt — building `grading-contract.ts`, the harness CLI, the pricing
config, the sample manifest, and the cluster-bootstrap statistics module are
all separate implementation work, not yet started.
