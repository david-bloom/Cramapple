# Round 5 (2026-10-01): re-derives the two APBIO-MCQ-005 variants against the NEW plain-language seed (APPROVAL-0068: same atoms arranged
# differently -> different 3-D shapes -> a transport protein fits one sugar better). CED vocabulary only: monosaccharide, molecular formula,
# polysaccharide, hydroxyl group, transport protein, hydrolysis. No "isomer", no carbon numbering, no "binding site". Both keep seed topic 1.3, unit 1.
# Replaces sv-005-v1 and sv-005-v2 only; the other 14 variants are untouched. build_variants*.py are NOT re-run.
import json, random, os
D = os.path.dirname(__file__); L = "ABCD"
TARGET = {"apbio-mcq-sv-005-v1": "D", "apbio-mcq-sv-005-v2": "B"}
R = [
("apbio-mcq-sv-005-v1","APBIO-MCQ-005",1,"1.3","fructose/intestinal cell -> galactose/bacterium; same idea (same atoms, different arrangement, different shape), plain language, no isomer wording",
 "Glucose and galactose are monosaccharides with the same molecular formula, C6H12O6, but their atoms are arranged differently, so the two molecules have different three-dimensional shapes. A transport protein in the plasma membrane of a bacterium moves galactose into the cell efficiently but moves glucose across the membrane very poorly.",
 "Which statement best explains how this transport protein can distinguish between the two sugars?",
 ("The two sugars have the same atoms arranged differently, so their shapes differ and only galactose fits the transport protein.",
  "Correct. The same atoms in a different arrangement give each sugar a different three-dimensional shape, and a transport protein can fit one shape much better than the other."),
 [("Galactose contains more carbon, hydrogen, and oxygen atoms than glucose, so the transport protein holds on to it more strongly.",
   "Incorrect. The stimulus states that both sugars have the molecular formula C6H12O6, so their atom counts are the same."),
  ("Galactose has hydroxyl groups that glucose lacks, and the transport protein recognizes those extra groups on galactose.",
   "Incorrect. Both sugars have the same number of hydroxyl groups; what differs is how the atoms are arranged."),
  ("Glucose is a polysaccharide, so it is too large to fit through the transport protein that moves galactose.",
   "Incorrect. Glucose is a monosaccharide, like galactose, not a polysaccharide.")]),
("apbio-mcq-sv-005-v2","APBIO-MCQ-005",1,"1.3","fructose/glucose discrimination -> prediction for a third sugar whose shape matches the well-transported one (applies the same idea; adds the monomer / hydrolysis check)",
 "Yeast cells have a transport protein in the plasma membrane that moves sugar A into the cell efficiently but moves sugar B very poorly. Sugars A and B are monosaccharides with the same molecular formula, C6H12O6, but their atoms are arranged differently. A third monosaccharide, sugar C, also has the formula C6H12O6. Its atoms are arranged so that its molecule has nearly the same three-dimensional shape as sugar A.",
 "Which prediction about the transport of sugar C is best supported by this information?",
 ("Sugar C will be moved into the cells efficiently, because its three-dimensional shape is nearly the same as sugar A's.",
  "Correct. The transport protein distinguishes the sugars by shape. A molecule with nearly the same shape as sugar A should fit the protein about as well as sugar A does."),
 [("Sugar C will be moved as poorly as sugar B, because all three sugars have the same molecular formula.",
   "Incorrect. Sugars A and B also share a formula, yet the protein moves sugar A efficiently. The formula is not what the protein distinguishes; shape is."),
  ("Sugar C will be moved poorly, because it has a different molecular formula from the formula of sugar A.",
   "Incorrect. The stimulus states that sugar C has the same molecular formula, C6H12O6, as sugar A."),
  ("Sugar C will be moved efficiently only after it is broken down into smaller molecules by hydrolysis first.",
   "Incorrect. Sugar C is a monosaccharide, a single monomer. Hydrolysis breaks bonds between monomers, and a monosaccharide has no such bond to break.")]),
]
items, man = {}, {}
for key, seed, unit, topic, change, stim, q, corr, dis in R:
    for n in range(500):
        rng = random.Random(f"{key}-r5-{n}")
        opts = [(corr[0], corr[1], True)] + [(t, r_, False) for t, r_ in dis]; rng.shuffle(opts)
        if L[[o[2] for o in opts].index(True)] == TARGET[key]: break
    keyed = TARGET[key]
    items[key] = dict(key=key, kind="mcq", unit=unit, topic=topic, seed=seed, stem=f"Stimulus: {stim}\n\nQuestion: {q}",
        choices=[dict(label=L[i], text=o[0]) for i, o in enumerate(opts)], keyed_label=keyed, rationales={L[i]: o[1] for i, o in enumerate(opts)})
    man[key] = (keyed, change)
def patch(fn):
    p = os.path.join(D, fn)
    if not os.path.exists(p): return
    data = json.load(open(p)); n = 0
    for i, x in enumerate(data):
        if x["key"] in items:
            n += 1; data[i] = items[x["key"]] if "choices" in x else {**x, "keyed_label": man[x["key"]][0], "topic": "1.3", "unit": 1, "change": man[x["key"]][1]}
    json.dump(data, open(p, "w"), indent=1, ensure_ascii=False); print(fn, "patched", n)
for fn in ("variants_all_items.json", "variants_items.json", "variants_manifest.json"): patch(fn)
json.dump(list(items.values()), open(os.path.join(D, "variants_round5_items.json"), "w"), indent=1, ensure_ascii=False)
print({k: v[0] for k, v in man.items()})
