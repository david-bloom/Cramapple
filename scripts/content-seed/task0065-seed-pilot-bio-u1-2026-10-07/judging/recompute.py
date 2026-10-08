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

# --- Load pre-check 2026-10-07: every computable key among all 82 accepted items (by pipeline id) ---
def rc(s): return s.translate(str.maketrans("ACGT", "TGCA"))[::-1]
def sub(s, pos, new): return s[:pos-1] + new + s[pos:]
L = {}
L["biology__1.6__C__seed#r1-openai"] = rc(sub("ACGTTA", 2, "A")) == "TAACTT"
L["biology__1.6__C__v1#r1-openai"] = rc(sub("TGCATGAC", 6, "A")) == "GTTATGCA"
L["biology__1.6__C__v2#r1-openai"] = rc(sub("GATCCAG", 2, "G")) == "CTGGACC"
L["biology__1.6__C__v3#r1-openai"] = rc(sub("CTAGGCAT", 7, "G")) == "ACGCCTAG"
# 1.3 C v1: two 5-mers (2 molecules); hydrolyze 5 bonds (+5 molecules, 5 H2O used); 2 joins (-2 molecules, 2 H2O released)
L["biology__1.3__C__v1#r2-openai"] = (2 + 5 - 2 == 5) and (5 - 2 == 3)  # key C: 5 molecules, 3 consumed
# 1.3 C v3: 15 monomers -> 3 chains of 5 (12 bonds, 12 H2O released); hydrolyze 4 (+4 molecules, 4 used)
L["biology__1.3__C__v3#r1-anthropic"] = (3 + 4 == 7) and (12 - 4 == 8)  # key A
L["biology__1.3__B__v1#r1-openai"] = (48 - 24 == 6 * 4) and (24 - 0 == 6 * 4)  # synthesis, key A
L["biology__1.3__B__v2#r2-openai"] = (12 * 8 == 9 * 8 + 24 == 3 * 8 + 72)  # hydrolysis, key D
L["biology__1.6__A__v1#r1-anthropic"] = 9 + 6 + 8 + 7 == 30
L["biology__1.6__A__v3#r1-anthropic"] = 3 * 4 == 12
L["biology__1.1__B__v1#r1-anthropic"] = (40.0 - 37.0) < (40.0 - 28.0)  # water falls less, key A
L["biology__1.1__B__v2#r1-openai"] = 12 / 3 > 3 / 3  # water needs more heat per degree, key B
L["biology__1.1__B__v3#r1-anthropic"] = (19 - 15) < (26 - 8)  # narrower range, key A
L["biology__1.1__B__seed#r1-openai"] = (22 - 20) < (30 - 20)  # key C
json.dump(L, open("judging/recompute_all.json", "w"), indent=1)
print("all accepted computable keys:", all(L.values()), sum(L.values()), "/", len(L))
