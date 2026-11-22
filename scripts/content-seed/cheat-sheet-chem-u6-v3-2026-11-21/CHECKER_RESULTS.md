# Unit 6 v3 checker results (2026-11-21)

Checkers: openai/gpt-6.1-sol (GPT) and moonshotai/kimi-k3.1-pro (Kimi). Sources are treated as truth; derived facts are judged as chemistry only.

## Controls (planted, `plants.json`)
- 6.4 Full credit: mass 100.0 g + 0.10 g = 100.1 g replaced by 0.10 g. GPT caught (2 defects); Kimi caught.
- 6.7 Full credit: "862 kJ released" changed to "required". GPT caught; Kimi caught.
- 6.9 Full credit: +180.6 − 114.2 = +66.4 changed to +180.6 + 114.2 = +294.8. GPT caught; Kimi caught.
Both models caught all three plants, so both clean passes are trustworthy for sign, arithmetic and mass-choice errors in this unit.

## Real defects found and fixed
- 6.2 Full credit: "any peak shown is activation energy" equated the peak with Ea. Fixed to "any barrier shown (reactant level to the peak) is activation energy". (Both models.)
- 6.1 mechanism table: "Warm"/"Cool" stated unconditionally, and one attraction's strength was made sufficient. Now "May warm"/"May cool" and the comparison is the energy released by new attractions versus energy needed to break old ones. (Both models.)
- 6.4 mechanism and step 1: "total solution mass" stated as categorical; now "mass of the solution warmed (usually total solution mass)". The sign flip now says "taking the solution as the only absorber of heat" (GPT, recheck 1).
- 6.5 core: "equal ΔH of opposite sign" changed to "equal in size and opposite in sign" (Kimi). 6.5 Link repeated the core's q = mcΔT claim (both models, overlap); replaced with the 6.6 link.
- 6.7 Link: "should agree in sign" overgeneralized; now "generally agree in sign ... but can differ, especially near ΔH = 0" (GPT). Full credit now states "per mole of reaction as written".
- 6.9 mechanism table: heuristics read as unconditional; column now headed "Usually" (GPT, recheck 1).
- 6.6 core: n now "moles of reaction" (GPT suggestion, cheap, applied).
- 6.8 and 6.9 Full credit: phase labels (g) added (GPT suggestion).

## Suggestions left
- 6.4: GPT twice asked to call c = 4.18 J/(g·°C) and ΔT = +2.0 °C "assumed" rather than "given for this example". Left: a model answer to a calculation needs supplied inputs; they are flagged NEW in the report.
- 6.8: GPT noted the zero formation enthalpy of elements is standard chemistry (no change needed).

## Final status
- Clean on both models after fixes (recheck2, last text): 6.4, 6.5, 6.6, 6.7, 6.9 (6.4 has only the GPT suggestion left above).
- Clean on both models on the final text via recheck1 (not changed afterwards): 6.1, 6.2, 6.8 (GPT left only a "no correction needed" suggestion on 6.8).
- 6.3: unchanged since the first run, clean on both models there.
- All topics' final text was checked.

## Cannot show
Checkers cannot verify NEW numbers against a source (bond energies 436, 243, 431; ΔH°f(NH₃) = −45.9; NO and NO₂ ΔH values +90.3, +57.1; c = 4.18; ΔT = +2.0 °C; 0.0100 mol). I recomputed all arithmetic myself: 100.1 × 4.18 × 2.0 = 836.8 ≈ 8.4×10² J; −840 J ÷ 0.0100 mol = −84 kJ/mol; 679 − 862 = −183 kJ; 2(−45.9) = −91.8 kJ; 2(+90.3) = +180.6, 2(−57.1) = −114.2, sum +66.4 kJ. Published worked examples for Unit 6 contain no numbers, so the numeric Full-credit answers are extensions.

## Words a student sees
1393 -> 1758 words (validate.py total; the draft is longer than the current text, because the current fields carry no numeric answers and the new Weak/Full credit are concrete).
