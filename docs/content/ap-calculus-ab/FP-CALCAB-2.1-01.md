# Fact Pack FP-CALCAB-2.1-01 — Differentiation Rules

**Pack ID:** FP-CALCAB-2.1-01
**Pack-Version:** v01
**State:** Drafted
**Subject:** CALCAB
**Applies to:** [CALCAB, CALCBC]  *(BC reuses AB differentiation content)*
**Unit / Topic:** Unit 2 (Differentiation: Definition and Fundamental
Properties) — power, product, quotient, and chain rules *(confirm exact official
topic id against the current AP Calculus CED before Approved)*
**Author class:** ai_draft_human_reviewed (illustrative format example)
**Source status:** cramapple_authored
**Official-material boundary checked:** yes — established public-domain calculus
in original wording; no official question text or scoring material used
**Status note:** Illustrative Draft demonstrating the fact-pack format. NOT
production content, NOT calibration evidence.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §4.

## Entries

### E1 — concept `teaching_safe` (learner_visible_summary, authoring_brief)

The derivative `f'(x)` is the instantaneous rate of change of `f` — the slope of
the tangent line at `x`, defined as the limit of the difference quotient
`f'(x) = lim(h→0) [f(x+h) − f(x)] / h`. The rules below are shortcuts that follow
from this definition.

### E2 — formula_rule `teaching_safe` (grading_only, learner_visible_summary, authoring_brief)

- **Power rule:** `d/dx [xⁿ] = n·xⁿ⁻¹`.
- **Constant multiple / sum:** `d/dx [c·f] = c·f'`; `d/dx [f + g] = f' + g'`.
- **Product rule:** `d/dx [f·g] = f'·g + f·g'`.
- **Quotient rule:** `d/dx [f/g] = (f'·g − f·g') / g²`.
- **Chain rule:** `d/dx [f(g(x))] = f'(g(x))·g'(x)`.
- Common derivatives: `d/dx[sin x] = cos x`; `d/dx[cos x] = −sin x`;
  `d/dx[eˣ] = eˣ`; `d/dx[ln x] = 1/x`.

### E3 — worked_method `teaching_after_attempt` (authoring_brief)

Neutral worked example of the product + chain rules combined:

```text
f(x) = x²·e^(3x)
f'(x) = (2x)·e^(3x) + x²·(e^(3x)·3)      # product rule; chain rule on e^(3x)
      = e^(3x)·(2x + 3x²)                # factor
```

### E4 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the student differentiates a product as the
  product of the derivatives, `(f·g)' = f'·g'`.
- **Response signal:** for `x²·e^(3x)` writes `2x·3e^(3x)`.
- **Discriminating probe:** ask them to differentiate `x·x` two ways and compare.
- **Repair move:** "Use the product rule: `f'g + fg'`, not `f'g'`."
- **Minimum fix:** add the missing `f·g'` (or `f'·g`) term.

### E5 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** chain rule's inner derivative is omitted.
- **Response signal:** writes `d/dx[e^(3x)] = e^(3x)` (missing the factor 3).
- **Repair move:** "Multiply by the derivative of the inside function."

### E6 — boundary `grading_sensitive` (grading_only) — criterion "chain rule applied correctly"

- **Required evidence:** the response multiplies by the derivative of the inner
  function (e.g. the factor `3` for `e^(3x)`, or `2x` for `sin(x²)`).
- **Accepted:** the inner-derivative factor is present and correct, in any
  equivalent algebraic form.
- **Insufficient:** correct outer derivative with the inner-derivative factor
  missing or set to 1.

## Views

- **authoring_view:** E1–E6, full fields.
- **learner_view:** E1, E2, E3 (post-attempt) — definition, rule list, worked
  example; excludes E4–E6 pre-attempt.
- **grading_view:** E2, E4, E5, E6 — rules plus boundary/misconception entries;
  adds no criterion beyond the rubric.
