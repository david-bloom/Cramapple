# AP Calculus BC Unit 10 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record is the migration `supabase/migrations/20260826173616_ap_calculus_bc_unit10_topic_guides.sql` and the `app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Calculus BC Unit 10 (Infinite Sequences and Series).

Source basis: `docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md` Unit 10. Unit 10 is BC-only and exam-assessed at 15-20%.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 10.1 | Defining Convergent and Divergent Infinite Series | point brief + Learn More explainer |
| 10.2 | Working with Geometric Series | point brief + Learn More explainer |
| 10.3 | The nth-Term Test for Divergence | point brief + Learn More explainer |
| 10.4 | Integral Test for Convergence | point brief + Learn More explainer |
| 10.5 | Harmonic Series and p-Series | point brief + Learn More explainer |
| 10.6 | Comparison Tests for Convergence | point brief + Learn More explainer |
| 10.7 | Alternating Series Test for Convergence | point brief + Learn More explainer |
| 10.8 | Ratio Test for Convergence | point brief + Learn More explainer |
| 10.9 | Absolute and Conditional Convergence | point brief + Learn More explainer |
| 10.10 | Alternating Series Error Bound | point brief + Learn More explainer |
| 10.11 | Taylor Polynomial Approximations of Functions | point brief + Learn More explainer |
| 10.12 | Lagrange Error Bound | point brief + Learn More explainer |
| 10.13 | Radius and Interval of Convergence of Power Series | point brief + Learn More explainer |
| 10.14 | Taylor and Maclaurin Series for a Function | point brief + Learn More explainer |
| 10.15 | Representing Functions as Power Series | point brief + Learn More explainer |

## Content Notes

- The Learn More mini-examples are Cramapple-original and avoid copied released or official prompt language.
- The content keeps the assessed convergence-test toolkit to the six named tests in the CED exclusion statement.
- Topics 10.14-10.15 follow the fact pack's lower-confidence note because the relevant 2026 released FRQ has no scoring guide as of the fact-pack update.
- The migration includes QA checks for row counts, pairing, unit alignment, route alignment, core-field duplication, and exact explainer-field duplication.
