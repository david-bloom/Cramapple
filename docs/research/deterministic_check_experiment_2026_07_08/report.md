# Deterministic Numeric-Check Experiment — Report, 2026-07-08

**Experiment:** #1 of the post-silver-packet battery (assessment 2026-07-08)
**Status:** Completed, reproducible
**Related:** DECISION-0034 (deterministic-check layer), `../grading_cross_subject_takeaways.md` (Lesson 3), `AP_CHEMISTRY_VERIFICATION_PROFILE.json`

## Run metadata

| Field | Value |
| --- | --- |
| Script | `checker.py` (this folder); deterministic, no API calls |
| Inputs | AP Chemistry full corpus (100 items, 300 responses, v2 wrong-reasoning) + AP Statistics gold-set slice (5 items, 20 responses) |
| Sample | 320 responses; 222 on numeric-keyed items, 98 on conceptual items |
| Read tier | Decision-grade by sample size for the *checker-mechanics* claim; results are on **synthetic/silver** data, so they bound the checker's behavior, not a production release |
| Cost | $0 (pure Python, single-digit ms/response) |

## What the checker does

For each item, a per-item key encodes the **correct** answer(s) recomputed from
the question's givens (exactly what a `verification_profile` carries). The
checker extracts *result* numbers from a response (dropping operands so an
intermediate like a `pKa` isn't mistaken for the final answer) and flags the
response if a keyed answer is missing. It never inspects what wrong value a
response contains, so it detects **any** numeric error, not a pre-known one.
Conceptual items carry no key → the checker **abstains** (correctly out of
scope; those are the language-model grader's job).

## Integrity gate

- [x] Specificity measured on canonical answers (69 numeric canonicals).
- [x] Extractor hardened after two false-negatives were found and fixed during the run: (1) it matched an operand (`pKa 4.74`) as if it were the answer `4.67`; (2) it matched `-800` from `(850-800)` to the CI bound `807`. Both fixed by result-only extraction + binary-operand exclusion; specificity re-confirmed at 100% afterward.
- [x] No API/cost fields (deterministic).

## Results

| Metric | Value |
| --- | ---: |
| Canonical answers on numeric items — PASS (specificity) | 69/69 = **100%** |
| False flags on correct answers | **0** |
| Wrong responses on numeric items — FLAGGED (detection) | 97/153 = **63.4%** |
| Wrong responses on numeric items — PASSED | 56 |
| Conceptual-item responses — all ABSTAIN | yes (98/98) |
| Verdict counts (all 320) | PASS 125, FLAG 97, ABSTAIN 98 |

### Interpreting the 63.4%

The 56 "passed" wrong responses are **not** misses — they are responses whose
**numbers are correct** and whose error lives in the *reasoning* (out of a
numeric checker's scope, correctly deferred to the LLM grader):

- ~42 are `borderline` variants, which by construction have correct numbers and
  a thin-reasoning flaw.
- ~13 are `partially_correct`/`subtly_wrong` variants whose stated final number
  is right but whose conceptual claim is wrong (spot-verified: e.g., L-036 gets
  pH 9.25 right but its dilution claim is wrong; L-042 gets both pH values right
  but reverses the inductive-effect explanation).
- **1 characterized limitation:** L-032 `partially_correct` displays *both*
  quadratic roots and selects the wrong one; presence-checking cannot catch
  "picked the wrong root when both are shown." This is the deterministic layer's
  boundary — a case for the LLM grader.

So on responses whose error is genuinely numeric, detection is essentially
complete; the residual is one edge case.

## Why this matters

Every caught error is a **confidently-wrong-but-complete numeric answer** — the
exact failure mode a model's self-reported confidence cannot catch (Takeaways
Lesson 4), caught here at zero API cost and ~0% false-positive rate on correct
work. Concretely, the checker flags the AP Statistics SE error
(`120/30` vs `120/√30`), the miscomputed two-sample t (`1.86` vs `2.06`), the
van't Hoff `i=2` for CaCl2, the Hess's-law un-halved sum, Graham's law without
the square root, and dozens more — before any model call.

## Claims supported / not supported

**Supported:** a per-item deterministic numeric checker achieves 100%
specificity (0 false flags on 69 correct answers) and catches the numeric-error
class at $0; it correctly abstains on conceptual items; the caught errors are
confidently-wrong-but-complete cases self-confidence misses. The per-item keys
are the concrete content a subject `verification_profile` must carry.

**Not supported:** any claim on non-numeric (judgment) criteria — those are out
of scope by design. No production/release claim — this is synthetic silver data;
the keys are hand-encoded and would, in production, be authored into the
question package and independently validated. No claim that the extractor is
robust to all prose forms — two real extraction bugs were found and fixed during
this run; it should be re-validated on any new corpus (same caution as the
Biology misattribution parser).

## Recommended follow-through

1. Promote the per-item keys into the subject verification profiles as the
   deterministic layer's content (Chem first — 50 numeric items keyed here).
2. Build the equivalent for AP Statistics (the 3 numeric gold items are keyed;
   extend to the bootstrap corpus).
3. In production, run this check *before* the LLM grader on any criterion it can
   decide, and route only the residual (conceptual + wrong-root-type edges) to
   the model.
