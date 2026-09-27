# AP Precalculus Unit 4 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record is the migration `supabase/migrations/20260826154201_ap_precalculus_unit4_topic_guides.sql` and the `app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Precalculus Unit 4 (Functions Involving Parameters, Vectors, and Matrices).

Source basis: `docs/product/AP_PRECALCULUS_CED_FACT_PACK.md` and `supabase/migrations/20260821280000_ap_precalculus_unit4_taxonomy_topics_seed.sql`. Unit 4 is course content but not AP Exam assessed, so exam importance is intentionally `not-important`.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 4.1 | Parametric Functions | point brief + Learn More explainer |
| 4.2 | Parametric Functions Modeling Planar Motion | point brief + Learn More explainer |
| 4.3 | Parametric Functions and Rates of Change | point brief + Learn More explainer |
| 4.4 | Parametrically Defined Circles and Lines | point brief + Learn More explainer |
| 4.5 | Implicitly Defined Functions | point brief + Learn More explainer |
| 4.6 | Conic Sections | point brief + Learn More explainer |
| 4.7 | Parametrization of Implicitly Defined Functions | point brief + Learn More explainer |
| 4.8 | Vectors | point brief + Learn More explainer |
| 4.9 | Vector-Valued Functions | point brief + Learn More explainer |
| 4.10 | Matrices | point brief + Learn More explainer |
| 4.11 | The Inverse and Determinant of a Matrix | point brief + Learn More explainer |
| 4.12 | Linear Transformations and Matrices | point brief + Learn More explainer |
| 4.13 | Matrices as Functions | point brief + Learn More explainer |
| 4.14 | Matrices Modeling Contexts | point brief + Learn More explainer |

## Content Notes

- The Learn More mini-examples are Cramapple-original and avoid copied released or official prompt language.
- The content supports class/course learning without presenting Unit 4 as AP Exam-assessed practice.
- The migration includes QA checks for row counts, pairing, unit alignment, route alignment, core-field duplication, and exact explainer-field duplication.
