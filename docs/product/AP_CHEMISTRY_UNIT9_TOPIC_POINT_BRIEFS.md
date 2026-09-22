# AP Chemistry Unit 9 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record is the migration `supabase/migrations/20260826131235_ap_chemistry_unit9_thermodynamics_electrochemistry_topic_guides.sql` and the `app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Chemistry Unit 9 (Thermodynamics and Electrochemistry).

Source basis: `docs/product/AP_CHEMISTRY_CED_FACT_PACK.md` Unit 9. The batch is grounded in entropy, absolute entropy, Gibbs free energy, thermodynamic favorability, kinetic control, free energy and equilibrium, dissolution free energy, coupled reactions, galvanic and electrolytic cell roles, cell potential and free energy, qualitative nonstandard cell potential, Faraday law, and 2025 misconception evidence for particle-level entropy, Gibbs sign reasoning, temperature shifts, and electrochemical electrode-role transfer.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 9.1 | Introduction to Entropy | point brief + Learn More explainer |
| 9.2 | Absolute Entropy and Entropy Change | point brief + Learn More explainer |
| 9.3 | Gibbs Free Energy and Thermodynamic Favorability | point brief + Learn More explainer |
| 9.4 | Thermodynamic and Kinetic Control | point brief + Learn More explainer |
| 9.5 | Free Energy and Equilibrium | point brief + Learn More explainer |
| 9.6 | Free Energy of Dissolution | point brief + Learn More explainer |
| 9.7 | Coupled Reactions | point brief + Learn More explainer |
| 9.8 | Galvanic and Electrolytic Cells | point brief + Learn More explainer |
| 9.9 | Cell Potential and Free Energy | point brief + Learn More explainer |
| 9.10 | Cell Potential under Nonstandard Conditions | point brief + Learn More explainer |
| 9.11 | Electrolysis and Faraday's Law | point brief + Learn More explainer |

## Content Notes

- The Learn More mini-examples are Cramapple-original and avoid copied released or official prompt language.
- The migration includes QA checks for row counts, pairing, unit alignment, route alignment, core-field duplication, and exact explainer-field duplication.
