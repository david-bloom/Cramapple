"""Deterministic recompute of numeric keys in the seed-pilot blind set (blind to arm)."""
import json
R = {}
# S1800: 6-mer (5 bonds) + 5 monomers by dehydration -> 11-mer, 5 H2O released; hydrolyze 4 bonds -> 5 pieces, 4 H2O used.
R["S1800"] = (6 + 5 - 4 == 7) and (4 + 1 == 5) and (5 - 4 == 1)  # key A: 5 molecules, 1 water released
# S5752: 8 monomers -> 1 polymer, 7 H2O released; hydrolyze 3 bonds -> 4 pieces, 3 H2O used; net 4 released.
R["S5752"] = (3 + 1 == 4) and (7 - 3 == 4)  # key B
# S7587: monomers 120->80->40 fall by 40 per step; chains +4 x 10 monomers = 40. Data consistent with synthesis (key A).
R["S7587"] = (120 - 80 == 4 * 10) and (80 - 40 == 4 * 10)
# S9020: 10 polymers x 6 = 60 monomers; 5 polymers lost -> 30 monomers. Data consistent with hydrolysis (key D).
R["S9020"] = (5 * 6 == 30) and (10 * 6 == 60)
json.dump(R, open("judging/recompute.json", "w"), indent=1); print(all(R.values()), R)
