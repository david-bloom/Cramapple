# AP Physics 1: Algebra-Based - CED Fact Pack

Status: Primary-source verified. Use this version for 2026-27 authoring and review. Mirrored into this repo from Google Drive on 2026-08-03 so all subject fact packs live in one place; no content was changed in the move.

## Source control

Source document: College Board, AP Physics 1: Algebra-Based Course and Exam Description.

Edition: "Effective Fall 2024," copyright 2026 College Board. David-supplied primary-source PDF, extracted and verified directly (not a web-search summary).

No local copy of the source PDF exists in this repo's `docs/teaching/` directory as of 2026-08-03 — unlike the Statistics/Precalculus/Calculus/Chemistry fact packs, this one cannot cite a local file path or SHA-256. If the PDF is added to `docs/teaching/`, update this section with its path and hash.

Drive fact-pack source (superseded/authoritative history):
- **v3 (current, this document):** "AP Physics 1 2026-27 — CED Fact Pack (v3, primary source Fall 2024, use this one)", file ID `1WTHwHrJujEuBzAXsL92zQdnHXlE-cvgsArE_FOVdR1g`, created 2026-07-24.
- v2 (superseded — Fall 2021 edition, now out of date): "AP Physics 1 2026-27 — CED Fact Pack (v2 - use this one)", file ID `1Ac-GXgNblqwxjXWfE98FhIZ-huxsyNw_p3RIrKfPYLI`.

This replaces the earlier fact pack (Fall 2021 edition), which is now significantly out of date. Physics 1 was substantially restructured for 2024-25: it now has 8 units (was 7), the unit names/order were rewritten to closely mirror Physics C: Mechanics' structure, and **Fluids was added as a new Unit 8** — this is the same Fluids content that was removed from AP Physics 2 (confirming the earlier hypothesis from the Physics 2 recheck: Fluids moved from Physics 2 to Physics 1, it wasn't simply cut).

## 1. Exam structure

- 3 hours, hybrid digital exam (Bluebook + handwritten FRQ booklets).
- Algebra-based (no calculus).
- FRQ types (now match the same 4 archetypes used across the whole Physics C/1 family): Mathematical Routines, Translation Between Representations, Experimental Design and Analysis, Qualitative/Quantitative Translation.

## 2. Units and MC exam weighting (verified, primary source, current edition)

| Unit | Title | MC Weighting |
|---|---|---|
| 1 | Kinematics | 10-15% |
| 2 | Force and Translational Dynamics | 18-23% |
| 3 | Work, Energy, and Power | 18-23% |
| 4 | Linear Momentum | 10-15% |
| 5 | Torque and Rotational Dynamics | 10-15% |
| 6 | Energy and Momentum of Rotating Systems | 5-8% |
| 7 | Oscillations | 5-8% |
| 8 | Fluids | 10-15% |

**8 units total.** No more "Circular Motion and Gravitation" as its own unit (old Unit 3) — circular motion content is folded into Unit 2 (Force and Translational Dynamics, topic 2.9), and orbital/gravitation content lives in Unit 6 (topic 6.6, "Motion of Orbiting Satellites") — **exactly mirroring the Physics C: Mechanics structure already documented in that fact pack.** Rotation is likewise split across two units (5 and 6), matching Physics C: Mechanics.

## 3. Topic map (verified from primary source, current edition)

Unit 1 (Kinematics): 1.1 Scalars and Vectors in One Dimension, 1.2 Displacement, Velocity, and Acceleration, 1.3 Representing Motion, 1.4 Reference Frames and Relative Motion, 1.5 Vectors and Motion in Two Dimensions

Unit 2 (Force and Translational Dynamics): 2.1 Systems and Center of Mass, 2.2 Forces and Free-Body Diagrams, 2.3 Newton's Third Law, 2.4 Newton's First Law, 2.5 Newton's Second Law, 2.6 Gravitational Force, 2.7 Kinetic and Static Friction, 2.8 Spring Forces, 2.9 Circular Motion

Unit 3 (Work, Energy, and Power): 3.1 Translational Kinetic Energy, 3.2 Work, 3.3 Potential Energy, 3.4 Conservation of Energy, 3.5 Power

Unit 4 (Linear Momentum): 4.1 Linear Momentum, 4.2 Change in Momentum and Impulse, 4.3 Conservation of Linear Momentum, 4.4 Elastic and Inelastic Collisions

Unit 5 (Torque and Rotational Dynamics): 5.1 Rotational Kinematics, 5.2 Connecting Linear and Rotational Motion, 5.3 Torque, 5.4 Rotational Inertia, 5.5 Rotational Equilibrium and Newton's First Law in Rotational Form, 5.6 Newton's Second Law in Rotational Form

Unit 6 (Energy and Momentum of Rotating Systems): 6.1 Rotational Kinetic Energy, 6.2 Torque and Work, 6.3 Angular Momentum and Angular Impulse, 6.4 Conservation of Angular Momentum, 6.5 Rolling, 6.6 Motion of Orbiting Satellites (gravitation/orbital content lives here, not a standalone unit)

Unit 7 (Oscillations): 7.1 Defining Simple Harmonic Motion (SHM), 7.2 Frequency and Period of SHM, 7.3 Representing and Analyzing SHM, 7.4 Energy of Simple Harmonic Oscillators

Unit 8 (Fluids): 8.1 Internal Structure and Density, 8.2 Pressure, 8.3 Fluids and Newton's Laws, 8.4 Fluids and Conservation Laws

## 4. Authoring/review guidance

- Do not author or approve any Physics 1 content under a standalone "Circular Motion and Gravitation" unit label — it doesn't exist anymore. Circular motion belongs under Unit 2 (topic 2.9); orbital/gravitation belongs under Unit 6 (topic 6.6).
- Any existing `apphy1-*` content referencing the old 7-unit structure (esp. old Unit 3 "Circular Motion and Gravitation," old Unit 6 "Simple Harmonic Motion," old Unit 7 "Torque and Rotational Motion") needs to be re-mapped to the current 8-unit/topic numbering.
- **New authoring scope: Physics 1 now covers Fluids (Unit 8).** If Cramapple has zero `apphy1-*` fluids content today, that's a real content gap now that Fluids lives here instead of (or in addition to) Physics 2.
- Algebra-based only — no calculus notation.
- This course's unit structure, topic numbering, and FRQ archetypes are now essentially parallel to Physics C: Mechanics (algebra-based version of the same skeleton) — cross-reference that fact pack when in doubt about topic placement, since the two courses are now structured the same way.
