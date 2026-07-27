# QA Findings — TASK-0016 Phase A (Grading Router + Typed Formula/ECF Engines)

**Reviewer:** Claude (independent QA per `CODEX_TASK0016_PHASE_A_QA_REVIEW.md`)
**Date:** 2026-07-08
**Scope reviewed:** working-tree diff vs `main` — `_shared/grading-router.ts`,
`_shared/math-verifier.ts`, `_shared/formula-notation.ts`,
`_shared/statistics-verifier.ts`, `_shared/grading-feedback.ts`,
`evaluate-attempt/index.ts`, migrations `…0005`–`…0010`, integration note.
**Authority:** proposes verdict + findings only; David is final approver.

## Proposed verdict: **FAIL** (fixable; shadow-first wiring prevents live harm)

Three **blocking correctness bugs in the core symbolic verifier**, each
empirically reproduced against the actual module. All three violate the
deterministic layer's reason for existing (100% specificity / never false-flag
correct work, and don't credit wrong work). They are currently **contained to
shadow mode** — `symbolic_ecf` items route to `buildShadowReviewPayload` with
`finalStatus="uncertain"` (`evaluate-attempt/index.ts:1259-1281`), so no
learner-facing score is emitted today — but they **will corrupt the Phase C
gold-set calibration** (which measures this engine) and **become learner-facing
at limited release** (semi/no human review, per `APPROVAL-0033`). Fix before the
engine's verdicts are trusted.

## Blocking findings

### B1 — ECF false-flags correct work that lacks itemized substitutions
`math-verifier.ts:646` (`workSupports` initialized `false`), used two-state at
`:689` and `:703`. The Python reference (`ecf_engine.py`) uses a **tri-state**
(`None` = unknown) and only triggers `COINCIDENTAL`/`INCORRECT` when work-support
is *explicitly* `False`. In the port, absence of `shown_subs` (unknown) is
conflated with "work contradicts the answer."
**Repro (verified):** part `SE`, `canonical_formula "s/sqrt(n)"`, student
`{stated_formula:"s/sqrt(n)", shown_subs:null, student_answer:21.90890}` →
verdict **`COINCIDENTAL`, 0/1** (expected `CORRECT`). A student with the right
formula and right number scores zero. Specificity violation.

### B2 — Unary minus binds tighter than exponent (wrong operator precedence)
`math-verifier.ts:278-287` (`parsePower` uses `parseUnary` as its base) with
`:289-299`. Standard math / AP / SymPy: `-2**2 = -4`; this parser yields `+4`.
**Repro (verified):** `checkFormulaCase({kind:"numeric",canonical:"-2^2",
response:"-4"})` → **`FLAG`** (correct answer rejected); `response:"4"` →
**`PASS`** (wrong answer credited); `expression "-x^2"` vs `"0 - x^2"` →
**`FLAG`** though equal. Both over- and under-credits; triggerable by any
leading-unary-minus power (`-b^2`, `-kx^2`, variance terms).

### B3 — Multivariable equivalence samples one line, not the space
`math-verifier.ts:465-471`: every free variable is set to the *same* scalar
`sample` plus a fixed per-name offset, so variables are perfectly correlated
(e.g. `y` is always `x + 0.03125`). The reference samples each symbol
**independently**. Non-equivalent multivariable expressions that coincide on that
single diagonal falsely pass.
**Repro (verified):** `expression "y"` vs `"x + 0.03125"` → **`PASS`**;
`"x - y"` vs `"-0.03125"` → **`PASS`** (both non-equivalent). Over-credit on
exactly the multivariable forms the engine targets (two-sample statistics,
physics). (Truly-equivalent forms still pass, so this one does not false-flag —
it under-discriminates.)

## Non-blocking risks / test gaps

- **Test suite (33/33 green) misses all three specificity cases.**
  `math-verifier_test.ts` covers the reference battery, the `3t^2/2t` ABSTAIN
  hazard, and the ECF happy-path *with* `shown_subs`, but has **zero** cases for
  no-`shown_subs` ECF, unary-minus power precedence, or multivariable
  non-equivalence. Green tests here do not mean the specificity property holds.
- **ECF path is latent until per-part extraction lands.** `coerceEcfQuestion`
  returns `null` for free-text responses (no per-part `{student_answer}`), so
  today many structured items fall back to the shadow summary; B1's real-world
  bite scales up when the extraction feeding ECF is wired.
- **Integration note internal inconsistency:** the "Decision" bullet says the
  symbolic+ECF boundary is "expected to be a separate verifier service," but the
  code ships an in-process TS port (as the later "Phase A implementation note"
  admits). Reconcile the framing.
- Did **not** exhaustively diff the 394/272-line `evaluate-attempt` change for
  byte-identical discrete-text output; router logic + tests indicate the
  discrete-text/legacy-FRQ path is preserved, but a targeted regression check on
  the LLM-path payload shape is advisable.

## What is correct (verified)

- **Router:** `mcq`/`discrete_text`/`structured_formula`/`spatial`/`holistic`
  route as intended; unsupported/missing metadata → shadow review, not error or
  silent pass (`grading-router.ts:140-147`; tests pass).
- **Shadow-first containment:** `symbolic_ecf` and `shadow_review` both →
  `buildShadowReviewPayload`, `finalStatus="uncertain"` — no learner-facing
  automated score (§4.5 respected).
- **ABSTAIN-on-ambiguity:** `3t^2/2t` → `ABSTAIN` (tested), not a false flag.
- **Verdict set, naked-answer→help, and the AP Statistics keys** are ported
  faithfully from the Phase B payload; migration adds the verifier-pin columns;
  `git diff --check` clean; 33/33 tests pass.

## Required remediation (hand back to Codex)

1. **B1:** make work-support tri-state (`unknown|true|false`); only
   `COINCIDENTAL`/`INCORRECT` on explicit `false`. Add a no-`shown_subs`
   correct-answer test asserting `CORRECT`.
2. **B2:** fix precedence so `^` binds tighter than unary minus (unary operand =
   `parsePower`; power base = `parsePrimary`). Add `-2^2 = -4` test.
3. **B3:** draw each variable independently per sample (match
   `formula_checker.py`). Add a multivariable non-equivalence test
   (`y` ≠ `x + c`).
4. Backfill the three specificity regression tests so "green" means trustworthy,
   then re-request QA.

---

## Re-review (2026-07-08, after Codex fix — `CODEX_TASK0016_PHASE_A_QA_NOTE`)

**Upgraded verdict: PASS on the three blocking findings**, with one required
non-blocking follow-up (F1). All three fixes verified independently against the
live module (not from the note), plus adversarial cases in both directions.

| Finding | Status | Evidence |
| --- | --- | --- |
| B1 ECF false-flag (no `shown_subs`) | **FIXED** | correct answer w/o subs → `CORRECT`; a genuine coincidental (work=4, wrote 5) still → `COINCIDENTAL` (not over-corrected). Test at `math-verifier_test.ts:127`. |
| B2 unary-minus vs `^` precedence | **FIXED** | `-2^2` → PASS on `-4` / FLAG on `4`; `-3^2=-9`; `-x^2 ≡ 0-x^2`; `(-2)^2=4` still PASS. Base now `parsePrimary` (`:279`). Test at `:163`. |
| B3 non-independent sampling | **FIXED — no new false-flags** | `y≠x+0.03125` and `x-y≠-0.03125` now FLAG; and the equivalent multivariable pairs `a*b≡b*a`, two-sample SE forms, and range double-angle **still PASS** (checked deliberately). Test at `:183`. |

35/35 tests pass; `git diff --check` clean.

### F1 (required, non-blocking, safe-direction) — negative exponents now ABSTAIN
The B2 fix set the exponent operand to `parsePower` (`math-verifier.ts:283`),
which starts at `parsePrimary` and cannot accept a signed exponent. So bare
negative exponents fail to parse:
**Repro (verified):** `2^-1`→ABSTAIN(`parse_error:unexpected_token`),
`x^-1`→ABSTAIN, `k*Q/r^2` vs `k*Q*r^-2`→ABSTAIN; parenthesized `2^(-1)` and
`x^(-1)` PASS. This is **safe-direction** (ABSTAIN routes to human; no wrong
grade, so the specificity property is intact) — hence non-blocking — but it
silently drops coverage on common notation (`r^-2`, `t^-1`, `n^-1`, physics).
**Fix:** change `:283` `const rhs = this.parsePower();` → `this.parseUnary();`
(exponent operand should be a unary expression; keeps `-2^2 = -(2^2)` and
right-associativity). Add a `2^-1 = 0.5` / `x^-1 ≡ 1/x` regression test.
**Launch impact:** the AP Statistics keyed items use `sqrt(...)` / `**2`, no bare
negative exponents, so this does **not** block the Statistics-first launch; it
does matter for the later physics SKUs.

**Bottom line:** the three specificity bugs that caused the FAIL are resolved and
tested; Phase A can move forward. Land F1 before the formula engine's coverage is
measured or relied on (and before physics content).

---

## Post-commit check — `8f79ebe` "TASK-0016 Phase A grading verifier fixes"

The three blocking fixes (B1/B2/B3) are in the commit and verified. **Two items
are NOT resolved in this commit:**

### F2 (blocking for deploy) — the committed code depends on migrations that were left untracked
`8f79ebe` committed `evaluate-attempt/index.ts` and migration `…0010`
(verifier pins) **only**. But the committed edge function references five columns
whose migrations (`…0005`,`…0007`,`…0008`,`…0009`) are **still untracked** in the
working tree:
- `content_item_versions.rubric_type` / `evaluator_strategy` — SELECTed at
  `evaluate-attempt/index.ts:796`, read at `:933-934` (migration `…0005`).
- `grading_results.feedback_preview` / `action_hint` / `repair_hint` — written at
  `:358-360`, `:1487-1489` (migrations `…0007/0008/0009`).
On a fresh database / CI / deploy, the SELECT and the writes fail because the
columns don't exist. **Fix:** commit `…0005`–`…0009` (they already exist in the
working tree) alongside the code. Verified via `git ls-files` (all five report
untracked) and column defs (`add column … rubric_type/evaluator_strategy/
feedback_preview/action_hint/repair_hint`).

### F1 (still open) — negative-exponent regression not fixed
`math-verifier.ts:283` still reads `this.parsePower()`. Re-probed on the
committed tree: `2^-1`, `x^-1`, `k*Q/r^2` vs `k*Q*r^-2` → **ABSTAIN
(`parse_error`)**; parenthesized forms PASS. Safe-direction (still no wrong
grade); unchanged recommendation — one-line fix before physics coverage.

### Handoff note accuracy
`CODEX_TASK0016_PHASE_A_HANDOFF_2026_07_08.md` presents Phase A as complete and
does not mention F1 or the untracked migrations — reconcile before the handoff is
treated as closed.
