# AP Calculus BC Unit 9 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record is the migration `supabase/migrations/20260826154746_ap_calculus_bc_unit9_topic_guides.sql` and the `app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Calculus BC Unit 9 (Parametric Equations, Polar Coordinates, and Vector-Valued Functions).

Source basis: `docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md` Unit 9. Unit 9 is BC-only and exam-assessed at 10-15%.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 9.1 | Defining and Differentiating Parametric Equations | point brief + Learn More explainer |
| 9.2 | Second Derivatives of Parametric Equations | point brief + Learn More explainer |
| 9.3 | Arc Lengths of Parametric Curves | point brief + Learn More explainer |
| 9.4 | Defining and Differentiating Vector-Valued Functions | point brief + Learn More explainer |
| 9.5 | Integrating Vector-Valued Functions | point brief + Learn More explainer |
| 9.6 | Motion Problems Using Parametric and Vector-Valued Functions | point brief + Learn More explainer |
| 9.7 | Defining Polar Coordinates and Differentiating in Polar Form | point brief + Learn More explainer |
| 9.8 | Area of a Polar Region or the Area Bounded by a Single Polar Curve | point brief + Learn More explainer |
| 9.9 | Area of the Region Bounded by Two Polar Curves | point brief + Learn More explainer |

## Content Notes

- The Learn More mini-examples are Cramapple-original and avoid copied released or official prompt language.
- Topics 9.1-9.6 follow the fact pack's lower-confidence note because recent released BC FRQs emphasize polar items, while 9.7-9.9 are grounded in BC-specific polar FRQ scoring evidence.
- The migration includes QA checks for row counts, pairing, unit alignment, route alignment, core-field duplication, and exact explainer-field duplication.
