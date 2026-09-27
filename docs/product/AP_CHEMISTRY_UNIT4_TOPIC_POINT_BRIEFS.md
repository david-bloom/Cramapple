# AP Chemistry Unit 4 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260826125459_ap_chemistry_unit4_chemical_reactions_topic_guides.sql`
and the `app.topic_point_briefs` / `app.topic_explainers` tables in each
environment.

Purpose: add paired topic point briefs and Learn More explainers for AP
Chemistry Unit 4 (Chemical Reactions). Before this addendum, Production and
Development both had taxonomy rows for all nine Unit 4 topics but zero
published topic-guide pairs for the unit.

Source basis: `docs/product/AP_CHEMISTRY_CED_FACT_PACK.md` Unit 4. The batch is
grounded in physical versus chemical changes, molecular/complete ionic/net
ionic equations, particulate representations, stoichiometric mole ratios,
titration equivalence versus endpoint, reaction type classification,
Bronsted-Lowry acid-base reactions in aqueous solution, redox half-reactions,
and the 2025 FRQ Q6 misconception trail for mass-based stoichiometric
comparison and electron placement in oxidation half-reactions.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 4.1 | Introduction for Reactions | point brief + Learn More explainer |
| 4.2 | Net Ionic Equations | point brief + Learn More explainer |
| 4.3 | Representations of Reactions | point brief + Learn More explainer |
| 4.4 | Physical and Chemical Changes | point brief + Learn More explainer |
| 4.5 | Stoichiometry | point brief + Learn More explainer |
| 4.6 | Introduction to Titration | point brief + Learn More explainer |
| 4.7 | Types of Chemical Reactions | point brief + Learn More explainer |
| 4.8 | Introduction to Acid-Base Reactions | point brief + Learn More explainer |
| 4.9 | Oxidation-Reduction Reactions | point brief + Learn More explainer |

## Content Notes

- 4.1 connects visible evidence to composition change rather than treating
  observations as definitions.
- 4.2 emphasizes atom and charge balance across molecular, complete ionic, and
  net ionic equation forms.
- 4.3 translates balanced coefficients into particulate ratios.
- 4.4 distinguishes chemical bonds from intermolecular-force changes while
  allowing nuanced dissolution reasoning.
- 4.5 uses the documented mass-comparison misconception from 2025 FRQ Q6.
- 4.6 separates equivalence point from endpoint.
- 4.7 preserves the AP scope exclusions for reducing/oxidizing agent terms and
  broad solubility-rule memorization.
- 4.8 keeps acid-base treatment to Bronsted-Lowry aqueous reactions and excludes
  Lewis acid-base concepts.
- 4.9 uses the documented electron-placement misconception from 2025 FRQ Q6.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
