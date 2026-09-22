# AP Chemistry Unit 5 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260826130006_ap_chemistry_unit5_kinetics_topic_guides.sql`
and the `app.topic_point_briefs` / `app.topic_explainers` tables in each
environment.

Purpose: add paired topic point briefs and Learn More explainers for AP
Chemistry Unit 5 (Kinetics). Before this addendum, Production had taxonomy rows
for all eleven Unit 5 topics but zero published topic-guide pairs for the unit.

Source basis: `docs/product/AP_CHEMISTRY_CED_FACT_PACK.md` Unit 5. The batch is
grounded in reaction rates, stoichiometric rate comparisons, rate laws,
initial-rate comparisons, integrated rate laws, first-order half-life,
elementary reactions, collision model and Maxwell-Boltzmann reasoning, reaction
energy profiles, qualitative Arrhenius interpretation without calculations,
reaction mechanisms, rate-determining steps, pre-equilibrium approximation,
multistep energy profiles, catalysis, and the 2025 FRQ Q7 misconception trail
requiring catalyst evidence from individual mechanism steps.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 5.1 | Reaction Rates | point brief + Learn More explainer |
| 5.2 | Introduction to Rate Law | point brief + Learn More explainer |
| 5.3 | Concentration Changes over Time | point brief + Learn More explainer |
| 5.4 | Elementary Reactions | point brief + Learn More explainer |
| 5.5 | Collision Model | point brief + Learn More explainer |
| 5.6 | Reaction Energy Profile | point brief + Learn More explainer |
| 5.7 | Introduction to Reaction Mechanisms | point brief + Learn More explainer |
| 5.8 | Reaction Mechanism and Rate Law | point brief + Learn More explainer |
| 5.9 | Pre-Equilibrium Approximation | point brief + Learn More explainer |
| 5.10 | Multistep Reaction Energy Profile | point brief + Learn More explainer |
| 5.11 | Catalysis | point brief + Learn More explainer |

## Content Notes

- 5.1 adjusts concentration-change rates by balanced-equation coefficients.
- 5.2 uses initial-rate comparisons rather than overall-equation coefficients.
- 5.3 ties graph linearity to integrated rate-law choice and first-order
  half-life scope.
- 5.4 uses elementary-step molecularity only when the step is truly elementary.
- 5.5 explains rate changes through successful collisions and activation energy.
- 5.6 separates activation energy from overall energy change and keeps
  Arrhenius treatment qualitative.
- 5.7 distinguishes intermediates from catalysts by order of appearance in
  mechanism steps.
- 5.8 derives rate laws from the slow elementary step.
- 5.9 uses pre-equilibrium to replace intermediates in rate laws.
- 5.10 labels peaks as transition states and intermediate valleys between
  steps.
- 5.11 uses the documented catalyst-identification misconception from 2025 FRQ
  Q7.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
