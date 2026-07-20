# Grading Model Assessment Protocol

**Status:** Plan — corpus and harness not yet built; regression suite drafted
and ready to use as soon as a harness exists.
**Owner:** David (Product Owner) triggers; Claude/Codex executes.
**Scope:** The LLM-grader component only (`llm_text` / discrete-text route,
and eventually holistic). Does **not** cover the deterministic/routing layer
(`grading-router.ts`, `statistics-verifier.ts`, `math-verifier.ts`) — those
are model-independent and out of scope for this protocol.
**Trigger:** On demand — "run the grading model tests on `<model>`." No fixed
cadence.
**Companion doc:** `docs/architecture/
GRADING_MODEL_ASSESSMENT_HARNESS_SCOPE_2026_07_11.md` (v2) — the detailed
build scope, including the label-normalization policy, shared grading
contract, expanded metrics, sampling, and provenance requirements this
protocol assumes. Read both together; this doc is the procedure, the harness
scope doc is the how.

## Naming

**Tier 1 = Placement Test. Tier 2 = Grader Challenger.** (Earlier drafts used
"Smoke Triage" and "Full Comparison Run" — those names are retired. Use
Placement Test / Grader Challenger consistently in code, CLI flags, result
schemas, and runbooks going forward.)

## Invocation convention

When asked to "run the grading model tests on `<model>`":

1. Default to **Placement Test** first, unless explicitly told to run
   Grader Challenger directly.
2. Only proceed to **Grader Challenger** if Placement Test doesn't show an
   obvious disqualifier (a regression-suite failure, or accuracy/cost/latency
   clearly out of the ballpark).
3. Always report regression-suite results and aggregate-corpus results
   **separately** — never blend a regression-case failure into an averaged
   accuracy number.
4. Output is a **comparison report**, not an auto-decided verdict — see
   "Decision bar" below. The report exists so David can weigh the tradeoff
   against a pre-defined materiality bar, not to auto-decide or to be
   rationalized after the fact.

## What's held fixed vs. varied

- **Varied:** the grading model only.
- **Fixed:** prompt/system instructions (via the shared grading contract —
  see harness scope §2), rubric/criteria for each item, the grading schema,
  the comparison corpus, the regression suite.
- Prompt variation is explicitly a **separate experiment**, not part of this
  protocol.
- **Transport mode must be recorded per run** (harness scope §3): whether the
  candidate model was benchmarked over production's exact call path (limits
  candidates to OpenAI-compatible models) or a normalized gateway adapter
  (broader candidate pool, but not literally production's transport). A
  result without this field stamped is not trustworthy for comparison.

## Placement Test

**Purpose:** cheap first look before committing to a full run.

**Corpus:** the full regression suite plus a small stratified sample (not
lexicographic — see harness scope §5) drawn from the frozen comparison
corpus once it exists.

**Procedure:** grade every item in this small set with the candidate model,
using the shared grading contract (harness scope §2) so the harness sends
exactly what production would send. Compare each regression case's verdict
against its known-correct answer, after label normalization (harness scope
§1). Compare the sample's rough accuracy/cost/latency against a fresh,
same-session production baseline — this is a triage, not the full metrics
suite.

**Stop here if:** the candidate model fails any regression case, or comes
back clearly worse on cost/latency/accuracy than production with no
offsetting advantage. Otherwise, proceed to Grader Challenger.

## Grader Challenger

**Purpose:** the actual standard experiment — a rigorous, repeatable,
side-by-side comparison against a fresh production baseline.

**Corpus (two components, always reported separately):**

1. **Representative corpus** — a fixed, stratified set of items with
   adjudicated gold labels, drawn per a committed sample manifest (harness
   scope §5). **Not yet frozen** — see Open Decisions.
2. **Regression suite** — run and reported individually (pass/fail per
   case), never averaged into the aggregate accuracy number. Being expanded
   beyond the initial 5 cases per harness scope §8, plus a private holdout
   suite not used during tuning.

**Baseline policy:** production and candidate run in the **same session**,
interleaved in a deterministic randomized order (item-response level,
randomized which side goes first per pair, full schedule recorded) — not a
cached historical baseline. A cached baseline may be kept for trend-watching
only; it cannot be used for a promotion decision unless every "must match"
compatibility hash (harness scope §11's equality matrix: prompt, schema,
corpus, normalization policy, transport mode, generation settings, timeout,
retry policy, concurrency — deliberately excluding model identity, which is
the one thing that's supposed to differ) matches the candidate run's.
Mismatched hashes → the comparison is marked invalid and its promotion
metrics are suppressed, but the raw run artifacts are kept, not discarded —
they remain useful for later re-analysis even when this particular run
can't support a promotion decision.

**Metrics captured per model** (full detail in harness scope §4 — this is
the summary):

- **Overall accuracy** (abstention/`not_applicable`/malformed output counts
  as incorrect) always reported paired with **selective accuracy and
  coverage** (accuracy only where the model gave a credit decision, plus
  how often it did) — never one without the other, so abstaining on hard
  cases can't inflate the headline number.
- Confusion matrix by gold label, macro-F1/balanced accuracy, FP/FN rates
  separately, point-weighted agreement, whole-response exact match (all
  rubric criteria with gold labels, not just the benchmark-selected subset).
- `unable_to_determine` rate and malformed/schema-non-conforming output
  rate.
- Paired bootstrap confidence intervals for candidate-minus-baseline
  differences.
- Stability/flip rate on a fixed subset (same model, run twice).
- Cost per item (every charged attempt, not only successes) and latency
  (p50/p90/p95/mean/max, first-attempt and total-with-retries, retry rate,
  timeout rate, schema-failure rate).
- Regression suite: pass/fail per case, actual model output quoted.
- Feedback quality — method **not yet decided**, see Open Decisions.

**Output format:** one side-by-side table, candidate vs. same-session
production baseline, across every metric above, plus the full provenance
block (harness scope §7: hashes, resolved model version, ordering seed,
pricing snapshot).

## Regression Suite

Current cases live in `docs/architecture/
grading_model_assessment_regression_suite.json` (5 cases as of 2026-07-11,
sourced from real findings in the TASK-0016 Phase C review, independently
re-verified by hand — not just relayed from a model's own claim). This is
being expanded per harness scope §8 to cover a broader range of response
shapes (correct-verbose, partially-correct, contradictory, multi-criterion,
prompt-injection-like text, malformed/empty/long responses, evidence-quoting
quality) plus a private holdout suite kept separate from iterative tuning.

## Decision bar

Human approval (David) remains the final gate. **Materiality thresholds must
be defined before viewing candidate results** — e.g. zero regression-suite
failures, a bounded accuracy non-inferiority margin vs. the same-session
baseline, and explicit cost/latency improvement requirements. Defining the
bar before looking at the numbers is what keeps this a real gate rather than
post-hoc rationalization of whichever model looks appealing after the fact.
The specific thresholds are not yet set — see Open Decisions.

## Open Decisions (need resolving before "run the tests" is a literal
one-command action)

1. **Corpus freeze.** The natural source is the AP Statistics gold-set
   package once it clears human/Product-Owner adjudication (currently
   staged as draft content, pending). Size TBD — starting point suggestion:
   30-50 items, stratified per harness scope §5, large enough for a stable
   accuracy read and meaningful bootstrap intervals, small enough to run on
   demand without a major cost/time commitment. Until this is frozen,
   Grader Challenger's representative-corpus component isn't runnable —
   only Placement Test's regression suite is available today.
2. **Harness.** Not yet built. Requires the shared grading contract
   extraction (harness scope §2) first — that's the change that makes a
   direct, non-duplicated import of production's prompt/schema logic
   possible, rather than a parallel reimplementation that can drift. Until
   this exists, running "the grading model tests" means manually executing
   this protocol's steps when asked, not a single automated command.
3. **Feedback-quality evaluation method.** Manual spot-check by David on a
   small N, or an LLM-judged rubric (grounded-in-evidence, no invented
   criteria, minimum-fix specificity)? Recommend starting manual — automating
   a judge is its own experiment and shouldn't block getting this protocol
   running.
4. ~~Label normalization policy~~ — **resolved** (harness scope §1, v3):
   binary `full_credit`/`not_full_credit` scale, with overall accuracy
   (abstention/`not_applicable`/malformed output counted as incorrect, not
   excluded) always reported paired with selective accuracy and coverage,
   so a model can't inflate its apparent accuracy by abstaining on hard
   cases. Fractional credit deferred as a separate, out-of-scope product
   migration.
5. **Specific materiality thresholds** for the decision bar above — the
   principle (define before viewing results) is settled; the actual numbers
   (non-inferiority margin, cost/latency improvement requirements) are not.

## Next step

Begin implementation now by extracting the shared grading contract (harness
scope §2), then build the regression-suite-only Placement Test around it.
Neither step depends on the AP Statistics gold set being frozen. In parallel,
finish adjudication and the committed response-level sample manifest; those
remain prerequisites for Grader Challenger, not for the initial harness or
Placement Test. This sequence turns "run the grading model tests on `<model>`"
into a real command as early as possible without weakening the full-run gate.
