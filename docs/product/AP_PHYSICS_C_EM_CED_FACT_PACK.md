# AP Physics C: Electricity and Magnetism - CED Fact Pack

Status: Primary-source verified. Use this version for 2026-27 authoring and review. Mirrored into this repo from Google Drive on 2026-08-03 so all subject fact packs live in one place; no content was changed in the move.

## Source control

Source document: College Board, AP Physics C: Electricity and Magnetism Course and Exam Description.

Edition: "Effective Fall 2024," copyright 2026 College Board. David-supplied primary-source PDF, extracted and verified directly.

No local copy of the source PDF exists in this repo's `docs/teaching/` directory as of 2026-08-03 — unlike the Statistics/Precalculus/Calculus/Chemistry fact packs, this one cannot cite a local file path or SHA-256. If the PDF is added to `docs/teaching/`, update this section with its path and hash.

Drive fact-pack source: "AP Physics C E&M 2026-27 — CED Fact Pack (v2, primary source, use this one)", file ID `1AwMAtwpUj798kRROyz4O8q9w36YubauEeB7122mrJM0`, created 2026-07-23.

This replaces the earlier fact pack (© 2019 edition). Core content scope is essentially unchanged, but **units have been renumbered from 1-5 to 8-13** (continuing the sequence from Physics C: Mechanics' 7 units), and Electrostatics has been split into two units instead of one.

**Calculus-based course** — use derivatives/integrals where appropriate (e.g., Gauss's law via flux integrals, capacitor energy via ∫(q/C)dq).

## 1. Exam structure

- Same format as Physics C: Mechanics — FRQ types: Mathematical Routines, Translation Between Representations, Experimental Design and Analysis, Qualitative/Quantitative Translation.
- 40 multiple-choice questions (50% of E&M score) + FRQ section (50%).

## 2. Units and MC exam weighting (verified, primary source, current edition)

| Unit | Title | MC Weighting |
|---|---|---|
| 8 | Electric Charges, Fields, and Gauss's Law | 15-25% |
| 9 | Electric Potential | 10-20% |
| 10 | Conductors and Capacitors | 10-15% |
| 11 | Electric Circuits | 15-25% |
| 12 | Magnetic Fields and Electromagnetism | 10-20% |
| 13 | Electromagnetic Induction | 10-20% |

**6 units total, numbered 8-13** (not 1-5 as in the old edition). No standalone "Electrostatics" unit anymore — it's split into Unit 8 (charge, fields, Gauss's law) and Unit 9 (potential). Content coverage itself is essentially the same as the old 5-unit version; this is a renumbering/regrouping, not new or removed topics, as far as the primary-source pass could verify.

## 3. Topic map (verified from primary source, current edition)

Unit 8 (Electric Charges, Fields, and Gauss's Law): 8.1 Electric Charge and Electric Force, 8.2 Conservation of Electric Charge and the Charge Distribution, 8.3 Electric Fields, 8.4 Electric Fields of Charge Distributions, 8.5 Electric Flux, 8.6 Gauss's Law

Unit 9 (Electric Potential): 9.1 Electric Potential Energy, 9.2 Electric Potential, 9.3 Conservation of Electric Energy

Unit 10 (Conductors and Capacitors): 10.1 Electrostatics with Conductors, 10.2 Redistribution of Charge Between Conductors, 10.3 Capacitors, 10.4 Dielectrics

Unit 11 (Electric Circuits): 11.1 Electric Current, 11.2 Simple Circuits, 11.3 Resistance, Resistivity, and Ohm's Law, 11.4 Electric Power, 11.5 Compound Direct Current Circuits, 11.6 Kirchhoff's Loop Rule, 11.7 Kirchhoff's Junction Rule, 11.8 Resistor-Capacitor (RC) Circuits

Unit 12 (Magnetic Fields and Electromagnetism): 12.1 Magnetic Fields, 12.2 Magnetism and Moving Charges, 12.3 Magnetic Fields of Current-Carrying Wires, 12.4 Ampère's Law

Unit 13 (Electromagnetic Induction): 13.1 Magnetic Flux, 13.2 Electromagnetic Induction, 13.3 Induced Currents and Magnetic Forces, 13.4 Inductance, 13.5 Circuits with Resistors and Inductors, 13.6 Circuits with Capacitors and Inductors

## 4. Authoring/review guidance

- If any existing `apphycem-*` content or tags reference "Unit 1-5" numbering, they need to be re-mapped to the current 8-13 numbering (content itself is very likely still valid; it's the unit/topic tags that need updating).
- Confirm capacitor energy derivations use the calculus form (∫(q/C)dq = Q²/2C).
- Confirm Ampère's law / Biot-Savart content lives in Unit 12 (Magnetic Fields and Electromagnetism), not misfiled under Unit 13 (Electromagnetic Induction, which is induction/RL/RC/LC circuits).
