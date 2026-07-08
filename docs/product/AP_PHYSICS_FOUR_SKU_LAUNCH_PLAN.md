# AP Physics Four-SKU Launch Plan

**Status:** Draft launch plan for Product Owner review
**Owner:** Product Owner with Learning Quality Owner and Main Conductor
**Scope:** AP Physics 1, AP Physics 2, AP Physics C: Mechanics, AP Physics C: Electricity and Magnetism
**Related Task:** `TASK-0015`

## Goal

Launch four separately sold AP Physics SKUs with one shared physics engine.
The shared engine should support subject-aware grading, point-maximizing
teaching, and reusable verification patterns, while each SKU keeps its own
scope, math style, and rubric behavior.

## Product Decisions

1. Sell four separate SKUs with one shared engine.
2. Roll out each SKU when ready, individually or in grouped waves when the
   overlap is high enough to reduce duplicate work.
3. Support diagram-heavy responses from day one for AP Physics 1 and AP
   Physics 2.
4. Bundle calculus notation and derivation handling into one rubric path for
   the calculus-based pair.
5. Use a single misconception library across all four SKUs.
6. Treat point-maximizing teaching as both learning optimization and helpful
   exam-taking strategy.
7. Build toward August launch readiness, with tutor onboarding completing in
   time for the launch window.

## SKU Map

| SKU | Math style | Main emphasis | Special handling |
| --- | --- | --- | --- |
| AP Physics 1 | Algebra-based | Mechanics, vectors, graphs, diagrams, measurement | Diagram-heavy from day one |
| AP Physics 2 | Algebra-based | Thermodynamics, E&M, optics, waves, modern physics | Diagram-heavy from day one |
| AP Physics C: Mechanics | Calculus-based | Motion, forces, energy, momentum, rotation | Calculus notation + derivations bundled in one rubric |
| AP Physics C: Electricity and Magnetism | Calculus-based | Fields, circuits, magnetism, induction | Calculus notation + derivations bundled in one rubric |

## Shared Engine

The shared physics engine should provide:

- subject routing by SKU;
- common physics misconceptions and error patterns;
- numeric, unit, and dimensional checks;
- vector/sign-convention handling;
- graph and diagram interpretation support;
- explanation and partial-credit boundary handling;
- point-maximizing teaching guidance;
- rubric-aware feedback grounded in the student response; and
- a shared calibration and monitoring loop.

## SKU-Specific Differences

### AP Physics 1

- strong diagram support from the first release;
- vectors, kinematics, dynamics, energy, momentum, rotation, and circuits;
- algebra-first response handling; and
- diagram + graph + text mixed items.

### AP Physics 2

- strong diagram support from the first release;
- thermo, electrostatics, circuits, magnetism, waves, optics, and modern physics;
- algebra-first response handling; and
- broader concept coverage than Physics 1.

### AP Physics C: Mechanics

- calculus-based mechanics;
- derivations and symbolic math are part of the scoring surface;
- calculus notation should be handled with the same rubric bundle as final
  answers; and
- heavier focus on formal mechanics reasoning than on broad topic coverage.

### AP Physics C: Electricity and Magnetism

- calculus-based fields, circuits, and induction;
- derivations and symbolic math are part of the scoring surface;
- calculus notation should be handled with the same rubric bundle as final
  answers; and
- heavier focus on field/potential/circuit reasoning than on broad topic coverage.

## Shared Misconception Library

Use one misconception library across all SKUs, tagged by:

- topic;
- representation type;
- algebra/calculus level;
- sign-convention issue;
- diagram issue;
- unit/dimensional issue;
- partial-credit boundary;
- and exam strategy issue.

The library should be reusable by the teaching layer, the grader, and the
content authoring workflow.

## Rollout Strategy

Roll out by readiness, not by calendar alone.

Recommended sequence:

1. AP Physics 1 base launch package.
2. AP Physics 2 once its diagram-heavy algebra path is stable and the shared
   misconception library is populated.
3. AP Physics C: Mechanics once calculus-rubric handling is proven.
4. AP Physics C: Electricity and Magnetism once the calculus rubric and field/
   circuit handling are stable.

If two SKUs share most of the same infrastructure, they can launch together as
a wave, but only if the readiness evidence exists for both.

## Shared Workstreams

### 1. Platform and grading

- subject-aware routing;
- shared physics misconception library;
- diagram support;
- units and dimensional analysis;
- calculus notation and derivation rubric support; and
- calibration and monitoring.

### 2. Content and teaching

- point-maximizing teaching patterns;
- topic prioritization by exam value;
- question-type coverage;
- explanation-first and calculation-first guidance; and
- SKU-specific pacing paths.

Content-authoring prompt packet:
- [Claude AP Physics Question Authoring Packet](/Users/davidbloom/Documents/Cramapple/prompts/CLAUDE_AP_PHYSICS_QUESTION_AUTHORING_PACKET.md)

### 3. UX and packaging

- four separate product offerings;
- clear SKU selection;
- package descriptions that explain the math style and exam style;
- diagram-friendly input flows; and
- clear differentiation between algebra-based and calculus-based tracks.

## Deferred Backend / Curriculum Follow-Ups

These items are intentionally later-stage and should not block the initial
four-SKU launch plan unless a SKU has already flipped live:

1. Ship `<TrackBadge>` and `<RubricPanel>` under `src/components/physics/`
   once any SKU flips live, then wire the diagram row for Physics 1 / Physics 2
   and the `DerivationStepList` for the calculus-based pair using the final
   verifier contracts.
2. Add per-SKU signup prefill to the home-page pricing footnote.
3. Add a real waitlist capture table only if we want per-SKU demand signal
   before purchase is enabled.

The waitlist concept should follow the broader subject-waitlist policy already
captured in the teaching/learning system docs; the implementation details are
still a later decision.

## Launch Gate

Do not call any SKU launch-ready until:

- the subject row and exam pack exist;
- the relevant verification profile is implemented and tested;
- the pilot content passes originality, rights, and quality review;
- the grader is calibrated against a gold set;
- the SKU is selectable end-to-end in a non-production environment; and
- the launch decision is recorded.

## Operating Rule

Physics launch work should favor the shared engine whenever the same rule can
serve multiple SKUs. Only split the implementation when the SKU-specific math
or rubric behavior is materially different.
