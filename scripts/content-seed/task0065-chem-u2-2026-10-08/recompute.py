"""Deterministic check of every computable key in the Chemistry Unit 2 batch."""
import json
R = {}
fc = lambda valence, lone_e, bond_e: valence - lone_e - bond_e // 2
# Electronegativity differences (polar covalent, toward the higher value)
R["apchem-mcq-071"] = 0 < 3.2 - 2.2 < 1.8          # key A, Cl partial negative
R["apchem-mcq-sv-071-v1"] = 0 < 3.4 - 2.6 < 1.8    # key C, O partial negative
# Potential-energy minima read from the tables
d = {40: 250, 60: -380, 74: -436, 100: -360, 150: -150, 300: -5}; R["apchem-mcq-072"] = min(d, key=d.get) == 74 and d[74] == -436
d = {150: 300, 180: -150, 199: -242, 230: -200, 300: -80, 500: -3}; R["apchem-mcq-sv-072-v1"] = min(d, key=d.get) == 199 and d[199] == -242
# Alloys: substitutional when radii within ~15%, interstitial when the solute is much smaller
sub = lambda a, b: abs(a - b) / max(a, b) < 0.15
R["apchem-mcq-076"] = sub(128, 135)                # key D substitutional
R["apchem-mcq-sv-076-v1"] = not sub(126, 77)       # key C interstitial
# Lewis electron counts
R["apchem-mcq-078"] = 6 + 1 + 1 == 2 + 3 * 2       # OH-: one bond + 3 lone pairs on O
R["apchem-mcq-sv-078-v1"] = 5 + 1 + 1 + 1 == 2 * 2 + 2 * 2  # NH2-: two bonds + 2 lone pairs
# Formal charges: OCN- (EN O > N > C) key III; SCN- (EN N > S > C) key I
ocn = {"I": (fc(6, 4, 4), fc(4, 0, 8), fc(5, 4, 4)), "II": (fc(6, 2, 6), fc(4, 0, 8), fc(5, 6, 2)), "III": (fc(6, 6, 2), fc(4, 0, 8), fc(5, 2, 6))}
R["apchem-mcq-079"] = ocn == {"I": (0, 0, -1), "II": (1, 0, -2), "III": (-1, 0, 0)} and all(sum(v) == -1 for v in ocn.values())
scn = {"I": (fc(6, 4, 4), fc(4, 0, 8), fc(5, 4, 4)), "II": (fc(6, 2, 6), fc(4, 0, 8), fc(5, 6, 2)), "III": (fc(6, 6, 2), fc(4, 0, 8), fc(5, 2, 6))}
R["apchem-mcq-sv-079-v1"] = scn["I"] == (0, 0, -1) and scn["III"] == (-1, 0, 0)  # -1 on N (most EN) -> I
json.dump(R, open("recompute.json", "w"), indent=1); print(all(R.values()), R)
