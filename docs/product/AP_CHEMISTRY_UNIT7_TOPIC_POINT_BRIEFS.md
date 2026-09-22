# AP Chemistry Unit 7 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record is the migration `supabase/migrations/20260826131232_ap_chemistry_unit7_equilibrium_topic_guides.sql` and the `app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Chemistry Unit 7 (Equilibrium).

Source basis: `docs/product/AP_CHEMISTRY_CED_FACT_PACK.md` Unit 7. The batch is grounded in reversible processes, dynamic equilibrium, Q and K expressions, solids and pure liquids excluded from equilibrium expressions, K magnitude, algebraic K manipulations, ICE-style concentration prediction, particulate equilibrium representations, Le Chatelier stress reasoning, Q returning to K, Ksp, common-ion effect, and 2025 misconception evidence for Ksp expressions, Q/Ksp comparison direction, and common-ion mechanism reasoning.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 7.1 | Introduction to Equilibrium | point brief + Learn More explainer |
| 7.2 | Direction of Reversible Reactions | point brief + Learn More explainer |
| 7.3 | Reaction Quotient and Equilibrium Constant | point brief + Learn More explainer |
| 7.4 | Calculating the Equilibrium Constant | point brief + Learn More explainer |
| 7.5 | Magnitude of the Equilibrium Constant | point brief + Learn More explainer |
| 7.6 | Properties of the Equilibrium Constant | point brief + Learn More explainer |
| 7.7 | Calculating Equilibrium Concentrations | point brief + Learn More explainer |
| 7.8 | Representations of Equilibrium | point brief + Learn More explainer |
| 7.9 | Introduction to Le Chatelier's Principle | point brief + Learn More explainer |
| 7.10 | Reaction Quotient and Le Chatelier's Principle | point brief + Learn More explainer |
| 7.11 | Introduction to Solubility Equilibria | point brief + Learn More explainer |
| 7.12 | Common-Ion Effect | point brief + Learn More explainer |

## Content Notes

- The Learn More mini-examples are Cramapple-original and avoid copied released or official prompt language.
- The migration includes QA checks for row counts, pairing, unit alignment, route alignment, core-field duplication, and exact explainer-field duplication.
