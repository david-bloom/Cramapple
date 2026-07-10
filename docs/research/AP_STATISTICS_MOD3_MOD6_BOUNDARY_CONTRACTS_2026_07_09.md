# AP Statistics MOD3/MOD6 Boundary-Contract Resolutions — 2026-07-09

**Scope:** the two open boundary questions listed in
`ap_statistics_gold_set_candidate_2026_07_08/adjudication_workflow.md` ("MOD3
z-versus-t boundary question", "MOD6 sign-sensitive t-statistic convention"),
plus the MOD8 corpus defect. Format follows the criterion-boundary contract
requirements in `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §9.1.

## 1. MOD3 — z* vs. t* critical value (`APSTAT-MOD3-H001-INV`, `ci_calculation`)

**The question:** the rubric's keyed CI (`850 ± 1.96(120/√30)` → `(807, 893)`)
uses the z-critical value 1.96. Population SD is unknown (estimated from the
sample), so the AP-correct method is a **t-interval** with `df = n − 1 = 29`,
`t* ≈ 2.0452`, giving `(805.19, 894.81)` — a numerically different interval. A
student who correctly reasons "SD is estimated, use t*" should not be penalized
for producing a different-looking bound than the keyed z-based answer.

**Resolution: no code change required — already covered by tolerance.**

`statistics-verifier.ts`'s `matchesTarget` uses a 2% relative tolerance
(`DEFAULT_REL_TOL = 0.02`) per keyed value. Computed:

| Bound | z*-based (keyed) | t*-based (df=29) | Relative difference |
|---|---:|---:|---:|
| CI lower | 807.05856 | 805.19126 | 0.231% |
| CI upper | 892.94144 | 894.80874 | 0.209% |

Both are well inside the 2% band, so a t*-based response already **passes** the
deterministic check as currently coded — no behavior change needed.

**Decision rule (for the record, since this was previously undocumented):**
for large-`df` CI/test items (`df ≳ 25`), accept either the z-critical or the
t-critical value as correct method; do not require the student to justify the
choice, since both approximate the same interval within rounding. This does
**not** generalize to small-`df` items (e.g., `df < 15`), where z* and t* diverge
by more than the tolerance band — those need a per-item boundary decision, not
this blanket rule.

**Action:** add a regression test (`statistics-verifier_test.ts`) asserting a
t*-based response (`SE = 120/sqrt(30) = 21.9; CI = 850 ± 2.045(21.9) = (805.2,
894.8)`) passes for `APSTAT-MOD3-H001-INV`. This closes the "MOD3 z-versus-t
boundary question" open item.

## 2. MOD6 — sign convention on the two-sample t-statistic (`APSTAT-MOD6-H001`, `test_calculation`)

**The question:** `H₀: μ₁ = μ₂` vs. `H₁: μ₁ ≠ μ₂` is **non-directional** — the
item never specifies which group is "group 1." Subtracting `control − treatment`
gives `t ≈ −2.06`; subtracting `treatment − control` gives `t ≈ +2.06`. Both are
algebraically identical two-tailed tests reaching the same `p ≈ 0.043` and the
same "reject H₀" conclusion. The corpus's own `partially_correct` response uses
the flipped order and was provisionally judged **earned** ("sign flipped,
magnitude right").

**Current code is inconsistent with that provisional judgment — this is a real
bug, not yet fixed.** `statistics-verifier.ts` keys the test statistic as
`{ value: -2.06104, sign_sensitive: true }`. A response reporting `t = +2.06`
fails `matchesTarget`'s sign check today, and there is a committed regression
test (`statistics-verifier_test.ts:89`, "flags a sign-sensitive t-statistic that
has the wrong sign") that **locks in the false-flag** as intended behavior. That
test was written before this boundary question was raised in the adjudication
workflow; it now contradicts the corpus's own gold judgment.

**Recommendation (needs Product Owner sign-off before code changes):** drop sign
sensitivity for this item — check `|t| ≈ 2.061` regardless of sign, since the
hypothesis is non-directional and either subtraction order is a valid, complete
answer. This is different from `APSTATS-SFRQ-003`/`-004` (residual sign), where
`sign_sensitive: true` is correct because a residual's sign is not
interchangeable — it encodes over- vs. under-prediction, a real distinction the
rubric grades. The MOD6 case is purely a labeling artifact of which group the
student called "1" vs. "2."

**If approved, the fix is:**
1. `statistics-verifier.ts`: change the MOD6 target to
   `{ value: 2.06104 }` (drop `sign_sensitive`) — `matchesTarget` already
   compares `Math.abs(candidate)` to `base`, so dropping the flag alone
   accepts either sign.
2. `statistics-verifier_test.ts:89`: rename/rewrite the existing test to assert
   `t = +2.06` **passes** rather than flags (its current assertion is the thing
   being corrected), and add a companion test that a genuinely wrong magnitude
   (e.g., `t = 1.86`, the known-wrong response) still flags regardless of sign.

**I have not made this code change** — it changes live grading behavior for a
committed regression, so it needs your explicit go-ahead per governance
(boundary-contract revisions are a C2 change, `CONTENT_GOVERNANCE_AND_VALIDATION.md`
§16.3).

## 3. MOD8 — corpus defect, no dataset (`APSTAT-MOD8-H001`)

Already flagged in the candidate README; restating with a concrete resolution
path since it blocks promotion to `adjudicated_gold`:

**Problem:** the item asks students to compute `r` and a regression line from a
dataset of 25 students, but no dataset is attached to the item. Responses
fabricate plausible-looking values (`r ≈ 0.75–0.82`); method can be graded,
values cannot.

**Two resolution paths — recommend (a):**

**(a) Scope the rubric to method-only (fast, no new content needed).** Rewrite
the three criteria's `evidence_requirements` to explicitly grade *procedure*, not
*numeric value*:
- `correlation_calculation`: earns if the response states the correct formula
  application steps (uses `Σ(x−x̄)(y−ȳ)` over `√[Σ(x−x̄)²Σ(y−ȳ)²]`, or
  equivalent), regardless of the specific `r` produced.
- `regression_equation`: earns if `b = r(sy/sx)` and `a = ȳ − b·x̄` are applied
  correctly to whatever `r`, `sy`, `sx` the response asserts (self-consistency
  check instead of a fixed-value check).
- `interpretation`: unchanged — already method/context-based, not value-based.

This keeps the item usable for calibration immediately, at the cost of never
being able to deterministically-check this item's numbers (acceptable — Engine 1
already abstains on it; see `STATISTICS_TARGETS["APSTAT-MOD8-H001"] = null`).

**(b) Attach a real dataset (slower).** Requires Learning Quality/content authoring
to generate or source 25 `(x, y)` pairs, recompute the four responses' `r`/
regression values against real data, and re-derive the "fully_correct" response
text. More expensive, but makes the item deterministically checkable and
sharper for calibration (a wrong `r` becomes checkable, not just "asserted").

**Recommendation:** do (a) now to unblock Phase C promotion on the current
slice; queue (b) as a fast-follow only if MOD8-style items recur often enough in
the launch-bar expansion to be worth deterministic coverage.

## Summary — all three approved 2026-07-09

| Item | Status | Outcome |
|---|---|---|
| MOD3 z-vs-t | **Resolved** — no code change, tolerance already covers it | Regression test added (`statistics-verifier_test.ts`); open item closed |
| MOD6 sign convention | **Approved** (Product Owner, 2026-07-09) | `sign_sensitive` dropped in `statistics-verifier.ts` + `statistics_item_keys.json`; tests rewritten to assert either sign passes, wrong magnitude still flags; `validate_keys.py` updated to compare magnitude when a part isn't explicitly sign_sensitive (8/8 integrity, 3/3 ECF pass) |
| MOD8 no dataset | **Approved** (Product Owner, 2026-07-09) — path (a) | Rubric scoped to method-only/self-consistency grading; see corpus + provisional-labels updates |

## 4. MOD6-H007 — halved-width confidence level content defect

**Problem:** `APSTAT-MOD6-H007` asked what confidence level results from
halving the width of a 90% confidence interval. The provisional rubric and
`fully_correct` synthetic response said approximately 67%, but halving the
interval width halves the critical value: `z*_new = 1.645 / 2 = 0.8225`, so the
two-sided confidence level is `2Phi(0.8225)-1 ≈ 0.5892` (about 58.9%).

**Resolution:** corrected the rubric and synthetic `fully_correct` response in
`ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json` to the
58.9% value. The deterministic key already used `canonical_answer: 0.58921`,
and `validate_keys.py` now passes with the corrected content.
