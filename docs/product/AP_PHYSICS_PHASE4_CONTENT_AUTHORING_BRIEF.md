# AP Physics 1 Phase 4 Content Authoring Brief

**Status:** Draft brief; not a publish approval
**Related Task:** `TASK-0015`
**Product Owner:** David Bloom
**Curriculum Owner:** Orly Bloom
**Prepared:** 2026-07-07

## Purpose

This brief defines the subject-side content plan for AP Physics 1.
It is the handoff surface for the governed pilot batch, the subject taxonomy,
the verification profile, and the grading-test shape that Codex should use
when adapting the platform.

The shared platform already covers subject-aware grading and subject rows.
AP Physics 1 needs the subject-specific data layer and launch evidence:

- subject taxonomy;
- versioned exam pack;
- content labels for the initial unit scaffold;
- verification profile for physics-specific response checks;
- grading-test coverage for vectors, diagrams, and calculation boundaries;
- pilot content under the existing governance rules; and
- launch-readiness evidence before anything is shown as production-ready.

Related artifacts:

- [AP_PHYSICS_CONTENT_NEEDS_ANALYSIS.md](/Users/davidbloom/Documents/Cramapple/docs/product/AP_PHYSICS_CONTENT_NEEDS_ANALYSIS.md)
- [AP_PHYSICS_1_TAXONOMY.json](/Users/davidbloom/Documents/Cramapple/docs/research/AP_PHYSICS_1_TAXONOMY.json)
- [AP_PHYSICS_1_VERIFICATION_PROFILE.json](/Users/davidbloom/Documents/Cramapple/docs/research/AP_PHYSICS_1_VERIFICATION_PROFILE.json)
- [AP_CHEMISTRY_PHYSICS_GRADING_TEST_MATRIX.md](/Users/davidbloom/Documents/Cramapple/docs/research/AP_CHEMISTRY_PHYSICS_GRADING_TEST_MATRIX.md)

## Subject Shape

AP Physics 1 is a representation-heavy subject with frequent use of:

- free-body diagrams and vector reasoning;
- motion, forces, energy, momentum, and rotational ideas;
- graphs and slopes;
- experimental design and measurement;
- unit analysis and dimensional reasoning;
- algebraic manipulation of equations;
- circuits and conservation relationships; and
- concise explanations of causal physical behavior.

The content plan should assume that diagrams, sign conventions, units, and
reasoning structure matter as much as final numeric answers.

## Launch Taxonomy

Initial taxonomy should be subject-driven rather than invented ad hoc.
For the draft scaffold, use the unit layer already represented in the database
and treat the unit names as placeholders until curriculum review confirms the
final authoring map.

Expected first-pass taxonomy concerns:

- unit coverage;
- force and motion reasoning;
- energy and momentum;
- rotational or angular concepts where applicable;
- graph interpretation;
- representation type;
- difficulty;
- vector and sign-convention handling; and
- misconception tracking for common physics errors.

## Verification Profile

AP Physics 1 will likely need a mixed verification profile:

- deterministic calculation checks for numeric answers and units;
- vector and sign-convention checks;
- graph-slope and graph-shape checks;
- diagram interpretation checks for force and circuit responses;
- scientific-consistency review for explanation items; and
- rights/originality review on every authored item.

The platform should treat these as subject-specific verification rules, not as
one generic science verifier.

## Grading-Test Priorities

The AP Physics 1 grading-test plan should cover:

1. calculation-heavy items with exact numeric expectations;
2. vector and sign-convention edge cases;
3. graph-interpreting items where slope or trend matters;
4. diagram-based responses with boundary conditions;
5. explanation items where the answer is conceptually right but incomplete;
6. misconception traps for kinematics, dynamics, energy, and circuits; and
7. mixed representation items that combine equations, diagrams, and text.

The initial packet should be compact enough for calibration but broad enough to
stress the physics-specific verification logic.

## Pilot Content Expectations

The pilot batch should stay governed and original. It should be enough to let
Codex validate the subject-aware path and let Orly review the physics shape.

The batch should include:

- MCQ;
- short FRQ;
- long FRQ where appropriate;
- calculation-first items;
- explanation-first items;
- diagram or graph items; and
- boundary examples for the grading verifier.

## Production-Readiness Gates

AP Physics 1 should not be treated as launch-ready until:

- the subject row and exam pack are in place;
- the verification profile is implemented and tested;
- the pilot content passes rights and originality review;
- the grader is calibrated against a gold set;
- the frontend exposes the subject only when policy allows; and
- David has reviewed the readiness evidence separately from implementation.
