# AP Physics C: Mechanics - CED Fact Pack

Status: Primary-source verified. Use this version for 2026-27 authoring and review. Mirrored into this repo from Google Drive on 2026-08-03 so all subject fact packs live in one place; no content was changed in the move.

## Source control

Source document: College Board, AP Physics C: Mechanics Course and Exam Description.

Edition: "Effective Fall 2024," copyright 2026 College Board. David-supplied primary-source PDF, extracted and verified directly.

No local copy of the source PDF exists in this repo's `docs/teaching/` directory as of 2026-08-03 — unlike the Statistics/Precalculus/Calculus/Chemistry fact packs, this one cannot cite a local file path or SHA-256. If the PDF is added to `docs/teaching/`, update this section with its path and hash.

Drive fact-pack source: "AP Physics C Mechanics 2026-27 — CED Fact Pack (v2, primary source, use this one)", file ID `1rc_z7A4CmhDx1Ya6zJswnKYm2wtOrLsJRK-7qBzDxG0`, created 2026-07-23.

This replaces an earlier low-confidence version built from web-search summaries, which was wrong about the unit structure — the web-search version had Unit 7 as "Gravitation." The actual current CED has no standalone Gravitation unit at all; that content is now folded into Unit 6.

## 1. Exam structure

- Calculus-based course.
- FRQ types (per scoring guidelines section): Question 1 Mathematical Routines, Question 2 Translation Between Representations, Question 3 Experimental Design and Analysis, Question 4 Qualitative/Quantitative Translation.

## 2. Units and MC exam weighting (verified, primary source, current edition)

| Unit | Title | MC Weighting |
|---|---|---|
| 1 | Kinematics | 10-15% |
| 2 | Force and Translational Dynamics | 20-25% |
| 3 | Work, Energy, and Power | 15-25% |
| 4 | Linear Momentum | 10-20% |
| 5 | Torque and Rotational Dynamics | 10-15% |
| 6 | Energy and Momentum of Rotating Systems | 10-15% |
| 7 | Oscillations | 10-15% |

**7 units total. No standalone Gravitation unit** — gravitational/orbital content now lives inside Unit 6 (topic 6.6). Rotation is split across two units (5 and 6) rather than one combined unit.

## 3. Topic map (verified from primary source, current edition)

**Unit 1 (Kinematics):** 1.1 Scalars and Vectors, 1.2 Displacement/Velocity/Acceleration, 1.3 Representing Motion, 1.4 Reference Frames and Relative Motion, 1.5 Motion in Two or Three Dimensions

**Unit 2 (Force and Translational Dynamics):** 2.1 Systems and Center of Mass, 2.2 Forces and Free-Body Diagrams, 2.3 Newton's Third Law, 2.4 Newton's First Law, 2.5 Newton's Second Law, 2.6 Gravitational Force, 2.7 Kinetic and Static Friction, 2.8 Spring Forces, 2.9 Resistive Forces, 2.10 Circular Motion

**Unit 3 (Work, Energy, and Power):** 3.1 Translational Kinetic Energy, 3.2 Work, 3.3 Potential Energy, 3.4 Conservation of Energy, 3.5 Power

**Unit 4 (Linear Momentum):** 4.1 Linear Momentum, 4.2 Change in Momentum and Impulse, 4.3 Conservation of Linear Momentum, 4.4 Elastic and Inelastic Collisions

**Unit 5 (Torque and Rotational Dynamics):** 5.1 Rotational Kinematics, 5.2 Connecting Linear and Rotational Motion, 5.3 Torque, 5.4 Rotational Inertia, 5.5 Rotational Equilibrium and Newton's First Law in Rotational Form, 5.6 Newton's Second Law in Rotational Form

**Unit 6 (Energy and Momentum of Rotating Systems):** 6.1 Rotational Kinetic Energy, 6.2 Torque and Work, 6.3 Angular Momentum and Angular Impulse, 6.4 Conservation of Angular Momentum, 6.5 Rolling, **6.6 Motion of Orbiting Satellites (this is where gravitation/orbital mechanics content lives now)**

**Unit 7 (Oscillations):** 7.1 Defining Simple Harmonic Motion (SHM), 7.2 Frequency and Period of SHM, 7.3 Representing and Analyzing SHM, 7.4 Energy of Simple Harmonic Oscillators, 7.5 Simple and Physical Pendulums

## 4. Authoring/review guidance

- **Do not author or approve any item under a standalone "Gravitation" topic label** — it doesn't exist as a unit in the current CED. Orbital mechanics / universal gravitation content belongs under Unit 6, Topic 6.6 (Motion of Orbiting Satellites), and should be framed in that context (energy/momentum of orbiting systems), not as isolated gravitation-only content.
- Rotational content is split: kinematics/torque/Newton's laws in rotational form live in Unit 5; rotational energy, angular momentum, rolling, and orbital motion live in Unit 6. Check which sub-topic a rotation question actually targets before filing it.
- This is a calculus-based course — content should use derivatives/integrals where appropriate (e.g., angular impulse as the integral of torque dt, matching the linear-momentum treatment in Unit 4).
- If any existing `apphycm-*` content references a standalone "gravitation" unit or topic tag, it needs to be re-mapped to Unit 6 topic 6.6 rather than treated as its own unit.
- This course's unit structure and topic numbering are the calculus-based counterpart to AP Physics 1 (see that fact pack) — the two are now structured identically, unit-for-unit and topic-for-topic, aside from calculus notation.
