# Unit 9 Cheat Sheet v3: checker results (2026-11-21)

Checkers: openai/gpt-6.1-sol (Sol) and moonshotai/kimi-k3.1-pro (Kimi). Raw output in `check_out/`.

## Controls (plants.json, run_plant_*)
| Topic | Plant | Sol | Kimi |
|---|---|---|---|
| 9.3 mechanism | "At no T" changed to "At low T" | caught | caught |
| 9.5 mechanism | K > 1 changed to K < 1 beside ΔG° < 0 | caught | caught |
| 9.9 full credit | ΔG° "negative" changed to "positive" | caught | caught |
| 9.11 full credit | 1.93×10⁵ C changed to 1.93×10⁴ C | caught | caught |
Both models caught all four; both clean passes are trustworthy for these areas.

## Real defects found in the first clean pass, and fixes
- 9.3 (Sol): formation free energies lacked coefficients. Fixed: Σ nΔG°f. Also qualified favorability as standard state.
- 9.6 (Sol): Full credit asserted solvent reorganization costs energy and omitted the solute-solvent attraction. Fixed: attraction added, reorganization "can" cost.
- 9.9 (both): "greater reduction potential is the cathode" was unqualified. Fixed: galvanic cell stated in step 1 and Full credit.
- 9.10 (Sol): Q = 1 does not guarantee standard conditions. Fixed: row now "Same Q as at standard conditions".
- 9.11 (Sol): "electrons per ion" is not a general conversion (Cl₂ from Cl⁻). Fixed: general chain uses mol e⁻ per mol of substance from the half-reaction; Link updated.

## Suggestions
- 9.6 (both, recheck1): separate enthalpy from free-energy effects. Applied (table header and cells now name enthalpy and entropy contributions).
- 9.11 (Sol): provenance note for F and the charge calculation; no change (see NEW in the report).

## Final status
Rechecked clean on both models after fixes: 9.3, 9.9, 9.10, 9.11 (recheck1, no defects; 9.11 only a Sol provenance note), 9.6 (recheck2, no findings, final text). Clean in the first pass on both, never changed: 9.1, 9.2, 9.4, 9.5, 9.7, 9.8. No topic is unclean.

## What the checkers cannot show
Sources are treated as truth; derived facts (F value, 1.93×10⁵ C, J/(mol·K), E° = E°cathode − E°anode, energy-sign cells in 9.6) were judged as chemistry only. Nothing was checked against a rendered page or by a human reader.

## Words a student sees
Old fields (incl. retired recap) 1214 words -> new 1833 words across 11 topics (validate.py prints "-51% less", i.e. 51% MORE words than the old fields; the old count was small because Unit 9's old fields were terse).
