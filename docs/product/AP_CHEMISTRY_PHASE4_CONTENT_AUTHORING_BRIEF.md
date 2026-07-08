# AP Chemistry Phase 4 Content Authoring Brief

**Status:** Draft brief; not a publish approval
**Related Task:** `TASK-0014`
**Product Owner:** David Bloom
**Curriculum Owner:** Orly Bloom
**Prepared:** 2026-07-07

## Purpose

This brief defines the subject-side content plan for AP Chemistry.
It is the handoff surface for the governed pilot batch, the subject taxonomy,
the verification profile, and the grading-test shape that Codex should use
when adapting the platform.

The shared platform already covers subject-aware grading and subject rows.
AP Chemistry needs the subject-specific data layer and launch evidence:

- subject taxonomy;
- versioned exam pack;
- content labels for the initial unit scaffold;
- verification profile for chemistry-specific response checks;
- grading-test coverage for calculation, notation, and reasoning boundaries;
- pilot content under the existing governance rules; and
- launch-readiness evidence before anything is shown as production-ready.

Related artifacts:

- [AP_CHEMISTRY_CONTENT_NEEDS_ANALYSIS.md](/Users/davidbloom/Documents/Cramapple/docs/product/AP_CHEMISTRY_CONTENT_NEEDS_ANALYSIS.md)
- [AP_CHEMISTRY_TAXONOMY.json](/Users/davidbloom/Documents/Cramapple/docs/research/AP_CHEMISTRY_TAXONOMY.json)
- [AP_CHEMISTRY_VERIFICATION_PROFILE.json](/Users/davidbloom/Documents/Cramapple/docs/research/AP_CHEMISTRY_VERIFICATION_PROFILE.json)
- [AP_CHEMISTRY_PHYSICS_GRADING_TEST_MATRIX.md](/Users/davidbloom/Documents/Cramapple/docs/research/AP_CHEMISTRY_PHYSICS_GRADING_TEST_MATRIX.md)

## Subject Shape

AP Chemistry is a quantitative science subject with heavy use of:

- stoichiometry and unit conversion;
- balanced equations and symbolic notation;
- particle-level reasoning;
- equilibrium, kinetics, thermodynamics, and acids/bases;
- electrochemistry;
- graph and table interpretation;
- lab-data reasoning; and
- concise explanation of scientific causality.

The subject is better treated as a chemistry-specific taxonomy than as a
generic science subject. The content plan should therefore preserve unit-level
scaffolding and keep the subject data explicit in Supabase.

## Launch Taxonomy

Initial taxonomy should be subject-driven rather than invented ad hoc.
For the draft scaffold, use the unit layer already represented in the database
and treat the unit names as placeholders until curriculum review confirms the
final authoring map.

Expected first-pass taxonomy concerns:

- unit coverage;
- chemistry-specific skills such as balancing, calculation, and reasoning;
- representation type;
- difficulty;
- lab/data interpretation;
- symbolic manipulation;
- units and significant figures; and
- misconception tracking for common chemistry errors.

## Verification Profile

AP Chemistry will likely need a mixed verification profile:

- deterministic calculation checks for numeric answers and unit handling;
- symbolic-equation checks for balanced reactions and conversions;
- chemistry notation checks for subscripts, coefficients, and formatting;
- graph/table interpretation checks for equilibrium and kinetics tasks;
- scientific-consistency review for causal claims and process descriptions; and
- rights/originality review on every authored item.

The platform should treat these as subject-specific verification rules, not as
one generic science verifier.

## Grading-Test Priorities

The AP Chemistry grading-test plan should cover:

1. calculation-heavy items with exact numeric expectations;
2. notation-sensitive items where units and equation form matter;
3. boundary cases around partial credit;
4. explanation items where the answer is scientifically correct but
   underspecified;
5. distractor and misconception traps for common stoichiometry and equilibrium
   mistakes; and
6. mixed representation items that combine tables, graphs, and text.

The initial packet should be compact enough for calibration but broad enough to
stress the chemistry-specific verification logic.

## Pilot Content Expectations

The pilot batch should stay governed and original. It should be enough to let
Codex validate the subject-aware path and let Orly review the chemistry shape.

The batch should include:

- MCQ;
- short FRQ;
- long FRQ where appropriate;
- calculation-first items;
- explanation-first items;
- mixed-representation items; and
- boundary examples for the grading verifier.

## Production-Readiness Gates

AP Chemistry should not be treated as launch-ready until:

- the subject row and exam pack are in place;
- the verification profile is implemented and tested;
- the pilot content passes rights and originality review;
- the grader is calibrated against a gold set;
- the frontend exposes the subject only when policy allows; and
- David has reviewed the readiness evidence separately from implementation.
