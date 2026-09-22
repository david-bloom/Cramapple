# AP Chemistry Unit 8 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record is the migration `supabase/migrations/20260826131233_ap_chemistry_unit8_acids_bases_topic_guides.sql` and the `app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Chemistry Unit 8 (Acids and Bases).

Source basis: `docs/product/AP_CHEMISTRY_CED_FACT_PACK.md` Unit 8. The batch is grounded in pH and pOH, Kw, strong acid/base ionization, weak acid/base equilibria, percent ionization, conjugate Ka/Kb relationships, neutralization and buffers, titration curves, molecular structure and acid strength, pH versus pKa, buffer properties, Henderson-Hasselbalch equation, buffer capacity, pH-sensitive solubility, and 2025 misconception evidence for pOH-to-pH conversion, titration equivalence volume, half-equivalence pKa, and Henderson-Hasselbalch ratio solving.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 8.1 | Introduction to Acids and Bases | point brief + Learn More explainer |
| 8.2 | pH and pOH of Strong Acids and Bases | point brief + Learn More explainer |
| 8.3 | Weak Acid and Base Equilibria | point brief + Learn More explainer |
| 8.4 | Acid-Base Reactions and Buffers | point brief + Learn More explainer |
| 8.5 | Acid-Base Titrations | point brief + Learn More explainer |
| 8.6 | Molecular Structure of Acids and Bases | point brief + Learn More explainer |
| 8.7 | pH and pKa | point brief + Learn More explainer |
| 8.8 | Properties of Buffers | point brief + Learn More explainer |
| 8.9 | Henderson-Hasselbalch Equation | point brief + Learn More explainer |
| 8.10 | Buffer Capacity | point brief + Learn More explainer |
| 8.11 | pH and Solubility | point brief + Learn More explainer |

## Content Notes

- The Learn More mini-examples are Cramapple-original and avoid copied released or official prompt language.
- The migration includes QA checks for row counts, pairing, unit alignment, route alignment, core-field duplication, and exact explainer-field duplication.
