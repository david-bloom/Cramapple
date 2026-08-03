# Engine 3 Harness — Run 1 Results

**Date:** 2026-07-28
**Scope:** Checker-level test of the production ECF state machine
(`supabase/functions/_shared/math-verifier.ts`) against computed fixtures.
**Cost:** $0 — the harness ran locally in Deno with no API or Supabase calls.
**Writes:** none — no Production or Dev data was modified. (In production the
deterministic path costs $0 in *model* tokens; edge-function compute and DB I/O
are still real infrastructure costs. The avoided model cost is Stage 6's
measured **$0.00389/FRQ** — about $58 across a 15,000-grading beta. Cost was
never the binding constraint; latency is.)
**Headline:** **3 previously-undetected production bugs**, one of which silently
mis-grades a **published, tutor-approved** AP Statistics item.

---

## 1. What was run

- **Fixture generator** (`scripts/engine3-harness/build_fixtures.py`) — reads the
  28 firing-capable verification profiles and constructs response fixtures that
  drive every one of the six ECF verdicts, with the expected verdict known **by
  construction**. Expectations are evaluated with **SymPy**, deliberately *not*
  with the TypeScript parser under test, so a parser bug surfaces as a
  disagreement instead of being baked into both sides.
- **Harness** (`scripts/engine3-harness/run_harness.ts`) — feeds each fixture
  through the **real production module** via the same
  `coerceEcfQuestion` → `buildEcfResult` path `evaluate-attempt` uses.

| | |
|---|---:|
| Profiles covered | 28 of 28 firing-capable |
| Cases | 131 |
| Part-level expectations | 211 |
| **Pass** | **187/211 = 88.6%** |
| Pass excluding items hit by Bug 1/3 | **170/174 = 97.7%** |
| `coerceEcfQuestion` rejections | 0 |

**Every one of the 24 mismatches is attributable to one of three named bugs.**
None are unexplained.

## 2. Latency — what was and was NOT measured

> **CORRECTED 2026-07-28.** An earlier version of this section reported
> "~45,000x faster" by comparing these two rows directly. That was misleading:
> they do not measure the same quantity. Corrected below.

| Measurement | p50 | p90 | max | what it times |
|---|---:|---:|---:|---|
| **Engine 3 checker** | **0.043 ms** | 0.272 ms | 2.477 ms | pure CPU — parse, evaluate, compare. Local Deno, **zero I/O** |
| Engine 1, per-criterion call | 1,428 ms | 2,188 ms | 12,024 ms | network to gateway + inference + stream back |
| Engine 1, per-item (max-of-N) | 1,943 ms | 2,866 ms | 12,024 ms | slowest of the parallel criterion calls |

The checker figure is **CPU-only**. It excludes HTTP from the student device,
auth, DB reads (content version, criteria, profile), DB writes
(`grading_results`, attempt rows), edge-function invocation and cold start, and
response/render. **That overhead is unmeasured** — quantifying it is a primary
purpose of the integration test.

**The defensible claim:** the deterministic verdict contributes essentially
nothing to the request budget, removing the ~1,400-1,900 ms model component. It
does **not** mean a request returns in 0.043 ms. Whether a fully-deterministic
item clears the 1,000 ms bar depends on the app-shell overhead nobody has
measured yet.

## 3. Bug 1 — Reserved-name collision silently corrupts arithmetic (SEVERITY: HIGH)

`CONSTANT_NAMES = new Set(["e", "pi", "C", "c"])`. The parser binds `e` to
Euler's number and `pi` to π **even when they are supplied as givens**, silently
ignoring the student's and the profile's actual values.

**Minimal reproduction:**

```
formula (a+b+c+d+e)/5 with a=12, b=15, c=18, d=21, e=24
  true mean                     = 18
  checker computes              = 13.7437
  (66 + Math.E)/5               = 13.743656...   <-- e bound to 2.71828
  verdict: INCORRECT (0 of 1 points)
```

Confirmed per-name: `e` → corrupted, `pi` → corrupted, `c` and `C` → unaffected
(input substitution wins for those).

**Blast radius:** 5 parts across **3 of 28** firing-capable profiles —
`APSTAT-MOD5-M001`, `STATS-MOD1-E004`, `STATS-MOD1-M002` — all of which use
`e` as the fifth data value in a five-number mean/SD.

**`STATS-MOD1-E004` is `published`, `question_review_approved`, tutor `approve`.**
Had Engine 3 been routed and live, a student correctly answering 18 to
"calculate the mean of 12, 15, 18, 21, 24" would be marked **INCORRECT**, with
feedback asserting their arithmetic gives 13.7437.

This is the worst failure shape: silent, confident, and against the student.

**Fix options:** treat a name as a constant only when it is *not* present in the
supplied inputs (recommended — inputs should always win); or reserve the
namespace and forbid `e`/`pi` as variable names at profile-validation time. The
validator should enforce whichever is chosen.

## 4. Bug 2 — ECF credit granted where no dependency exists (SEVERITY: HIGH)

A part with **no `deps`** and an **empty `shown_subs`** that is simply *wrong*
receives **`CORRECT_VIA_ECF` — full marks**.

```
profile: APSTAT-MOD3-E001, part pct_within_1sd
  canonical_formula "68", givens {}, canonical_answer 68
  student_answer 92.5   (wrong by any measure)
  verdict: CORRECT_VIA_ECF, 1 of 1 points
  feedback: "Your value from an earlier part was off, but your setup ...
             — full credit"
```

There is no earlier part. The feedback is not merely wrong, it invents a
justification.

**Mechanism:** with empty `shown_subs`, the guard
`if (stated && shownSubs && Object.keys(shownSubs).length > 0)` never runs, so
`workSupports` stays `null`. Both the `COINCIDENTAL` and `INCORRECT` branches
test `workSupports === false`, so both are skipped, and control falls through to
the terminal `else` which awards `CORRECT_VIA_ECF` unconditionally.

**Blast radius:** any part with no dependencies whose response carries no
substitutions — 4 profiles in this set, but structurally it applies to **every
constant-answer or single-step keyed part**, which is the most common shape in
the bank.

**Fix:** the terminal `else` must require that the part actually has `deps` AND
that at least one upstream value diverged. Absent that, a non-matching answer is
`INCORRECT`.

## 5. Bug 3 — Parser lacks `erf` and `factorial` used by shipped profiles (SEVERITY: MEDIUM)

`FUNCTIONS = {sin, cos, tan, exp, log, sqrt, abs}`. Two profiles depend on
functions outside that set:

| profile | canonical_formula |
|---|---|
| `APSTAT-MOD6-H007` | `erf((1.645 / 2) / sqrt(2))` |
| `APSTAT-MOD7-H005` | `factorial(20) / (factorial(8) * factorial(12)) * (0.4**8) * (0.6**12)` |

The canonical formula fails to parse, and the failure path emits
**`NAKED_ANSWER`** — so a fully correct student with complete work is told *"No
work shown … Opening help."* The diagnosis is not just wrong, it is misleading.

**Fix:** add `erf`/`factorial` to the parser, or have profile validation reject
formulas using unsupported functions so the gap is caught at authoring time
rather than at grading time. Recommend both.

## 6. One fixture bug of my own, found and corrected

The first run showed 19 additional mismatches expecting `CORRECT` where the
checker said `INCORRECT`. **That was my error, not the checker's.** In the
arithmetic-slip case I had downstream parts reuse the *canonical* upstream value
while the student's own earlier answer was wrong. The checker correctly requires
`shown_subs` dependency values to match the student's **own** prior answer, and
flags the inconsistency. The fixture now expects `INCORRECT` there, and the case
is renamed `inconsistent_upstream_reference` to describe what it actually tests.

Recording this because the distinction matters: **the checker's behaviour was
right and my expectation was wrong**, and a harness that could not tell those
apart would be worthless.

## 7. What this run does and does not establish

**Establishes:**
- The ECF state machine is sound on its core paths — **97.7%** on profiles not
  hit by Bugs 1 and 3, with `NAKED_ANSWER` handling at **100%** (44/44),
  including the DECISION-0034 naked-answer→help behaviour.
- The deterministic check itself costs ~0.04 ms of CPU and zero model tokens,
  so it adds nothing to the request budget — though end-to-end request latency
  for a deterministic item remains unmeasured (see 2).
- Three specific, reproducible, individually-fixable production defects.

**Does not establish** (unchanged from the scope):
- **Routing** — 0 of 1,316 items are tagged `symbolic_ecf`; the integration test
  still requires that write decision.
- **Authoritative output** — the path hard-codes `finalStatus = "uncertain"`.
- **Real student input** — no producer of structured `response_parts` exists.
- Any accuracy or launch-readiness claim.

## 8. Why the earlier "validated" status was misleading

Engine 3's components were recorded as validated: formula checker 62/62, ECF
engine 6/6, Statistics templates 7/7. Those batteries were real but **narrow** —
none of them included a variable named `e`, a wrong answer on a
no-dependency part, or a profile using `erf`/`factorial`. The components passed
the tests that existed; the tests did not cover the shapes the actual profiles
use.

**Durable lesson:** component batteries authored alongside the component test
what the author anticipated. A fixture generator derived from the **real profile
corpus** tests what the system will actually meet. The second found three bugs
the first missed, on its first run, for $0.

## 8b. RESOLUTION — all three fixed, 2026-07-28

| | before | after |
|---|---:|---:|
| Harness | 187/211 = 88.6% | **211/211 = 100.0%** |
| Existing unit tests | 9/9 | **13/13** (4 regression tests added) |

Fixes applied to `supabase/functions/_shared/math-verifier.ts`:

1. **Bug 1** — `evaluate()` now resolves a supplied input **before** any built-in
   constant name, so a data value named `e` or `pi` wins. Verified: the original
   repro `(a+b+c+d+e)/5` with `e=24` now returns **CORRECT, 1 of 1** instead of
   INCORRECT.
2. **Bug 2** — the terminal `else` now requires `upstreamDiverged`: the part must
   have `deps` **and** an upstream value that genuinely differs from canonical.
   A no-dependency wrong answer is now `INCORRECT` with honest feedback
   ("there is no earlier result to carry forward from"). A regression test
   confirms **genuine** carried-forward errors still earn `CORRECT_VIA_ECF`, so
   the fix did not over-correct.
3. **Bug 3** — `erf` (Abramowitz & Stegun 7.1.26, max abs error 1.5e-7) and
   `factorial` (exact for non-negative integers) added to the parser's function
   set and evaluator.

Four regression tests were added to `math-verifier_test.ts` so none of these
classes can silently return. The harness itself
(`scripts/engine3-harness/`) is now a standing regression suite: regenerate
fixtures with `build_fixtures.py`, run with
`deno run --allow-read --allow-write scripts/engine3-harness/run_harness.ts`.

**Not yet done:** these fixes are in the repo, **not deployed**. The edge
function still needs a deploy for them to reach Production — though nothing is
currently reachable anyway, since 0 items route to `symbolic_ecf`.

## 9. Recommended next actions

1. **Fix Bug 1** (inputs must win over constant names) — highest priority; it
   mis-grades a published item against the student.
2. **Fix Bug 2** (require real dependency divergence before ECF credit) — equal
   priority; it awards full marks for wrong answers.
3. **Fix Bug 3** (add `erf`/`factorial`, and reject unsupported functions at
   validation time).
4. **Re-run this harness** — it is now a permanent regression suite. Expect
   211/211.
5. Fold all three into the profile **validator** from the scope doc, so these
   classes cannot re-enter.
6. Only then proceed to the integration test (routing + `evaluate-attempt`),
   which still needs the environment and write decisions.
